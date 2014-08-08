---
layout: docsLanding
title: Alchemy.js Docs Home
---
<div id="sidebar-wrapper">
    <div id="sidebar" class="list-group">
    {% assign sorted_docs = (site.documentation | sort: 'position') %}
    <!--     <div id="sidebar-list"> -->
    {% for item in sorted_docs %}

        <div class = "section-bar list-group-item">
            <a class="level-1" where-to="{{item.title}}" href="#{{item.title}}"> {{item.title}} </a>
        </div>

    {% endfor %}
<!--     </div>  -->
    </div>
</div>

<div id="doc-content" class="auto-generated">
{% for item in sorted_docs %}
<section class="doc" id="{{item.title}}">
    {{item.output}}
</section>
{% endfor %}

</div>
