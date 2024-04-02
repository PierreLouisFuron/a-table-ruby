# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set environment variables for Rails
ENV RAILS_ENV=test
ENV RAILS_LOG_TO_STDOUT=true

# Install dependencies
RUN apt update -qq && apt install -y \
    build-essential \
    apt-utils \
    libpq-dev \
    libvips-dev \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

# Set up the application directory
RUN mkdir /app
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the Rails application into the container
COPY . /app/

# Precompile assets (if needed)
RUN bundle exec rails assets:precompile
# RUN bundle exec rails db:migrate

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
