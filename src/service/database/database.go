/*
Package database is the middleware between the app database and the code. All data (de)serialization (save/load) from a
persistent database are handled here. Database specific logic should never escape this package.

To use this package you need to apply migrations to the database if needed/wanted, connect to it (using the database
data source name from config), and then initialize an instance of AppDatabase from the DB connection.

For example, this code adds a parameter in `webapi` executable for the database data source name (add it to the
main.WebAPIConfiguration structure):

	DB struct {
		Filename string `conf:""`
	}

This is an example on how to migrate the DB and connect to it:

	// Start Database
	logger.Println("initializing database support")
	db, err := sql.Open("sqlite3", "./foo.db")
	if err != nil {
		logger.WithError(err).Error("error opening SQLite DB")
		return fmt.Errorf("opening SQLite: %w", err)
	}
	defer func() {
		logger.Debug("database stopping")
		_ = db.Close()
	}()

Then you can initialize the AppDatabase and pass it to the api package.
*/
package database

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
)

// AppDatabase is the high level interface for the DB
type AppDatabase interface {
	GetStations(filter string) *[]Station
	GetTrains(filter string) *[]Train
	GetStationByBeaconID(beaconID string) *Station
	GetTrainByBeaconID(beaconID string) *Train
	UpdateUserPosition(userID string, beaconID string) (*UpdateUserPositionResponse, error)
	GetUserPosition(userID string) *UserState

	UpdateTrainPosition(trainID string, stationID string, status string, time_string string) error
	ResetTrainPosition(trainID string) error
	GetPaymentHistory(userID string) ([]PaymentResponse, error)

	ValidateTicket(ticketID string) (string, error)

	GetStationDepartures(stationID string) (*[]StationTimetableItem, error)
	GetStationArrivals(stationID string) (*[]StationTimetableItem, error)

	GetBeaconList() *[]string
}

// JSON database implementation
type appdbimpl struct {
	filename       string
	Stations       []Station
	Trains         []Train
	UserStates     map[string]*UserState
	PaymentHistory map[string][]PaymentResponse
	ValidTickets   map[string]string
}

