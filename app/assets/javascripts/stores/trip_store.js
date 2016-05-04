(function (root) {

  var _trips = [];
  var CHANGE_EVENT = "change";

  var reset_trips = function (trips) {
    _trips = trips;
  };

  root.TripStore = $.extend({}, EventEmitter.prototype, {

    all: function () {
      return _trips.slice(0);
    },

    addChangeListener: function (callback) {
      this.on(CHANGE_EVENT, callback);
    },

    removeChangeListener: function (callback) {
      this.removeListener(CHANGE_EVENT, callback);
    },

    DispatcherId: AppDispatcher.register(function (payload) {
      switch(payload.actionType){
        case TripConstants.TRIPS_RECEIVED:
          reset_trips(payload.trips);
          TripStore.emit(CHANGE_EVENT);
          break;
        case TripConstants.TRIP_RECEIVED:
          _trips.push(payload.trip);
          TripStore.emit(CHANGE_EVENT);
          break;
        case TripConstants.TRIP_DELETED:
          var spliceIdx = TripStore.findIndexInStore(payload.trip.id);
          _trips.splice(spliceIdx, 1);
          TripStore.emit(CHANGE_EVENT);
          break;
        case TripConstants.UPDATED_TRIP_RECEIVED:
          var tripIdx = TripStore.findIndexInStore(payload.trip.id);
          _trips[tripIdx] = payload.trip;
          TripStore.emit(CHANGE_EVENT);
          break;
      }
    }),

    findIndexInStore: function (comment_id) {
      for (var i = 0; i < _comments.length; i++) {
        if (_comments[i].id === comment_id) {
          return i;
        }
      }
      return -1;
    }

  });

})(this);
