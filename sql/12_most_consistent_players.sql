SELECT
    player_name,
    competition,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    consistency_score,
    batting_index
FROM player_metrics
WHERE innings >= 8
ORDER BY consistency_score DESC, avg_runs DESC
LIMIT 25;