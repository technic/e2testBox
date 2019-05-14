# e2testBox
Bunch of scripts to setup virtual machine for testing enigma2 plugins

You may be also interested in the Docker [solution](https://github.com/technic/e2xvfb).

# Usage
Install Vagrant and Virtualbox on your host OS. Then run `vagrant up` and wait for virtual machine to be downloaded, compiled and configured. Afterwards reload vm with `vagrant reload` to apply changes. Now enigma2 can be started via `/opt/disk/usr/bin/enigma2`.
