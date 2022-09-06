library(knitr)
themes = knit_theme$get()
pat_brew()  # use brew patterns <%  %>
for (theme in themes) knit('theme.brew', paste('theme-', theme, '.Rhtml', sep = ''))
knit_patterns$restore() # clear patterns

mapply(knit, input = list.files(pattern = '\\.Rhtml$'))

writeLines(c(
  '<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Highlight themes in knitr</title>
<meta name="author" content="Taiyun Wei and Yihui Xie" />
</head>
<body>', 
paste(sprintf('<iframe src="%s" width="800" height="520" scrolling="auto" style="display: block; margin: auto;"></iframe>',
              list.files(pattern = '^theme-.*\\.html$')), collapse = '<hr />\n'),
'</body>
</html>'),
con = 'themes.html')

browseURL('themes.html')
