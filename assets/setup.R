# Setup chunk for presentations

options(rmarkdown.paste_image_dir = 'img')

# output options
options(width = 70, scipen = 6, digits = 3)

library(knitr)
knitr::opts_template$set(
  fig.full = list(fig.width = 12, fig.height = 9),
  fig.large = list(fig.width = 12, fig.height = 8),
  fig.wide.tall = list(fig.width = 12, fig.height = 8),
  fig.wide.taller = list(fig.width = 12, fig.height = 6),
  fig.wide = list(fig.width = 12, fig.height = 4.4),
  fig.wider.tall = list(fig.width = 8, fig.height = 8),
  fig.wider.taller = list(fig.width = 8, fig.height = 6),
  fig.wider = list(fig.width = 8, fig.height = 4.4),
  fig.column = list(fig.width = 6.5, fig.height = 5),
  fig.column3 = list(fig.width = 4.5, fig.height = 5),
  fig.medium.tall = list(fig.width = 6, fig.height = 8),
  fig.medium.taller = list(fig.width = 6, fig.height = 6),
  fig.medium = list(fig.width = 6, fig.height = 4.4),
  fig.small = list(fig.width = 6, fig.height = 4)
)
# chunk default options
opts_chunk$set(message = FALSE, tidy = FALSE, warning = FALSE, echo = FALSE, comment = "", opts.label='fig.medium', fig.showtext = TRUE, fig.retina = 3)

library("xaringanthemer")
style_duo_accent(
  #base_color = "#2B5E6D",
  primary_color = "#2B5E6D",
  secondary_color = "#3b528b",
  # title_slide_text_color = "#2B5E6D",
  # title_slide_background_color = "#CBCED2", 
  # inverse_background_color = "#CBCED2",
  base_font_size = "22px",
  text_font_size = "1rem",
  header_h1_font_size = "2.2rem",
  header_h2_font_size = "1.7rem",
  header_h3_font_size = "1.5rem",
  header_font_google = google_font("Arsenal", languages = c("latin", "cyrillic", "greek")),
  header_font_family_fallback = "Georgia, serif",
  text_font_google   = google_font("Nunito", "400", "400i", languages = c("latin", "cyrillic")),
  text_font_family_fallback = "Calibri, sans-serif",
  code_font_google   = google_font("Ubuntu Mono", languages = c("latin", "cyrillic")),
  code_font_family_fallback = "Courier New, monospace",
  outfile = "assets/xaringan-themer.css"
)
# library(xaringanExtra)
# use_tile_view()
# use_scribble()
# use_search(show_icon = FALSE)
# use_progress_bar(color = "#6d2b5e", location = "bottom", height = "5px")
# use_freezeframe()
# # use_webcam()
# # use_panelset()
# # use_extra_styles(hover_code_line = TRUE)
# 
# # http://tachyons.io/docs/
# # https://roperzh.github.io/tachyons-cheatsheet/
# use_tachyons()

library("kableExtra")
options(knitr.kable.NA = '')
library("showtext")
library("ggplot2")
# th <- theme_xaringan(background_color = "#FFFFFF", title_font_size = 22, text_font_size = 22)
# Для теоретических презентаций
theme_set(theme_bw(base_size = 22) + theme(plot.title = element_text(size = 18)))
update_geom_defaults("point", list(size = 3))
