FROM ruby:2.2

RUN mkdir /app && \
    gem install foreman --no-ri --no-rdoc
WORKDIR /app/
COPY Gemfile Gemfile.log /app/
RUN bundle install --deployment

COPY . /app/

ENV PORT=5000
EXPOSE 5000
CMD ["foreman", "start"]
