-- ===========================================
-- ЭТАП 2. Сегментация клиентов
-- Проект: Кредитный риск-анализ
-- Автор: Владимир
-- ===========================================

-- Запрос 1. Дефолты по возрастным группам
WITH age_groups AS (
    SELECT
        default_flag,
        CASE
            WHEN age < 30 THEN 'young'
            WHEN age < 50 THEN 'middle'
            ELSE 'old'
        END AS age_group
    FROM credit_en
)
SELECT
    age_group,
    COUNT(*) AS cnt,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
FROM age_groups
GROUP BY age_group
ORDER BY default_percent DESC;

-- Запрос 2. Дефолты по доходным группам
WITH income_groups AS (
    SELECT
        default_flag,
        CASE
            WHEN monthly_income <= 4000 THEN 'low'
            WHEN monthly_income <= 7000 THEN 'middle'
            ELSE 'high'
        END AS income_group
    FROM credit_en
    WHERE monthly_income IS NOT NULL
)
SELECT
    income_group,
    COUNT(*) AS cnt,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
FROM income_groups
GROUP BY income_group
ORDER BY default_percent DESC;

-- Запрос 3. Дефолты по количеству кредитов
WITH credit_groups AS (
    SELECT
        default_flag,
        CASE
            WHEN open_credits = 0 THEN 'none'
            WHEN open_credits <= 3 THEN 'few'
            WHEN open_credits <= 7 THEN 'medium'
            ELSE 'many'
        END AS credit_group
    FROM credit_en
)
SELECT
    credit_group,
    COUNT(*) AS cnt,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
FROM credit_groups
GROUP BY credit_group
ORDER BY default_percent DESC;

-- Запрос 4. Дефолты по просрочкам 90+
WITH late_groups AS (
    SELECT
        default_flag,
        CASE
            WHEN late_90_plus = 0 THEN 'none'
            WHEN late_90_plus <= 2 THEN 'few'
            ELSE 'many'
        END AS late_group
    FROM credit_en
)
SELECT
    late_group,
    COUNT(*) AS cnt,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
FROM late_groups
GROUP BY late_group
ORDER BY default_percent DESC;