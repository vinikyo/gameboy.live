FROM golang:1.24-bookworm AS builder

WORKDIR /app

COPY go.mod ./
COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o gbdotlive main_static.go

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/gbdotlive ./gbdotlive
COPY --from=builder /app/gb.svg ./gb.svg

RUN mkdir -p /app/snapshots /app/roms

EXPOSE 1989

CMD ["./gbdotlive", "-r", "/app/roms/game.gb", "-p", "1989"]
