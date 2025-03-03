package db

import (
	"context"
	"github.com/mirshodNasilloyev/mini_chat/db/utils"
	"github.com/stretchr/testify/require"
	"testing"
	"time"
)

// Create Random User on DB
//Hello world
func createRandomUser(t *testing.T) Users {
	args := CreateUserParams{
		Name:         utils.RandomName(6),
		Username:     utils.RandomUsername(),
		PasswordHash: utils.RandomPassword(),
	}
	user, err := testQueries.CreateUser(context.Background(), args)
	require.NoError(t, err)
	require.NotEmpty(t, user)

	require.Equal(t, args.Name, user.Name)
	require.Equal(t, args.Username, user.Username)
	require.Equal(t, args.PasswordHash, user.PasswordHash)

	require.NotZero(t, user.ID)
	require.NotZero(t, user.CreatedAt)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t)
}

func TestGetUser(t *testing.T) {
	user1 := createRandomUser(t)
	user2, err := testQueries.GetUser(context.Background(), user1.ID)

	require.NoError(t, err)
	require.NotEmpty(t, user2)
	require.Equal(t, user1.ID, user2.ID)
	require.Equal(t, user1.Name, user2.Name)
	require.Equal(t, user1.Username, user2.Username)
	require.Equal(t, user1.PasswordHash, user2.PasswordHash)
	require.WithinDuration(t, user1.CreatedAt.Time, user2.CreatedAt.Time, time.Second)
}
func TestUpdateUser(t *testing.T) {
	user1 := createRandomUser(t)
	args := UpdateUserParams{
		ID:       user1.ID,
		Name:     utils.RandomName(6),
		Username: utils.RandomUsername(),
	}

	user2, err := testQueries.UpdateUser(context.Background(), args)
	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.ID, user2.ID)
	require.Equal(t, args.Name, user2.Name)
	require.Equal(t, args.Username, user2.Username)
	require.WithinDuration(t, user1.CreatedAt.Time, user2.CreatedAt.Time, time.Second)
}

func TestDeleteUser(t *testing.T) {
	user1 := createRandomUser(t)
	err := testQueries.DeleteUser(context.Background(), user1.ID)
	require.NoError(t, err)

	user2, err := testQueries.GetUser(context.Background(), user1.ID)
	require.Error(t, err)
	require.Empty(t, user2)
	require.Contains(t, err.Error(), "no rows in result set")
}

func TestListUsers(t *testing.T) {
	for i := 0; i < 5; i++ {
		createRandomUser(t)
	}

	args := ListUsersParams{
		Limit:  5,
		Offset: 5,
	}

	users, err := testQueries.ListUsers(context.Background(), args)
	require.NoError(t, err)
	require.Len(t, users, 5)

	for _, user := range users {
		require.NotEmpty(t, user)
	}

}
