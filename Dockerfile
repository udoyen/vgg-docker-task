# creates a layer froom the nginx:lts Docker imag
FROM ubuntu:bionic

# designate the workdir
WORKDIR /var/www/html/app


# install required tools
RUN apt update
RUN apt install nginx -y
RUN apt-get install uwsgi-plugin-python3 python3-setuptools build-essential libssl-dev libffi-dev python3-virtualenv python3-pip python3-venv -y
RUN pip3 install flask

# RUN /usr/bin/uwsgi --build-plugin "/usr/src/uwsgi/plugins/python python36"
# RUN mv python36_plugin.so /usr/lib/uwsgi/plugins/python36_plugin.so
# RUN chmod 666 /usr/lib/uwsgi/plugins/python36_plugin.so

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

EXPOSE 5000

CMD [ "uwsgi", "--ini",  "./myproject.ini" ]