#!/usr/bin/python
import dns.resolver
import sys
import time
start = time.time()
resolver = dns.resolver.Resolver()
resolver.nameservers = [sys.argv[2]] # using google DNS
result = resolver.query(sys.argv[1])
print time.time()-start
