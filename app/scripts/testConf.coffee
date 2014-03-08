window.alchemyConf =
    caption: (n) ->
        "#{n.li_firstName} #{n.li_lastName}"
    dataSource: '/sample_data/grace_huston_team.json'
    initialScale: 0.3081060106225185
    initialTranslate:[462.646563149586,276.6962475525915]
    #nodeMouseOver: (n) ->
    #    $("#node-#{n.id}")[0].popover({title: n.id, container: 'body'})
    nodeMouseOver: true
    tipBody: 'li_firstName'
    # tipBody: (d) ->
    #     d3.html("http://social.test.com:8000/li_profile/bio/#{d.id}")
