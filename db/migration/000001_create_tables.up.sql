CREATE TABLE "users" (
                         "id" serial PRIMARY KEY,
                         "name" varchar NOT NULL,
                         "username" varchar UNIQUE NOT NULL,
                         "password_hash" varchar NOT NULL,
                         "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "tweets" (
                          "id" serial PRIMARY KEY,
                          "user_id" bigint,
                          "tweet_id" bigint DEFAULT null,
                          "content" text NOT NULL,
                          "file_url" text DEFAULT null,
                          "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "followers" (
                             "id" serial PRIMARY KEY,
                             "follower_id" bigint,
                             "following_id" bigint,
                             "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "likes" (
                         "id" serial PRIMARY KEY,
                         "user_id" bigint,
                         "tweet_id" bigint,
                         "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "users" ("username");

CREATE INDEX ON "tweets" ("user_id");

CREATE INDEX ON "followers" ("follower_id");

CREATE INDEX ON "followers" ("following_id");

CREATE UNIQUE INDEX ON "followers" ("follower_id", "following_id");

CREATE INDEX ON "likes" ("tweet_id");

CREATE UNIQUE INDEX ON "likes" ("user_id", "tweet_id");

COMMENT ON COLUMN "users"."username" IS 'should be unique';

COMMENT ON TABLE "followers" IS 'A user cannot follow themselves.';

ALTER TABLE "tweets" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "tweets" ADD FOREIGN KEY ("tweet_id") REFERENCES "tweets" ("id");

ALTER TABLE "followers" ADD FOREIGN KEY ("follower_id") REFERENCES "users" ("id");

ALTER TABLE "followers" ADD FOREIGN KEY ("following_id") REFERENCES "users" ("id");

ALTER TABLE "likes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "likes" ADD FOREIGN KEY ("tweet_id") REFERENCES "tweets" ("id");
