# Linux Bridge with KVM VM Lab

## Prerequisite

Install Linux Bridge
```bash
sudo apt install bridge-utils
sudo su
```

## Network Devices

### Private Bridge
Create a private bridge
```bash
ip link add br-private type bridge
```

### TAP 
Create, activate and bind 2 `TAP` devices
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ip tuntap add mode tap tap1
ip tuntap add mode tap tap2
ip link set tap1 up
ip link set tap2 up
ip link set tap1 master br-private
ip link set tap2 master br-private
ip link set br-private up
```

Check
```bash
brctl show br-private
```

## VM
### Launch VM
Lauch VM1 and VM2
```bash
qemu-system-x86_64 -hda debian_wheezy_amd64_standard1.qcow2 -device e1000,netdev=net0,mac=00:11:22:33:44:01 -netdev tap,id=net0,ifname=tap1,script=no,downscript=no -name vm1 -daemonize
qemu-system-x86_64 -hda debian_wheezy_amd64_standard2.qcow2 -device e1000,netdev=net0,mac=00:11:22:33:44:02 -netdev tap,id=net0,ifname=tap2,script=no,downscript=no -name vm2 -daemonize
```

### Config IP Address
Config IP address of each VM, login: `root`, password: `root`
VM1: 
```bash
ip addr add 8.8.8.8/24 dev eth0
```

VM2: 
```bash
ip link set eth1 up
ip addr add 8.8.8.9/24 dev eth1
```

## Test
In VM1
```bash
ping 8.8.8.9
```

## Bug
If cannot ping, add an IP address for br-private and ping the bridge from the VM
```bash
ip addr add 8.8.8.7/24 dev br-private
```