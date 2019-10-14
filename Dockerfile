FROM phusion/passenger-full:1.0.8

ENV HOME /root

CMD ["/sbin/my_init"]

# Start nginx & passenger && remove default server config
RUN rm -f /etc/service/nginx/down && rm /etc/nginx/sites-enabled/default

# Add our server config
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# create the home directory && Set ruby version to 2.3.5
RUN mkdir /home/app/webapp && bash -l -c 'rvm --default use ruby-2.6.0'

# bundle install

ADD ./Gemfile /home/app/webapp/Gemfile
ADD ./Gemfile.lock /home/app/webapp/Gemfile.lock

RUN cd /home/app/webapp && bundle install --retry=5

ADD . /home/app/webapp

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD env.conf /etc/nginx/main.d/env.conf

RUN cd /home/app/webapp && bundle exec rails assets:precompile
