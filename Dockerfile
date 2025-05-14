# syntax=docker/dockerfile:1
FROM ruby:3.3.0

RUN apt-get update -qq && apt-get install -y nodejs npm yarn postgresql-client
WORKDIR /devise
COPY Gemfile /devise/Gemfile
COPY Gemfile.lock /devise/Gemfile.lock
RUN npm install --global yarn
RUN yarn add bootstrap
RUN bundle install

# Cleanup cache
RUN bundle clean --force \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

# Set directory ownership
RUN chown -R $USER:$USER .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]