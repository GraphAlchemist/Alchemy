    
    Alchemy::Index = (instance)->
        a = instance

        # Index maintains an index of common mappings/selections of
        # nodes and edges to reduce iteration during non-creative/destructive
        # operation of alchemy.
        
        # a.elements is set with base iterations that other iterations are made
        # from.  These are seperated out so that other indexes can use them
        # during creation instead of recreating them during index.

        a.elements = 
            nodes:
                svg : do -> a.vis.selectAll('g.node')[0]
                val : do -> _.values a._nodes
            edges:
                svg : do -> a.vis.selectAll('g.edge')[0]
                val : do -> _.values a._edges

        nodes = a.elements.nodes
        edges = a.elements.edges

        # Auxiliary indexes. ORDER IS IMPORTANT.
        # Before reordering or adding a new index, see if you can
        # use a previous index in it's creation.

        a.elements.nodes.d3 = do -> _.map nodes.val, (n)-> n._d3

        a.elements.edges.flat = do -> _.flatten edges.val
        a.elements.edges.d3   = do -> _.map edges.flat, (e)-> e._d3