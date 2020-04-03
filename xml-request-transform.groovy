def list = new groovy.util.XmlParser(false,false).parseText(new String(payload))

def requestSource = list.'**'.findAll{ node-> node.name() == 'requestSource' }*.text()
def customerUserID = list.'**'.findAll{ node-> node.name() == 'customerUserID' }*.text()
payload = [customerUserID, requestSource]
println payload

String json = "{"
def i = 0
payload.each { p ->
    label = "param" + i
    json = json + '"' + label + '":"' + p[0] + '",'
    i++    
}
json = json.substring(0, json.length() - 1)
json = json + "}"

println json
return json

