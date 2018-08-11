FROM jboss-webserver31-tomcat7-openshift:1.1

ENV OPENMRS_HOME /home/jboss/.OpenMRS
ENV OPENMRS_MODULES ${OPENMRS_HOME}/modules
ENV OPENMRS_PLATFORM_VERSION="2.1.3"
ENV OPENMRS_PLATFORM_URL="https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_2.1.3/openmrs.war/download"
ENV OPENMRS_REFERENCE_VERSION="2.8.0"
ENV OPENMRS_REFERENCE_URL="https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Reference_Application_2.8.0/referenceapplication-addons-2.8.0.zip/download"
ENV DATABASE_SCRIPT_FILE="openmrs_2.1.3_2.8.0.sql.zip"
ENV DATABASE_SCRIPT_PATH="db/${DATABASE_SCRIPT_FILE}"
ENV OPENHMIS_DATABASE_SCRIPT_FILE="openhmis_demo_data_2.x.sql.zip"
ENV OPENHMIS_DATABASE_SCRIPT_PATH="db/${OPENHMIS_DATABASE_SCRIPT_FILE}"
ENV OPENHMIS_LOCAL_DATABASE_SCRIPT_PATH="/home/jboss/temp/db/${OPENHMIS_DATABASE_SCRIPT_FILE}"

ENV DEFAULT_DB_NAME="openmrs_2_1_3_ref_2_8_0"
ENV DEFAULT_OPENMRS_DB_USER="openmrs_user"
ENV DEFAULT_OPENMRS_DB_PASS="Openmrs123"
ENV DEFAULT_OPENMRS_DATABASE_SCRIPT="${DATABASE_SCRIPT_FILE}"
ENV DEFAULT_OPENMRS_DATABASE_SCRIPT_PATH="/home/jboss/temp/db/${DEFAULT_OPENMRS_DATABASE_SCRIPT}"

# Refresh repositories and add mysql-client and libxml2-utils (for xmllint)
# Download and Deploy OpenMRS
# Download and copy reference application modules (if defined)
# Unzip modules and copy to module/ref folder
# Create database and setup openmrs db user
RUN curl -L ${OPENMRS_PLATFORM_URL} -o /opt/webserver/webapps/openmrs.war \
    && curl -L ${OPENMRS_REFERENCE_URL} -o ref.zip \
    && mkdir -p /home/jboss/temp/modules \
    && unzip -j ref.zip -d /home/jboss/temp/modules/

# Copy OpenHMIS dependencies
#COPY modules/dependencies/2.x/*.omod /home/jboss/temp/modules/

# Copy OpenMRS properties file
COPY openmrs-runtime.properties /home/jboss/temp/

# Copy default database script
COPY ${DATABASE_SCRIPT_PATH} /home/jboss/temp/db/

# Copy OpenHMIS database script
COPY ${OPENHMIS_DATABASE_SCRIPT_PATH} /home/jboss/temp/db/

# Expose the openmrs directory as a volume
VOLUME /home/jboss/.OpenMRS/

EXPOSE 8080

# Setup openmrs, optionally load demo data, and start tomcat
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]