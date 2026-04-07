WITH ranked_innings AS (
    SELECT
        player_name,
        competition,
        runs,
        balls,
        match_id,
        ROW_NUMBER() OVER (
            PARTITION BY player_name, competition
            ORDER BY match_id DESC
        ) AS rn
    FROM batting_scorecard
    WHERE player_name IS NOT NULL
),
last_5 AS (
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
    FROM ranked_innings
    WHERE rn <= 5
    GROUP BY player_name, competition
),
season AS (
    SELECT
        player_name,
        competition,
        innings,
        avg_runs,
        strike_rate
    FROM player_metrics
)
SELECT
    s.player_name,
    s.competition,
    s.innings,
    s.avg_runs AS season_avg,
    l.recent_avg,
    ROUND(l.recent_avg - s.avg_runs, 2) AS avg_form_delta,
    s.strike_rate AS season_strike_rate,
    l.recent_strike_rate,
    ROUND(l.recent_strike_rate - s.strike_rate, 2) AS strike_rate_form_delta
FROM season s
JOIN last_5 l
  ON s.player_name = l.player_name
 AND s.competition = l.competition
WHERE s.innings >= 8
  AND l.recent_innings = 5
ORDER BY avg_form_delta DESC, strike_rate_form_delta DESC
LIMIT 30;