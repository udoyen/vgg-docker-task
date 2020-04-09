# creates a layer froom the nginx:lts Docker imag
FROM nginx:latest

# designate the workdir
WORKDIR /usr/share/nginx/html/app

# install required tools
RUN apt update
RUN apt-get install python3-setuptools build-essential libssl-dev libffi-dev python3-pip python3-venv -y

# copy contents of app into workdir
COPY ./app ./

# setup virtualenv and install requirements
RUN python3.6 -m venv ./myprojectenv
RUN source ./myprojectenv/bin/activate
RUN pip install -r ./requirements.txt
RUN deactivate

# setup the systemd service
COPY myproject.service /etc/systemd/system
RUN systemctl start myproject
RUN systemctl enable myproject

# remove default nginx conf file
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/conf.d/examplessl.conf
# add own nginx config files
COPY myproject.conf /etc/nginx/conf.d
# restart the nginx service
RUN service nginx restart

EXPOSE 12000


