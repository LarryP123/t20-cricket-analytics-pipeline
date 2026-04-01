SELECT
    player_name,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    batting_index
FROM player_metrics
WHERE innings >= 10
  AND total_runs >= 350
ORDER BY total_runs DESC, avg_runs DESC, strike_rate DESC
LIMIT 15;