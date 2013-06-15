define (require) ->
	Backbone = require 'backbone'

	class MainRouter extends Backbone.Router

		'routes':
			'': 'home'

		home: ->