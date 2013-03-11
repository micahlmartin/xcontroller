# express-controller

NodeJS controller framework for express

## usage

```javascript  
var app = require('express')()
var controllers = require('express-controller');

controllersPath = path.resolve("./controllers");

controllers({
  dir: controllersPath,
  express: app,
  verbose: true
});
```  

If you're not using express you can manully register the callbacks

```javascript  
var controllers = require('express-controller');
controllersPath = path.resolve("./controllers");
controllers(controllersPath, function(routes){ 
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

