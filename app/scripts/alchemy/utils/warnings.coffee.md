    class warnings
        constructor: (instance) ->
            @a = instance
        
        dataWarning: =>
            if @a.conf.dataWarning and typeof @a.conf.dataWarning is 'function'
                @a.conf.dataWarning()
            else if @a.conf.dataWarning is 'default'
                no_results = """
                            <div class="modal fade" id="no-results">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title">Sorry!</h4>
                                        </div>
                                        <div class="modal-body">
                                            <p>#{@a.conf.warningMessage}</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                           """
                $('body').append no_results
                $('#no-results').modal 'show'
                
        divWarning: ->
            """
                create an element that matches the value for 'divSelector' in your conf.
                For instance, if you are using the default 'divSelector' conf, simply provide
                <div id='#alchemy'></div>.
            """