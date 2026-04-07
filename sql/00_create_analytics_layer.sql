DROP TABLE IF EXISTS player_metrics;

CREATE TABLE player_metrics AS
SELECT
    b.player_name,
    b.team,
    m.competition,
    COUNT(*) AS innings,
    SUM(b.runs) AS total_runs,
    SUM(b.balls) AS balls_faced,
    ROUND(AVG(b.runs), 2) AS avg_runs,
    ROUND(
        CASE
            WHEN SUM(b.balls) > 0 THEN SUM(b.runs) * 100.0 / SUM(b.balls)
            ELSE 0
        END,
        2
    ) AS strike_rate,
    SUM(b.fours) AS total_fours,
    SUM(b.sixes) AS total_sixes,
    ROUND(
        CASE
            WHEN COUNT(*) > 0 THEN SUM(b.sixes) * 1.0 / COUNT(*)
            ELSE 0
        END,
        2
    ) AS sixes_per_innings,
    ROUND(
        CASE
            WHEN SUM(b.runs) > 0 THEN ((SUM(b.fours) * 4.0) + (SUM(b.sixes) * 6.0)) * 100.0 / SUM(b.runs)
            ELSE 0
        END,
        2
    ) AS boundary_pct,
    ROUND(
        AVG(b.runs) *
        CASE
            WHEN SUM(b.balls) > 0 THEN SUM(b.runs) * 100.0 / SUM(b.balls)
            ELSE 0
        END,
        2
    ) AS batting_index,
    ROUND(
        AVG(b.runs) * LOG10(COUNT(*) + 1),
        2
    ) AS consistency_score
FROM batting_scorecard b
LEFT JOIN matches m
    ON b.match_id = m.match_id
WHERE b.player_name IS NOT NULL
GROUP BY
    b.player_name,
    b.team,
    m.competition;