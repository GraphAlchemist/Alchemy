Default styling of the alchemy graph's comes from the [alchemy.css](#) file.

Most of the different styles that can be over written in the current development version are obvious from the alchemy sass files found [here](https://github.com/GraphAlchemist/Alchemy/tree/master/app/styles).

A couple popular overrides might be the following (in plane ol css):
```css
/*  set the color of all of the edges to red on :hover */
.alchemy line:hover {stroke: red;}

/* set the stroke width and color of all nodes */
.alchemy .node circle {
  fill: yellow;
  stroke-width: 2px;
}
```

Alchemy.js also allows for more complex overrides.  See [[node_types|Nodes#nodetypes]] and [[edge_type|Edges#edgetypes]] in the documentation for more information on how alchemy assigns classes to node elements and edge elements:

```css
/* set the font size to 48 for only the root nodes */
.alchemy .node.root text {
  font-size: 20px;
}

/* set the color to blue and the text size on all nodes that are of the type 'movie' */

.alchemy .node.movie text {
  font-size: 20px;
  fill: blue;
}
```



