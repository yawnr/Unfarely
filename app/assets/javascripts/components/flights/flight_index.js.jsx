var FlightIndex = React.createClass({
  
  getInitialState: function () {
    return { flights: [] };
  },

  componentDidMount: function () {
    FlightStore.addChangeListener(this.onChange);
    ApiUtil.fetchFlightsSample();
  },

  onChange: function () {
    new_flights = FlightStore.all();
    this.setState({ flights: new_flights });
  },

  render: function () {
    var toRender;

    if (this.state.flights.length === 0) {
      toRender = (<div>Add flights</div>);
    } else {
      toRender = (
        <div>
          <ul className="group">
            {this.state.flights.map(function (flight) {
                return (<Flight key={flight.id} flight={flight} />);
              })
            }
          </ul>
        </div>
      )
    }
    return (toRender);
  }
})
