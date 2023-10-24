#!/bin/env python3
import json

with open("terraform.tfstate") as fio_state:
    state = json.load(fio_state)

hosts = {"all": []}

for resource in state["resources"]:
    if resource["type"] == "hcloud_server":
        for count, instance in enumerate(resource["instances"]):
            ipv6 = instance["attributes"]["ipv6_address"]
            hosts["all"].append(ipv6)
            if resource["name"] not in hosts:
                hosts[resource["name"]] = []
                if resource["name"] == "server":
                    hosts["serverprimary"] = [ipv6]
            elif resource["name"] == "server":
                hosts["serversecondary"] = [ipv6]
            if ipv4:=instance["attributes"]["ipv4_address"]:
                if "ipv4" not in hosts:
                    hosts["ipv4"] = []
                hosts["ipv4"].append(ipv4)
            hosts[resource["name"]].append(ipv6)

for section in hosts:
    print(f"[{section}]")
    for entry in hosts[section]:
        print(entry)
    print()
