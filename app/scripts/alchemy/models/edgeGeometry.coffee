###
leave in drawing.drawingUtils for now...
We are tied to d3 methods so it does not makes sense to abstract out into a model
###

# class alchemy.models.EdgeGeometry
#     constructor: (edge) ->
#         nodes = alchemy._nodes
#         width  = nodes[edge._d3.target].x - nodes[edge._d3.source].x
#         height = nodes[edge._d3.target].y - nodes[edge._d3.source].y
#         hyp = Math.sqrt(height * height + width * width) # as in hypotenuse 
#         @edgeWalk = (edge, point) ->
#             distance = (hyp / 2) if point is "middle"
#                 x: edge.source.x + width * distance / hyp
#                 y: edge.source.y + height * distance / hyp

#         edgeAngle = (edge) ->
#             width  = edge.target.x - edge.source.x
#             height = edge.target.y - edge.source.y
#             Math.atan2(height, width) / Math.PI * 180

#         middleLine: (edge) -> edgeWalk(edge, 'middle')
#         middlePath: (edge) -> 
#             # edgeWalk places text as if the line were straight
#             # offset the text to lie on the mid point of the path

                
#                 # x: 

#         angle: (edge) -> 
#             angle = edgeAngle(edge)
#             if angle < -90 or angle > 90
#                 angle += 180
#             else
#                 angle