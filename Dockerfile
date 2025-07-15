# Multi-stage build for Evilginx2
# Stage 1: Build the application
FROM golang:1.22-alpine AS builder

# Install git and ca-certificates (needed for private repos and SSL)
RUN apk add --no-cache git ca-certificates tzdata

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o evilginx main.go

# Stage 2: Create the runtime image
FROM alpine:latest

# Install ca-certificates for SSL/TLS
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user
RUN addgroup -g 1000 evilginx && \
    adduser -D -s /bin/sh -u 1000 -G evilginx evilginx

# Set working directory
WORKDIR /app

# Copy binary from builder stage
COPY --from=builder /app/evilginx .

# Copy necessary directories
COPY --chown=evilginx:evilginx phishlets ./phishlets
COPY --chown=evilginx:evilginx redirectors ./redirectors

# Create directories for runtime data
RUN mkdir -p /app/data && \
    mkdir -p /app/crt && \
    chown -R evilginx:evilginx /app

# Switch to non-root user
USER evilginx

# Expose ports
# Port 53 for DNS
# Port 80 for HTTP
# Port 443 for HTTPS
EXPOSE 53/udp 80 443

# Set environment variables
ENV EVILGINX_CONFIG_DIR=/app/data
ENV EVILGINX_PHISHLETS_DIR=/app/phishlets
ENV EVILGINX_REDIRECTORS_DIR=/app/redirectors

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD nc -z localhost 443 || exit 1

# Default command
CMD ["./evilginx", "-c", "/app/data", "-p", "/app/phishlets", "-t", "/app/redirectors"]
