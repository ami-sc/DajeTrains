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
				ID:       "FR9210",
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
		},
		UserStates:     make(map[string]*UserState),
		PaymentHistory: make(map[string][]PaymentResponse),
		ValidTickets:   make(map[string]string),
	}
}
