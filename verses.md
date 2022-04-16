---
title: Verses
layout: page
---

<ul>
  {% for verse in site.data.versdiff %}
    {% include verse.html verse=verse %}
  {% endfor %}
</ul>
