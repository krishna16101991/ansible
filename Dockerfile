FROM centos:7
RUN yum update 
RUN yum install -y httpd; yum clean all; systemctl enable httpd.service

EXPOSE 80
 
RUN yum install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip 

# INSTALL DEPENDENCIES
RUN yum install -y curl gcc gcc-c++ libffi-devel openssl-devel openldap-devel sshpass unzip openjdk-8-jre-headless xvfb libxi6 libgconf-2-4 git postfix

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Selenium with Headless Chrome and CentOS" \
    org.label-schema.vendor="liguoliang.com" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20180817"

# install necessary tools
# RUN yum install unzip -y
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# INSTALL ANSIBLE
RUN pip install ansible==2.10.7

# install headless chrome
RUN curl -O  https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN yum install google-chrome-stable_current_x86_64.rpm -y

# install selenium
RUN pip install selenium

# download chromedriver
RUN mkdir /opt/chrome
RUN curl -O https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /opt/chrome

# copy the testing python script
#COPY selenium-with-headless-chrome.py .
#RUN python selenium-with-headless-chrome.py


# INSTALL SELENIUM
# RUN pip install selenium

# RUN TEST SCRIPT
#COPY test_selenium.py test_selenium.py

#CMD ["python3", "test_selenium.py"]
