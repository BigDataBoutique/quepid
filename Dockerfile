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

# Install PhantomJS
#RUN mkdir /tmp/phantomjs                               \
#  && curl -L                                            \
#    https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2  \
#    | tar -xj --strip-components=1 -C /tmp/phantomjs    \
#  && cd /tmp/phantomjs                                  \
#  && mv bin/phantomjs /usr/local/bin                    \
#  && cd                                                 \

COPY . /srv/app
WORKDIR /srv/app

RUN bundle install
RUN yarn install
