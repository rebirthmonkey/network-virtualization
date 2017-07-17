# Linux Device TAP Lab

## TAP Device Manipulation

Create a TAP device
```bash
sudo ip tuntap add dev tap1 mode tap
```

Attach an IP address
```bash
sudo ip addr add 192.168.88.88/24 dev tap1
```

Listen to port 8888 for all network devices
```bash
sudo nc -l 8888
```

Open another terminal, establish a session on the port 8888 of `tap1`, and send messages
```bash
sudo nc 88888 192.168.88.88 8888
```
we can send messages now


## Send data through a TAP file

Create and activate a TAP device
```bash
sudo ip tuntap add dev tap1 mode tap
sudo ip link set dev tap89 up
```

Open a new terminal and monitor `tap89`
```bash
sudo tcpdump -i tap89 -vv
```

In another terminal, compile and execute the `tap.c` program
```bash
gcc -Wall tap.c -o tapw
sudo ./tapw
```

We can see that the `tcpdump` monitors data sent from `tap89`