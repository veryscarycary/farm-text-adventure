# Use the official Ruby 2.7.0 image as the base image
FROM ruby:2.7.0

# Install socat
RUN apt-get update && apt-get install -y socat

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of your application code into the container
COPY . ..

# Install dependencies
RUN bundle install

# Expose the port that socat will listen on
EXPOSE 3001

# Run socat to execute the Ruby script and forward its input and output to port 3000
CMD ["socat", "-d", "-d", "TCP-LISTEN:3001,reuseaddr,fork", "EXEC:\"ruby game.rb\",pty"]
