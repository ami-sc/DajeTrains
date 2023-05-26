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

