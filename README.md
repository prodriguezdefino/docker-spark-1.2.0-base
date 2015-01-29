# Docker base image for Apache Spark
An Apache Spark base image container for Docker, runs on Ubuntu Trusty Tahr and it's based in the Hadoop image from [here](https://github.com/prodriguezdefino/docker-hadoop-base).

It includes: 
 - Java 8
 - Scala 2.11.5
 - SBT 0.13.7

The Spark installation is compiled to use Spark SQL, if it's needed. The idea is to use this image to build all componentes of the Spark cluster (master, workers and clients/submitters).
