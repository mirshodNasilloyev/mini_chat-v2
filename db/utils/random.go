package utils

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet = "abcdefghijklmnopqrstuvwxyz"

func init() {
	rand.Seed(time.Now().UnixNano())
}

func RandomInt(min, max int) int {
	return min + rand.Intn(max-min)
}

func RandomString(length int) string {
	var sb strings.Builder
	k := len(alphabet)
	for i := 0; i < length; i++ {
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}
	return sb.String()
}

func RandomName(length int) string {
	return RandomString(length)
}

func RandomUsername() string {
	return RandomString(16)
}

func RandomPassword() string {
	result := RandomString(4)
	result += string(rune(RandomInt(0, 10000)))
	return result
}
