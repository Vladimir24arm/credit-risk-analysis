-- ===========================================
-- ЭТАП 3. Продвинутый анализ
-- Проект: Кредитный риск-анализ
-- Автор: Владимир
-- ===========================================

-- Запрос 1. Топ-3 возрастные группы по риску (RANK)
WITH age_stats AS (
    SELECT
        CASE
            WHEN age < 25 THEN '18-24'
            WHEN age < 35 THEN '25-34'
            WHEN age < 45 THEN '35-44'
            WHEN age < 55 THEN '45-54'
            WHEN age < 65 THEN '55-64'
            ELSE '65+'
        END AS age_group,
        COUNT(*) AS cnt,
        SUM(default_flag) AS defaults,
        ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
    FROM credit_en
    GROUP BY age_group
),
ranked AS (
    SELECT
        age_group,
        cnt,
        defaults,
        default_percent,
        RANK() OVER (ORDER BY default_percent DESC) AS rank
    FROM age_stats
)
SELECT *
FROM ranked
WHERE rank <= 3
ORDER BY rank;

-- Запрос 2. Сравнение должников и платящих
SELECT
    default_flag,
    COUNT(*) AS cnt,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(monthly_income), 2) AS avg_income,
    ROUND(AVG(credit_utilization), 2) AS avg_utilization,
    ROUND(AVG(open_credits), 2) AS avg_credits,
    ROUND(AVG(late_90_plus), 2) AS avg_late_90
FROM credit_en
WHERE monthly_income IS NOT NULL
GROUP BY default_flag;

-- Запрос 3. Комбинированный анализ: возраст + просрочки
WITH combined AS (
    SELECT
        default_flag,
        CASE
            WHEN age < 40 THEN 'young'
            ELSE 'old'
        END AS age_group,
        CASE
            WHEN late_90_plus = 0 THEN 'no_late'
            ELSE 'has_late'
        END AS late_group
    FROM credit_en
)
SELECT
    age_group,
    late_group,
    COUNT(*) AS cnt,
    SUM(default_flag) AS defaults,
    ROUND(100.0 * SUM(default_flag) / COUNT(*), 2) AS default_percent
FROM combined
GROUP BY age_group, late_group
ORDER BY default_percent DESC;