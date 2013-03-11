controller = require '../lib/express-controller'

module.exports = 

	WhenControllerDirectoryIsNotSpecified_ThenError: (test) ->

		test.expect 1

		controller null, (err) ->

			test.ok err isnt null

			test.done()

	WhenDirectoryDoesNotExists_ThenError: (test) ->

		test.expect 1

		controller dir: "invalid-dir", (err) ->

			test.ok err isnt null

			test.done()	

	IfControllerIsEmptyObject_ThenError: (test) ->

		test.expect 1

		controller dir: "./tests/controllers/emptyController", (err, routes) ->
	
			test.ok err			
			test.done()

	IfControllerDoesNotProperlySpecifyABaseRoute_ThenError: (test) ->

		test.expect 1

		controller dir: "./tests/controllers/badRoute", (err, routes) ->

			test.ok err
			test.done()

	IfRouteAndBaseRouteAreNotSpecified_ThenError: (test) ->

		test.expect 1

		controller { dir: "./tests/controllers/noRoute", verbose: true }, (err, routes) ->
			test.ok err
			test.done()

	IfRouteAndBaseRouteAreNotSpecified_ThenError: (test) ->

		test.expect 1

		controller dir: "./tests/controllers/noRoute", (err, routes) ->
			test.ok err
			test.done()

	AllRoutesLoadedProperly: (test) ->

		test.expect 6
		
		controller dir: "./tests/controllers/okController", (err, routes) ->

			test.ok not err
			test.equal 1, routes.length
			test.equal 'endpoint', routes[0].name
			test.equal '/base/endpoint', routes[0].route
			test.equal 2, routes[0].middleware.length
			test.ok typeof routes[0].handler is 'function'
			test.done()



