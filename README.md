# Collection of DevOps Scripts

A number of script files and tools have been written to manage COOLab's computing resources. This repository collects these scripts for the purpose of automating DevOps for computing resources and clusters.

## Table of Contents

Name      | Desc.
--------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TUN2Socks | Connect the server to the external network via the socks5 proxy tunnel. The TUN device ensures that all connections are made through the proxy (even inside the container).
L2TP      | Enables the server to connect to an external network via the L2TP VPN protocol. Deprecated and replaced with `TUN2Socks`.
OpenPAI   | Platform for managing computing resources in the form of task queues.
