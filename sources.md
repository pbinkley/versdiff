---
title: Sources
layout: page
---

<dl>
{% for source in site.data.sourcemetadata %}
  <dt><strong>{{ source.display }}</strong>
  </dt>
  <dd>{{ source.citation }}</dd>
  {% if source.tag %}<a href="{{ site.baseurl }}/tag/{{ source.tag | slugify }}/">&gt; See verses</a><br/><br/>{% endif %}
{% endfor %}
</dl>
