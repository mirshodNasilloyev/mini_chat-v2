postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root mini_chatdb
dropdb:
	docker exec -it postgres12 dropdb mini_chatdb

migrateup:
	migrate -path db/migration -database "postgres://root:secret@localhost:5432/mini_chatdb?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgres://root:secret@localhost:5432/mini_chatdb?sslmode=disable" -verbose down

test:
	go test -v -cover ./...
sqlc:
	sqlc generate


.PHONY: createdb dropdb postgres migrateup migratedown sqlc test