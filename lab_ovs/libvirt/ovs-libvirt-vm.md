# OVS  by Libvirt

## Prerequisite

```bash
sudo apt install bridge-utils openvswitch-common openvswitch-switch
sudo su
```


## Manipulation

### Host Part

Create an OVS bridge
```bash
ovs-vsctl add-br ovsbr0
virsh net-create --file kvm-net.xml
```
        
###  VM1 Part

Create VM1
```bash
virsh create kvm-vm1.xml
```

Add an IP address
```bash
ifconfig eth0 192.168.88.88/24 up
```


###  VM2 Part

Create VM2
```bash
virsh create kvm-vm2.xml
```

Add an IP address
```bash
ifconfig eth0 192.168.88.89/24 up
```
      
Test
```bash
ping 192.168.88.88
```       


### Host Test

Activate ovsbr0
```bash
ifconfig ovsbr0 192.168.150.1/24 up
ovs-vsctl show
```

No traffic through `eth0`
```bash
tcpdump -i eth0 icmp
```

ICMP traffic tjrpigj `vnet0`
```bash
tcpdump -i vnet0 icmp
```