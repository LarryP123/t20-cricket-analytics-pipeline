SELECT
    player_name,
    innings,
    total_runs,
    total_balls,
    avg_runs,
    strike_rate,
    batting_index
FROM player_metrics
WHERE innings >= 8
  AND total_runs >= 300
  AND total_balls >= 180
ORDER BY batting_index DESC
LIMIT 15;