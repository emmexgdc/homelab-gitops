FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY cmd ./cmd

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o api ./cmd/api


FROM alpine:3.20

WORKDIR /app

RUN addgroup -g 10001 -S app \
    && adduser -u 10001 -S app -G app

COPY --from=builder /app/api ./api

USER 10001

EXPOSE 8080

CMD ["./api"]
