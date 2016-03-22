FROM mainlxc/base
MAINTAINER Asokani "https://github.com/asokani"

RUN add-apt-repository -y ppa:chris-lea/nginx-devel

RUN apt-get update && \
  apt-get -y install nginx-full libreadline-dev libffi-dev

USER www-user

RUN git clone https://github.com/sstephenson/rbenv.git ~www-user/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build ~www-user/.rbenv/plugins/ruby-build
RUN git clone https://github.com/ianheggie/rbenv-binstubs.git ~www-user/.rbenv/plugins/rbenv-binstubs

ENV PATH /home/www-user/.rbenv/bin:$PATH

RUN eval "$(rbenv init -)"

RUN rbenv install 2.3.0
#RUN rbenv install 2.2.3
#RUN rbenv install 2.2.0
#RUN rbenv install 1.9.3-p551
RUN rbenv global 2.3.0

RUN gem install bundler && rbenv rehash 

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~www-user/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~www-user/.bashrc

EXPOSE 80 22 443

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
