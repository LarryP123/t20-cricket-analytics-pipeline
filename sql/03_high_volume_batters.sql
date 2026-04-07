SELECT
    player_name,
    competition,
    innings,
    balls_faced,
    total_runs,
    avg_runs,
    strike_rate
FROM player_metrics
WHERE innings >= 8
ORDER BY total_runs DESC
LIMIT 40;