# rsync

A container for rsync:ing stuff

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
