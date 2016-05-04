var Flight = React.createClass({

  render: function () {
    return (
      <div>Flight {this.props.flight.id}, from {this.props.flight.departure_airport_id}
      to {this.props.flight.arrival_airport_id}, on {this.props.flight.full_date} for ${this.props.flight.price}</div>
    );
  }

})
