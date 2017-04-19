#!/bin/bash

sudo rm -rf debian/
sudo rm -rf ubuntu/

# remove n if update jail is needed
sudo bash run_in_jail.sh -dn
sudo bash run_in_jail.sh -un

rm -rf repo/

bash create_repository.sh -d 
bash create_repository.sh -u
