(function (root) {

  var _flights = [];
  var CHANGE_EVENT = "change";

  var reset_flights = function (flights) {
    _flights = flights;
  };

  root.FlightStore = $.extend({}, EventEmitter.prototype, {

    all: function () {
      return _flights.slice(0);
    },

    addChangeListener: function (callback) {
      this.on(CHANGE_EVENT, callback);
    },

    removeChangeListener: function (callback) {
      this.removeListener(CHANGE_EVENT, callback);
    },

    DispatcherId: AppDispatcher.register(function (payload) {
      switch(payload.actionType){
        case FlightConstants.FLIGHTS_RECEIVED:
          reset_flights(payload.flights);
          FlightStore.emit(CHANGE_EVENT);
          break;
      }
    }),

  });

})(this);
