# Image for Solr configured for CKAN

FROM solr:8.11
LABEL org.opencontainers.image.authors="Yoda team"

# TODO when upgrade CKAN to 2.11, this file will need
# to be overhauled to match the EPOS-MSL one
ENV SOLR_CONFIG_DIR="/opt/solr/server/solr/configsets"
ENV SOLR_VERSION="8.11.3"
ENV SOLR_ELEVATE_EXAMPLE_DIR="${SOLR_CONFIG_DIR}/sample_techproducts_configs/conf"

# Create a CKAN configset based on the default one
USER root
RUN cp -R $SOLR_CONFIG_DIR/_default $SOLR_CONFIG_DIR/ckan

# Install basic components
RUN apt update && \
    apt install -y git vim && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists/*

# Download the cd2-config plugin (for the schema)
RUN cd /usr/lib && \
    git clone https://github.com/UtrechtUniversity/cd2-config.git cd2_config

# Change the CKAN configset to use the cd2-config schema, and enable Query Elevation
USER root
ADD solrconfig.xml ${SOLR_CONFIG_DIR}/ckan/conf/solrconfig.xml
RUN ln -s /usr/lib/cd2_config/ckanext/cd2_config/config/schema.xml $SOLR_CONFIG_DIR/ckan/conf/schema.xml && \
    perl -n -i.bak -e 'print unless /defaultSearchField/ or /solrQueryParser/' $SOLR_CONFIG_DIR/ckan/conf/schema.xml && \
    cp $SOLR_CONFIG_DIR/ckan/conf/schema.xml $SOLR_CONFIG_DIR/ckan/conf/managed-schema && \
    cp ${SOLR_ELEVATE_EXAMPLE_DIR}/elevate.xml $SOLR_CONFIG_DIR/ckan/conf/elevate.xml

USER solr
CMD ["sh", "-c", "solr-precreate ckan $SOLR_CONFIG_DIR/ckan"]
