-- name: CreateFollow :one
INSERT INTO followers (
    follower_id,
    following_id
) VALUES ($1, $2)
    ON CONFLICT (follower_id, following_id) DO NOTHING
    RETURNING *;

-- name: GetFollowers :many
SELECT u.id, u.name, u.username, f.created_at
FROM followers f
JOIN users u ON f.follower_id=u.id
WHERE f.following_id=$1
ORDER BY f.created_at DESC
    LIMIT $2
OFFSET $3;

-- name: GetFollowing :many
SELECT u.id, u.name, u.username, f.created_at
FROM followers f
         JOIN users u ON f.following_id=u.id
WHERE f.follower_id=$1
ORDER BY f.created_at DESC
    LIMIT $2
OFFSET $3;

-- name: UnfollowUser :exec
DELETE FROM followers
WHERE follower_id = $1 AND following_id = $2;