define (require) ->
	Backbone = require 'backbone'
	config = require 'config'
	
	Collections =
		'View': require 'collections/view'

	class ViewManager

		currentViews = new Collections.View()

		debugCurrentViews: currentViews

		selfDestruct = (view) ->
			if not currentViews.has(view)
				console.error 'Unknown view!'
				return false;

			if view.destroy then view.destroy() else view.remove()

		constructor: ->
			@main = $ config.appRootElement


		clear: (view) ->
			# Remove one view
			if view
				selfDestruct view 
				currentViews.remove view.cid
			# Remove all views
			else
				currentViews.each (model) ->
					selfDestruct model.get('view')
				currentViews.reset()


		register: (view) ->
			if view
				currentViews.add
					'id': view.cid
					'view': view


		show: (view) ->
			html = if not view? then '' else view.$el
			
			@main.html html

	new ViewManager();