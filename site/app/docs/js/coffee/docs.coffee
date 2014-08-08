$ ->
    for section in $("#sidebar").children()
        href = $(section).children(".level-1").attr("where-to")
        sectionContent = $("##{href}").children("h1, h2, h3, h4, h5")
        $(section).append("<div id='lvl-2-#{href}' class='level-2 list-group'>")
        nextLvl = $("#lvl-2-#{href}")
        for header in sectionContent
            id = $(header).prop("id")
            title = id.replace(/-/g, " ")
            nextLvl.append("<a class='level-2 list-group-item' href='##{id}'>#{title}</a>")
        $("#sidebar").find(".level-2").addClass("hidden")

    $(".section-bar>a")
        .on 'click', () ->
            # console.log $(@).offset()
            # console.log $(@).position()
            # console.log $(@).parent().position()
            href = $(@).attr("where-to")
            console.log $("##{href}").offset()
            console.log $("##{href}").position()
            absTargetY = $("##{href}").offset().top
            relTargetY = $("##{href}").position().top
            relHeaderY = $(@).parent().position().top
            y = absTargetY
            $("#sidebar").attr("style", "transform: translate(0, #{y}px)")
            $(@).parent().toggleClass("active")
            $(@).parent().siblings().removeClass("active")
            $(@).parent().find(".level-2").removeClass("hidden")
            $(@).parent().siblings().find(".level-2").addClass("hidden")