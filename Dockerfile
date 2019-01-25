FROM oryxprod/python-3.7
LABEL maintainer="arttu.mahlakaarto@gmail.com"

# Web Site Home
ENV HOME_SITE "/home/site/wwwroot"

#Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev \
        openssh-server \
        vim \
        curl \
        wget \
        g++ \
        unixodbc-dev \ 
        tcptraceroute \
    && pip install --upgrade pip \
    && pip install subprocess32 \
    && pip install gunicorn \ 
    && pip install virtualenv \
    && pip install flask \
    && pip install flask-sqlalchemy \
    && pip install celery \
    && pip install redis \
    && pip install pyodbc
WORKDIR ${HOME_SITE}

EXPOSE 8000
# setup SSH
RUN mkdir -p /home/LogFiles \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /etc/bash.bashrc 


COPY sshd_config /etc/ssh/
RUN mkdir -p /opt/startup
COPY init_container.sh /opt/startup/init_container.sh

# setup default site
RUN mkdir /opt/defaultsite
COPY hostingstart.html /opt/defaultsite
COPY application.py /opt/defaultsite

# install SQL driver and dependencies
COPY libssl.deb /home/libssl.deb
RUN dpkg -i /home/libssl.deb
COPY driver.deb /home/driver.deb
RUN ACCEPT_EULA=Y dpkg -i /home/driver.deb
RUN rm /home/libssl.deb
RUN rm /home/driver.deb

# configure startup
RUN chmod -R 777 /opt/startup
COPY entrypoint.py /usr/local/bin

ENTRYPOINT ["/opt/startup/init_container.sh"]

