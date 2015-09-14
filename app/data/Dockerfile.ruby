FROM ruby:2.2

RUN mkdir -p /app/vendor && \
    apt-get update && \
    apt-get install -y nodejs && \
    gem install foreman --no-ri --no-rdoc

WORKDIR /app

ADD Gemfile* /app/
RUN bundle install --jobs=10 --deployment

ADD . /app/

RUN ! grep -L rails Gemfile || bundle exec rake assets:precompile

RUN echo "SECRET_KEY_BASE=`openssl rand -hex 50`" > .env

ENV PORT=5000 ENV=production RAILS_ENV=production
EXPOSE 5000

CMD ["foreman", "start"]
