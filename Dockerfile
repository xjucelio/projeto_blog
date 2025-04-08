FROM python:3.13.2-alpine3.21
LABEL maintainer="jucelio3832@gmail.com"

# Prevent Python from writing bytecode (.pyc) files
ENV PYTHONDONTWRITEBYTECODE=1

# Ensure Python output is unbuffered and displayed in real-time
ENV PYTHONUNBUFFERED=1

# Copy the djangoapp and scripts directories into the container
COPY djangoapp /djangoapp
COPY scripts /scripts

# Install system dependencies using apk (Alpine's package manager)
RUN apk update && apk add --no-cache \
    postgresql-libs \
    gcc \
    musl-dev \
    postgresql-dev \
    netcat-openbsd && \
    # Create virtual environment and install Python dependencies
    python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    # Create a non-root user
    adduser -D -H duser && \
    # Create directories for static and media files
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    # Set ownership and permissions
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts

# Set working directory
WORKDIR /djangoapp

# Expose port 8000 for Django
EXPOSE 8000

# Add scripts and venv/bin to PATH
ENV PATH="/scripts:/venv/bin:$PATH"

# Switch to non-root user
USER duser

# Run the commands.sh script
CMD ["commands.sh"]