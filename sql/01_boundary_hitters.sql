SELECT
    player_name,
    innings,
    total_balls,
    total_runs,
    total_fours,
    total_sixes,
    boundary_pct
FROM player_metrics
WHERE innings >= 6
  AND total_balls >= 120
  AND total_runs >= 200
  AND (total_fours + total_sixes) >= 25
ORDER BY boundary_pct DESC, strike_rate DESC, total_runs DESC
LIMIT 15;