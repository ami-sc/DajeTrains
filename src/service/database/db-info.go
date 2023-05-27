package database

import (
	"errors"
	"strings"
)

// Get stations by name
func (db *appdbimpl) GetStations(filter string) *[]Station {
	stations := make([]Station, 0)
	for _, station := range db.Stations {
		if strings.Contains(strings.ToLower(station.Name), strings.ToLower(filter)) {
			stations = append(stations, station)
		}
	}
	return &stations
}

// Get trains by ID
func (db *appdbimpl) GetTrains(filter string) *[]Train {
	trains := make([]Train, 0)
	for _, train := range db.Trains {
		if strings.Contains(strings.ToLower(train.ID), strings.ToLower(filter)) {
			trains = append(trains, train)
		}
	}
	return &trains
}

// Get train by ID
func (db *appdbimpl) getTrainByID(ID string) (*Train, error) {
	for _, train := range db.Trains {
		if strings.ToLower(train.ID) == strings.ToLower(ID) {
			return &train, nil
		}
	}
	return nil, errors.New("Train not found")
}

// Get station by ID
func (db *appdbimpl) GetStationByID(ID string) (*Station, error) {
	for _, station := range db.Stations {
		if strings.ToLower(station.Name) == strings.ToLower(ID) {
			return &station, nil
		}
	}
	return nil, errors.New("Station not found")
}

// Get station by beacon ID
func (db *appdbimpl) GetStationByBeaconID(beaconID string) *Station {
	for _, station := range db.Stations {
		if station.BeaconID == beaconID {
			return &station
		}
	}
	return nil
}

// Get train by beacon ID
func (db *appdbimpl) GetTrainByBeaconID(beaconID string) *Train {
	for _, train := range db.Trains {
		if train.BeaconID == beaconID {
			return &train
		}
	}
	return nil
}