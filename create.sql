CREATE DATABASE impl_development;

\c impl_development;

CREATE TABLE "travels" (
    "id" BIGSERIAL PRIMARY KEY,
    "travel_stops" integer[] NOT NULL
);