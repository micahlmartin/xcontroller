# express-controller

NodeJS controller framework for express

## Usage

```javascript  
var app = require('express')()
var controllers = require('express-controller');

controllers({
  dir: './controllersPath', /* the path where the controllers are located */
  express: app, /* optionally pass in express to automatically register the routes */
  verbose: true /* writes debug logging to the console */
});
```

Example Controller:  
```javascript  
module.exports = {
  
  options: {
    baseRoute: '/myRoute'
  },
  
  /*
      method: defaults to 'get'
      route: uses the base route of '/myRoute'
  */
  index: {
    handler: function (req, res) {
      res.send("Hello World!");
    }
  },
  
  /*
      handles a post reqest
      add some middleware
      sets a route of '/myroute/:id/edit'
  */
  edit: {
    route: '/:id/edit',
    method: 'post',
    middleware: requireLogin /* some middleware */,
    handler: function (req, res) {
      res.send "Editing something"
    }
  }
  
};
```

If you're not using express or you want to manually register the callbacks

```javascript  
var controllers = require('express-controller');
controllers("./controllers", function(routes){ 
  /*
    Route:
    
      name
      route
      middleware: [] or function(req, res, next)
      method: 'get', 'post', 'put', 'delete'
      handler: function(req, res)
    
    Manually register with express
    
      app[method](route, middleware, handler)
  */
});
```

