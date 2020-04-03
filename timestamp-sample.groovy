import groovy.json.JsonSlurper

def payload = '''{
    "timestamp": "1565368680.268319130",
    "source": "cfnetworking.iptables",
    "message": "cfnetworking.iptables.egress-allowed",
    "log_level": 1,
    "data": {
        "packet": {
            "direction": "egress",
            "allowed": true,
            "src_ip": "10.255.138.3",
            "dst_ip": "72.74.149.50",
            "src_port": 48322,
            "dst_port": 443,
            "protocol": "TCP",
            "mark": "",
            "icmp_type": 0,
            "icmp_code": 0
        },
        "source": {
            "container_id": "aa096fe0-42de-46d3-5a79-62b1",
            "app_guid": "0e786c4a-8b3a-4cbc-a899-39f95d88d79a",
            "space_guid": "e224e064-d568-45e3-804f-27097062d5ee",
            "organization_guid": "51c0571f-a0c8-4d2b-8bf4-177e948c4588",
            "host_ip": "10.0.0.123",
            "host_guid": "06f0bacb-9724-44a4-8134-3365717652e3"
        }
    }
}'''


def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(payload)

assert object instanceof Map
assert object.timestamp == '1565368680.268319130'
println object.timestamp
