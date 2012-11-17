# Python-VM #

Virtual Machine for Python Development


## Setup ##

After you install [Vagrant][]:

### Linux ###
```bash
git clone git://github.com/UT-Austin/Python-VM.git
cd Python-VM/
vagrant up
vagrant ssh
```

### Windows ###
Open a command prompt (type `cmd` at the run or find dialog in the Windows
start menu)

Run the following commands:
```cmd
git clone git://github.com/UT-Austin/Python-VM.git
cd Python-VM
vagrant up
```

Windows does not support `vagrant ssh`, so now you will need to use
an external SSH client to access the VM.

1.  Download and install [PuTTY][]
1.  The SSH key that Vagrant provides needs to be converted in order to work
    with PuTTY, so run `C:\Program Files (x86)\PuTTY\puttygen.exe`
1.  Now click `Load`, and navigate to the `.vagrant.d` directory in your home
    directory.
1.  Change the file type dropdown next to `File name`, so that it lists All
    Files.
1.  Select `insecure_private_key`
1.  Now click `Save private key`. Click `Yes` when it complains about not having
    a password (this doesn't matter since it is just for use with the VM).
1.  Save the file with a `.ppk` suffix, and remember where you save it.
1.  Now you can run PuTTY and set up a new profile to connect to your Vagrant
    box. Set the following settings:
    *   In `Session`
        *   set `Host Name (or IP address)` to `localhost`
        *   set `Port` to `2222`
    *   In `Connection` -> `Data`
        *   set `Auto-login username` to `vagrant`
    *   In `Connection` -> `SSH` -> `Auth`
        *   set `Private key file for authentication:` to the location of the
            the `.ppk` file you created earlier
    *   (Optional) Back in `Session`
        *   Type a name like `PyPE Vagrant` in the `Saved Sessions` input
            and click `Save`. This will allow you to avoid having to do the
            other steps every time.
    *   Click `Open`, ignore a scary security warning if it shows up, and you
        should now be sitting at a command line inside your VM.

### How do I customize this thing? ###
TODO: explain `custom.csv`



[Vagrant]: http://vagrantup.com
[PuTTY]: http://www.chiark.greenend.org.uk/~sgtatham/putty/
