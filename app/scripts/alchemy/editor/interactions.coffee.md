    class EditorInteractions
        # @mouseUpNode = null
        # @sourceNode = null
        # @targetNode = null
        # @newEdge = null
        # @click = null
        constructor: ->
            @editor = new alchemy.editor.Editor

        nodeMouseOver: (n) ->
            if !d3.select(@).select("circle").empty()
                radius = d3.select @
                           .select "circle"
                           .attr "r"
                d3.select @
                  .select "circle"
                    .attr "r", radius*3
            @

        nodeMouseUp: (n) =>
            if @sourceNode != n
                @mouseUpNode = true
                @targetNode = n
                @click = false
            else 
                @click = true
            @

        nodeMouseOut: (n) ->
            if !d3.select(@).select("circle").empty()
                radius = d3.select @
                           .select "circle"
                           .attr "r"
                d3.select @
                  .select "circle"
                  .attr "r", radius/3
            @

        nodeClick: (c) =>
            d3.event.stopPropagation()
            # select the correct nodes
            if !alchemy.vis.select("#node-#{c.id}").empty()
                selected = alchemy.vis
                                  .select "#node-#{c.id}"
                                  .classed 'selected'
                alchemy.vis
                       .select "#node-#{c.id}"
                       .classed 'selected', !selected
            @editor.editorClear()
            @editor.nodeEditor c

        edgeClick: (e) =>
            d3.event.stopPropagation()
            @editor.editorClear()
            @editor.edgeEditor e
            
        addNodeStart: (d, i) =>
            d3.event.sourceEvent.stopPropagation()
            @sourceNode = d
            alchemy.vis
                .select '#dragline'
                .classed "hidden":false
            @

        addNodeDragging: (d, i) =>
            # rework
            x2coord = d3.event.x
            y2coord = d3.event.y
            alchemy.vis
                .select '#dragline'
                .attr "x1", @sourceNode.x
                .attr "y1", @sourceNode.y
                .attr "x2", x2coord
                .attr "y2", y2coord
                .attr "style", "stroke: #FFF"
            @


        addNodeDragended: (d, i) =>
            #we moused up on an existing (different) node
            if !@click 
                if !@mouseUpNode
                    dragline = alchemy.vis.select "#dragline"
                    targetX = dragline.attr "x2"
                    targetY = dragline.attr "y2"

                    @targetNode =
                        id: "#{_.uniqueId('addedNode_')}",
                        x: parseFloat(targetX),
                        y: parseFloat(targetY),
                        caption: "node added"

                @newEdge =
                    id: "#{@sourceNode.id}-#{@targetNode.id}", 
                    source: @sourceNode.id, 
                    target: @targetNode.id, 
                    caption: "edited"

                alchemy.editor.update @targetNode, @newEdge
            
            @reset()
            @

        deleteSelected: (d) =>
            switch d3.event.keyCode
                when 8, 46
                    if !(d3.select(d3.event.target).node().tagName is ("INPUT" or "TEXTAREA"))
                        d3.event.preventDefault()
                        alchemy.editor.remove()

        reset: =>
            # reset interaciton variables
            @mouseUpNode = null
            @sourceNode = null
            @targetNode = null
            @newEdge = null
            @click = null

            #reset dragline
            alchemy.vis
                .select "#dragline"
                .classed "hidden":true
                .attr "x1", 0            
                .attr "y1", 0
                .attr "x2", 0
                .attr "y2", 0 
            @

        @
