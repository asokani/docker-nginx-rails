FROM mainlxc/base
MAINTAINER Asokani "https://github.com/asokani"

RUN add-apt-repository -y ppa:chris-lea/nginx-devel

RUN apt-get update && \
  apt-get -y install nginx-full libreadline-dev libffi-dev

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build /usr/local/rbenv/plugins/ruby-build
#RUN git clone https://github.com/ianheggie/rbenv-binstubs.git /usr/local/rbenv/plugins/rbenv-binstubs

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
RUN eval "$(rbenv init -)"

RUN rbenv install 2.3.0
#RUN rbenv install 2.2.3
#RUN rbenv install 2.2.0
#RUN rbenv install 1.9.3-p551
RUN rbenv global 2.3.0

# TODO move to the base, probably PPA nodejs version (this is for uglifier)
RUN apt-get -y install nodejs

RUN gem install bundler && rbenv rehash 

RUN chown www-manage:www-user -R /usr/local/rbenv/ && chmod -R g+rX /usr/local/rbenv/ && find /usr/local/rbenv -type d -exec chmod g+s {} \;
RUN echo 'export PATH="/usr/local/rbenv/bin:$PATH"\nexport RBENV_ROOT="/usr/local/rbenv"\neval "$(rbenv init -)"' >> ~www-user/.bashrc
RUN echo 'export PATH="/usr/local/rbenv/bin:$PATH"\nexport RBENV_ROOT="/usr/local/rbenv"\neval "$(rbenv init -)"' >> ~www-manage/.bashrc
RUN echo 'gem: --no-rdoc --no-ri' >> ~www-manage/.gemrc

USER root

# nginx
RUN mkdir /etc/service/nginx
ADD nginx.sh /etc/service/nginx/run
RUN rm -rf /etc/nginx/conf.d
RUN sed -i -e  's/http[[:space:]]*{/http {\nserver_names_hash_bucket_size 64;\n/' /etc/nginx/nginx.conf

# unicorn
RUN mkdir -p /var/log/unicorn && chown www-user:www-user /var/log/unicorn
RUN mkdir -p /var/log/rails && touch /var/log/rails/production.log && chown -R www-user:www-user /var/log/rails
RUN chmod 770 /var/log/rails && chmod 660 /var/log/rails/production.log
RUN mkdir /etc/service/unicorn
ADD unicorn.sh /etc/service/unicorn/run
ADD unicorn-reload.sh /usr/bin/unicorn-reload.sh
RUN echo "www-manage ALL = NOPASSWD: /usr/bin/unicorn-reload.sh" > /etc/sudoers.d/unicorn

EXPOSE 80 22 443

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

