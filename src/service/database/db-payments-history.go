package database

import "errors"

func (db *appdbimpl) GetPaymentHistory(userID string) ([]PaymentResponse, error) {

	if db.PaymentHistory[userID] == nil {
		return nil, errors.New("User has no payment history")
	}

	return db.PaymentHistory[userID], nil
}
