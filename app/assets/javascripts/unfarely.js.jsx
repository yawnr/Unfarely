$(function () {

  var root = document.getElementById('content');
  var Router = ReactRouter.Router;
  var Route = ReactRouter.Route;
  var IndexRoute = ReactRouter.IndexRoute;

  var App = React.createClass({
    render: function () {
      return (
        <div className="app">
          <nav>Hey nav</nav>
          {this.props.children}
        </div>
      );
    }
  });

  var routes = (
    <Route path="/" component={App}>
      <IndexRoute component={TripIndex} />
      <Route path="/users/:userId" component={Profile} />
      <Route path="/flights" component={FlightIndex} />
    </Route>
  );

  if (!!root) {
    React.render(<Router>{routes}</Router>, root);
  }

});
