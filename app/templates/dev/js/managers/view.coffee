define (require) ->
	Backbone = require 'backbone'
	Collections =
		'View': require 'collections/view'

	class ViewManager

		currentViews = new Collections.View()

		selfDestruct = (view) ->
			if not currentViews.has(view)
				console.error('Unknown view!');
				return false;

			if view.destroy then view.destroy() else view.remove();
		};

		constructor: ->
			this.main = $('div#main');

		debugCurrentViews: currentViews

		clear: (view) ->
			# Remove one view
			if (view) {
				selfDestruct view 
				currentViews.remove view.cid
			# Remove all views
			else {
				currentViews.each (model) ->
					selfDestruct model.get('view')
				currentViews.reset()


		register: (view) ->
			if (view) 
				currentViews.add
					'id': view.cid
					'view': view

		show: (view) ->
			if (!view) this.main.html('');
			else this.main.html(view.$el);

	new ViewManager();