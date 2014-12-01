#!/bin/sh

# using gem ruby-protocol-buffers

cd gauge-proto
ruby-protoc -o ../lib spec.proto
ruby-protoc -o ../lib messages.proto
ruby-protoc -o ../lib api.proto
