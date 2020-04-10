# creates a layer froom the ubuntu:bionix Docker image
FROM ubuntu:bionic

LABEL maintainer="George Udosen datameshprojects@gmail.com"

# designate the workdir
WORKDIR /var/www/html/app


# install required tools
RUN apt update
RUN apt-get install nginx -y
RUN apt-get install uwsgi-plugin-python3 python3-setuptools build-essential libssl-dev libffi-dev python3-virtualenv python3-pip python3-venv -y
RUN pip3 install flask

# copy contents of app into workdir
COPY ./app ./

# setup virtualenv and install requirements
COPY myprojectenv ./myprojectenv
RUN touch ./myprojectenv/__init__.py

# remove default nginx conf file
RUN rm /etc/nginx/sites-enabled/*

# add own nginx config files
COPY myproject /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled/myproject

# check the state of the nginx conf
RUN nginx -t

# expose port 5000
EXPOSE 5000

# entry point for the app
CMD [ "uwsgi", "--ini",  "./myproject.ini" ]