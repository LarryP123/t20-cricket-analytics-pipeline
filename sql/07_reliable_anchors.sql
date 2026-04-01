SELECT
    player_name,
    innings,
    total_runs,
    avg_runs,
    strike_rate
FROM player_metrics
WHERE innings >= 8
  AND total_runs >= 280
  AND avg_runs >= 32
  AND strike_rate BETWEEN 125 AND 155
ORDER BY avg_runs DESC, total_runs DESC
LIMIT 15;