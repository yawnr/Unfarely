var TripIndex = React.createClass({

  getInitialState: function () {
    return { trips: [] };
  },

  componentDidMount: function () {
    TripStore.addChangeListener(this.onChange);
    ApiUtil.fetchTrips();
  },

  onChange: function () {
    new_trips = TripStore.all();
    this.setState({ trips: new_trips });
  },

  render: function () {
    var toRender;

    if (window.Unfarely.currentUser.id == "null") {
      toRender = (<div>Please <a href='http://localhost:3000/session/new'>sign in to add trips.</a></div>)
    }
    else if (this.state.trips.length === 0) {
      toRender = (<div>Add trips</div>);
    } else {
      toRender = (
        <div>
          <ul className="group">
            {this.state.trips.map(function (trip) {
                return (<Trip key={trip.id} trip={trip} />);
              })
            }
          </ul>
        </div>
      )
    }
    return (toRender);
  }
})
