FROM golang:1.24-bookworm AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    libgl1-mesa-dev \
    xorg-dev \
    libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

COPY go.mod ./
COPY . .

RUN go mod tidy

RUN CGO_ENABLED=1 GOOS=linux go build -o gbdotlive main_static.go

FROM debian:bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgl1 \
    libx11-6 \
    libxcursor1 \
    libxrandr2 \
    libxinerama1 \
    libxi6 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/gbdotlive ./gbdotlive
COPY --from=builder /app/gb.svg ./gb.svg

RUN mkdir -p /app/snapshots /app/roms

EXPOSE 1989

CMD ["./gbdotlive", "-r", "/app/roms/game.gb", "-p", "1989"]
