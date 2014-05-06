custom = {}
custom.nodeClick = (d, bio_url) ->
    $('.d3-tip').remove()
    d3.text "#{bio_url}#{d.id}", (error, response) ->
        if response
            custom.div = """
                            <div class='d3-tip'>
                                #{response}
                                <ul>
                                    <li class='lead'>
                                        Influencer Score: <span class="coming-soon">Coming soon!</span>
                                    </li>
                                    <li class='lead'>
                                        Messenger Score: <span class="coming-soon">Coming soon!</span>
                                    </li>
                                    <li class='lead'>
                                        Popularity Score: <span class="coming-soon">Coming soon!</span>
                                    </li>
                                </ul>
                            </div>
                         """
            $('.alchemy').append(custom.div)
            return

custom.mouseOut = (d) ->
    custom.PopUp.transition()
                .delay(500)
                .remove()

customConf = _.assign {},
    caption: (n) ->
        "#{n.li_firstName} #{n.li_lastName}"
    # dataSource: '/sample_data/org_graph_root_nodes_in_community.json'
    dataSource: '/sample_data/grace_huston_team.json'
    # initialScale: 0.305
    # initialTranslate:[462.646563149586, 276.6962475525915]
    initialScale: 0.0
    initialTranslate: [0.0 , 0.0]
    nodeMouseOver: (n) ->
       $("#node-#{n.id}")[0].popover({title: n.id, container: 'body'})
    # tipBody: 'li_firstName'
    # tipBody: (d) ->
    #             req = d3.html("http://social.test.com:8000/li_profile/bio/#{d.id}").get()
    #             .on('load', )
    # nodeMouseOver: (d) ->
    #     custom.mouseOver(d)
    # nodeMouseOut: (d) ->
    #     custom.mouseOut(d)
    nodeClick: (d) ->
        custom.nodeClick(d, window.alchemyConf.bio_url)
    

alchemy.conf = _.assign(alchemy.conf, customConf)