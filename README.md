# hello network virtualization

## Lab
This is a tutorial about different network virtualizatioin technologies:
- Linux Network Devices Lab
  - [Linux Tap](lab_linux-device/tap/linux-tap.md)
- Linux Bridge Lab
  - [Linux Bridge with communicatin between Namespaces](lab_linux-bridge/linux-br-inter-namespace.md)
  - [Linux Bridge with communicatin from Namespace to Internet](lab_linux-bridge/linux-br-namespace-ext.md)
  - [Linux Bridge with KVM VMs](lab_linux-bridge/linux-bridge-kvm-vm.md)
- OpenVSwitch Lab
  - [OpenVSwitch Manipulation](lab_ovs/ovs-manipulation.md)
  - [OpenVSwitch with Namespaces](lab_ovs/ovs-namespace.md)
  - [OpenVSwitch with KVM VMs](lab_ovs/ovs-kvm-vm.md)
  - [OpenVSwitch with Libvirt VMs](lab_ovs/libvirt/ovs-libvirt-vm.md)
  - [OpenVSwitch Pipeline](lab_ovs/ovs-pipeline.md)
  - [OpenVSwitch VXLan Tunneling](lab_ovs/tunneling/ovs-tunneling.md)
  
## Commands
### `ovs-vsctl`
- `ovs-vsctl add-br sw`: add a new OVS bridge 
- `ovs-vsctl list bridge sw`: lookup
- `ovs-vsctl del-br sw`: remove the bridge
- `ovs-vsctl show`: show the `OVS` configuration of a server
  - `OVS manager` is for the whole server
  - `OVS controller` is for a dedicated switch

### `ovs-ofctl`
- `ovs-ofctl dump-flows sw`: show all the flow tables
  - `table=0`: output for one table
  - `--color`: don't work for `ssh`
- `ovs-ofctl del-flows sw`: cleanup the flow tables
- authorize all IP flows between 1 and 2:
```bash
ovs-ofctl add-flow sw arp,actions=normal
ovs-ofctl add-flow sw priority=800,ip,nw_src=8.8.8.7,nw_dst=8.8.8.8,actions=normal
ovs-ofctl add-flow sw priority=800,ip,nw_src=8.8.8.8,nw_dst=8.8.8.7,actions=normal
```
- `ovs-ofctl dump-flows sw`: show the flow tables
