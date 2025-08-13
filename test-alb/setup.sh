#!/bin/bash
echo "Hello World from $(hostname -f)" > index.html
nohup python3 -m http.server 80 &