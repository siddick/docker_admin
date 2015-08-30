FROM ruby:2.2

RUN mkdir /app && \
    gem install foreman --no-ri --no-rdoc

WORKDIR /app

ENV PORT 5000
EXPOSE 5000

COPY Gemfile Gemfile.lock /app/
RUN bundle install --deployment

COPY . /app/

CMD ["foreman", "start"]
