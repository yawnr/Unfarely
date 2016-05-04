ApiUtil = {

  fetchFlightsSample: function () {
    $.ajax({
      url: 'api/best_flights',
      method: "GET",
      dataType: "json",
      success: function (flights) {
        ApiActions.receiveFlightsSample(flights);
      }
    })
  },

  fetchTrips: function () {
    $.ajax({
      url: 'api/trips',
      method: "GET",
      dataType: "json",
      success: function (trips) {
        ApiActions.receiveTrips(trips);
      }
    });
  },

  createTrip: function (trip) {
    $.ajax({
      url: 'api/trip',
      method: "POST",
      dataType: "json",
      data: {trip: trip},
      success: function (trip) {
        ApiUtil.receiveTrip(trip);
      }
    });
  },

  editTrip: function (trip) {
    $.ajax({
      url: 'api/trips/' + trip.id,
      method: "PATCH",
      dataType: "json",
      data: {trip: trip},
      success: function (trip) {
        ApiActions.receiveUpdatedTrip(trip);
      }
    });
  },

  deleteTrip: function (trip_id) {
    $.ajax({
      url: 'api/trips/' + trip_id,
      method: "DELETE",
      dataType: "json",
      success: function (trip) {
        ApiActions.deleteTrip(trip);
      }
    });
  },

};
