package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

// update train position
func (rt *_router) updateTrainPosition(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	train_id := ps.ByName("train_id")
	station_id := r.URL.Query().Get("station_id")
	status := r.URL.Query().Get("status")
	time_string := r.URL.Query().Get("time")

	err := rt.db.UpdateTrainPosition(train_id, station_id, status, time_string)

	if err != nil {
		// set status code to 400
		w.WriteHeader(http.StatusBadRequest)
		_ = json.NewEncoder(w).Encode(&UpdateResponse{UpdateStatus: err.Error()})
		return
	}
	_ = json.NewEncoder(w).Encode(&UpdateResponse{UpdateStatus: "OK"})
}

// reset train position
func (rt *_router) resetTrainPosition(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	train_id := ps.ByName("train_id")

	err := rt.db.ResetTrainPosition(train_id)

	if err != nil {
		// set status code to 404
		w.WriteHeader(http.StatusNotFound)
		_ = json.NewEncoder(w).Encode(&UpdateResponse{UpdateStatus: err.Error()})
		return
	}
	_ = json.NewEncoder(w).Encode(&UpdateResponse{UpdateStatus: "OK"})
}