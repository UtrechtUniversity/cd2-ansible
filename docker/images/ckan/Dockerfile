# This is a locally modified version of the upstream CKAN Dockerfile

# See CKAN docs on installation from Docker Compose on usage
FROM ubuntu:jammy
LABEL org.opencontainers.image.authors="Yoda team"

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Setting the locale
ENV LC_ALL=en_US.UTF-8
RUN adduser ckan
RUN apt-get update
RUN apt-get install --no-install-recommends -y locales
RUN sed -i "/$LC_ALL/s/^# //g" /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=${LC_ALL}

# Install required system packages
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get -q -y update \
    && apt-get -q -y install \
        python3.9 \
        python3.9-dev \
        python3-pip \
        python3.9-venv \
        python3-wheel \
        libpq-dev \
        python3-pastescript \
        python3-virtualenv \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        postgresql-client \
        build-essential \
        git-core \
        vim \
        wget \
        curl \
        nodejs \
        npm \
        nmap \
        sqlite3 \
        pwgen \
        uuid-runtime \
        sudo \
        vim  \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install less -g

# Define environment variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/default
ENV CKAN_CONFIG /etc/ckan
ENV CKAN_STORAGE_PATH=/ckanstorage
ENV CKAN_VERSION=2.11.0
ENV CKAN_CD2_LOGO_PATH_PREFIX=/usr/lib/ckan/default/src/ckan/ckan/public
ENV CKAN_CD2_LOGO_RELPATH=base/images/cd2-logo.png
# Extensions, plugins
ENV CKAN_PAGES_PLUGIN_VERSION=master
ENV CKAN_SCHEMING_VERSION=release-3.0.0
ENV CKAN_PYOAI_REPO=EUDAT-B2FIND/pyoai
ENV CKAN_PYOAI_VERSION=c820990bad0eb1f1267532041f458bc716461ec8
# Our plugins
ENV CKAN_CD2_CONFIG_VERSION=v1.0.1
ENV CKAN_MSL_UTIL_VERSION=1.1.0
ENV CKAN_CD2_THEME_VERSION=v1.0.2
ENV CKAN_OAIPMH_SERVER_PLUGIN_REPO=UtrechtUniversity/ckanext-oaipmh-server
ENV CKAN_OAIPMH_SERVER_PLUGIN_VERSION=YDA-6221-docker-setup-upgrade
#ENV CKAN_OAIPMH_SERVER_PLUGIN_VERSION=3fc2b5cd7443f71a631a71c16cb3228a17adfe8d
ENV CKAN_CD2_THEME_CSS_LESS="/usr/lib/ckan/default/src/ckanext-cd2-theme/ckanext/cd2_theme/less/main.less"
ENV CKAN_CD2_THEME_CSS_CUSTOM="/usr/lib/ckan/default/src/ckanext-cd2-theme/ckanext/cd2_theme/fanstatic/cd2_custom.css"

# Create storage path
RUN mkdir -p $CKAN_STORAGE_PATH/webassets $CKAN_STORAGE_PATH/storage && \
    chown -R www-data:www-data $CKAN_STORAGE_PATH

# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG/default && \
    python3.9 -m venv $CKAN_VENV && \
    ln -s $CKAN_VENV/bin/pip3 /usr/local/bin/ckan-pip3 &&\
    ln -s $CKAN_VENV/bin/ckan /usr/local/bin/ckan
ADD ckan.ini /etc/ckan/default/ckan.ini
ADD who.ini /etc/ckan/default/who.ini
ADD wsgi.py /etc/ckan/default/wsgi.py
ADD ckan-uwsgi.ini /etc/ckan/default/ckan-uwsgi.ini

# Virtual environment binaries/scripts to be used first
ENV PATH=${CKAN_VENV}/bin:${PATH}
ENV CD2_HOST=${CD2_HOST}
ENV CKAN_ADMIN_PASSWORD=${CKAN_ADMIN_PASSWORD}

# Install CKAN and plugins, configure plugins
RUN ckan-pip3 install -U pip && \
    ckan-pip3 install setuptools-scm==7.1.0 && \
    ckan-pip3 install --upgrade pip && \
    ckan-pip3 install wheel && \
    ckan-pip3 install -e "git+https://github.com/ckan/ckan@ckan-${CKAN_VERSION}#egg=ckan[requirements]" && \
    ckan-pip3 install uwsgi && \
    ckan-pip3 install -e "git+https://github.com/ckan/ckanext-pages@${CKAN_PAGES_PLUGIN_VERSION}#egg=ckanext-pages" && \
    ckan-pip3 install -e "git+https://github.com/ckan/ckanext-scheming@${CKAN_SCHEMING_VERSION}#egg=ckanext-scheming" && \
    # ckan-pip3 install -e "git+https://github.com/UtrechtUniversity/cd2-ckan-theme@YDA-6221-docker-setup-upgrade#egg=ckanext-cd2-theme" && \
    ckan-pip3 install -e "git+https://github.com/UtrechtUniversity/cd2-config@${CKAN_CD2_CONFIG_VERSION}#egg=ckanext-cd2_config" && \
    ckan-pip3 install -e "git+https://github.com/UtrechtUniversity/msl_ckan_util@${CKAN_MSL_UTIL_VERSION}#egg=ckanext-msl_ckan_util" && \
    ckan-pip3 install -e "git+https://github.com/${CKAN_PYOAI_REPO}@${CKAN_PYOAI_VERSION}#egg=pyoai" && \
    ckan-pip3 install -e "git+https://github.com/${CKAN_OAIPMH_SERVER_PLUGIN_REPO}@${CKAN_OAIPMH_SERVER_PLUGIN_VERSION}#egg=ckanext-oaipmh-server" && \
    ckan-pip3 install -r "https://raw.githubusercontent.com/${CKAN_OAIPMH_SERVER_PLUGIN_REPO}/${CKAN_OAIPMH_SERVER_PLUGIN_VERSION}/requirements.txt" && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH $COVERAGE_DIR && \
    ln -sf /usr/lib/ckan/default/src/ckanext-cd2-config/ckanext/cd2_config/config/schema.xml /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml && \
    # lessc ${CKAN_CD2_THEME_CSS_LESS} ${CKAN_CD2_THEME_CSS_CUSTOM} && \
    perl -n -i.bak -e 'print unless /defaultSearchField/ or /solrQueryParser/' /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml

ADD ./files/cd2-logo.png ${CKAN_CD2_LOGO_PATH_PREFIX}/${CKAN_CD2_LOGO_RELPATH}
ADD ./ckan-entrypoint.sh /ckan-entrypoint.sh
ENTRYPOINT ["/ckan-entrypoint.sh"]
RUN chmod +x /ckan-entrypoint.sh

USER root
EXPOSE 8080

CMD ["/ckan-entrypoint.sh"]
