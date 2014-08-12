---
layout: docsLanding
title: Alchemy.js Docs Home
---
<div id="sidebar-wrapper">
    <div id="sidebar" class="list-group">
    {% assign sorted_docs = (site.documentation | sort: 'position') %}
    <!--     <div id="sidebar-list"> -->
    {% for item in sorted_docs %}
        {% assign href = ({{item.title}} | replace: ' ', '-') %}

        <div class = "section-bar list-group-item">
            <a class="level-1" href="#{{href}}"> {{item.title}} </a>
        </div>

    {% endfor %}
<!--     </div>  -->
    </div>
</div>

<div id="doc-content" class="auto-generated">
{% for item in sorted_docs %}
    {% assign href = ({{item.title}} | replace: ' ', '-') %}

    <section class="doc" id="{{href}}">
        {{item.output}}
    </section>

{% endfor %}

</div>