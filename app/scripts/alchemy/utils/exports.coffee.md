
    Alchemy::exports = (instance)->
        a = instance
        init: ()->
            a.exports.show()
        
        show: ()->
            a.dash.select "#all-exports"
             .append "li"
             .attr
                class: "list-group-item active-label toggle"
             .html "SVG"
             .on "click", (e)->
                svg = d3.select "#{a.conf.divSelector} svg"
                        .node()
                str = (new XMLSerializer).serializeToString svg
                url = "data:image/svg+xml;utf8,#{str}"
                sanitizedUrl = url.replace("xlink:", "")
                win = window.open sanitizedUrl
                win.focus()