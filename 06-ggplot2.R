# ---
# title: Графики в пакете ggplot2
# subtitle: "Основы биостатистики, осень 2022"
# author: Марина Варфоломеева
# ---

# Теория работы в ggplot2 #############################

library(ggplot2)

## Данные
library(readxl)
penguins <- read_xlsx(path = "data/penguins.xlsx", sheet = "penguin data")

colnames(penguins)

# График в ggplot2 ####################################

## 1. Откуда брать данные?
ggplot(data = penguins)

## 2. Что рисовать?
# При помощи функции `aes()` задаем __эстетики__ — свойства графика, при помощи которых будут отображены данные.
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g))

## 3. В виде чего рисовать?
# Геомы — графические объекты в виде которых будут изображены свойства данных.
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


## Можно "жестко" указать свойства геома
# colour и size здесь не эстетики
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(colour = "red", size = 3)

# у некоторых форм точек есть отдельно цвет границы и цвет заливки
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(colour = "red", size = 3, shape = 22, fill = "grey")

## Можно задать другие эстетики, гибко меняющиеся вместе с данными
# colour — эстетика, size — не эстетика
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3)

## Шкалы `scale_*()` управляют эстетиками
# формат названий scale_эстетика_тип()
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3) +
  scale_color_brewer(palette = "Set2")

## Лейблы labs() управляют подписями

ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3) +
  scale_color_brewer(palette = "Set2") +
  labs(x = "Flipper length, mm", y = "Body mass, g")

## Фасетки `facet_*()` делят график на части
ggplot(data = penguins, 
       aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3) +
  scale_color_brewer(palette = "Set2") +
  labs(x = "Flipper length, mm", y = "Body mass, g") +
  facet_wrap(~ island)

## Графики можно сохранять в переменные
gg_peng1 <- ggplot(data = penguins, 
                   aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3) +
  scale_color_brewer(palette = "Set2") +
  labs(x = "Flipper length, mm", y = "Body mass, g") +
  facet_wrap(~ island)
gg_peng1

## Тема `theme()` настраивает оформление графика

gg_peng1 +
  theme(legend.position = "bottom", 
        axis.text.x = element_text(angle = 45, hjust = 1))

## Есть встроенные темы оформления `theme_*()`

# Можно применить тему к конкретному графику
gg_peng1 + theme_classic(base_size = 14)

# Можно изменить тему всех последующих графиков
theme_set(theme_bw(base_size = 20))
gg_peng1

## Сохранение графиков в файл
# `filename` — путь (отн. рабочей директории) и имя файла.

# Векторный формат svg
ggsave(filename = "plot_penguins.svg", plot = gg_peng1)

# Растровый формат png
ggsave(filename = "plot_penguins.png", plot = gg_peng1)

### ЗАДАНИЯ ###############################################

# Простейшие графики (без статистической обработки) #######

# 1. Скаттерплот, диаграмма рассеяния - geom_point() ------
# (только что сделали)

# 2. Столбчатый график - geom_col() -----------------------

# Найдем объемы выборок пингвинов разных видов в разные годы наблюдений
tbl_penguins <- table(penguins$species, penguins$year)
tbl_penguins
sample_size <- as.data.frame(tbl_penguins)
colnames(sample_size) <- c("species", "year", "N")
sample_size

# Нарисуйте столбчатый график, на котором показан объем выборки
# пингвинов разных видов в разные годы наблюдений (покажите цветом).
# Что делает аргумент position?
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) + 
  geom_col(aes(RRR = year), position = position_dodge())

# 3. Линейный график - geom_line() -----------------------

# (a) Нарисуйте график, на котором линиями показано, 
# как  для пингвинов разных видов (цвет)
# год от года изменяется объем выборки.
# Что делает эстетика group в геоме line?
# Заполните пропуски (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  geom_line(aes(RRR = RRR, group = RRR))

# (b) Добавьте к предыдущему графику этот слой.
# Что делает аргумент ylim?

coord_cartesian(ylim = c(0, max(sample_size$N)))


# 4. Точечный график, стрипчарт - geom_jitter() ------------

# (a) Нарисуйте точечный график, 
# показывающий зависимость массы тела от вида пингвинов.
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  geom_jitter(aes(colour = RRR))

# (b) Добавьте в геом jitter аргументы 
# width = 0.2 (ширина полосы точек) и alpha = 0.75 (прозрачность).
# Что они регулируют?


# (c) Измените цветовую палитру для переменной species, 
# для этого добавьте шкалу scale_colour_brewer()
# Выберите понравившуюся палитру из предложенных:
RColorBrewer::display.brewer.all()
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  geom_jitter(aes(colour = RRR), width = 0.2, alpha = 0.75) +
  scale_colour_brewer(palette = RRR) 

# (d) Подпишите на русском языке оси и название легенды при помощи слоя `labs()`. 
# Измените название видов пингвинов в легенде и подписях к оси х
# при помощи аргумента `labels` в `scale_color_brewer()` и `scale_x_discrete()`
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  geom_jitter(aes(colour = RRR), width = 0.2, alpha = 0.75) +
  scale_colour_brewer(palette = RRR,
                      labels = c(RRR, RRR, RRR)) +
  scale_x_discrete(labels = c(RRR, RRR, RRR)) +
  labs(x = RRR, y = RRR, colour = RRR)

# Графики со встроенной стат. обработкой ################

# 5. Гистограмма - geom_histogram() ---------------------

# (a) Постройте гистограмму распределения массы тела пингвинов.
# Сделайте, чтобы у столбцов гистограммы был
# белый цвет рамки и оранжевый цвет заливки.
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(RRR = body_mass_g)) +
  geom_histogram(RRR = "white", RRR = "orange")

# (b) Измените предыдущий график, 
# чтобы разделить информацию о разных видах пингвинов.
# Попробуйте придумать несколько вариантов решения.


# (c) # Измените гистограмму, чтобы использовать число интервалов,
# вычисленное методом Стурджеса (Sturges, 1926)
# Количество интервалов geom_histogram() задает параметр bins
# Заполните пропуски  (RRR):

# Вычислим количество интервалов n_bins:
n_bins <- nclass.RRR(penguins$RRR)
ggplot(data = RRR, aes(x = RRR)) +
  geom_histogram(aes(RRR = species), 
                 position = RRR, 
                 bins = n_bins)


# 6. Боксплоты - geom_boxplot() -------------------------

# Постройте боксплот распределения массы тела пингвинов разных видов.
# Сделайте так, чтобы цвет заливки боксплотов был разный у разных видов.
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  geom_boxplot(aes(RRR = species))

# 7. Точки с усами - stat_summary(geom = "pointrange") ------------------

# Постройте график массы тела у разных видов пингвинов. 
# (a) Изобразите медиану, минимум и максимум при помощи функци median_hilow()
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  stat_summary(geom = "RRR", fun.data = RRR)

# (b) Измените предыдущий график так, чтобы цвет точек и усов был разный у разных видов.
# Заполните пропуски  (RRR):
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  stat_summary(geom = "RRR", fun.data = RRR,
               aes(RRR = species))

# (c) Измените предыдущий график, чтобы показать 
# средние ± 2 стандартных отклонения (функция mean_sdl())
ggplot(data = RRR, aes(x = RRR, y = RRR)) +
  stat_summary(geom = "RRR", fun.data = RRR,
               aes(RRR = species))

