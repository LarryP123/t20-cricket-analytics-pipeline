SELECT
    competition,
    player_name,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    batting_index
FROM player_metrics
WHERE innings >= 6
ORDER BY competition, batting_index DESC;