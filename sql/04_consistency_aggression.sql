SELECT
    player_name,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    impact_score
FROM player_metrics
WHERE innings >= 8
  AND avg_runs >= 28
  AND strike_rate >= 145
  AND total_runs >= 250
ORDER BY impact_score DESC, avg_runs DESC
LIMIT 15;