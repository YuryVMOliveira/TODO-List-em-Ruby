# Use Ruby 3.4.5
FROM ruby:3.4.5-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Create assets directory for Propshaft
RUN mkdir -p app/assets/builds

# Expose port
EXPOSE 3000

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
