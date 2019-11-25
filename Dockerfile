FROM node:8.16 AS node_deps
WORKDIR /srv/app
COPY package.json yarn.lock ./
RUN yarn install

FROM ruby:2.5.7-stretch

# Must have packages
RUN apt-get update -qq && apt-get install -y vim curl git tmux apt-transport-https ca-certificates

# Install Node
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn \
  && apt-get install -y --no-install-recommends \
    ca-certificates                             \
    bzip2                                       \
    libfontconfig                               \
  && apt-get clean all                          \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies
WORKDIR /srv/app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY --from=node_deps /srv/app/node_modules ./node_modules/
COPY . .
RUN rake assets:precompile DB_ADAPTER=mysql2
CMD foreman s
