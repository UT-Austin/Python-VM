Python-VM
=========

Virtual Machine for Python Development


Setup
-----
After you install Vagrant:

```bash
git clone git://github.com/UT-Austin/Python-VM.git
cd Python-VM/
vagrant box add base http://files.vagrantup.com/lucid32.box
vagrant up
vagrant ssh
cd /home/trecs/pype/
source activate-26.3.4-rc2
```
