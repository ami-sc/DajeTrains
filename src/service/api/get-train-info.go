package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

func (rt *_router) getStations(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	stations := rt.db.GetStations(ps.ByName("name"))

	_ = json.NewEncoder(w).Encode(stations)
}

func (rt *_router) getTrains(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	trains := rt.db.GetTrains(ps.ByName("name"))

	_ = json.NewEncoder(w).Encode(trains)
}

func (rt *_router) getStationDepartures(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {

	data, err := rt.db.GetStationDepartures(ps.ByName("name"))

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Header().Set("content-type", "application/json")

	_ = json.NewEncoder(w).Encode(data)
}

func (rt *_router) getStationArrivals(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {

	data, err := rt.db.GetStationArrivals(ps.ByName("name"))

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Header().Set("content-type", "application/json")

	_ = json.NewEncoder(w).Encode(data)
}