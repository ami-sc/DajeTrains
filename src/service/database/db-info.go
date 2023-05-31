package database

import (
	"errors"
	"strings"
	"time"
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
	for i, train := range db.Trains {
		if strings.ToLower(train.ID) == strings.ToLower(ID) {
			return &db.Trains[i], nil
		}
	}
	return nil, errors.New("Train not found")
}

// Get station by ID
func (db *appdbimpl) GetStationByID(ID string) (*Station, error) {
	for i, station := range db.Stations {
		if strings.ToLower(station.Name) == strings.ToLower(ID) {
			return &db.Stations[i], nil
		}
	}
	return nil, errors.New("Station not found")
}

// Get station by beacon ID
func (db *appdbimpl) GetStationByBeaconID(beaconID string) *Station {
	for i, station := range db.Stations {
		if station.BeaconID == beaconID {
			return &db.Stations[i]
		}
	}
	return nil
}

// Get train by beacon ID
func (db *appdbimpl) GetTrainByBeaconID(beaconID string) *Train {
	for i, train := range db.Trains {
		if train.BeaconID == beaconID {
			return &db.Trains[i]
		}
	}
	return nil
}

// Get the departure timetable for a station
func (db *appdbimpl) GetStationDepartures(station string) (*[]StationTimetableItem, error) {
	return db.getStationTimetable(station, false)
}

// Get the arrivals timetable for a station
func (db *appdbimpl) GetStationArrivals(station string) (*[]StationTimetableItem, error) {
	return db.getStationTimetable(station, true)
}

// Get the station timetable
func (db *appdbimpl) getStationTimetable(station string, arrivals bool) (*[]StationTimetableItem, error) {

	timetable := make([]StationTimetableItem, 0)

	// for each train, check if it has to arrive or depart from the station
	for _, train := range db.Trains {
		for _, tripItem := range *train.Trip {
			if tripItem.Station.Name == station && ((arrivals && tripItem.ArrivalTime == "") || (!arrivals && tripItem.DepartureTime == "")) {

				timetable = append(timetable, StationTimetableItem{
					TrainID:                train.ID,
					FirstStation:           (*train.Trip)[0].Station.Name,
					LastStation:            (*train.Trip)[len(*train.Trip)-1].Station.Name,
					ScheduledArrivalTime:   tripItem.ScheduledArrivalTime,
					ScheduledDepartureTime: tripItem.ScheduledDepartureTime,
					LastDelay:              train.LastDelay,
					Platform:               tripItem.Platform,
				})
			}
		}
	}

	return &timetable, nil
}

// compute delay
func getTrainDelay(train Train) (int, error) {

	lastDelay := 0

	for _, tripItem := range *train.Trip {

		if tripItem.ScheduledDepartureTime != "" && tripItem.DepartureTime != "" {
			// compute delay as difference between scheduled and actual arrival time
			schedTime, err := time.Parse("15:04", tripItem.ScheduledDepartureTime)

			if err != nil {
				return -1, err
			}

			realTime, err := time.Parse("15:04", tripItem.DepartureTime)

			if err != nil {
				return -1, err
			}

			delay := realTime.Sub(schedTime)
			// get the delay in minutes
			lastDelay = int(delay.Minutes())
		} else if tripItem.ScheduledArrivalTime != "" && tripItem.ArrivalTime != "" {
			// compute delay as difference between scheduled and actual arrival time
			schedTime, err := time.Parse("15:04", tripItem.ScheduledArrivalTime)

			if err != nil {
				return -1, err
			}

			realTime, err := time.Parse("15:04", tripItem.ArrivalTime)

			if err != nil {
				return -1, err
			}

			delay := realTime.Sub(schedTime)
			// get the delay in minutes
			lastDelay = int(delay.Minutes())
		}
	}

	return lastDelay, nil
}
