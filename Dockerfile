ARG CENTOS_VERSION=8
FROM centos:${CENTOS_VERSION}

# set the locale
# avoid Failed to set locale, defaulting to C.UTF-8
RUN yum install -y glibc-locale-source
RUN localedef --quiet -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN yum install -y \
        yum-utils \
        curl \
        git \
        unzip \
        postfix \
        tmux \
        vim \
        python38 \
        python38-pip \
        python38-devel \
        emacs-nox && \
    yum install -y \
        epel-release && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
        cairo-devel \
        dejavu-sans-fonts \
        libffi-devel \
        libxml2-devel \
        libxslt-devel \
        ImageMagick

#RUN yum clean -y all

# Symlink python
RUN ln -sfn /usr/bin/python3.8 /usr/bin/python3 & \
    ln -sfn /usr/bin/python3 /usr/bin/python & \
    ln -sfn /usr/bin/pip3.8 /usr/bin/pip3 & \
    ln -sfn /usr/bin/pip3 /usr/bin/pip

# setuptools v58 removed 2to3 support: https://setuptools.pypa.io/en/latest/history.html#v58-0-0
# the `fs` package relies on `2to3`
RUN pip3 install --upgrade pip pipenv "setuptools<58" wheel
RUN which python3 
RUN which pip3


LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Selenium with Headless Chrome and CentOS" \
    org.label-schema.vendor="liguoliang.com" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20180817"


#RUN curl -O https://bootstrap.pypa.io/get-pip.py
#RUN python get-pip.py

# INSTALL ANSIBLE
RUN pip3 install ansible

# install headless chrome
RUN curl -O  https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN yum install google-chrome-stable_current_x86_64.rpm -y

# install selenium
RUN pip3 install selenium

# download chromedriver
RUN mkdir /opt/chrome
RUN curl -O https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /opt/chrome

#RUN yum install -y yum-utils
#RUN yum install -y terraform

CMD ["/bin/ping","localhost"]

# copy the testing python script
#COPY selenium-with-headless-chrome.py .
#RUN python selenium-with-headless-chrome.py


# INSTALL SELENIUM
# RUN pip install selenium

# RUN TEST SCRIPT
#COPY test_selenium.py test_selenium.py

#CMD ["python3", "test_selenium.py"]
