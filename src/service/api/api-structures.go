package api

type UpdateResponse struct {
	UpdateStatus string `json:"status"`
}

type TicketValidationResponse struct {
	TrainID string `json:"train_id"`
}