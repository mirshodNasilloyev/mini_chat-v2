-- name: CreateTweet :one
INSERT INTO tweets (
    user_id,
    tweet_id,
    content,
    file_url
) VALUES ($1, $2, $3, $4)
    RETURNING *;

-- name: GetTweetWithLikeStatus :one
SELECT
    t.*,
    CASE
        WHEN l.user_id IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_liked
FROM tweets t
LEFT JOIN likes l
    ON t.id=l.tweet_id AND l.user_id=$2
WHERE t.id=$1
LIMIT 1;

-- name: ListTweetsWithLikeStatus :many
SELECT
    t.*,
    EXISTS (
        SELECT 1 FROM likes l
        WHERE l.tweet_id = t.id
          AND l.user_id = $1
    ) AS is_liked
FROM tweets t
ORDER BY t.id
    LIMIT $2 OFFSET $3;


-- name: ListTweets :many
SELECT * FROM tweets
ORDER BY id
    LIMIT $1
OFFSET $2;

-- name: ListUserTweets :many
SELECT * FROM tweets
WHERE user_id=$1
ORDER BY id
    LIMIT $2
OFFSET $3;


-- name: UpdateTweet :one
UPDATE tweets
SET content=$2, file_url=$3
WHERE id = $1
    RETURNING *;

-- name: DeleteTweet :exec
DELETE FROM tweets
WHERE id = $1;