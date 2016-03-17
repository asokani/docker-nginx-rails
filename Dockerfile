FROM mainlxc/apache-php
MAINTAINER Asokani "https://github.com/asokani"

RUN add-apt-repository -y ppa:chris-lea/nginx-devel

RUN apt-get update && \
  apt-get -y install nginx-full libreadline-dev libffi-dev

RUN sudo -H -u www-user git clone https://github.com/rbenv/rbenv.git /home/www-user/.rbenv && \
	sudo -H -u www-user git clone https://github.com/rbenv/ruby-build.git /home/www-user/.rbenv/plugins/ruby-build
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;rbenv install 2.3.0'
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;rbenv install 2.2.3'
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;rbenv install 2.2.0'
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;rbenv install 1.9.3-p551'
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;rbenv global 2.3.0'
RUN sudo -H -u www-user bash -c 'export PATH=/home/www-user/.rbenv/bin:$PATH;eval "$(rbenv init -)";gem install bundler;rbenv rehash;bundle install;rbenv rehash'

EXPOSE 80 22 443

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
