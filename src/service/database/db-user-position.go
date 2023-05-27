package database

// Update user position
func (db *appdbimpl) UpdateUserPosition(userID string, beaconID string) (*UpdateUserPositionResponse, error) {

	// get current user position
	previousPosition := Away
	previousUserPosition := db.GetUserPosition(userID)

	if previousUserPosition != nil {
		previousPosition = previousUserPosition.Status
	}

	if station := db.GetStationByBeaconID(beaconID); station != nil {
		// User is in a station

		// update the database
		db.UserStates[userID] = &UserState{
			Station: station,
			Train:   nil,
			Status:  InStation,
		}
		db.Write() // todo: write to the database

		// check if the user was on a train
		if previousPosition == InTrain {
			// process payment
			payment, err := db.processPayment(userID, *previousUserPosition.Train, *previousUserPosition.Station, *station)

			// payment is successful
			if err == nil {
				return &UpdateUserPositionResponse{
					Status:          InStation,
					ID:              station.Name,
					PaymentResponse: payment,
				}, nil
			}
			// if payment fails, it means that one of the stations is not in the train's trip
			// if it happens, it means that there is an error in the database
			// so we don't charge the user
		}

		// user was not on a train
		return &UpdateUserPositionResponse{
			Status:          InStation,
			ID:              station.Name,
			PaymentResponse: nil,
		}, nil

	} else if train := db.GetTrainByBeaconID(beaconID); train != nil {
		// User is in a train

		// Check if the user was in a different train before
		// this means that the user has changed train (very quickly)

		last_train_station, err := findLastStation(*train)

		if err != nil {
			// error occurred: train hasn't arrived to any station
			// we suppose that the train is on the first station
			last_train_station = (*train.Trip)[0].Station
		}

		// update the database
		db.UserStates[userID] = &UserState{
			Station: last_train_station,
			Train:   train,
			Status:  InTrain,
		}
		db.Write() // todo: check for errors

		if previousPosition == InTrain && previousUserPosition.Train.BeaconID != beaconID {

			// find previous train's last station
			last_train_station, err := findLastStation(*previousUserPosition.Train)

			if err != nil {
				// error occurred: train hasn't arrived to any station
				// we suppose that the train is on the first station
				last_train_station = (*previousUserPosition.Train.Trip)[0].Station
			}

			payment, err := db.processPayment(userID, *previousUserPosition.Train, *previousUserPosition.Station, *last_train_station)

			if err != nil {
				// error processing the payment
				// if it happens, it means that there is an error in the database
				// so we don't charge the user
				return &UpdateUserPositionResponse{
					Status:          InTrain,
					ID:              train.ID,
					PaymentResponse: nil,
				}, err
			}

			return &UpdateUserPositionResponse{
				Status:          InTrain,
				ID:              train.ID,
				PaymentResponse: payment,
			}, nil
		}

		// user still is in the same train
		// we don't need to update the database or process any payment (yet)
		return &UpdateUserPositionResponse{
			Status:          InTrain,
			ID:              train.ID,
			PaymentResponse: nil,
		}, nil

	} else {
		// User is away from any beacon

		// update the database
		db.UserStates[userID] = &UserState{
			Station: nil,
			Train:   nil,
			Status:  Away,
		}
		db.Write() // todo: check for errors

		if previousPosition == InTrain {
			// User was on a train and it ended its trip

			// find train's last station
			last_train_station, err := findLastStation(*previousUserPosition.Train)

			if err != nil {
				// error occurred: train hasn't arrived to any station
				// we suppose that the train is on the first station
				last_train_station = (*previousUserPosition.Train.Trip)[0].Station
			}

			payment, err := db.processPayment(userID, *previousUserPosition.Train, *previousUserPosition.Station, *last_train_station)

			if err != nil {
				// error occurred: station not found in train's trip
				// if it happens, it means that there is an error in the database
				// so we don't charge the user
				return &UpdateUserPositionResponse{
					Status:          Away,
					ID:              "",
					PaymentResponse: nil,
				}, err
			}

			// payment is successful
			return &UpdateUserPositionResponse{
				Status:          Away,
				ID:              "",
				PaymentResponse: payment,
			}, nil
		}

		// user hasn't been on a train before
		// or payment was already processed
		return &UpdateUserPositionResponse{
			Status:          Away,
			ID:              "",
			PaymentResponse: nil,
		}, nil
	}
}

// Get user position
func (db *appdbimpl) GetUserPosition(userID string) *UserState {
	return db.UserStates[userID]
}
