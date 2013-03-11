(function() {
  var fs, path;

  fs = require('fs');

  path = require('path');

  module.exports = function(opts, done) {
    var controllersPath, isEmptyObject, log;
    if (typeof opts === "string") {
      opts = {
        dir: opts
      };
    }
    opts = opts || {};
    opts.dir = opts.dir || null;
    done = done || function() {};
    log = function(message) {
      if (opts.verbose !== true) {
        return;
      }
      return console.log(message);
    };
    isEmptyObject = function(obj) {
      var o;
      for (o in obj) {
        return false;
      }
      return true;
    };
    if (opts.dir == null) {
      done(new Error("Controller directory must be specified"), null);
      return;
    }
    controllersPath = path.resolve(opts.dir);
    return fs.exists(controllersPath, function(exists) {
      if (exists !== true) {
        done(new Error("Controller directory " + controllersPath + " does not exist"), null);
        return;
      }
      log("Loading controllers from " + controllersPath);
      return fs.readdir(controllersPath, function(err, files) {
        var action, controller, controllerName, controllerOpts, file, handler, method, middleware, obj, route, routes, _i, _len;
        if (err != null) {
          done(err, null);
        }
        routes = [];
        for (_i = 0, _len = files.length; _i < _len; _i++) {
          file = files[_i];
          if (~file.indexOf('.js') || ~file.indexOf('.coffee')) {
            controllerName = file.replace(/\.coffee$/gi, "").replace(/\.js$/gi, "");
            log("Registering controller " + controllerName);
            controller = require(path.join(controllersPath, controllerName));
            if (isEmptyObject(controller) === true) {
              done(new Error("Controller has not data"), null);
              return;
            }
            controllerOpts = controller['options'] || {};
            controllerOpts.baseRoute = controllerOpts.baseRoute || '';
            if (controllerOpts.baseRoute == null) {
              done(new Error("Base route option configured incorrectly for " + controllerName), null);
              return;
            }
            for (obj in controller) {
              if (~['options'].indexOf(obj.toLowerCase())) {
                continue;
              }
              action = controller[obj];
              method = action.method || 'get';
              route = "" + controllerOpts.baseRoute + (action.route || '');
              if ((route == null) || route.length === 0) {
                done(new Error("Base route or action route must be specified. Action name: " + obj), null);
                return;
              }
              handler = action.handler;
              middleware = action.middleware || [];
              routes.push({
                name: obj,
                method: method,
                route: route,
                handler: handler,
                middleware: middleware
              });
              if (opts.express != null) {
                log("Registering route with express: " + route);
                opts.express[method](route, middleware, handler);
              }
            }
          } else {
            log("Skipping file " + file);
          }
        }
        return done(null, routes);
      });
    });
  };

}).call(this);
