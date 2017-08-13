#!/usr/bin/env bash

# create a namespace
ip netns add ns2
ip netns list

# create a veth pair
ip link add dev tap2 type veth peer name br-tap2

# set veth to the namespaces
ip link set tap2 netns ns2

# create and setup a Linux bridge `br88`:
brctl addbr br88
brctl showmacs br88
brctl addif br88 br-tap2
brctl addif br88 enp0s3
brctl showmacs br88

# activate all the devices:
ip link set dev br-tap2 up
ip link set dev br88 up
ip netns exec ns2 ip link set dev lo up
ip netns exec ns2 ip link set dev tap2 up
brctl showmacs br88

# associate IP addresses to the devices:
ip netns exec ns2 ip addr add 192.168.88.2/24 dev tap2
ip netns exec ns3 ip addr add 192.168.88.3/24 dev tap3

# Test
ip netns exec ns2 ping 192.168.88.3