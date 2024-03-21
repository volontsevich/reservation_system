# Use the official Ruby image as the base image
FROM ruby:3.1.4

ENV APP_ROOT /app
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update -qq

# Set the working directory inside the container
WORKDIR $APP_ROOT

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile* ./

# Install any needed gems
RUN gem install bundler --no-document -v 2.5.6 && bundle install

# Copy the main application
COPY . /app

# Expose the port the app runs on
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
