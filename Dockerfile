## Apache Spark Base image
#
FROM prodriguezdefino/hadoopbase
MAINTAINER prodriguezdefino prodriguezdefino@gmail.com

# install scala 
ENV SCALA_VERSION 2.11.5
ENV SBT_VERSION 0.13.7
ENV SCALA_HOME /usr/share/scala
ENV PATH $SCALA_HOME/bin:$PATH

RUN wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb 
RUN dpkg -i scala-$SCALA_VERSION.deb
 
# sbt installation
RUN wget http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb
RUN dpkg -i sbt-$SBT_VERSION.deb 

# clean up deb files
RUN rm -f /*.deb

# download spark 1.3.1
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.3.1-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client
RUN mkdir /tmp/spark-files
ADD spark-files /tmp/spark-files

# create default configuration pointing to local host
RUN sed s/HOSTNAME/localhost/ $SPARK_HOME/yarn-remote-client/core-site.xml.template > $SPARK_HOME/yarn-remote-client/core-site.xml
RUN sed s/HOSTNAME/localhost/ $SPARK_HOME/yarn-remote-client/yarn-site.xml.template > $SPARK_HOME/yarn-remote-client/yarn-site.xml

RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave && hdfs dfs -put $SPARK_HOME-1.3.1-bin-hadoop2.6/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV SPARK_JAR hdfs:///spark/spark-assembly-1.3.1-hadoop2.6.0.jar
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

CMD ["/etc/bootstrap.sh", "-d"]
