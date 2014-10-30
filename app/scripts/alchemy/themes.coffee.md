    Alchemy::themes = 
        "default":
            "backgroundColour": "#000000"
            "nodeStyle":
                "all":
                    "radius": -> 10
                    "color"  : -> "#68B9FE"
                    "borderColor": ->"#127DC1"
                    "borderWidth": (d, radius) -> radius / 3
                    "captionColor": -> "#FFFFFF"
                    "captionBackground": -> null
                    "captionSize": 12
                    "selected":
                        "color" : -> "#FFFFFF"
                        "borderColor": -> "#349FE3"
                    "highlighted":
                        "color" : -> "#EEEEFF"
                    "hidden":
                        "color": -> "none" 
                        "borderColor": -> "none"
            "edgeStyle":
                "all":
                    "width": 4
                    "color": "#CCC"
                    "opacity": 0.2
                    "directed": true
                    "curved": true
                    "selected":
                        "opacity": 1
                    "highlighted":
                        "opacity": 1
                    "hidden":
                        "opacity": 0

        "white":
            "theme": "white"
            "backgroundColour": "#FFFFFF"
            "nodeStyle":
                "all":
                    "radius": -> 10
                    "color"  : -> "#68B9FE"
                    "borderColor": ->"#127DC1"
                    "borderWidth": (d, radius) -> radius / 3
                    "captionColor": -> "#FFFFFF"
                    "captionBackground": -> null
                    "captionSize": 12
                    "selected":
                        "color": -> "#FFFFFF"
                        "borderColor": -> "38DD38"
                    "highlighted":
                        "color" : -> "#EEEEFF"
                    "hidden":
                        "color": -> "none" 
                        "borderColor": -> "none"
            "edgeStyle":
                "all":
                    "width": 4
                    "color": "#333"
                    "opacity": 0.4
                    "directed": false
                    "curved": false
                    "selected":
                        "color": "#38DD38"
                        "opacity": 0.9
                    "highlighted":
                        "color": "#383838"
                        "opacity": 0.7
                    "hidden":
                        "opacity": 0
