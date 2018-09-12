FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y ruby2.6

WORKDIR /usr/src/app

COPY . ./

CMD ruby2.6 main.rb

###
# Given that
#
# <local_config_folder> describes the folder on the physical host containing your config.json file (absolute path required)
#
# start the container using
#
# docker run --rm -d -v <local_config_folder>:/usr/src/app/config -p8080:8080 --name service-monitor service-monitor
###
