



# Example

```bash
curl --output settings.frozen.yml 'https://raw.githubusercontent.com/searxng/searxng/28d1240fce945a48a2c61c29fff83336410c4c77/searx/settings.yml'

curl --output settings.frozen.yml.patch 'https://raw.githubusercontent.com/mirage335-special/kit-researchEngine/e69acb9da1d4979c6ed042b11cf71b0a6d0371a2/_import/etc--searxng/settings.yml.patch'

cp settings.frozen.yml settings.frozen.patched.yml

yes | patch -p1 settings.frozen.patched.yml settings.frozen.yml.patch

git diff settings.frozen.yml settings.frozen.patched.yml
```

```bash
curl --output settings.upstream.yml 'https://raw.githubusercontent.com/searxng/searxng/1520a8d545e436e43c0ea0aff916cc4cc9ba5494/searx/settings.yml'

curl --output settings.yml.patch 'https://raw.githubusercontent.com/mirage335-special/kit-researchEngine/refs/heads/main/_import/etc--searxng/settings.yml.patch'

cp settings.upstream.yml settings.yml

yes | patch -p1 settings.yml settings.frozen.yml.patch
# Alternatively, edit settings.yml file directly.

git diff settings.upstream.yml settings.yml > settings.yml.patch
```


# Differences List

```yaml
search:
  autocomplete: "duckduckgo"
  favicon_resolver: "duckduckgo"
  default_lang: "en-US"
  formats:
    - html
    - json

ui:
  search_on_category_select: false

enabled_plugins:
  - 'Open Access DOI rewrite'

- name: apk mirror
    disabled: false

- name: anaconda
  disabled: false

- name: bandcamp
  disabled: true

- name: bing images
  disabled: true

- name: bing news
  disabled: true

- name: bing videos
  disabled: true

- name: chefkoch
  disabled: true

- name: cppreference
  disabled: false

- name: crossref
  disabled: false

- name: duckduckgo images
  disabled: false

- name: duckduckgo videos
  disabled: false

- name: duckduckgo news
  disabled: false

- name: duckduckgo weather
  disabled: false

- name: fdroid
  disabled: false

- name: flickr
  disabled: true

- name: free software directory
  disabled: false

- name: genius
  disabled: true

- name: gitlab
  disabled: false

- name: google
  disabled: true

- name: google images
  disabled: true

- name: google news
  disabled: true

- name: google videos
  disabled: true

- name: hackernews
  disabled: false

- name: crates.io
  disabled: false

- name: kickass
  disabled: true

- name: z-library
  disabled: true

- name: metacpan
  disabled: false

- name: mixcloud
  disabled: true

- name: npm
  disabled: false

- name: openlibrary
  disabled: false

- name: pinterest
  disabled: true

- name: piped.music
  disabled: true

- name: piratebay
  disabled: true

- name: qwant
  disabled: true

- name: qwant news
  disabled: true

- name: qwant images
  disabled: true

- name: qwant videos
  disabled: true

- name: radio browser
  disabled: true

- name: reddit
  disabled: false

- name: soundcloud
  disabled: true

- name: searchcode code
  disabled: false

- name: startpage
  disabled: false

- name: solidtorrents
  disabled: true

- name: yahoo news
  disabled: true

- name: wikibooks
  disabled: false

- name: wttr.in
  disabled: true

- name: lib.rs
  disabled: false

```




# Formatting of Some Differences as of 2025-09-29

```yaml
plugins:
  searx.plugins.oa_doi_rewrite.SXNGPlugin:
    active: true
```



