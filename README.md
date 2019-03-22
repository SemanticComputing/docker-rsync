# rsync

A container for rsync:ing stuff

# Environment

These environment variables can be used to configure the container
```
DEBUG=
SSH_PRIVATE_KEY_FILE=/secrets/id_rsa
SSH_PRIVATE_KEY=<private key here> # Prioritized over SSH_PRIVATE_KEY_FILE if set
SSH_KNOWN_HOSTS_FILE=/config/know_hosts
SSH_KNOWN_HOSTS=<known_hosts contents here> # Prioritize dover SSH_KNOWN_HOSTS_FILE if set
RSYNC_SOURCE=/m/source/
RSYNC_TARGET=/m/target/
RSYNC_OPTIONS=-avz
```

`SSH_PRIVATE_KEY_FILE` should contain path to the private key to be used for accessing any remote hosts. Alternatively the key can be directly given in the `SSH_PRIVATE_KEY`. `SSH_PRIVATE_KEY` will be prioritized if both are set.

`SSH_KNOWN_HOSTS_FILE` should contain the public keys for the ssh hosts that will be accessed. Format is whatever will be accepted as UserKnownHostsFile in ssh_config. Alternatively the contents of the file can be given in `SSH_KNOWN_HOSTS`. `SSH_KNOWN_HOSTS will be prioritized if both are set`

`RSYNC_SOURCE` and `RSYNC_TARGET` will be fed to rsync as is. They can be either local (e.g. /path/to/file) or remote (e.g. user@examplehost.com:/path/to/file) or whatever rsync normally accepts.

`RSYNC_OPTIONS` can be used to define extra options for rsync. Do not override the ssh command ('-e' -flag). Anything that would need the ssh command to be customized (e.g. different ssh port) are not well supported at the moment.

# OpenShift

Make sure you have have the OpenShift CLI tools installed and that you are logged in

```
oc login
```

## Setup ImageStream in OpenShift

Before using the rsync image, we need to import it from dockerhub to the OpenShift internal registry

Import the image:
```
oc import-image rsync:latest --from=docker.io/secoresearch/rsync:latest --confirm --scheduled true
```

Set the lookup policy for the imagestream. This makes it so that Kubernetes Resources (e.g. ubilds, Jobs) can refernece the imagestream directly.
```
oc set image-lookup rsync
```

If you wish, you can replace the imagestream name 'rsync' with something else.

## Scheduled Rsync

In the openshift/ folder, there is a template that can be used to schedule rsync of a folder/file between a volume and a remote host

First you need to have an OpenShift secret containing the private ssh key used to access the remote host. If you don't have one, create one e.g.

```
oc create secret generic <secret-name> --from-file=ssh-privatekey=<path/to/ssh/privatekey> --type=kubernetes.io/ssh-auth
```

To create an rsync CronJob using the template:

```
oc process -f 'template-rsync-cronjob.yaml' --param-file <template-parameters-file> | oc create -f -
```

or

```
oc process -f 'template-rsync-cronjob.yaml' -p CRONJOB_NAME=example-rsync -p ... | oc create -f -
```

See `rsync-cronjob-example.params` for an example parameters file.
