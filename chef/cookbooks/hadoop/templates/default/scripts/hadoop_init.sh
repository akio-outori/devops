#!/bin/bash

HADOOP_ROOT=<%= "#{@hadoop_path}" %>

${HADOOP_ROOT}/etc/hadoop/hadoop-env.sh
${HADOOP_ROOT}/bin/hdfs namenode -format
${HADOOP_ROOT}/sbin/start-dfs.sh
${HADOOP_ROOT}/sbin/start-yarn.sh
