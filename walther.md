---
title: Walther Numbers
layout: page
---

## Proverbia

<ul>
  {% for item in site.data.walther.wp %}
    <li>
      {{ item.tag }}:
      {% for verse in item.verses %}<a href="/{{ verse }}/">{{ verse }}</a>{% unless forloop.last %}, {% endunless %}{% endfor %}
    </li>
  {% endfor %}
</ul>

## Carmina

<ul>
  {% for item in site.data.walther.wc %}
    <li>
      {{ item.tag }}:
      {% for verse in item.verses %}<a href="/{{ verse }}/">{{ verse }}</a>{% unless forloop.last %}, {% endunless %}{% endfor %}
    </li>
  {% endfor %}
</ul>
