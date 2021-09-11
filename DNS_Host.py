#!/usr/bin/python
import dns.resolver
import sys
resolver = dns.resolver.Resolver()
resolver.nameservers = [sys.argv[2]] # using google DNS
result = resolver.query(sys.argv[1])
nameservers = [ns.to_text() for ns in result]
print nameservers
