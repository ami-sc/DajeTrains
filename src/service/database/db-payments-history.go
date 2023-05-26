package database

import "errors"

func (db *appdbimpl) GetPaymentHistory(userID string) ([]PaymentResponse, error) {

	if db.paymentHistory[userID] == nil {
		return nil, errors.New("User has no payment history")
	}

	return db.paymentHistory[userID], nil
}
