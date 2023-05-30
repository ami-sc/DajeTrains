package database

import (
	"errors"
	"time"
)

// Update train position
func (db *appdbimpl) UpdateTrainPosition(trainID string, stationID string, status string) error {

	train, err := db.getTrainByID(trainID)

	if err != nil {
		return err
	}

	// get station
	station, err := db.GetStationByID(stationID)

	if err != nil {
		return err
	}

	station_idx := indexStation(*station, *train)

	if station_idx == -1 {
		return errors.New("Station not found in train's trip")
	}

	// check if the train is arrived on all the previous stations
	for i := 0; i < station_idx; i++ {
		if (*train.Trip)[i].ArrivalTime == "" || (*train.Trip)[i].DepartureTime == "" {
			return errors.New("Illegal train position update: train is not arrived to and departed from all the previous stations")
		}
	}

	// check if the train is arrived before departing
	if status == "departed" {
		// check if the train is already arrived
		if station_idx > 0 && (*train.Trip)[station_idx - 1].ArrivalTime != "" {
			return errors.New("Illegal train position update: train has never arrived to the station")
		}
	}

	if status == "arrived" {
		(*train.Trip)[station_idx].ArrivalTime = time.Now().Format("15:04")
	}
	if status == "departed" {
		(*train.Trip)[station_idx].DepartureTime = time.Now().Format("15:04")
	}

	delay, err := getTrainDelay(*train)

	if err != nil {
		return err
	}

	train.LastDelay = delay

	err = db.Write()

	if err != nil {
		return err
	}

	return nil
}

func (db *appdbimpl) ResetTrainPosition(trainID string) error {

	train, err := db.getTrainByID(trainID)

	if err != nil {
		return err
	}

	for i := 0; i < len(*train.Trip); i++ {
		(*train.Trip)[i].ArrivalTime = ""
		(*train.Trip)[i].DepartureTime = ""
	}
	train.LastDelay = 0

	// delete all the tickets for this train
	for ticket, train := range db.ValidTickets {
		if train == trainID {
			delete(db.ValidTickets, ticket)
		}
	}

	err = db.Write()

	if err != nil {
		return err
	}

	return nil
}