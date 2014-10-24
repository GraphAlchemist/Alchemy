---
position: 7
title: API
---

{% capture apiOverview %}

# API: Overview

While Alchemy is a fantastic plug and play solution to graph visualization with many features out of the box, certain users will want to extend functionality or interact with the graph directly to create a more specific user experience.  For this reason, we've exposed a few API endpoints that will let you easily access nodes and edges, allowing you to use them in your application.

If you find that you are implementing a certain feature over and over using the API endpoints, we invite you to [fork the repo](http://github.com/GraphAlchemist/Alchemy) and submit a pull request with the feature so that most work can be done by Alchemy and its configuration.

{% endcapture %}

{{ apiOverview | markdownify }}

{% assign sorted_apiDocs = (site.apiDocs | sort: 'position') %}

{% for item in sorted_apiDocs %}

    {% assign href = ({{item.title}} | replace: ' ', '-') %}

<section class="api-doc" id="{{href}}">

{{item.content | markdownify}}

</section>

    {% endfor %}
