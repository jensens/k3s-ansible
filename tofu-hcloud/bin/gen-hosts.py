#!/bin/env python3
import json

with open("terraform.tfstate") as fio_state:
    state = json.load(fio_state)

hosts = {'all': []}

for resource in state['resources']:
    if resource['type'] == "hcloud_server":
        for instance in resource["instances"]:
            ipv6 = instance["attributes"]["ipv6_address"]
            hosts["all"].append(ipv6)
            rtypes = instance["attributes"]["labels"]["type"].split("-")
            for rtype in rtypes:
                if rtype not in hosts:
                    hosts[rtype] = []
                hosts[rtype].append(ipv6)

for section in hosts:
    print(f"[{section}]")
    for entry in hosts[section]:
        print(entry)
    print()