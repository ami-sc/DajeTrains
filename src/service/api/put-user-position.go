package api

import (
	"encoding/json"
	"net/http"

	"github.com/ami-sc/DajeTrains/service/api/reqcontext"
	"github.com/julienschmidt/httprouter"
)

// update user position
func (rt *_router) updateUserPosition(w http.ResponseWriter, r *http.Request, ps httprouter.Params, ctx reqcontext.RequestContext) {
	w.Header().Set("content-type", "application/json")

	user_id := ps.ByName("user_id")
	beacon_id := r.URL.Query().Get("beacon_id")

	status, err := rt.db.UpdateUserPosition(user_id, beacon_id)

	if err == nil {
		_ = json.NewEncoder(w).Encode(status)
	}
}