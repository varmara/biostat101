# ---
# title: Связь категориальных переменных в R
# subtitle: "Основы биостатистики, осень 2022"

options(digits = 7, scipen = 6)

## Аспирин и рак ============================================================
# Аспирин используется для лечения головной боли, простуды, 
# профилактики инфаркта и инсульта. В некоторых описательных 
# исследованиях предположили, что он может снижать риск рака.
# Экспериментальное слепое исследование (Cook et al. 2005)

asp <- read.csv(
  "data/aspirin_cancer_Cook_etal_2005.csv", 
  stringsAsFactors = FALSE)
head(asp)


# Таблица частот
tbl_a <- table(asp$cancer, asp$aspirinTreatment)
tbl_a

par(pty = "s") # _квадратный график
mosaicplot( t(tbl_a), col = c("darkcyan", "lightblue"), cex.axis = 1, 
            sub = "Aspirin treatment",
            ylab = "Relative frequency", main = "")

# Риск #####################################################################

# Добавляем суммы в таблицу частот
tbl_a_sums <- addmargins(tbl_a)
tbl_a_sums

# Риск
R_a <- tbl_a_sums[1, 1:2] / tbl_a_sums[3, 1:2]
R_a

# Отностительный риск
RR_a <- R_a[1] / R_a[2]
RR_a

# Стандартная ошибка относительного риска
SE_RR_a <- sqrt(sum(1 / c(tbl_a_sums[1, 1:2], tbl_a_sums[3, 1:2])))

# 95% доверительный интервал для относительного риска
exp(log(RR_a) + c(-1, 1) * qnorm(p = 0.975) * SE_RR_a)

# Функция для расчета относительного риска из пакета effectsize
# library(effectsize)
# riskratio(t(tbl))

# Наша собственная функция для расчета относительного риска
risk_ratio <- function(tbl) {
  # Проверка
  if (class(tbl) != "table") stop("tbl must be a table object")
  if (length(tbl) != 4)  stop("tbl must be a 2х2 table object")
  # Добавляем суммы в таблицу частот
  tbl_sums <- addmargins(tbl)
  # Риск
  R <- tbl_sums[1, 1:2] / tbl_sums[3, 1:2]
  # Отностительный риск
  RR <- R[1] / R[2]
  # Стандартная ошибка
  SE_RR <- sqrt(sum(1 / c(tbl_sums[1, 1:2], tbl_sums[3, 1:2])))
  # 95% доверительный интервал
  CI <- exp(log(RR) + c(-1, 1) * qnorm(p = 0.975) * SE_RR)
  # Результат работы функции
  result <- c(RR, CI)
  names(result) <- c("risk_ratio", "lower_CL", "upper_CL")
  return(result)
}

risk_ratio(tbl = tbl_a)

# Шансы ####################################################################

# Шансы
odds_a <- R_a / (1 - R_a)
odds_a

# Отношение шансов (через шансы)
odds_a[1]/odds_a[2]

# Отношение шансов (сразу из таблицы)
OR_a <- (tbl_a[1, 1] * tbl_a[2, 2]) / (tbl_a[1, 2] * tbl_a[2, 1])
OR_a

# Стандартная ошибка отношения шансов
SE_OR_a <- sqrt(sum(1 / tbl_a))

# 95% доверительный интервал для отношения шансов
exp(log(OR_a) + c(-1, 1) * qnorm(p = 0.975) * SE_OR_a)

# Функция для расчета отношения шансов из пакета effectsize
# library(effectsize)
# oddsratio(tbl)

# Наша собственная функция для расчета отношения правдоподобий
odds_ratio <- function(tbl) {
  # Проверка
  if (class(tbl) != "table") stop("tbl must be a table object")
  if (length(tbl) != 4)  stop("tbl must be a 2х2 table object")
  # Отношение шансов (сразу из таблицы)
  OR <- (tbl[1, 1] * tbl[2, 2]) / (tbl[1, 2] * tbl[2, 1])
  # Стандартная ошибка
  SE_OR <- sqrt(sum(1 / tbl))
  # 95% доверительный интервал
  CI <- exp(log(OR) + c(-1, 1) * qnorm(p = 0.975) * SE_OR)
  # Результат работы функции
  result <- c(OR, CI)
  names(result) <- c("ods_ratio", "lower_CL", "upper_CL")
  return(result)
}
odds_ratio(tbl = tbl_a)

