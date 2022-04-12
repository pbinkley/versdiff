---
title: Verses
layout: page
---

<ul>
  {% for verse in site.data.versdiff %}
    <li><a href="/{{ verse.id}}/">{{ verse.id }}</a>: {{ verse.text }}</li>
  {% endfor %}
</ul>
