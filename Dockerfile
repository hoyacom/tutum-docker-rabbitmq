FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>


# Add the officially endorsed Erlang debian repository:
# See:
#  - http://www.erlang.org/download.html
#  - https://www.erlang-solutions.com/downloads/download-erlang-otp
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 434975BD900CCBE4F7EE1B1ED208507CA14F4FCA
RUN echo 'deb http://packages.erlang-solutions.com/debian wheezy contrib' > /etc/apt/sources.list.d/erlang.list

# http://www.rabbitmq.com/install-debian.html
# "Please note that the word testing in this line refers to the state of our release of RabbitMQ, not any particular Debian distribution."
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys F78372A06FF50C80464FC1B4F7B8CEA6056E8E56
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbitmq.list

# Install RabbitMQ
RUN apt-get update && \
    apt-get install -y rabbitmq-server pwgen && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_mqtt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "ERLANGCOOKIE" > /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

# Add scripts
ADD run.sh /run.sh
ADD set_rabbitmq_password.sh /set_rabbitmq_password.sh
RUN chmod 755 ./*.sh

EXPOSE 1883 5672 15672
CMD ["/run.sh"]
