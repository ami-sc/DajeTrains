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

	UpdateTrainPosition(trainID string, stationID string, status string) error
	ResetTrainPosition(trainID string) error
	GetPaymentHistory(userID string) ([]PaymentResponse, error)
}

// JSON database implementation
type appdbimpl struct {
	filename       string
	stations       []Station
	trains         []Train
	userStates     map[string]*UserState
	paymentHistory map[string][]PaymentResponse
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
	ID       string           `json:"id"`
	BeaconID string           `json:"beacon_id"`
	Trip     *[]TrainTripItem `json:"trip"`
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
	Cost        float64  `json:"cost"`
	TrainID     string   `json:"train_id"`
	FromStation *Station `json:"from_station"`
	ToStation   *Station `json:"to_station"`
}

type UpdateUserPositionResponse struct {
	Status          string           `json:"status"`
	ID              string           `json:"id"`
	PaymentResponse *PaymentResponse `json:"payment_response"`
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
	// todo: write to file
	return nil
}

// Creates a new database with fake data
func NewDatabase(file string) *appdbimpl {

	stations := []Station{
		{
			Name:     "Napoli Centrale",
			BeaconID: "1234567890",
			Location: Location{
				Latitutde: 40.852,
				Longitude: 14.270,
			},
		},
		{
			Name:     "Roma Termini",
			BeaconID: "1234567891",
			Location: Location{
				Latitutde: 41.901,
				Longitude: 12.499,
			},
		},
		{
			Name:     "Roma Tiburtina",
			BeaconID: "1234567892",
			Location: Location{
				Latitutde: 41.910,
				Longitude: 12.528,
			},
		},
		{
			Name:     "Firenze S.M.N.",
			BeaconID: "1234567893",
			Location: Location{
				Latitutde: 43.792,
				Longitude: 11.210,
			},
		},
		{
			Name:     "Bologna Centrale",
			BeaconID: "1234567894",
			Location: Location{
				Latitutde: 44.505,
				Longitude: 11.340,
			},
		},
		{
			Name:     "Ferrara",
			BeaconID: "1234567891",
			Location: Location{
				Latitutde: 44.842,
				Longitude: 11.601,
			},
		},
		{
			Name:     "Padova",
			BeaconID: "1234567895",
			Location: Location{
				Latitutde: 45.417,
				Longitude: 11.877,
			},
		},
		{
			Name:     "Venezia Mestre",
			BeaconID: "1234567896",
			Location: Location{
				Latitutde: 45.482,
				Longitude: 12.229,
			},
		},
		{
			Name:     "Venezia Santa Lucia",
			BeaconID: "1234567897",
			Location: Location{
				Latitutde: 45.441,
				Longitude: 12.318,
			},
		},
	}

	return &appdbimpl{
		filename: file,
		stations: stations,
		trains: []Train{
			{
				ID:       "FR9422",
				BeaconID: "1234567898",
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
				BeaconID: "1234567899",
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
				BeaconID: "1234567820",
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
		userStates:     make(map[string]*UserState),
		paymentHistory: make(map[string][]PaymentResponse),
	}
}
