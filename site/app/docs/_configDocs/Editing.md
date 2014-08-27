---
position: 4
title: Editing
---

# Editing

<p></p>

##### showEditor

[`bool`] default:`false` 

When both `showEditor` is true, an Editor menu where you can directly edit elements on the graph is created. When the editor is showing in the Control Dash, there are currently two options, remove element and editor interactions. When the editor interactions are enabled, adding nodes and edges is a simple as clicking and dragging.

##### removeElement 

[`bool`] default:`false` 

Adds a "Remove Element" button to the editor dropdown in the control dash.  When clicked, it will remove any selected node or edge.  Keep in mind this is to completely remove the element, not hide it.

##### toggleRootNodes
[`bool`] default:`false`

Adds a "Toggle Root Nodes" button to the editor dropdown in the control dash.  When clicked, it will hide all rootNodes.  Keep in mind, this will only be effective if root nodes are defined.


##### captionToggle
[`bool`] default:`false`

Adds a "Toggle Captions" button to the editor dropdown in the control dash.  When clicked, it will hide all captions.

______
