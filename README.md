# WEB HOST HEALTH TESTER
Testing tool written in Ruby to determine if a host is pingable and responding to HTTP requests.

### Gems Required
- net/ping
- net/http
- socket
- colorize

### Usage
Populate hosts.txt file with hosts you want to check.
Must include the protocol/scheme.
Some sample hosts with proper formatting are provided in hosts.txt for testing.

`./test_host.rb`
