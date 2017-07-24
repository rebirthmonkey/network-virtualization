# OVS Bridge between VMs
## Prerequisite
```bash
sudo apt install bridge-utils openvswitch-common openvswitch-switch
sudo su
```


## Network Devices
### OVS Private Bridge
Create an OVS private bridge 
```bash
ovs-vsctl add-br ovs-br-private
ovs-vsctl show
ip link set dev ovs-br-private up
ip addr add 8.8.8.7/24 broadcast 8.8.8.255 dev ovs-br-private
```
      
### TAP 
Create, activate and bind 2 TAP devices
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ip tuntap add mode tap tap1
ip tuntap add mode tap tap2
ip link set dev tap1 up
ip link set dev tap2 up
ovs-vsctl add-port ovs-br-private tap1
ovs-vsctl add-port ovs-br-private tap2
ovs-vsctl show
```

## VM
###  Launch VM1
Create VM1
```bash
kvm debian_wheezy_amd64_standard1.qcow2 -device virtio-net-pci,netdev=net0,mac=12:34:56:AB:CD:81 -netdev tap,id=net0,ifname=tap1,script=no,downscript=no -name vm1 -daemonize
```

Setup VM1, login:`root`, password: `root` 
```bash
ip addr add 8.8.8.8/24 broadcast 8.8.8.255 dev eth0
route add default gw 8.8.8.1
```

Test the gateway
```bash
ping 8.8.8.1
```


### Launch VM2
Create VM2
```bash
kvm debian_wheezy_amd64_standard2.qcow2 -device virtio-net-pci,netdev=net0,mac=12:34:56:AB:CD:82 -netdev tap,id=net0,ifname=tap2,script=no,downscript=no -name vm2 -daemonize
```

Setup VM2, login:`root`, password: `root`
```bash
ip link set dev eth1 up
ip addr add 8.8.8.9/24 broadcast 8.8.8.255 dev eth1
route add default gw 8.8.8.1
```

Test the gateway
```bash
ping 8.8.8.1
```

## Test
in VM1
```bash
ping 8.8.8.9
```

     
### Minitor Traffic
Monitor Traffic between VM1 and VM2 from the host
```bash
tcpdump -i tap1 icmp
```