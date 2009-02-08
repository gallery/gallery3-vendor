find modified -name .svn -prune -o -type f -print0 | xargs -0 rm
cp /dev/null modified/ui.base.css
for css in core theme datepicker dialog progressbar resizable; do
    unzip -q -o -j upstream/jquery-ui-themeroller.zip -d modified jquery-ui-themeroller/theme/ui.$css.css
    echo "@import \"ui.$css.css\";" >> modified/ui.base.css
done

unzip -q -o -j upstream/jquery-ui-themeroller.zip -d modified/images jquery-ui-themeroller/theme/images/\*
