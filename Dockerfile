# Use the official Ruby 2.7.0 image as the base image
FROM ruby:2.7.0

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of your application code into the container
COPY . .

# Install dependencies
RUN bundle install

# Define the command to run your Ruby process
CMD ["ruby", "game.rb"]