define (require) ->

	BaseView = require 'views/base'

	tpls = require 'tpls'

	class Home extends BaseView

		initialize: ->
			super

			@render()

		render: ->
			rtpl = tpls['home']()
			@$el.html rtpl

			@