window.Dash = window.Dash || {}
window.Dash.DashboardConfig = ->

    #Get list of all available widgets
    getWidgets = (uri)->
        $.ajax uri, {
            dataType: 'json',
            success: (data) ->
               listWidgets(data)
            error: (error) ->
                console.log(error)
        }

    listWidgets = (widgets) ->
        $('.js-data ul').empty()
        widgets.forEach (widget) ->
            name = widget.name
            id = name.toLowerCase().replace(' ', '-')
            options = widget.options
            $elem = $("<h3>#{name}</h3>")
            console.log options
            for key, value of options
                $elem.after("""
                            <label for="js-#{id}-#{key}">#{key}</label>
                            <input id="js-#{id}-#{key}" value="#{value}" />
                            """)
            $('.js-available-widgets ul').append $elem
            $elem.wrapAll("<li class='js-#{id}' />")

    {
        getWidgets: getWidgets
    }
