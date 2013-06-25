define (require) ->
	Backbone = require('backbone');

	class Views extend Backbone.Collection
		
		has: (view) -> 
			if this.get(view.cid) then true else false