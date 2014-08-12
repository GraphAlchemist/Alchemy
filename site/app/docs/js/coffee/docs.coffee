$ ->
    for section in $("#sidebar").children()
        href = $(section).children("a.level-1")[0].hash.replace("#", "")
        sectionContent = $("##{href}").children("h2, h3, h4, h5")
        if sectionContent.length
            $(section).append("<div id='lvl-2-#{href}' class='level-2 list-group'>")
            nextLvl = $("#lvl-2-#{href}")
            for header in sectionContent
                id = $(header).prop("id")
                text =  $(header)[0].innerText
                console.log id
                console.log text
                nextLvl.append("<a class='level-2 list-group-item' href='##{id}'>#{text}</a>")
            $("#sidebar").find(".level-2").addClass("hidden")

    # $(window).on 'hashchange', () ->
    #     activeItem = window.location.hash
    #     targetItem = "a[href='#{activeItem}']"
    #     activate(targetItem)

    $(window).on 'load', () ->
        activeItem = window.location.hash
        targetItem = "a[href='#{activeItem}']"
        activate(targetItem)

    $(".section-bar a")
        .on 'click', () ->
            activate(@)

    activate = (clickedItem) ->
        # event.preventDefault()
        # net additional padding from sidebar wrapper and <a> elements
        if $(clickedItem).length
            padding = 50 - 15 
            offset = $("#sidebar").offset().top - padding
            $("#sidebar").find('.active').removeClass("active")
            $("#sidebar").find('.level-2').addClass("hidden")

            $(clickedItem).parents(".section-bar").addClass("active")
            $(clickedItem).parents(".section-bar").find(".level-2").removeClass("hidden")
            $(clickedItem).addClass("active")

            pos =  $(clickedItem).offset().top - offset 
            $("#sidebar-wrapper").scrollTop(pos)

        # window.location.hash = $(clickedItem)[0].hash
        # id = $(clickedItem)[0].innerText
        # console.log $("##{id}").position().top
        # docPos = $("##{id}").position().top - 15
        # $("#doc-content").scrollTop(docPos)


