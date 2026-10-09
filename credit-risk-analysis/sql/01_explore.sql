-- ===========================================
-- ЭТАП 1. Разведка данных
-- Проект: Кредитный риск-анализ
-- Автор: Владимир
-- ===========================================

-- Запрос 1. Сколько всего клиентов в базе?
SELECT COUNT(*) AS total_clients
FROM credit_en;

-- Запрос 2. Доля дефолтов в портфеле
SELECT
    default_flag,
    COUNT(*) AS default_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_en), 2) AS default_percent
FROM credit_en
GROUP BY default_flag;

-- Запрос 3. Средние значения по портфелю
SELECT
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(monthly_income), 2) AS avg_income,
    ROUND(AVG(debt_ratio), 2) AS avg_debt_ratio
FROM credit_en;

-- Запрос 4. Качество данных: нули и пропуски
SELECT
    COUNT(*) FILTER (WHERE debt_ratio = 0) AS zero_ratio,
    COUNT(*) FILTER (WHERE monthly_income = 0) AS zero_income,
    COUNT(*) AS total
FROM credit_en;

-- Запрос 5. Очистка выбросов: статистика после фильтрации
SELECT
    ROUND(AVG(debt_ratio), 2) AS avg_ratio,
    ROUND(MIN(debt_ratio), 4) AS min_ratio,
    ROUND(MAX(debt_ratio), 2) AS max_ratio,
    COUNT(*) AS cnt
FROM credit_en
WHERE debt_ratio > 0
  AND debt_ratio < 5
  AND monthly_income > 0;