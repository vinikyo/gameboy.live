FROM golang:1.24-bookworm AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o gbdotlive main.go

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/gbdotlive ./gbdotlive
COPY --from=builder /app/gb.svg ./gb.svg

EXPOSE 1989

CMD ["./gbdotlive", "-h"]
