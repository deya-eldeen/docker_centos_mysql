FROM centos:7.4.1708
RUN yum -y update && yum upgrade

RUN yum install -y centos-release-scl
RUN yum install -y yum-utils
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install -y mysql-connector-python.noarch
RUN yum install -y gdal.x86_64 make

#################################
RUN yum-builddep -y python; yum -y install make postgresql-devel gcc \
 libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel \
 libxslt-devel libxml2-devel python-devel; yum clean all

#################################
ENV PYTHON_VERSION="3.7.2"
# Downloading and building python
RUN mkdir /tmp/python-build && cd /tmp/python-build && \
  curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz > python.tgz && \
  tar xzf python.tgz && cd Python-$PYTHON_VERSION && \
  ./configure --prefix=/usr/local --enable-shared && make install && cd / && rm -rf /tmp/python-build

#################################
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true
ENV LC_ALL "en_US.UTF-8"
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/lib"

#################################
RUN pip3 install django
RUN pip3 install djangorestframework
RUN pip3 install psycopg2-binary
RUN pip3 install djangorestframework-gis
RUN pip3 install django-extra-fields
RUN pip3 install phpserialize
RUN pip3 install requests
RUN pip3 install firebase_admin
RUN pip3 install django-rest-swagger
RUN pip3 install dj-database-url
RUN pip3 install mysql-connector-python
RUN pip3 install PyMySQL

RUN yum install -y python-devel mysql-devel
RUN pip3 install mysqlclient

RUN pip3 install django-cors-headers
RUN yum install -y mlocate
RUN updatedb

ARG djangoDebug=True
ENV djangoDebug=$djangoDebug

ARG djangoLive=False
ENV djangoLive=$djangoLive

EXPOSE 80

#ENTRYPOINT "cd /var/www/html/ && python3.7 manage.py runserver 0.0.0.0:80" && /bin/bash

