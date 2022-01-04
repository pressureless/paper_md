# Gallery for papers

Install [Lektor](https://www.getlektor.com/downloads/) through command ```curl -sf https://www.getlektor.com/installer.py | python3```

## Gallery

```papers``` directory contains related files for each paper

```lektor_proj``` directory is used for gallery pages lektor project

Download I❤️LA first, then ```python  process.py  --la_path=/path/to/iheartla-repos``` will generate content under ```lektor_proj```

```lektor_proj/assets/static/style.css``` and ```lektor_proj/templates/macros/gallery.html``` are used for the gallery pages


```cd lektor_proj```

```lektor build --output-path webpages``` will generate ```webpages``` directory, we can then copy the ```gallery``` and ```static``` subdirectories to github pages

The generated site is here.
