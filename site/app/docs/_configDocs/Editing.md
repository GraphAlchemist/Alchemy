---
position: 4
title: Editing
---

# Editing

##### showEditor

[bool] **default**: `false` 

When both `showEditor` and [`showControlDash`](#showControlDash) are true, creates an Editor menu where you can directly edit elements on the graph. If `showControlDash` is false, then the editor menu will not be visible. When the editor is showing in the Control Dash, there are currently two options, remove element and editor interactions. When the editor interactions are enabled, adding nodes and edges is a simple as clicking and dragging.

##### removeElement 

[bool] **default**: `false` 

Adds a "Remove Element" button to the editor dropdown in the control dash.  When clicked, it will remove any selected node or edge.  Keep in mind this is to completely remove the element, not hide it.

<!-- ##### addNodes

[bool] `false`    

**not currently implemented** Adds an "Add node" button to the editor dropdown in the control dash.  When clicked, it will insert a new node into the graph. -->

<!-- ##### addEdges

[bool] `false`   

**not currently implemented** Adds an "Add edge" button to the editor dropdown in the control dash.  When clicked, it will insert a new node into the graph. Note that an edge cannot exist without both a source and a target node.-->

___