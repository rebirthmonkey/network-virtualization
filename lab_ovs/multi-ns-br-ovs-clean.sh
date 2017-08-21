#!/usr/bin/env bash

ovs-vsctl del-br ovs

ip link set dev g-bridge down
ip link set dev r-bridge down
brctl delbr g-bridge
brctl delbr r-bridge

ip link del dev g-veth0 type veth peer name g-veth0-bis
ip link del dev r-veth0 type veth peer name r-veth0-bis
ip link del dev g-veth1 type veth peer name g-veth1-bis
ip link del dev r-veth1 type veth peer name r-veth1-bis

ip netns del green
ip netns del red