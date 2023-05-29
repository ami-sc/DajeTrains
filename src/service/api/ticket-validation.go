package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

// validate a ticket
func (rt *_router) validateTicket(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	ticket := ps.ByName("ticket_code")

	trainID, err := rt.db.ValidateTicket(ticket)

	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(&TicketValidationResponse{
			TrainID: "TICKET_INVALID",
		})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(&TicketValidationResponse{
		TrainID: trainID,
	})
}
