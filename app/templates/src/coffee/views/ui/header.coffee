define (require) ->
	Views = 
		Base: require 'views/base'

	tpls = require 'tpls'

	class Header extends Views.Base

		tagName: 'header'

		initialize: ->
			super

			@render()

		render: ->
			rtpl = tpls['ui/header']()
			@$el.html rtpl

			@