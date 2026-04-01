DROP VIEW IF EXISTS player_metrics;

CREATE VIEW player_metrics AS
SELECT
    player_name,

    COUNT(*) AS innings,
    SUM(runs) AS total_runs,
    SUM(balls) AS total_balls,

    ROUND(AVG(runs), 2) AS avg_runs,

    ROUND(SUM(runs) * 100.0 / SUM(balls), 2) AS strike_rate,

    SUM(fours) AS total_fours,
    SUM(sixes) AS total_sixes,

    ROUND(
        (SUM(fours) * 4 + SUM(sixes) * 6) * 100.0 / SUM(runs),
        2
    ) AS boundary_pct,

    ROUND(SUM(sixes) * 1.0 / COUNT(*), 2) AS sixes_per_innings,

    ROUND(
        SUM(runs) * (SUM(runs) * 100.0 / SUM(balls)) / 100.0,
        2
    ) AS batting_index,

    ROUND(
        AVG(runs) * (SUM(runs) * 100.0 / SUM(balls)) / 100.0,
        2
    ) AS impact_score

FROM batting_scorecard
GROUP BY player_name
HAVING COUNT(*) >= 6
   AND SUM(balls) >= 120
   AND SUM(runs) >= 200;