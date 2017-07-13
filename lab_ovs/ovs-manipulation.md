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

Check al functions used by ovs-vsctl
```bash
strace ovs-vsctl show
```

## Create and Setup an OVS Bridge

Lookup 
```bash
ovs-vsctl list bridge ovs-br
```

Add a new OVS bridge
```bash
ovs-vsctl add-br ovs-br
```

Remove the bridge
```bash
ovs-vsctl del-br ovs-br
```

## Check FlowTables
```bash
ovs-ofctl show ovs-br
```

Check the data structure
```bash
ovsdb-client dump
```
