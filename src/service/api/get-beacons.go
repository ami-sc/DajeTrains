package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

func (rt *_router) getBeacons(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	_ = json.NewEncoder(w).Encode(rt.db.GetBeaconList())
}