WITH ranked_innings AS (
    SELECT
        player_name,
        team,
        competition,
        runs,
        balls,
        fours,
        sixes,
        match_id,
        ROW_NUMBER() OVER (
            PARTITION BY player_name, competition
            ORDER BY match_id DESC
        ) AS rn
    FROM batting_scorecard
    WHERE player_name IS NOT NULL
),
last_5 AS (
    SELECT *
    FROM ranked_innings
    WHERE rn <= 5
)
SELECT
    player_name,
    competition,
    COUNT(*) AS recent_innings,
    SUM(runs) AS recent_runs,
    ROUND(AVG(runs), 2) AS recent_avg,
    ROUND(
        CASE
            WHEN SUM(balls) > 0 THEN SUM(runs) * 100.0 / SUM(balls)
            ELSE 0
        END,
    2) AS recent_strike_rate
FROM last_5
GROUP BY player_name, competition
HAVING COUNT(*) = 5
ORDER BY recent_runs DESC, recent_strike_rate DESC
LIMIT 30;