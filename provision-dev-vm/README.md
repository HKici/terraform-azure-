## Provisioning of a developer vm in azure using teraform.

### Configure VM during provisioning using a local file and the filebase64 function

The filebase64 function reads the content of a file and returns the content in a base64-encoded string, this is what the custom datafield in Azure is excpacting. 

Pass your script as a file on local filesystem:

````
custom_data = filebase64("customdata.tpl")
````

- For Linux VMs your script has to start with shebang #!/bin/sh, otherwise it won’t be processed.

- Your script will be executed as cloud-init, all rules from cloud-init applies.

- After the provosioning of the VM you can review cloud-init logs at 

```
/var/log/cloud-init-output.log.
```

### Create SSH keypair for the VM

```
ssh-keygen -t rsa
```
Name and Save the key in your .ssh folder. For Linux and OSX:

```
~/.ssh/yourKey
```
### Add public key to the vm using the file function

```
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/yourKey.pub")
  }
```