type Location struct {
	Latitutde float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type Station struct {
	Name     string   `json:"name"`
	BeaconID string   `json:"beacon_id"`
	Location Location `json:"location"`
}

type TrainTripItem struct {
	Station                *Station `json:"station"`
	ScheduledArrivalTime   string   `json:"scheduled_arrival_time"`
	ScheduledDepartureTime string   `json:"scheduled_departure_time"`
	ArrivalTime            string   `json:"arrival_time"`
	DepartureTime          string   `json:"departure_time"`
	Platform               int      `json:"platform"`
	Cost                   float64  `json:"cost"`
}

type Train struct {
	ID        string           `json:"id"`
	BeaconID  string           `json:"beacon_id"`
	LastDelay int              `json:"last_delay"`
	Trip      *[]TrainTripItem `json:"trip"`
}

const (
	InTrain   string = "in_train"
	InStation        = "in_station"
	Away             = "away"
)

type UserState struct {
	Status  string   `json:"status"`
	Train   *Train   `json:"train"`
	Station *Station `json:"station"`
}

type PaymentResponse struct {
	Cost                   float64  `json:"cost"`
	TrainID                string   `json:"train_id"`
	FromStation            *Station `json:"from_station"`
	ToStation              *Station `json:"to_station"`
	DepartureTime          string   `json:"departure_time"`
	ArrivalTime            string   `json:"arrival_time"`
	ScheduledDepartureTime string   `json:"scheduled_departure_time"`
	ScheduledArrivalTime   string   `json:"scheduled_arrival_time"`
	Date                   string   `json:"date"`
}

type UpdateUserPositionResponse struct {
	Status          string           `json:"status"`
	ID              string           `json:"id"`
	PaymentResponse *PaymentResponse `json:"payment_response"`
	TicketCode      string           `json:"ticket_code"`
}

type StationTimetableItem struct {
	TrainID                string `json:"train_id"`
	ScheduledArrivalTime   string `json:"scheduled_arrival_time"`
	ScheduledDepartureTime string `json:"scheduled_departure_time"`
	FirstStation           string `json:"first_station"`
	LastStation            string `json:"last_station"`
	LastDelay              int    `json:"last_delay"`
	Platform               int    `json:"platform"`
}

// Load loads a database from a file
func Load(file string) (AppDatabase, error) {
	if file == "" {
		return nil, errors.New("No file path provided")
	}

	// read file
	jsonFile, err := os.Open(file)

	if err != nil {
		return nil, fmt.Errorf("Error opening file: %w", err)
	}
	defer jsonFile.Close()

	// decode json
	byteValue, err := ioutil.ReadAll(jsonFile)

	if err != nil {
		return nil, fmt.Errorf("Error reading file: %w", err)
	}

	var db appdbimpl

	err = json.Unmarshal(byteValue, &db)

	if err != nil {
		return nil, fmt.Errorf("Error unmarshalling json: %w", err)
	}

	db.filename = file

	return &db, nil
}

// Write changes to the database file
func (db *appdbimpl) Write() error {

	// encode json
	byteValue, err := json.MarshalIndent(db, "", "  ")

	if err != nil {
		return fmt.Errorf("Error marshalling json: %w", err)
	}

	// write to file
	err = ioutil.WriteFile(db.filename, byteValue, 0644)

	if err != nil {
		return fmt.Errorf("Error writing file: %w", err)
	}

	return nil
}

// Creates a new database with fake data
func NewDatabase(file string) *appdbimpl {

	stations := []Station{
		{
			Name:     "Napoli Centrale",
			BeaconID: "c7ed8863-f368-4810-bb06-998ec4316987",
			Location: Location{
				Latitutde: 40.852,
				Longitude: 14.270,
			},
		},
		{
			Name:     "Roma Termini",
			BeaconID: "61d09100-f9a2-43aa-b727-9d1a6f7a2bc2",
			Location: Location{
				Latitutde: 41.901,
				Longitude: 12.499,
			},
		},
		{
			Name:     "Roma Tiburtina",
			BeaconID: "331845ed-11c6-4028-8271-5cb1214de809",
			Location: Location{
				Latitutde: 41.910,
				Longitude: 12.528,
			},
		},
		{
			Name:     "Firenze S.M.N.",
			BeaconID: "6617c867-403e-4be6-a3b5-8573e2a80d75",
			Location: Location{
				Latitutde: 43.792,
				Longitude: 11.210,
			},
		},
		{
			Name:     "Bologna Centrale",
			BeaconID: "f3803edc-2736-4265-8554-7fccfe3b4fd4",
			Location: Location{
				Latitutde: 44.505,
				Longitude: 11.340,
			},
		},
		{
			Name:     "Ferrara",
			BeaconID: "3a780118-6815-4188-b84f-2cfcf004949d",
			Location: Location{
				Latitutde: 44.842,
				Longitude: 11.601,
			},
		},
		{
			Name:     "Padova",
			BeaconID: "aae16383-257d-4a16-8eab-734c28084801",
			Location: Location{
				Latitutde: 45.417,
				Longitude: 11.877,
			},
		},
		{
			Name:     "Venezia Mestre",
			BeaconID: "114ab5a1-470e-4d47-83d1-66fef1e12817",
			Location: Location{
				Latitutde: 45.482,
				Longitude: 12.229,
			},
		},
		{
			Name:     "Venezia Santa Lucia",
			BeaconID: "f498fea7-a81b-460e-bc37-4e20af3bdcfc",
			Location: Location{
				Latitutde: 45.441,
				Longitude: 12.318,
			},
		},
		{
			Name:     "Pomezia-Santa Palomba",
			BeaconID: "f9233e49-dd1c-44b0-9c31-c67b98d808dd",
			Location: Location{
				Latitutde: 41.706,
				Longitude: 12.571,
			},
		},
		{
			Name:     "Campoleone",
			BeaconID: "a8a23bfb-ca7a-4a3c-a8dd-90d56e6f74e9",
			Location: Location{
				Latitutde: 41.642,
				Longitude: 12.645,
			},
		},
		{
			Name:     "Cisterna di Latina",
			BeaconID: "a6ec956a-ace3-4f95-99e7-7bff63677a5e",
			Location: Location{
				Latitutde: 41.588,
				Longitude: 12.830,
			},
		},
		{
			Name:     "Latina",
			BeaconID: "10c08a5e-f0c2-4487-8900-f6f0e9a52143",
			Location: Location{
				Latitutde: 41.537,
				Longitude: 12.946,
			},
		},
		{
			Name:     "Priverno Fossanova",
			BeaconID: "5307b088-a631-428b-96a5-78f3b968bbb7",
			Location: Location{
				Latitutde: 41.399,
				Longitude: 13.088,
			},
		},
		{
			Name:     "Monte San Biagio",
			BeaconID: "5af3e3e3-7dfb-46f4-9f86-a6cc478ac912",
			Location: Location{
				Latitutde: 41.347,
				Longitude: 13.349,
			},
		},
		{
			Name:     "Fondi-Sperlonga",
			BeaconID: "41cc5857-9c2a-4db5-ab0a-93517df758c4",
			Location: Location{
				Latitutde: 41.337,
				Longitude: 13.422,
			},
		},
		{
			Name:     "Formia-Gaeta",
			BeaconID: "6db1ca6e-7d0e-47a5-84e2-687eb085ee7b",
			Location: Location{
				Latitutde: 41.258,
				Longitude: 13.605,
			},
		},
	}

	return &appdbimpl{
		filename: file,
		Stations: stations,
		Trains: []Train{
			{
				ID:        "FR9422",
				BeaconID:  "c29ce823-e67a-4e71-bff2-abaa32e77a98",
				LastDelay: 0,
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[0],
						ScheduledArrivalTime:   "11:00",
						ScheduledDepartureTime: "12:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "13:20",
						ScheduledDepartureTime: "13:55",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[2],
						ScheduledArrivalTime:   "13:42",
						ScheduledDepartureTime: "13:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[3],
						ScheduledArrivalTime:   "15:11",
						ScheduledDepartureTime: "15:20",
						Platform:               8,
						Cost:                   5.5,
					},
					{
						Station:                &stations[4],
						ScheduledArrivalTime:   "15:58",
						ScheduledDepartureTime: "16:01",
						Platform:               17,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "IC774",
				BeaconID: "d2d1fc1d-ec6e-4be2-bb0b-9f55956efac0",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "11:00",
						ScheduledDepartureTime: "12:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "13:20",
						ScheduledDepartureTime: "13:55",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "13:42",
						ScheduledDepartureTime: "13:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "15:11",
						ScheduledDepartureTime: "15:20",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "R18271",
				BeaconID: "a50f90e0-1b9b-47bd-a89b-c6e5f0bd07d7",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "11:00",
						ScheduledDepartureTime: "12:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "13:20",
						ScheduledDepartureTime: "13:55",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "13:42",
						ScheduledDepartureTime: "13:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "15:11",
						ScheduledDepartureTime: "15:20",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "R18272",
				BeaconID: "5737c92a-670d-40cf-a550-6a29335ed7f3",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "13:00",
						ScheduledDepartureTime: "13:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "14:20",
						ScheduledDepartureTime: "14:21",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "15:42",
						ScheduledDepartureTime: "15:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "16:11",
						ScheduledDepartureTime: "16:12",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "R19572",
				BeaconID: "3b931c98-3a77-4add-b0a6-8c3087315fdf",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "14:00",
						ScheduledDepartureTime: "14:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "15:20",
						ScheduledDepartureTime: "15:21",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "16:42",
						ScheduledDepartureTime: "16:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "17:11",
						ScheduledDepartureTime: "17:12",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "R18273",
				BeaconID: "358474d2-a0bb-4abc-8bcf-b018a0cd7c3c",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "15:00",
						ScheduledDepartureTime: "15:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "16:20",
						ScheduledDepartureTime: "16:21",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "17:42",
						ScheduledDepartureTime: "17:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "18:11",
						ScheduledDepartureTime: "18:12",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			{
				ID:       "R18274",
				BeaconID: "a8980213-9cae-401f-96c2-fdaeb39d7d25",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[8],
						ScheduledArrivalTime:   "16:00",
						ScheduledDepartureTime: "16:09",
						Platform:               16,
						Cost:                   0.0,
					},
					{
						Station:                &stations[7],
						ScheduledArrivalTime:   "17:20",
						ScheduledDepartureTime: "17:21",
						Platform:               6,
						Cost:                   5.5,
					},
					{
						Station:                &stations[6],
						ScheduledArrivalTime:   "18:42",
						ScheduledDepartureTime: "18:45",
						Platform:               12,
						Cost:                   5.5,
					},
					{
						Station:                &stations[5],
						ScheduledArrivalTime:   "19:11",
						ScheduledDepartureTime: "19:12",
						Platform:               8,
						Cost:                   5.5,
					},
				},
			},
			// From Roma Termini to Formia
			{
				ID:       "R12655",
				BeaconID: "0a31fec3-37ed-452d-bbe7-e79327ad2a7b",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "08:00",
						ScheduledDepartureTime: "08:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "08:24",
						ScheduledDepartureTime: "08:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "08:31",
						ScheduledDepartureTime: "08:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "08:40",
						ScheduledDepartureTime: "08:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "08:49",
						ScheduledDepartureTime: "08:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "09:06",
						ScheduledDepartureTime: "09:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "09:17",
						ScheduledDepartureTime: "09:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "09:23",
						ScheduledDepartureTime: "09:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "09:40",
						ScheduledDepartureTime: "09:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12656",
				BeaconID: "6fd2134d-6111-4bfb-86a1-9f8125c7737f",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "10:00",
						ScheduledDepartureTime: "10:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "10:24",
						ScheduledDepartureTime: "10:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "10:31",
						ScheduledDepartureTime: "10:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "10:40",
						ScheduledDepartureTime: "10:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "10:49",
						ScheduledDepartureTime: "10:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "11:06",
						ScheduledDepartureTime: "11:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "11:17",
						ScheduledDepartureTime: "11:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "11:23",
						ScheduledDepartureTime: "11:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "11:40",
						ScheduledDepartureTime: "11:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12657",
				BeaconID: "e1d58361-44b7-474b-a931-ccce764fa4de",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "12:00",
						ScheduledDepartureTime: "12:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "12:24",
						ScheduledDepartureTime: "12:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "12:31",
						ScheduledDepartureTime: "12:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "12:40",
						ScheduledDepartureTime: "12:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "12:49",
						ScheduledDepartureTime: "12:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "13:06",
						ScheduledDepartureTime: "13:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "13:17",
						ScheduledDepartureTime: "13:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "13:23",
						ScheduledDepartureTime: "13:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "13:40",
						ScheduledDepartureTime: "13:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12658",
				BeaconID: "78896392-ac2a-49cf-b588-dd2895e81233",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "14:00",
						ScheduledDepartureTime: "14:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "14:24",
						ScheduledDepartureTime: "14:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "14:31",
						ScheduledDepartureTime: "14:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "14:40",
						ScheduledDepartureTime: "14:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "14:49",
						ScheduledDepartureTime: "14:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "15:06",
						ScheduledDepartureTime: "15:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "15:17",
						ScheduledDepartureTime: "15:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "15:23",
						ScheduledDepartureTime: "15:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "15:40",
						ScheduledDepartureTime: "15:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12659",
				BeaconID: "12300685-ec19-46c1-ad75-f1da38d27523",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "16:00",
						ScheduledDepartureTime: "16:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "16:24",
						ScheduledDepartureTime: "16:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "16:31",
						ScheduledDepartureTime: "16:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "16:40",
						ScheduledDepartureTime: "16:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "16:49",
						ScheduledDepartureTime: "16:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "17:06",
						ScheduledDepartureTime: "17:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "17:17",
						ScheduledDepartureTime: "17:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "17:23",
						ScheduledDepartureTime: "17:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "17:40",
						ScheduledDepartureTime: "17:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12660",
				BeaconID: "b33e3f28-ab77-4e01-a472-587892cd3cc3",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "18:00",
						ScheduledDepartureTime: "18:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "18:24",
						ScheduledDepartureTime: "18:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "18:31",
						ScheduledDepartureTime: "18:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "18:40",
						ScheduledDepartureTime: "18:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "18:49",
						ScheduledDepartureTime: "18:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "19:06",
						ScheduledDepartureTime: "19:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "19:17",
						ScheduledDepartureTime: "19:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "19:23",
						ScheduledDepartureTime: "19:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "19:40",
						ScheduledDepartureTime: "19:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12661",
				BeaconID: "9465c69f-5eca-4967-a609-d18eba98722c",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "20:00",
						ScheduledDepartureTime: "20:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "20:24",
						ScheduledDepartureTime: "20:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "20:31",
						ScheduledDepartureTime: "20:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "20:40",
						ScheduledDepartureTime: "20:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "20:49",
						ScheduledDepartureTime: "20:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "21:06",
						ScheduledDepartureTime: "21:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "21:17",
						ScheduledDepartureTime: "21:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "21:23",
						ScheduledDepartureTime: "21:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "21:40",
						ScheduledDepartureTime: "21:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12662",
				BeaconID: "0da70b41-eee6-465e-8573-709b1d825b6a",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "22:00",
						ScheduledDepartureTime: "22:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "22:24",
						ScheduledDepartureTime: "22:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "22:31",
						ScheduledDepartureTime: "22:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "22:40",
						ScheduledDepartureTime: "22:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "22:49",
						ScheduledDepartureTime: "22:52",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[13],
						ScheduledArrivalTime:   "23:06",
						ScheduledDepartureTime: "23:07",
						Platform:               4,
						Cost:                   3.5,
					},
					{
						Station:                &stations[14],
						ScheduledArrivalTime:   "23:17",
						ScheduledDepartureTime: "23:18",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[15],
						ScheduledArrivalTime:   "23:23",
						ScheduledDepartureTime: "23:24",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[16],
						ScheduledArrivalTime:   "23:40",
						ScheduledDepartureTime: "23:50",
						Platform:               1,
						Cost:                   2.5,
					},
				},
			},
			{
				ID:       "R12675",
				BeaconID: "73195d6c-710b-4848-872e-c5eb88fe03dc",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "15:00",
						ScheduledDepartureTime: "15:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "15:24",
						ScheduledDepartureTime: "15:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "15:31",
						ScheduledDepartureTime: "15:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "15:40",
						ScheduledDepartureTime: "15:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "15:49",
						ScheduledDepartureTime: "15:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
			{
				ID:       "R12676",
				BeaconID: "a380a811-809b-4198-96a3-80b05201768a",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "16:00",
						ScheduledDepartureTime: "16:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "16:24",
						ScheduledDepartureTime: "16:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "16:31",
						ScheduledDepartureTime: "16:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "16:40",
						ScheduledDepartureTime: "16:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "16:49",
						ScheduledDepartureTime: "16:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
			{
				ID:       "R12697",
				BeaconID: "7f1f4c5a-e3a3-40dd-b983-ec54f70f1be5",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "17:00",
						ScheduledDepartureTime: "17:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "17:24",
						ScheduledDepartureTime: "17:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "17:31",
						ScheduledDepartureTime: "17:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "17:40",
						ScheduledDepartureTime: "17:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "17:49",
						ScheduledDepartureTime: "17:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
			{
				ID:       "R12677",
				BeaconID: "c64b7c7b-ddca-4bc9-a1d1-40d7dc0e5559",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "18:00",
						ScheduledDepartureTime: "18:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "18:24",
						ScheduledDepartureTime: "18:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "18:31",
						ScheduledDepartureTime: "18:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "18:40",
						ScheduledDepartureTime: "18:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "18:49",
						ScheduledDepartureTime: "18:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
			{
				ID:       "R12678",
				BeaconID: "9a5e1634-f656-453b-a7a1-be230ee30223",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "19:00",
						ScheduledDepartureTime: "19:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "19:24",
						ScheduledDepartureTime: "19:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "19:31",
						ScheduledDepartureTime: "19:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "19:40",
						ScheduledDepartureTime: "19:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "19:49",
						ScheduledDepartureTime: "19:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
			{
				ID:       "R12679",
				BeaconID: "cb06e49a-d2ea-4fa3-8dd8-1d14b02ffd43",
				Trip: &[]TrainTripItem{
					{
						Station:                &stations[1],
						ScheduledArrivalTime:   "20:00",
						ScheduledDepartureTime: "20:06",
						Platform:               11,
						Cost:                   0.0,
					},
					{
						Station:                &stations[9],
						ScheduledArrivalTime:   "20:24",
						ScheduledDepartureTime: "20:26",
						Platform:               1,
						Cost:                   3.5,
					},
					{
						Station:                &stations[10],
						ScheduledArrivalTime:   "20:31",
						ScheduledDepartureTime: "20:33",
						Platform:               2,
						Cost:                   1.5,
					},
					{
						Station:                &stations[11],
						ScheduledArrivalTime:   "20:40",
						ScheduledDepartureTime: "20:42",
						Platform:               1,
						Cost:                   2.5,
					},
					{
						Station:                &stations[12],
						ScheduledArrivalTime:   "20:49",
						ScheduledDepartureTime: "20:52",
						Platform:               2,
						Cost:                   1.5,
					},
				},
			},
		},
		UserStates:     make(map[string]*UserState),
		PaymentHistory: make(map[string][]PaymentResponse),
		ValidTickets:   make(map[string]string),
	}
}
