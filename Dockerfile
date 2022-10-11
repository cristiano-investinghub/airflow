FROM apache/airflow:2.1.3-python3.8

USER root

# run mkdir /usr/local/airflow

ENV AIRFLOW_HOME=/usr/local/airflow

#configs
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
#COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

#plugins
COPY plugins ${AIRFLOW_HOME}/plugins

#initial dags
COPY dags /dags

RUN mkdir ${AIRFLOW_HOME}/dags 

RUN chmod 777 -R /usr/local/airflow

RUN groupadd airflow

RUN  usermod -aG airflow airflow

RUN chown -R airflow:airflow /usr/local/airflow

RUN chmod 777 -R /dags

USER airflow

#requirements
COPY config/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt


EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]

