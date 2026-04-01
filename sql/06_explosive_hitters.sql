SELECT
    player_name,
    innings,
    total_runs,
    strike_rate,
    total_sixes,
    sixes_per_innings
FROM player_metrics
WHERE innings >= 6
  AND total_runs >= 180
  AND strike_rate >= 165
  AND sixes_per_innings >= 1.3
ORDER BY strike_rate DESC, sixes_per_innings DESC, total_runs DESC
LIMIT 15;