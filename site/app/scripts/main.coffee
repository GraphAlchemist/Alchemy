$(document).ready ->
    $("#tutorial").tooltip placement: "bottom"
    $("#btn-alchemy-rel").tooltip placement: "bottom"
    $('pre').addClass('prettyprint')
    prettyPrint()

    $("#example3").addClass("hidden")
    $("#full-app-btn")
        .on "click", () ->
            $("#examples").toggleClass("hidden")
            $(".footer").toggleClass("hidden")
            $(".header").toggleClass("hidden")
            $("#btn-alchemy-rel").toggleClass("hidden")
            $("#example3").toggleClass("hidden")
            $("#full-app-btn>h3").text(()->
                if $("#examples").hasClass("hidden")
                    return "Go back to Example Code"
                else
                    return "View Full App"
                )
console.log "'Allo from CoffeeScript!"
