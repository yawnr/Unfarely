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
    <IndexRoute component={Test} />
    <Route path="/users/:userId" component={Profile} />
  </Route>
);

React.render(<Router>{routes}</Router>, root);

});
