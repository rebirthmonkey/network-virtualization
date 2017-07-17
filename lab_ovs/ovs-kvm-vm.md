# OVS Bridge between VMs

## Prerequisite

```bash
sudo apt-get install bridge-utils openvswitch-common openvswitch-switch
sudo su
```


## Manipulation

### Host Part

Create an OVS bridge 
```bash
ovs-vsctl add-br somebr
ovs-vsctl show
ip link set dev somebr up
ip addr add 192.168.21.1/24 broadcast 192.168.21.255 dev somebr
```
      
Create and activate 2 TAP devices:
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ip tuntap add mode tap vport1
ip tuntap add mode tap vport2
ifconfig vport1 up
ifconfig vport2 up
ovs-vsctl add-port somebr vport1
ovs-vsctl add-port somebr vport2
ovs-vsctl show
```


###  VM1 Part

Create VM1
```bash
kvm debian-mini.img -device virtio-net-pci,netdev=net0,mac='12:34:56:AB:CD:81' -netdev tap,id=net0,ifname=vport1,script=no,downscript=no -name vm1 -daemonize
```

Setup VM1
```bash
su
ifconfig eth0 192.168.21.2 netmask 255.255.255.0 broadcast 192.168.21.255
route add default gw 192.168.21.1
```

Test the gateway
```bash
ping 192.168.21.1
```


###  VM2 Part

Create VM2
```bash
kvm debian-mini2.img -device virtio-net-pci,netdev=net0,mac='12:34:56:AB:CD:82' -netdev tap,id=net0,ifname=vport2,script=no,downscript=no -name vm2 -daemonize
```

      
Setup VM2
```bash
su
ifconfig eth0 192.168.21.3 netmask 255.255.255.0 broadcast 192.168.21.255
route add default gw 192.168.21.1
```

Test the gateway
```bash
ping 192.168.21.1
```

Test the VM1 connection
```bash
ping 192.168.21.2
```

     
### Minitor Traffic

Monitor Traffic between VM1 and VM2 from the host
```bash
tcpdump -i vport1 icmp
```