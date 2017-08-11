# Linux Bridge with Namespace
Communication from namespace to Internet

- `dhclient br0`
- `ip netns exec ns1 dhclient veth`