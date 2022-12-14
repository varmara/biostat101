# ---
# title: Тестирование гипотез, сравнение двух групп в R
# subtitle: "Основы биостатистики, осень 2022"

##### Пример: Два вида снотворного ###########################################

# В датасете `sleep` содержатся данные об увеличении продолжительности сна по
# сравнению с контролем после применения двух снотворных препаратов (Cushny,
# Peebles, 1905, Student, 1908).
# Одинаково ли два снотворных влияют на увеличение продолжительности сна?
  
data(sleep)

head(sleep)

str(sleep)

library(ggplot2)
ggplot(data = sleep, aes(x = group, y = extra)) +
  stat_summary(geom = "pointrange", fun.data = mean_cl_normal)

##### Средняя разница эффектов двух снотворных ###############################

# Чтобы научиться считать среднюю разницу изменения качества сна 
# и ее доверительный интервал вручную,
# реорганизуем данные так, 
# чтобы оба наблюдения для одного человека (ID)
# были в одной строке
# Заодно научимся изменять компоновку таблиц с данными
library(dplyr)
library(tidyr)
sl_diff <- sleep %>% 
  pivot_wider(id_cols = ID,           
              names_from = group, 
              names_prefix = "pill_", 
              values_from = extra) %>% 
  mutate(d = pill_2 - pill_1)
sl_diff

# Средняя разница изменения качества сна (= разница эффектов двух снотворных)
mdiff <- mean(sl_diff$d, na.rm = TRUE)
mdiff 
# на столько часов будет в среднем больше
# изменение продолжительности сна по сравнению с контролем 
# при приеме снотворного 2, чем при приеме снотворного 1.

##### Доверительный интервал к средней разнице значенийх в парах ##############

# Задание 1.  -----------------------------------------------------------------
# Рассчитайте границы 95% доверительного интервала 
# к средней разнице эффектов двух снотворных mdiff.
# Подсказка: доверительный интервал к средней разнице 
# считается так же как к среднему значению.
# Заполните пропуски:
s <-        # стандартное отклонение средней разницы
n <-         # размер выборки
se_mdiff <-  # стандартная ошибка средней разницы
df_mdiff <-  # число степеней свободы t-распределения
t_val_95 <- qt(p = , df = ) # значение t для 95% доверительного интервала
mdiff + c(-1, 1)    # границы доверительного интервала к средней разнице



##### Парный t-тест (t-тест для зависимых выборок) ##########################


# Задание 2 -----------------------------------------------------------------
# Вручную рассчитайте значение t статистики и p-value в парном t-тесте
# t = (наблюдаемое - ожидаемое при H0)/(стандартная ошибка наблюдаемого) 
t_val <- # значение t статистики по данным
p_val <- 1 - pt(q = , df = ) # p-value


# Парный t-тест при помощи готовых функций в R
tt_sleep <- t.test(formula = extra ~ group, data = sleep, paired = TRUE)
tt_sleep


### Задание 3 ------------------------------------------------------------
# Проверьте условия применимости парного t-теста.
library()
qqPlot()
qqPlot()


# ## Пример: Гормоны и артериальная гипертензия ##############################
#
# Синдром Кушинга --- это нарушения уровня артериального давления, 
# вызванные гиперсекрецией кортизола надпочечниками.
# В датасете `Cushings` (пакет `MASS`) записаны данные 
# о секреции двух метаболитов при разных типах синдрома
# (данные из кн. Aitchison, Dunsmore, 1975).
# - `Tetrahydrocortisone` --- секреция тетрагидрокортизона с мочой (мг/сут.)
# - `Pregnanetriol` --- секреция прегнантриола с мочой (мг/сут.)
# - `Type` --- тип синдрома:
#   - `a` --- аденома
#   - `b` --- двусторонняя гиперплазия
#   - `c` --- карцинома
#   - `u` --- не известно
# Различается ли секреция тетрагидрокортизона 
# при аденома и двусторонней гиперплазии надпочечников?
library(MASS)
data("Cushings")

Cushings %>% 
  filter(Type %in% c("a", "b")) %>% 
  ggplot(data = ., aes(x = Type, y = Tetrahydrocortisone)) +
  stat_summary(fun.data = mean_cl_normal)

##### Разница средних #########################################################

# выборки 1 и 2
X1 <- Cushings$Tetrahydrocortisone[Cushings$Type == "a"]
X2 <- Cushings$Tetrahydrocortisone[Cushings$Type == "b"]
# средние
m1 <- mean(X1, na.rm = TRUE)
m2 <- mean(X2, na.rm = TRUE)
# разница средних
diff_means <-  m2 - m1

##### Доверительный интервал к разнице средних ###############################

# Задание 4 ------------------------------------------------------------------
# Вычислите границы доверительного интервала разницы средних

# размеры выборок в группах
n1 <- 
n2 <- 
# выборочные стандартные отклонения
sd1 <- 
sd2 <- 
# число степеней свободы
df1 <- 
df2 <- 
df12 <- n1 + n2 - 2
# обобщенная дисперсия
s2_pooled <- (df1 * sd1^2 +  * sd2^2) / df12
# стандартная ошибка разницы средних
se_diff_means <- sqrt(s2_pooled * (1 / n1 + 1 / ))
# t-статистика для 95% доверительного интервала
tval_95 <- qt(p = , df = )
diff_means + c(-1, 1)  # границы доверительного интервала


##### Двухвыборочный t-тест ###################################################

tt_cush <- t.test(formula = Tetrahydrocortisone ~ Type, data = Cushings,
             subset = Cushings$Type %in% c('a', 'b'))
tt_cush

# Задание 5 -------------------------------------------------------------------
# Проверьте условия применимости t-теста.


# Задание 6. ------------------------------------------------------------------
# (1) Перепишите вызов функции t.test с использованием
# другого шаблона вызова (с параметрами x и y)
# (см. справку к t.test)


# (2) Как называются отдельные элементы результатов
# можно узнать посмотрев их структуру при помощи
# функции `str()`


# (3) Получите отдельные элементы результатов из
# объекта tt при помощи оператора $
# - значение t-критерия
# - число степеней свободы
# - уровень значимости


##### Пример: Память и биодобавки ###################################################

# Скачайте файл memory.txt с сайта курса по ссылке
# https://varmara.github.io/biostat101/lectures.html

# Исследователи изучали влияние добавок из гингко на качество памяти, 
# сравнивая его эффект с плацебо (Solomon et al. 2002)
# Откройте данные, убедившись, 
# что используется правильный разделитель столбцов

mem <- read.table(file = "data/memory.csv", header = TRUE, sep = "")
head(mem)
str(mem)

# Задание 7 -----------------------------------------------------------------

# (1) Оцените, чему равна разница средних эффектов плацебо и гингко.
# Постройте доверительный интервал к этой разнице.

# (2) При помощи t-теста проверьте значимость этой разницы.

# (3) Проверьте условия применимости t-теста. 

