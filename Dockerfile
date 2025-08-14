# Use Ruby 3.4 as the base image
FROM ruby:3.4.5-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    nodejs \
    npm \
    tzdata \
    curl

# Set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle config --global frozen 1 && \
    bundle install --without development test

# Copy the rest of the application
COPY . .

# Make the entrypoint script executable
RUN chmod +x docker-entrypoint.sh

# Create the database directory
RUN mkdir -p db

# Create a non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

# Change ownership of the app directory
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the port that the app runs on
EXPOSE 9292

# Set environment variables
ENV RACK_ENV=production
ENV DATABASE_URL=sqlite3:db/production.sqlite3

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:9292/ || exit 1

# Set entrypoint
ENTRYPOINT ["./docker-entrypoint.sh"]

# Start the application
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "9292"]
