package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

// get user position
func (rt *_router) getUserPosition(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	user_id := ps.ByName("user_id")

	status := rt.db.GetUserPosition(user_id)

	if status == nil {
		w.WriteHeader(http.StatusNotFound)
		_ = json.NewEncoder(w).Encode((&UpdateResponse{UpdateStatus: "User not found"}))
		return
	}

	_ = json.NewEncoder(w).Encode(status)
}

// get user payment history
func (rt *_router) getPaymentHistory(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	user_id := ps.ByName("user_id")

	history, err := rt.db.GetPaymentHistory(user_id)

	if err != nil {
		w.WriteHeader(http.StatusNotFound)
		_ = json.NewEncoder(w).Encode((&UpdateResponse{UpdateStatus: err.Error()}))
		return
	}

	_ = json.NewEncoder(w).Encode(history)
}