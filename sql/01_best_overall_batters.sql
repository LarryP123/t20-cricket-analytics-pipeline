SELECT
    player_name,
    competition,
    innings,
    balls_faced,
    total_runs,
    avg_runs,
    strike_rate,
    batting_index
FROM player_metrics
WHERE innings >= 8
ORDER BY batting_index DESC
LIMIT 20;