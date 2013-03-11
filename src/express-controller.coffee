fs 		= require 'fs'
path 	= require 'path'

module.exports = (opts, done) ->

	opts = opts || {}
	opts.dir = opts.dir || null

	log = (message) ->

		if opts.verbose isnt true
			return

		console.log message

	isEmptyObject = (obj) ->

		for o of obj
			return false

		return true

	if not opts.dir?
		done new Error("Controller directory must be specified"), null
		return

	controllersPath = path.resolve opts.dir

	fs.exists controllersPath, (exists) ->

		if exists isnt true
			done new Error("Controller directory #{controllersPath} does not exist"), null
			return

		log("Loading controllers from #{controllersPath}")

		fs.readdir controllersPath, (err, files) ->
			if err?

				done err, null
			
			routes = []

			for file in files

				if ~file.indexOf('.js') or ~file.indexOf('.coffee')
					
					controllerName = file.replace(/\.coffee$/gi, "").replace(/\.js$/gi,"")

					log("Registering controller #{controllerName}")

					controller = require(path.join(controllersPath, controllerName))
					
					if isEmptyObject(controller) is true
						done new Error("Controller has not data"), null
						return 

					controllerOpts = controller['options'] || {}
					controllerOpts.baseRoute = controllerOpts.baseRoute || ''

					if not controllerOpts.baseRoute?
						done new Error("Base route option configured incorrectly for #{controllerName}"), null
						return

					for obj of controller
						if ~['options'].indexOf(obj.toLowerCase()) then continue
						action = controller[obj]

						method = action.method || 'get'
						route = "#{controllerOpts.baseRoute}#{action.route || ''}"

						if not route? or route.length is 0
							done new Error("Base route or action route must be specified. Action name: #{obj}"), null
							return 

						log "Registering route: #{route}"

						handler = action.handler
						middleware = action.middleware || []

						routes.push
							name: obj
							method: method
							route: route
							handler: handler
							middleware: middleware

						if opts.express?
							opts.express[method](route, middleware, handler)

				else

					log("Skipping file #{file}")

			done null, routes
