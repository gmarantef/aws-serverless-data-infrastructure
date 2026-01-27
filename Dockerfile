FROM ghcr.io/opentofu/opentofu:1.11.2-minimal AS tofu

FROM alpine:3.20

# Copy the tofu binary from the minimal image
COPY --from=tofu /usr/local/bin/tofu /usr/local/bin/tofu

# Add any other tools or dependencies you need
RUN apk add --no-cache \
    bash \
    ca-certificates \
    git \
    curl \
    jq \
    aws-cli \
    fzf


# Your application setup
WORKDIR /workspace
