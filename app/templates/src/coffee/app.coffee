define (require) ->
    Backbone = require 'backbone'

    MainRouter = require 'routers/main'

    viewManager = require 'hilib/managers/view'

    Views =
        Header: require 'views/ui/header'

    initialize: ->
        mainRouter = new MainRouter()

        viewManager.show '.wrapper', Views.Header,
            prepend: true
            persist: true

        Backbone.history.start pushState: true   

        $(document).on 'click', 'a:not([data-bypass])', (e) ->
            href = $(@).attr 'href'
            
            if href?
                e.preventDefault()

                Backbone.history.navigate href, trigger: true