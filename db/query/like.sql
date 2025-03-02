-- name: ToggleLike :exec
WITH deleted AS (
DELETE FROM likes WHERE user_id = $1 AND tweet_id = $2
    RETURNING *
)
INSERT INTO likes (user_id, tweet_id, created_at)
SELECT $1, $2, now()
    WHERE NOT EXISTS (SELECT 1 FROM deleted);
