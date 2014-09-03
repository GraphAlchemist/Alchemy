---
position: 2
title: Configuration
---

{% capture configOverview %}

# Configuration: Overview

Alchemy.js is initialized using the `alchemy.begin(your_config)` where the **your_config** object includes any of the configurations here that you would like to override.

The only configuration absolutely necessary is the [dataSource](#datasource) configuration.  See the [Quick Start](#quick-start) or [Examples](#examples) for more examples of how to initialize Alchemy.js.

Additionally, configurations for any app are available at the alchemy.conf endpoint after the app has been initialized.

{% endcapture %}

{{ configOverview | markdownify }}


{% assign sorted_configDocs = (site.configDocs | sort: 'position') %}

{% for item in sorted_configDocs %}

    {% assign href = ({{item.title}} | replace: ' ', '-') %}

<section class="config-doc" id="{{href}}">

{{item.content | markdownify}}

</section>

    {% endfor %}

