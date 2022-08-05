ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION AS base

ARG PG_MAJOR
# Common dependencies
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential \
  gnupg2 \
  less \
  git \
  libcurl4-openssl-dev \
  libpq-dev \
  wget \
  zip \
  zlib1g-dev \
  postgresql-client-$PG_MAJOR \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  LANG="en_US.UTF-8" \
  LANGUAGE="en_US.UTF-8" \
  TZ="Europe/Minsk"

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Upgrade RubyGems
RUN gem update --system

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Document that we're going to expose port 3000
EXPOSE 3000
# Use Bash as the default command

# Then, we define the "development" stage from the base one
FROM base AS development

ENV RAILS_ENV=development
CMD ["/usr/bin/bash"]
# The major difference from the base image is that we may have development-only system
# dependencies (like Vim or graphviz).
# We extract them into the Aptfile.dev file.
# COPY Aptfile.dev /tmp/Aptfile.dev
# RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
#   DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#   $(grep -Ev '^\s*#' /tmp/Aptfile.dev | xargs) && \
#   apt-get clean && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
#   truncate -s 0 /var/log/*log

# The production-builder image is responsible for installing dependencies and compiling assets
FROM base as production-builder

# First, we create and configure a dedicated user to run our application
RUN groupadd --gid 1005 my_user \
  && useradd --uid 1005 --gid my_user --shell /bin/bash --create-home my_user
USER my_user
RUN mkdir /home/my_user/app
WORKDIR /home/my_user/app

# Then, we re-configure Bundler
ENV RAILS_ENV=production \
  LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_APP_CONFIG=/home/my_user/bundle \
  BUNDLE_PATH=/home/my_user/bundle \
  GEM_HOME=/home/my_user/bundle

# Install Ruby gems
COPY --chown=my_user:my_user Gemfile Gemfile.lock ./
RUN mkdir $BUNDLE_PATH \
  && bundle config --local deployment 'true' \
  && bundle config --local path "${BUNDLE_PATH}" \
  && bundle config --local without 'development test' \
  && bundle config --local clean 'true' \
  && bundle config --local no-cache 'true' \
  && bundle install --jobs=${BUNDLE_JOBS} \
  && rm -rf $BUNDLE_PATH/ruby/3.1.0/cache/* \
  && rm -rf /home/my_user/.bundle/cache/*

# Copy code
COPY --chown=my_user:my_user . .

# Finally, our production image definition
# NOTE: It's not extending the base image, it's a new one
FROM ruby:$RUBY_VERSION AS production

# Production-only dependencies
RUN apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  curl \
  gnupg2 \
  less \
  tzdata \
  time \
  locales \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
  gem install bundler

# Create and configure a dedicated user (use the same name as for the production-builder image)
RUN groupadd --gid 1005 my_user \
  && useradd --uid 1005 --gid my_user --shell /bin/bash --create-home my_user
RUN mkdir /home/my_user/app
WORKDIR /home/my_user/app
USER my_user

# Ruby/Rails env configuration
ENV RAILS_ENV=production \
  BUNDLE_APP_CONFIG=/home/my_user/bundle \
  BUNDLE_PATH=/home/my_user/bundle \
  GEM_HOME=/home/my_user/bundle \
  PATH="/home/my_user/app/bin:${PATH}" \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

EXPOSE 3000

# Copy code
COPY --chown=my_user:my_user . .

# Copy artifacts
# 1) Installed gems
COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH
# 2) We can even copy the Bootsnap cache to speed up our Rails server load!
# COPY --chown=my_user:my_user --from=production-builder /home/my_user/app/tmp/cache/bootsnap* /home/my_user/app/tmp/cache/

CMD ["bundle", "exec", "rails", "telegram:bot:poller"]