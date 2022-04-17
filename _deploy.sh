#!/usr/bin/bash
JEKYLL_ENV=production bundle exec jekyll b
rsync -e ssh -a _site/ wallandbinkley:./versdiff.wallandbinkley.com/ --delete

