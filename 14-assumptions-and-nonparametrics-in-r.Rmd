---
title: Борьба с ограничениями статистических методов  и непараметрические методы в R
subtitle: "Основы биостатистики, осень 2022"
author: 
  - Марина Варфоломеева
company: 'Каф. Зоологии беспозвоночных, СПбГУ'
output:
  xaringan::moon_reader:
    self-contained: true
    lib_dir: libs
    css: [ninjutsu, "assets/xaringan-themer.css", "assets/xaringan.css"]
    df_print: default
    nature:
      highlightStyle: googlecode
      highlightLines: true
      countIncrementalSlides: false
      titleSlideClass: [middle, left, inverse]
      beforeInit: "assets/macros.js"
    includes:
      in_header: "assets/xaringan_in_header.html"
      after_body: "assets/xaringan_after_body.html"
---

```{r setup, include = FALSE, cache = FALSE, purl = FALSE, fig.showtext = TRUE}
source("assets/setup.R")
```

## 14. (П) Борьба с отклонениями от условий применимости

- [ ] Трансформация данных в R
- [ ] Проверка на нормальность в R
- [ ] Непараметрические методы в R
- [ ] Бутстреп в R
