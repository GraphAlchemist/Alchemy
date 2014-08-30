$ ->
    for section in $("#sidebar").children()
        href = $(section).children("a.level-1")[0].hash.replace("#", "")
        sectionContent = $("##{href}").children("section, h2, h3, h4, h5")
        if sectionContent.length
            $(section).append("<div id='lvl-2-#{href}' class='level-2 list-group'>")
            nextLvl = $("#lvl-2-#{href}")
            for header in sectionContent
                id = $(header).prop("id")
                if href (not "Configuration") and (not "API")
                    text =  $(header)[0].innerText
                    nextLvl.append("<a class='level-2 list-group-item' href='##{id}'>#{text}</a>")
                
                else
                    nextLvl.append("<a href='##{id}' class='level-2 list-group-item'>#{id}</a>")
                    nextLvl.append("<div id='lvl-3-#{id}' class='level-3 list-group'></div>")
                    configHeader = $("#lvl-3-#{id}")
                    subSectionContent = $("##{id}").children("h5")
                    for item in subSectionContent
                        ssID = $(item).prop("id")
                        text =  $(item)[0].innerText
                        configHeader.append("<a class='level-3 list-group-item' href='##{ssID}'>#{text}</a>")
                    $(configHeader).find("div.level-3").addClass("hidden")

                $("#sidebar").find("div.level-2").addClass("hidden")

    $("#social-hide")
        .on 'click', ()->
            $("#btn-alchemy-rel, #social-icons").toggleClass("hidden")

    $(window).on 'load', () ->
        activeItem = window.location.hash || "#Start"
        targetItem = "a[href='#{activeItem}']"
        activate(targetItem, false)
    
    $(".section-bar a")
        .on 'click', () ->
            activate(@, true)

    scrollActivate = (tocEl) ->
        padding = 50 - 15 
        offset = $("#sidebar").offset().top - padding
        if $(tocEl).hasClass("active")
                $("#pointer").removeClass("hidden")
                $(tocEl)
                    .parents(".level-3, .level-2, .level-1, .section-bar")
                        .removeClass("hidden")
                        .addClass("active")
                $(tocEl)
                    .siblings("a.level-1, a.level-2, a.level-3")
                        .removeClass("active")

            else if !$(tocEl).hasClass("active")
                $("#pointer").addClass("hidden")
                $(tocEl)
                    .parents(".level-3,  .level-2, .level-1, .section-bar")
                        .removeClass("active")
                $(tocEl)
                    .siblings("a.level-1, a.level-2, a.level-3")
                        .removeClass("active")

            pos =  $(tocEl).offset().top - offset 
            $("#sidebar-wrapper").scrollTop(pos)

    activate = (tocEl, click) ->
        # event.preventDefault()
        # net additional padding from sidebar wrapper and <a> elements
        if $(tocEl).length
            padding = 50 - 15 
            offset = $("#sidebar").offset().top - padding

            $("#sidebar").find('.active').removeClass("active")
            # $(tocEl).parents(".section-bar").find(".level-2").removeClass("hidden")

            if $(tocEl).hasClass("level-1")
                if click
                    $(tocEl).toggleClass("active")
                    $(tocEl).parent().children(".level-2")
                        .toggleClass("hidden", () ->
                            if $(tocEl).hasClass(".active")
                                false
                            else
                                true
                        )
                    $(tocEl).parent().find("div.level-3").addClass("hidden")
                else  $(tocEl).addClass("active")


            else if $(tocEl).hasClass("level-2")
                if $(tocEl).next().hasClass("level-3")
                    if click
                        $(tocEl).toggleClass("active")
                        $(tocEl).next().toggleClass("hidden", ()->
                            if $(tocEl).hasClass(".active")
                                false
                            else
                                true)
                    else
                        $(tocEl).addClass("active")
                        $(tocEl).next().removeClass("hidden")

                else
                    $(tocEl).addClass("active")

            else if $(tocEl).hasClass("level-3")
                $("#sidebar").find(".level-3").removeClass("active")
                $("#sidebar").find(".level-2").removeClass("active")
                $(tocEl).addClass("active")
                $(tocEl).parent().prev().addClass("active")


            if $(tocEl).hasClass("active")
                $("#pointer").removeClass("hidden")
                $(tocEl)
                    .parents(".level-3, .level-2, .level-1, .section-bar")
                        .removeClass("hidden")
                        .addClass("active")
                $(tocEl)
                    .siblings("a.level-1, a.level-2, a.level-3")
                        .removeClass("active")

            else if !$(tocEl).hasClass("active")
                $("#pointer").addClass("hidden")
                $(tocEl)
                    .parents(".level-3,  .level-2, .level-1, .section-bar")
                        .removeClass("active")
                $(tocEl)
                    .siblings("a.level-1, a.level-2, a.level-3")
                        .removeClass("active")

            pos =  $(tocEl).offset().top - offset 
            $("#sidebar-wrapper").scrollTop(pos)

        # window.location.hash = $(tocEl)[0].hash
        # id = $(tocEl)[0].innerText
        # console.log $("##{id}").position().top
        # docPos = $("##{id}").position().top - 15
        # $("#doc-content").scrollTop(docPos)


