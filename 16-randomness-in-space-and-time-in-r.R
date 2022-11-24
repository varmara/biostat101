# ---
# title: Случайность в пространстве или времени в R
# subtitle: "Основы биостатистики, осень 2022"

library(ggplot2)

## Пример: дни рождения =====================

# Дни недели, на которые пришлось рождение, 
# в случайной выборке из 180 младенцев 2016 году
# (данные the U.S. National Center 
# for Health Statistics; Martin et al. 2018).

# Открываем данные
birthDay <- read.csv("data/DayOfBirth2016.csv", stringsAsFactors = FALSE)

# Все ли правильно открылось
head(birthDay)
str(birthDay)

# Переименуем дни недели
# и одновременно посчитаем частоты рождений
days_en <- c("Monday", "Tuesday", "Wednesday",
             "Thursday", "Friday", "Saturday",
             "Sunday")
days_ru <- c("Пн", "Вт", "Ср", 
             "Чт", "Пт", "Сб", 
             "Вс")

b_tbl <- birthDay %>% 
  # переименовываем
  mutate(day = factor(day, 
                      levels = days_en,
                      labels = days_ru)) %>% 
  # считаем частоты рождений по дням
  group_by(day) %>% 
  summarise("N_births" = n())
b_tbl

# Объем выборки
N <- sum(b_tbl$N_births)
N 

# Хи-квадрат тест ############################

# Хи-квадрат тест вручную =====================

## Ожидаемые частоты пропорциональны 
# числу дней каждого типа в году
days2016 <- c(52, 52, 52, 52, 53, 53, 52)

b_chi <- b_tbl %>% # наблюдаемые частоты в таблице
  mutate(
    n_days = days2016, # число дней
    prop_days = n_days/ 366, # доля дней
    expected_frequency = prop_days * N, # ожидаемые
    chisq = (N_births - expected_frequency)^2/expected_frequency # слагаемые хи-квадрат
  ) 
b_chi # Все готово для расчета хи-квадрат
# Хи-квадрат статистика
b_chi_val <- sum(b_chi$chisq)
b_chi_val
# Число степеней свободы
b_chi_df <- 7 - 1 - 0
b_chi_df
# p-value
1 - pchisq(b_chi_val, df = b_chi_df)

# Хи-квадрат тест при помощи функции ===========
# Для расчета нужны наблюдаемые и ожидаемые частоты
chtest <- chisq.test(b_tbl$N_births, p = days2016/366)
chtest$statistic
chtest$p.value


# Распределение Пуассона #####################

## Пример: Вымирания видов в истории Земли =======

# Данные о вымирании семейств морских
# беспозвоночных за 76 отрезков времени
# (Raup, Sepkoski, 1982).
# Случаются ли вымирания "равномерно" 
# или бывают периоды массовых вымираний? 


ex_data <- read.csv("data/RaupSepkoski1982MassExtinctions.csv", stringsAsFactors = FALSE)

# Среднее число вымираний за период времени
ex_mean <- mean(ex_data$numberOfExtinctions)
# Объем выборки (количество временных отрезков)
N <- nrow(ex_data)

# Чтобы посчитать частоты, нам понадобится сделать фактором число вымираний за период
ex_data$nExtinctCategory <- factor(ex_data$numberOfExtinctions, levels = c(0:20))  
# Частоты различного числа вымираний
ex_tbl <- data.frame(table(ex_data$nExtinctCategory))
colnames(ex_tbl) <- c("n_extinctions", "observed_frequency")
# превращаем фактор обратно в число
ex_tbl$n_extinctions <- as.numeric(as.character(ex_tbl$n_extinctions))

# График наблюдаемых частот
ggplot(ex_tbl, aes(x = n_extinctions, y = observed_frequency)) +
  geom_col(aes(fill = "наблюдаемая")) +
  scale_fill_manual(name = "Частота", values = c("darkcyan", "black")) +
  labs(x = "Число вымираний\nза единицу времени", y = "Частота")

# Ожидаемые частоты по полным данным
ex_chi <- ex_tbl %>% 
  mutate(
    expected_proportion = dpois(0:20, lambda = ex_mean),
    expected_frequency = expected_proportion * N
  )

# График наблюдаемых и ожидаемых частот
ggplot(ex_chi, aes(x = n_extinctions, y = observed_frequency)) +
  geom_col(aes(fill = "наблюдаемая")) +
  geom_col(aes(y = expected_frequency, fill = "ожидаемая"), width = 0.2) +
  scale_fill_manual(name = "Частота", values = c("darkcyan", "black")) +
  labs(x = "Число вымираний\nза единицу времени", y = "Частота")

