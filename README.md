#  Launching SCDF in local mode using docker-compose: 
## Overivew of Pipeline
![Pipeline & Binders](file:///Users/wlund/Dropbox/git-workspace/wxlund/nvenergy/reqres-files/rabbit-kafka-binder.png)

See [Local Machine: Docker Compose](https://dataflow.spring.io/docs/installation/local/docker/) for details on starting scdf with docker-compose. For this example we've been
using
```bash
DATAFLOW_VERSION=2.4.2.RELEASE SKIPPER_VERSION=2.3.2.RELEASE docker-compose -f ./docker-compose.yml -f ./docker-compose-rabbitmq.yml -f ./docker-compose-postgres.yml up
```

One of the options we discussed, as the main theme in existing use cases of IBM data-power services involve patterns of integration and transformation tasks, we can leverage Spring Cloud Stream technique to perform typical tasks. Spring Cloud Stream provides a light-weight programming model to construct a stream of messages that is composed of a starting source, through one or more processors and a final sink. Each of the source, processor and sink parts are essentially a simple Spring Boot-based application with a qualifying binding annotation and few properties. Furthermore, with the Spring Cloud Data Flow and Spring Cloud Skipper it would be super-easy to orchestrate and manage the creation, deployment, scaling and versioning of the streams and their applications.

Our brainstormed idea is to use a request / response model of a stream that starts with an HTTP source and goes through one/more processor(s). No sink stream application is needed, but rather the final message returns back as a response. An integration gateway adapter is used in the HTTP source application to model a request/response pattern. The picture below worths a 1000 word to illustrate the stream.

We have completed the POC we started together about this model where a request/reply invocation from the dataflow server replying on the bus for support waits for the response from the backend before returning. The HTTP source has an endpoint that takes a request in same format as the existing XML payload. The DB query parameters are extracted out of the request payload using a Groovy transformer. Another transformer receives these parameters, reads the query string from its configuration properties (config server could be used here), executes the query and passes through the result in XML. If needed, a processor could be created to further transform the query result into another XML format per the response requirement.

The code is in Github. You can follow the steps below to run the POC locally. Same applications could be prepared further to be registered and used with SCDF / Skipper.

HTTP Source application
——————————-

Clone this application from https://github.com/Haybu/reqresp-http-source-rabbit. Go to the project home directory, and do

$ mvn clean install
$ java -jar ./target/reqres-http-source-rabbit-0.0.1-SNAPSHOT.jar

If you are running docker-compose with rabbit you can register the app in the following manner:

```bash
dataflow:>app register --name http-reqres --type source --uri maven://com.agilehandy:reqresp-http-source-rabbit:0.0.1-SNAPSHOT
```
To enable this we use the local customization option we use the maven section for mounting volumes for the docker-compose configuration found at "Maven Local Repository Mounting" - https://dataflow.spring.io/docs/installation/local/docker-customize/. In addition, when using rabbit we expose the management port (15672) so that developers can have a view into the auto-created queues and monitor pipeline traffic. Add the following in the docker-compose-rabbitmq.yml.  Finally, we exec into the dataflow-rabbitmq container and enable the rabbitmq management plugin with the following.
```bash
docker exec -it dataflow-rabbitmq /bin/sh
#rabbitmq-plugins enable rabbitmq_management
```
Now you can watch the message flow through the pipeline's use of your chosen binder  with localhost:15672  (guest/guest)

Groovy Transformer
———————---

Download OOB groovy-transform-processor-rabbit-2.0.1.RELEASE.jar file (I can send it to you if you need). Save the attached groovy script somewhere in your system, and in a different cmd window run the following

$ java -jar ./groovy-transform-processor-rabbit-2.0.1.RELEASE.jar \
 --groovy-transformer.script=file:/{path-to-file}/xml-request-transform.groovy \
 --spring.cloud.stream.bindings.input.destination=requests \
 --spring.cloud.stream.bindings.output.destination=txf1 \
 --server.port=8083 

Note: You need to copy the groovy script to the root directory in the following manner:

```bash
docker cp xml-request-transform.groovy dataflow-server:/root
```

Now we add the groovy-transform-processor to our pipeline with the following syntax:

```dataflow-shell
stream create --name http-reqresp-log --definition "http-reqres --server.port=20001 | groovy-transform --script=file:///root/xml-request-transform.groovy | log"
stream deploy http-reqresp-log
```

Once the stream is deployed We can test the groovy processor with the following curl command:

```bash
 curl http://localhost:20001 -H "Content-type: text/plain" -d @payload.xml
 ```

It will not return yet because our message bus is configured for request/reply. 

JDBC Processor application
———————————

Clone this application from https://github.com/Haybu/reqres-jdbc-processor-rabbit. Go to the project home directory, and in a different cmd window do
(Note: need to check it back in again. )

$ mvn clean install
$ java -jar ./target/reqres-jdbc-processor-rabbit-0.0.1-SNAPSHOT.jar

Postgres:
```bash
// I could not get the pull from maven to work without doing this local install 
mvn install:install-file -Dfile=/Users/wlund/Downloads/postgresql-42.2.10.jar -DgroupId=org.postgresql -DartifactId=postgresql -Dversion=42.2.5 -Dpackaging=jar
app register --name jdbc-reqres --type sink --uri maven://com.agilehandy:/reqres-jdbc-processor-rabbit:0.0.1-SNAPSHOT
Run the postgres container with the following:
```bash
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```
and the shell to execute the script with the following:

[Note: workaround that uses postgres as provisioned by docker-compose above. ]
```bash
PGPASSWORD=rootpw pgcli -U root -h localhost -d dataflow
```

```bash
PGPASSWORD=postgres pgcli -U postgres -h localhost -d reqres
```

Note: I was unable to run the script in DbVisualizer because of this error that I didn't take the time to resolve [Dollar-Quoted Postgres pl/pgsql procedures abort at first semi-colon] [https://support.dbvis.com/support/discussions/topics/1000076926]

```dataflow-shell
stream create --name http-reqres-jdbc --definition "http-reqres --server.port=20001 | groovy-transform --script=file:///root/xml-request-transform.groovy | jdbc-reqres"
stream deploy http-reqres-jdbc
```

* Optional *
If you want to try using the oracle script here is the Oracle Path:

I have used an Oracle docker image to run the DB locally in my system. I also mimc’ed creating a PL/SQL function to retrieve a customers table so I can run the same query string with the passed parameters. I have the JDBC application pointed to the Oracle DB instance that David provided me. (Note: that image was pulled down so I used the updated version)


```bash
docker run -d --rm --name oracledb -p 49161:1521 -e ORACLE_ALLOW_REMOTE=true haybu/wnameless-oracle-xe-11g
sqlplus system/oracle@localhost:49161
```
Haythem's seems to be based off of an older version of this one labeled wnameless

```bash
docker run -d -p 49161:1521 -e ORACLE_ALLOW_REMOTE=true ORACLE_ENABLE_XDB=true wnameless/oracle-xe-11g-r2
```
that is found here: https://github.com/wnameless/docker-oracle-xe-11g.  It has a note that they had to tear down their container per directions
from Oracle and that this is a new version.  Functions seem to be turned off in this configuration.

Please let me know if you have any questions or need any help running the POC.
