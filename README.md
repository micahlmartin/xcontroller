# xcontroller

NodeJS controller framework for express. Makes your controller more easily testable.

## Usage

Configuration:  
```javascript  
var app = require('express')()
var controllers = require('xcontroller');

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

If you want to manually register the callbacks

```javascript  
var controllers = require('xcontroller');
controllers("./controllers", function(routes){ 
  /*
    Route:
    
      name
      route
      middleware: [] or function(req, res, next)
      method: 'get', 'post', 'put', 'delete'
      handler: function(req, res)
    
    Manually register with 
    
    
      app[method](route, middleware, handler)
  */
});
```

