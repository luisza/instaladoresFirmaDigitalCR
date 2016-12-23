#!/bin/bash

sudo bash run_in_jail.sh -d 
sudo bash run_in_jail.sh -u

rm -rf repo/

bash create_repository.sh -d 
bash create_repository.sh -u
