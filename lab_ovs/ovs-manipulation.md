# OpenVSwitch Manipulation Lab

## Install OVS

Install packages
```bash
sudo apt install openvswitch-common openvswitch-switch
```

Check OVS services
```bash
ps aux grep openvswitch
lsmod  grep openvswitch
```

Check all files used by `ovs-vswitchd`
```bash
lsof -p PID
```

Check all files used by `ovsdb-server`
```bash
lsof -p PID
```

Check all functions used by ovs-vsctl
```bash
strace ovs-vsctl show
```

## OVS Bridge Creation

Add a new OVS bridge
```bash
sudo su
ovs-vsctl add-br sw
```

Lookup 
```bash
ovs-vsctl list bridge sw
```

Remove the bridge
```bash
ovs-vsctl del-br sw
```

Check FlowTables
```bash
ovs-ofctl show ovs-br
```

Check the data structure
```bash
ovsdb-client dump
```

## Namespace and Network Setup

Create namespaces
```bash
ip netns add ns1
ip netns add ns2
ip netns add ns3
```

Create network devices
```bash
ip link add eth0-1 type veth peer name veth-1
ip link add eth0-2 type veth peer name veth-2
ip link add eth0-3 type veth peer name veth-3
```

Device allocation
```bash
ip link set eth0-1 netns ns1
ip link set eth0-2 netns ns2
ip link set eth0-3 netns ns3
ovs-vsctl add-port sw veth-1
ovs-vsctl add-port sw veth-2
ovs-vsctl add-port sw veth-3
```

Device Activation
```bash
ip link set dev veth-1 up
ip link set dev veth-2 up
ip link set dev veth-3 up
ip netns exec ns1 ip link set dev lo up
ip netns exec ns1 ip link set eth0-1 up
ip netns exec ns1 ip address add 10.0.0.1/24 dev eth0-1
ip netns exec ns2 ip link set dev lo up
ip netns exec ns2 ip link set eth0-2 up
ip netns exec ns2 ip address add 10.0.0.2/24 dev eth0-2
ip netns exec ns3 ip link set dev lo up
ip netns exec ns3 ip link set eth0-3 up
ip netns exec ns3 ip address add 10.0.0.3/24 dev eth0-3
```

## Flow Table Configuration
### IP Flow between 1 and 2

Clean up 
```bash
ovs-ofctl del-flows sw
```

Show
```bash
ovs-ofctl dump-flows sw
```

Authorize all IP flows between 1 and 2
```bash
ovs-ofctl add-flow sw arp,actions=normal
ovs-ofctl add-flow sw priority=800,ip,nw_src=10.0.0.1,nw_dst=10.0.0.2,actions=normal
ovs-ofctl add-flow sw priority=800,ip,nw_src=10.0.0.2,nw_dst=10.0.0.1,actions=normal
```

Show
```bash
ovs-ofctl dump-flows sw
```

Test
```bash
ip netns exec ns1 ping 10.0.0.2 # OK 
ip netns exec ns1 ping 10.0.0.3 # OK
ip netns exec ns2 ping 10.0.0.1 # OK
ip netns exec ns2 ping 10.0.0.3 # OK
ip netns exec ns3 ping 10.0.0.1 # OK
ip netns exec ns3 ping 10.0.0.2 # OK
```


### ICMP Flow from 1 to 2

Clean up 
```bash
ovs-ofctl del-flows sw
```

Show
```bash
ovs-ofctl dump-flows sw
```

Authorize only ICMP flows from 1 to 2
```bash
ovs-ofctl add-flow sw arp,actions=normal
ovs-ofctl add-flow sw priority=800,icmp,icmp_type=8,nw_src=10.0.0.1,nw_dst=10.0.0.2,actions=normal
ovs-ofctl add-flow sw priority=800,icmp,icmp_type=0,nw_src=10.0.0.2,nw_dst=10.0.0.1,actions=normal
```

Show
```bash
ovs-ofctl dump-flows sw
```

Test
```bash
ip netns exec ns1 ping 10.0.0.2 # OK 
ip netns exec ns1 ping 10.0.0.3 # KO
ip netns exec ns2 ping 10.0.0.1 # KO
ip netns exec ns2 ping 10.0.0.3 # KO
ip netns exec ns3 ping 10.0.0.1 # KO
ip netns exec ns3 ping 10.0.0.2 # KO
```


### ICMP Flow from 1 to all

Clean up 
```bash
ovs-ofctl del-flows sw
```

Show
```bash
ovs-ofctl dump-flows sw
```

Authorize only ICMP flows from 1 to 2
```bash
ovs-ofctl add-flow sw arp,actions=normal
ovs-ofctl add-flow sw priority=800,icmp,icmp_type=8,nw_src=10.0.0.1,nw_dst=10.0.0.0/24,actions=normal
ovs-ofctl add-flow sw priority=800,icmp,icmp_type=0,nw_src=10.0.0.0/24,nw_dst=10.0.0.1,actions=normal
```

Show
```bash
ovs-ofctl dump-flows sw
```

Test
```bash
ip netns exec ns1 ping 10.0.0.2 # OK 
ip netns exec ns1 ping 10.0.0.3 # OK
ip netns exec ns2 ping 10.0.0.1 # KO
ip netns exec ns2 ping 10.0.0.3 # KO
ip netns exec ns3 ping 10.0.0.1 # KO
ip netns exec ns3 ping 10.0.0.2 # KO
```



