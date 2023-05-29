package database

import (
	"errors"

	"github.com/gofrs/uuid"
)

func (db *appdbimpl) generateTicket(trainID string) (string, error) {

	// check if the train exists
	_, err := db.getTrainByID(trainID)

	if err != nil {
		return "", err
	}

	// generate a new ticket (a ticket is a UUID)
	ticket, err := uuid.NewV4()

	if err != nil {
		return "", err
	}

	db.ValidTickets[ticket.String()] = trainID

	// write changes to the database
	err = db.Write()

	if err != nil {
		return "", err
	}

	return ticket.String(), nil
}

func (db *appdbimpl) ValidateTicket(ticket string) (string, error) {

	// check if the ticket exists
	trainID, ok := db.ValidTickets[ticket]

	if !ok {
		return "", errors.New("Invalid ticket")
	}

	return trainID, nil
}