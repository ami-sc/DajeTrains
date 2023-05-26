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

// JSON database implementation todo json names
type appdbimpl struct {
	filename        string
	stations        []Station
	trains          []Train
	userStates      map[string]*UserState
	paymentHistory map[string][]PaymentResponse
}

type Location struct {
	Latitutde float64
	Longitude float64
}

type Station struct {
	Name     string
	BeaconID string
	Location Location
}

type TrainTripItem struct {
	Station                *Station
	ScheduledArrivalTime   string
	ScheduledDepartureTime string
	ArrivalTime            string
	DepartureTime          string
	Platform               int
	Cost                   float64
}

type Train struct {
	ID           string
	BeaconID     string
	Trip         *[]TrainTripItem
}

const (
	InTrain   string = "in_train"
	InStation        = "in_station"
	Away             = "away"
)

type UserState struct {
	Status  string
	Train   *Train
	Station *Station
}

type PaymentResponse struct {
	Cost        float64
	TrainID     string
	FromStation *Station
	ToStation   *Station
}

type UpdateUserPositionResponse struct {
	Status          string
	ID              string
	PaymentResponse *PaymentResponse
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
			Name:     "Station 1",
			BeaconID: "1234567890",
			Location: Location{
				Latitutde: 0,
				Longitude: 0,
			},
		},
		{
			Name:     "Station 2",
			BeaconID: "1234567891",
			Location: Location{
				Latitutde: 0,
				Longitude: 0,
			},
		},
	}

	return &appdbimpl{
		filename: file,
		stations: stations,
		trains: []Train{
			{
				ID:           "Train 1",
				BeaconID:     "1234567892",
				Trip: &[]TrainTripItem{
					{
						Station:       &stations[0],
						ScheduledArrivalTime:   "11:00",
						ScheduledDepartureTime: "11:05",
						Platform:      1,
						Cost:          0.0,
					},
					{
						Station:       &stations[1],
						ScheduledArrivalTime:   "12:00",
						ScheduledDepartureTime: "12:05",
						Platform:      2,
						Cost:          5.0,
					},
				},
			},
		},
		userStates:      make(map[string]*UserState),
		paymentHistory: make(map[string][]PaymentResponse),
	}
}
