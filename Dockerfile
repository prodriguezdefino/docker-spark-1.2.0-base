FROM prodriguezdefino/hadoop-2.6.0-base
MAINTAINER prodriguezdefino prodriguezdefino@gmail.com

# install scala 
ENV SCALA_VERSION 2.11.5
ENV SBT_VERSION 0.13.7
ENV SCALA_HOME /usr/share/scala
ENV PATH $SCALA_HOME/bin:$PATH

RUN wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb 
RUN dpkg -i scala-$SCALA_VERSION.deb
RUN apt-get update && apt-get install -y scala
 
# sbt installation
RUN wget http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb
RUN dpkg -i sbt-$SBT_VERSION.deb 
RUN apt-get update && apt-get install -y sbt

# download spark 1.2.0
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.2.0-bin-hadoop2.4 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

# create default configuration pointing to local host
RUN sed s/HOSTNAME/localhost/ $SPARK_HOME/yarn-remote-client/core-site.xml.template > $SPARK_HOME/yarn-remote-client/core-site.xml
RUN sed s/HOSTNAME/localhost/ $SPARK_HOME/yarn-remote-client/yarn-site.xml.template > $SPARK_HOME/yarn-remote-client/yarn-site.xml

RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave && hdfs dfs -put $SPARK_HOME-1.2.0-bin-hadoop2.4/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV SPARK_JAR hdfs:///spark/spark-assembly-1.2.0-hadoop2.4.0.jar
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

CMD ["/etc/bootstrap.sh", "-d"]
