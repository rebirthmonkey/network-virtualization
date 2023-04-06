# Network Virtualization

## Lab
This is a tutorial about different network virtualizatioin technologies:
- Linux Devices
  - [Tap Manipulation](lab_linux-device/tap/tap.md)
  - [Namespace-VETH-Namespace Communication](lab_linux-device/veth/ns-veth-ns.md)
- Linux Bridge
  - [Namespace-Bridge-Namespace Communication](lab_linux-bridge/ns-br-ns.md)
  - [Namespace-Bridge-Internet Communication](lab_linux-bridge/ns-br-ext.md)
  - [???Namespace-Bridge-Namespace-Bridge-Internet Communication]()
  - [VM-Bridge-VM Communication](lab_linux-bridge/vm-br-vm-kvm.md)
  - [???VM-Bridge-Internet Communication]()
- OpenVSwitch
  - [OpenVSwitch Manipulation](lab_ovs/ovs-manipulation.md)
  - [Namespace-OVS-Namespace Communication](lab_ovs/ns-ovs-ns.md)
  - [Namespace-OVS-Namespace Communication bis](lab_ovs/ns-ovs-ns-bis.md)
  - [Namespace-OVS-Internet Communication](lab_ovs/ns-ovs-ext.md)
  - [???Namespace-OVS-Namespace-OVS-Internet Communication]()
  - [VM-OVS-VM Communication: KVM](lab_ovs/vm-ovs-vm-kvm.md)
  - [VM-OVS-VM Communication: Libvirt](lab_ovs/vm-ovs-vm-libvirt/vm-ovs-vm-libvirt.md)
  - [Multi-Namespace-Br-OVS Scenario](lab_ovs/multi-ns-br-ovs.md)
  - [FlowTable Pipeline](lab_ovs/ovs-pipeline.md)
  - [VXLan Tunneling](lab_ovs/tunneling/ovs-tunneling.md)
  
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