## Токсоплазма и автомобильные аварии ========================================
# Toxoplasma gondii — это паразитический протист, 
# который заражает мозг птиц и млекопитающих 
# и влияет на их поведение. 
# ~25% людей инфицированы токсоплазмой. 
# Зараженность токсоплазмой в выборках водителей 21-40 лет,
# попадавших в автомобильные аварии и без истории аварий.
# (Yereli et al., 2006)
# Связан ли токсоплазмоз на вероятность попадания в аварию?
  
tox <- read.csv("data/toxoplasma_driving_Yereli_etal_2006.csv", stringsAsFactors = FALSE)
head(tox)

tbl_tox <- table(tox$accident, tox$condition)
tbl_tox

par(pty = "s") # _квадратный график
mosaicplot(tbl_tox, col = c("darkgreen", "seagreen2"), cex.axis = 1.2, 
           sub = "Condition", dir = c("h","v"), 
           ylab = "Relative frequency", main = "")

# Относительный риск нельзя посчитать
# Отношение шансов можно
odds_ratio(tbl_tox)

# Паразиты рыб: “передай другому” ============================================
# У трематод Euhaplorchis californiensis три хозяина в жизненном цикле: 
# улитка, рыба и птица. Инфицированные рыбы проводят много времени 
# у поверхности воды могут стать добычей птиц (Lafferty, Morris, 1996). 
# Влияет ли уровень заражения трематодами на вероятность поедания птицами?
trem <- read.csv("data/trematodes_behaviour_Lafferty_Morris_1996.csv", stringsAsFactors = FALSE)
head(trem)

trem$infection <- factor(trem$infection, levels = c("uninfected", "lightly", "highly"))
tbl_trem <- table(trem$fate, trem$infection)
addmargins(tbl_trem)

par(pty = "s") # квадратный график
mosaicplot( t(tbl_trem), col = c("coral", "aquamarine4"), cex.axis = 1, 
            sub = "Infection status", 
            ylab = "Relative frequency", main = "")

# Тест сопряженности хи-квадрат #############################################
chi_trem <- chisq.test(trem$fate, trem$infection, correct = FALSE)
chi_trem

# Ожидаемые частоты (условия применимости хи-квадрат)
chi_trem$expected


# Питание вампиров ===========================================================
# Летучие мыши-вампиры _Desmodus rotundus_ в Коста Рике 
# часто питаются кровью крупного рогатого скота. 
# Кажется, они предпочитают коров быкам, и возможно, реагируют на гормоны. 
# Влияет ли эструс коров на вероятность быть укушенной вампиром (Turner, 1975)?

vamp <- read.csv("data/vampires_Turner_1975.csv", stringsAsFactors = FALSE)

tbl_vamp <- table(vamp$bitten, vamp$estrous)
tbl_vamp

par(pty = "s") # квадратный график
mosaicplot(t(tbl_vamp), col = c("deeppink", "plum"), cex.axis = 1, 
            sub = "Cow status", 
           ylab = "Relative frequency", main = "")

# Тест сопряженности хи-квадрат
chi_vamp <- chisq.test(vamp$bitten, vamp$estrous, correct = FALSE) 
# Ожидаемые частоты (условия применимости хи-квадрат)
chi_vamp$expected

# Точный критерий Фишера ####################################################
fisher.test(vamp$bitten, vamp$estrous)

# Задание 1 ----------------------------------------------------------------
# В датасете Titanic_sex_and_survival.csv приведены данные 
# о выживании пассажиров после катастрофы Титаника в зависимости от пола.
titanic <- read.csv("data/Titanic_sex_and_survival.csv", stringsAsFactors = FALSE)

# - Создайте таблицу наблюдаемых частот

# - Постройте мозаичный график

# - Протестируйте при помощи хи-квадрат теста, зависит ли выживание от пола.

# - Поверьте, выполняются ли условия применимости хи-квадрат теста.

# - При помощи точного критерия Фишера протестируйте ту же гипотезу 
#   о независимости выживания пассажиров от их пола. Сравните p-значения. 
#   Какой тест мягче?


