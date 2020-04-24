FROM zammad/zammad:3.4.0-56
# Attempting to fix file permissions from container to shared volume
# When using mkdir command, I need to specify -p to create parents as necessary. Otherwise, this line will fail
RUN mkdir -p /shared/zammad_data
RUN mkdir -p /shared/zammad_backup
ENV USER_ID=1000
ENV GROUP_ID=1000
#RUN usermod -u ${USER_ID} ${ZAMMAD_USER}
#RUN groupmod -g ${GROUP_ID} ${ZAMMAD_USER}
RUN chown -R ${USER_ID}:${GROUP_ID} /shared/zammad_data && chown -R ${USER_ID}:${GROUP_ID} /shared/zammad_backup
#https://askubuntu.com/questions/487527/give-specific-user-permission-to-write-to-a-folder-using-w-notation
VOLUME /shared/zammad_data
VOLUME /shared/zammad_backup
COPY ./zammad_run.sh /opt/zammad_run.sh
RUN chmod 777 /opt/zammad_run.sh
ENTRYPOINT /opt/zammad_run.sh
