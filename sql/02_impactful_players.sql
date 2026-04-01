SELECT
    player_name,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    impact_score
FROM player_metrics
WHERE innings >= 8
  AND total_runs >= 250
  AND strike_rate >= 135
ORDER BY impact_score DESC, total_runs DESC
LIMIT 15;