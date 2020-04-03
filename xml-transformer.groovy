@GrabResolver(name='restlet', root='http://maven.restlet.org/')
@Grapes([
    @Grab(group='org.codehaus.groovy', module='groovy-xml', version='3.0.1'),
    @Grab(group='org.apache.ivy', module='ivy', version='2.4.0')
])

import groovy.util.XmlParser

def payload = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:eser="http://www.nvenergy.com/eservices">
                           <soapenv:Header>
                                  <wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                                         <wsse:UsernameToken wsu:Id="UsernameToken-1" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
                                                <wsse:Username>SEIF_Eservices</wsse:Username>
                                                <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">Zsh7jQiXIMHM</wsse:Password>
                                                <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">Ib2ItPQx9GLDUdIWwhoeZw==</wsse:Nonce>
                                                <wsu:Created>2012-08-31T15:22:48.031Z</wsu:Created>
                                         </wsse:UsernameToken>
                                  </wsse:Security>
                           </soapenv:Header>
                           <soapenv:Body>
                          <eser:checkUserExists>
                                 <checkUserExistsRequest>
                                        <standardRequest>
                                           <requestSource>MOB</requestSource>
                                           <companyCode>30</companyCode>
                                        </standardRequest>
                                        <customerUserID>JSD11538</customerUserID>
                                 </checkUserExistsRequest>
                         </eser:checkUserExists>
                        </soapenv:Body>
                </soapenv:Envelope>
'''

def list = new groovy.util.XmlParser(false,false).parseText(new String(payload))
def requestSource = list.'**'.findAll{ node-> node.name() == 'requestSource' }*.text()
def customerUserID = list.'**'.findAll{ node-> node.name() == 'customerUserID' }*.text()
payload = [customerUserID, requestSource]

String json = "{"
def i = 0
payload.each { p ->
    label = "param" + i
    json = json + label + ":'" + p[0] + "',"
    i++    
}
json = json.substring(0, json.length() - 1)
json = json + "}"

println json

return json
