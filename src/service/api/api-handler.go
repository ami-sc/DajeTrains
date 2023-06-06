package api

import (
	"net/http"
)

// Handler returns an instance of httprouter.Router that handle APIs registered here
func (rt *_router) Handler() http.Handler {
	// Register routes
	rt.router.GET("/", rt.getHelloWorld)
	rt.router.GET("/stations/:name", rt.wrap(rt.getStations))

	rt.router.GET("/stations/:name/departures", rt.wrap(rt.getStationDepartures))
	rt.router.GET("/stations/:name/arrivals", rt.wrap(rt.getStationArrivals))

	rt.router.PUT("/positions/:user_id", rt.wrap(rt.updateUserPosition))
	rt.router.GET("/positions/:user_id", rt.wrap(rt.getUserPosition))

	rt.router.GET("/payment_history/:user_id", rt.wrap(rt.getPaymentHistory))

	rt.router.GET("/trains/:name", rt.wrap(rt.getTrains))

	rt.router.PUT("/trains/:train_id", rt.wrap(rt.updateTrainPosition))
	rt.router.DELETE("/trains/:train_id", rt.wrap(rt.resetTrainPosition))

	rt.router.GET("/tickets/:ticket_code", rt.wrap(rt.validateTicket))

	rt.router.GET("/beacons", rt.wrap(rt.getBeacons))

	return rt.router
}
