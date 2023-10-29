# Use the official Ruby image as the base image
FROM ruby:3.2.2

# Set environment variables
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies
#RUN apt update && apt install -y build-essential mysql-server mysql-client libmysqlclient-dev nodejs

# Create and set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

# Copy the application code into the container
COPY . .

# Expose port 3000 to the host
EXPOSE 3000

# Start the Rails application
CMD ["rails", "server", "-b", "0.0.0.0"]