# Данные не соответствуют условиям применимости критерия $\chi^2$:  
# - одна ожидаемая частота < 1,
# - более 20% ожидаемых частот < 5
# Нужно объединить малочисленные категории

# Помечаем, какие категории объединять
ex_chi$group <- cut(ex_chi$n_extinctions, 
                    breaks = c(0, 2:8, 21), 
                    right = FALSE,
                    labels = c("0 или 1","2",
                               "3","4","5",
                               "6","7",">8"))
ex_chi

# Суммируем наблюдаемые и ожидаемые частоты для новых категорий
ex_poisson <- ex_chi %>% 
  group_by(group) %>% 
  summarise(
    observed_frequency = sum(observed_frequency),
    expected_frequency = sum(expected_frequency)
  )

# График наблюдаемых и ожидаемых частот
ggplot(ex_poisson, aes(x = group, y = observed_frequency)) +
  geom_col(aes(fill = "наблюдаемая")) +
  geom_col(aes(y = expected_frequency, fill = "ожидаемая"), width = 0.2) +
  scale_fill_manual(name = "Частота", values = c("darkcyan", "black")) +
  labs(x = "Число вымираний\nза единицу времени", y = "Частота") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "bottom")

# !!! Здесь посчитать хи-квадрат можно только вручную !!!
# Если использовать функцию - неправильное число степеней свободы
chisq_wrong_df <- chisq.test(ex_poisson$observed_frequency, p = ex_poisson$expected_frequency/N)
chisq_wrong_df


# Считаем хи-квадрат вручную ===================
ex_chi_val <- sum((ex_poisson$observed_frequency - ex_poisson$expected_frequency)^2/ex_poisson$expected_frequency)
# Число степеней свободы
# -1 как обычно и -1 за то, что оценили среднее
ex_chi_df <- nrow(ex_poisson) - 1 - 1 
# p-value
1 - pchisq(ex_chi_val, df = ex_chi_df)


# Сравнение дисперсии и среднего ##############

# Посчитайте индекс дисперсии, чтобы определить,
# как располагаются деревья в лесу.
n_quad <- 8 # объем выборки
trees <- c(0, 1, 0, 0, 1, 1, 2, 6) # частоты
trees_m <- mean(trees)
trees_var <- var(trees)
# Индекс дисперсии
Is <- trees_var/trees_m
Is
# Тестируем значимость индекса дисперсии
df <- n_quad - 1 # число степеней свободы
df
chi_val <- Is * df # хи-квадрат
chi_val
# Считаем площадь под правым хвостом
p_right <- 1 - pchisq(chi_val, df = df)
# Тест двусторонний
p_right * 2  # p-value


# Задание 1 --------------
# Птицы часто погибают, врезаясь в окна 
# высотных зданий. Если окно слегка наклонено вниз,
# вероятность гибели снижается.
# Klem et al. (2004) изучили, как влияет 
# на количество смертей птиц угол наклона окна.
# Предположим, что окна были совершенно одинаковы 
# и различались только углом наклона 
# (без наклона, 20 или 40 градусов). 
# Было использовано равное количество окон каждого типа.
# За время эксперимента погибло ударившись об окна
# без наклона - 30 птиц,
# под углом 20 градусов - 15 птиц, 
# а под углом 40 градусов - 8 птиц. 
# Данные в файле Klem_etal.2004_BirdWindowCrash.csv
# 
# (1) Сформулируйте нулевую и альтернативную гипотезы
# 
# (2) Протестируйте гипотезы, выбрав подходящий тест

# Задание 2 ----------------
# В Прусской армии нередко умирали от удара копытом. В файле приведено число случаев такой смерти в год (в нескольких подразделениях армии за каждый из 20 лет) (Bortkiewicz, 1898). Если число смертей от удара копытом не зависит от подразделения и от года, то оно будет подчиняться распределению Пуассона. Но если в некоторые годы некоторые подразделения состояли из людей, не умеющих обращаться с лошадьми, то число смертей от удара копытом не будет случайным.
# Данные в файле Cavalry.csv
# 
# (1) Сформулируйте нулевую и альтернативную гипотезы
# 
# (2) Протестируйте гипотезы, выбрав подходящий тест

# Задание 3 ----------------
# Трюфели — дорогой и вкусный деликатес. 
# В северной Калифорнии решили исследовать 
# их пространственное распределение 
# (Waters et al. 1997) и посчитали 
# их количество на множестве участков
# одинаковой площади. 
# Данные в файле Waters_etal.1997_Truffles.csv
# 
# (1) Определите, случайно ли распределены трюфели в лесу. Если нет, то в какую сторону их распределение отличается от случайного? 
# 
# (2) Протестируйте значимость отличий.




