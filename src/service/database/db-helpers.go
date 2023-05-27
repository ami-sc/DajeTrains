package database

import "errors"

func (db *appdbimpl) processPayment(userID string, train Train, from_station Station, to_station Station) (*PaymentResponse, error) {

	start_index := indexStation(from_station, train)
	if start_index == -1 {
		return nil, errors.New("Start station not found in train's trip")
	}

	end_index := indexStation(to_station, train)
	if end_index == -1 {
		return nil, errors.New("End station not found in train's trip")
	}

	total_cost := 0.0

	for i := start_index + 1; i <= end_index; i++ {
		total_cost += (*train.Trip)[i].Cost
	}

	payment := PaymentResponse{
		Cost:        total_cost,
		TrainID:     train.ID,
		FromStation: &from_station,
		ToStation:   &to_station,
	}

	if total_cost > 0.0 {
		if db.PaymentHistory[userID] == nil {
			db.PaymentHistory[userID] = make([]PaymentResponse, 0)
		}
		db.PaymentHistory[userID] = append(db.PaymentHistory[userID], payment)
	}

	return &payment, nil
}

// Find the last station the train has arrived to
func findLastStation(train Train) (*Station, error) {
	for k, v := range *train.Trip {
		if v.ArrivalTime == "" {

			if k == 0 {
				return nil, errors.New("Train is not in a station")
			}

			return (*train.Trip)[k-1].Station, nil
		}
	}

	// Train is in the last station
	return (*train.Trip)[len(*train.Trip)-1].Station, nil
}

// Find the position of a station in a train's trip
func indexStation(station Station, train Train) int {
	for k, v := range *train.Trip {
		if station == *v.Station {
			return k
		}
	}
	return -1
}