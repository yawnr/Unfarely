ApiActions = {

  receiveFlightsSample: function (flights) {
    AppDispatcher.dispatch({
      actionType: FlightConstants.FLIGHTS_RECEIVED,
      flights: flights
    })
  },

  receiveTrips: function (trips) {
    AppDispatcher.dispatch({
      actionType: TripConstants.TRIPS_RECEIVED,
      trips: trips
    });
  },

  receiveTrip: function (trip) {
    AppDispatcher.dispatch({
      actionType: TripConstants.TRIP_RECEIVED,
      trip: trip
    });
  },

  receiveUpdatedTrip: function (trip) {
    AppDispatcher.dispatch({
      actionType: TripConstants.UPDATED_TRIP_RECEIVED,
      trip: trip
    });
  },

  deleteTrip: function (trip) {
    AppDispatcher.dispatch({
      actionType: TripConstants.DELETE_TRIP,
      trip: trip
    });
  },

}
