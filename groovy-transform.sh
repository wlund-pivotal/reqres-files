#! /bin/bash
java -jar ./groovy-transform-processor-rabbit-2.1.0.RELEASE.jar \
  --groovy-transformer.script=file:///Users/wlund/Dropbox/git-workspace/wxlund/nvenergy/xml-request-transform.groovy \
  --spring.cloud.stream.bindings.input.destination=requests \
  --spring.cloud.stream.bindings.output.destination=txf1 \
--server.port=8083 