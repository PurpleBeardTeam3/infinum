FROM ruby:2.7.2 AS infinum-development
LABEL maintainer="alexrogna@yahoo.com"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs yarn

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

ENV INSTALL_PATH /opt/app/
RUN mkdir -p $INSTALL_PATH
COPY /infinum/Gemfile* $INSTALL_PATH
WORKDIR $INSTALL_PATH
ENV BUNDLE_PATH /gems

RUN bundle install
COPY infinum/ $INSTALL_PATH

RUN chown -R user:user $INSTALL_PATH
#USER $USER_ID
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "bin/rails", "s", "-b", "0.0.0.0" ]