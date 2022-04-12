---
title: Verses
layout: page
---

<ul>
  {% for verse in site.data.versdiff %}
    <li>{{ verse.id}}: {{ verse.text }}</li>
  {% endfor %}
</ul>
