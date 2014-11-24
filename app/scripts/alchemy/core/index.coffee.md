    
    Alchemy::Index = (instance)->
        a = instance

        # Index maintains an index of common mappings/selections of
        # nodes and edges to reduce iteration during non-creative/destructive
        # operation of alchemy.
        
        # a.elements is set with base iterations that other iterations are made
        # from.  These are seperated out so that other indexes can use them
        # during creation instead of recreating them during index.

        # ORDERING IS IMPORTANT!
        # Before reordering or adding a new index, see if you can
        # use a previous index in it's creation.
        
        elements =
            nodes:
                val: do -> _.values a._nodes
            edges:
                val: do -> _.values a._edges
        
        nodes = elements.nodes
        edges = elements.edges

        elements.edges.flat = do -> _.flatten edges.val

        elements.nodes.d3 = do -> _.map nodes.val, (n)-> n._d3
        elements.edges.d3 = do -> _.map edges.flat, (e)-> e._d3

        if a.initial
            elements.nodes.svg = do -> a.vis.selectAll 'g.node'
            elements.edges.svg = do -> a.vis.selectAll 'g.edge'

        a.elements = elements

        () ->
            # Auxiliary indexes.
            a.elements.nodes.svg = do -> a.vis.selectAll 'g.node'
            a.elements.edges.svg  = do -> a.vis.selectAll 'g.edge'