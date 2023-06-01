package database

// Get a list of all the beacons
func (db *appdbimpl) GetBeaconList() *[]string {
	beacons := make([]string, 0)
	for _, station := range db.Stations {
		beacons = append(beacons, station.BeaconID)
	}
	for _, train := range db.Trains {
		beacons = append(beacons, train.BeaconID)
	}
	return &beacons
}