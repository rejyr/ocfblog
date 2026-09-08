+++
date = '2026-09-08T11:54:21-07:00'
draft = false
title = 'read only public_html'
+++

# problem

the [OCF](ocf.io) has [website hosting](https://bestdocs.ocf.io/user-docs/services/web/), so
I made this one with a [static site generator](https://gohugo.io/) and [nix flake](https://www.chrisportela.com/posts/this-site-is-a-flake/).
when I try to rebuild and copy over the files, I get this:

```console
jerrywang@koi ~/p/ocfblog (main)> cp -r result/* ~/public_html/
cp: cannot create regular file '/home/j/je/jerrywang/public_html/404.html': Permission denied
cp: cannot create regular file '/home/j/je/jerrywang/public_html/blog/hello-world/index.html': Permission denied
cp: cannot create regular file '/home/j/je/jerrywang/public_html/blog/index.html': Permission denied
# ... and so on
```

so I can't update my website :(.

# huh

`nix build` `$out` (in this case `result/`) is read only.

`cp -r result/* ~/public_html` preserves those read only perms, so files there cannot be modified or removed.

```console
jerrywang@koi ~/p/ocfblog (main)> ll ~/public_html/
total 32
-r--r--r-- 1 jerrywang ocf 1560 Sep  8 11:20 404.html
dr-xr-xr-x 3 jerrywang ocf 4096 Sep  8 11:20 blog
dr-xr-xr-x 2 jerrywang ocf 4096 Sep  8 11:20 categories
-r--r--r-- 1 jerrywang ocf 2594 Sep  8 11:20 index.html
-r--r--r-- 1 jerrywang ocf 1060 Sep  8 11:20 index.xml
-r--r--r-- 1 jerrywang ocf 1666 Sep  8 11:20 original.min.css
-r--r--r-- 1 jerrywang ocf  710 Sep  8 11:20 sitemap.xml
dr-xr-xr-x 2 jerrywang ocf 4096 Sep  8 11:20 tags
```


# solution
use `cp -rL` instead and `chmod` for write perms. `cp -L` dereferences symbolic links.

optional: `build.sh` helper script to get a `public/` with proper file perms.


```bash
#!/usr/bin/env bash

set -euo pipefail

nix build

mkdir -p public
rm -drf public/*
cp -rL result/* public/
chmod 755 -R public/
```

[relevant commit here](https://github.com/rejyr/ocfblog/commit/ce618ec9354029d6edbf6c03144e531ed45dd437)

shoutout `ericgu` for helping me work this out.

fin!
