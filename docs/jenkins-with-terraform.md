# Jenkins with Terraform

## dependencies

When setting up a Jenkins instance, ensure these are installed:

- pass (<https://www.passwordstore.org/>)
- gpg
- terraform

## GPG

A GPG key has been generated for Jenkins to decrypt the Terraform secrets.
It is currently stored in `.private/passwords/keys/jenkins-gpg-key`.

In the event of the key expiring, generate a new key, and update in the passwords store.

**note**: the key is set to expire in January 2021.

To apply the key in the Jenkins container, `ssh` to the jenkins server, shell into
the docker container, and import the gpg key.

## AWS Access

Jenkins has been provided an account with total administrative rights.

The credentials have been limited to only being access via the `govwifi-terraform`
job, and should **not** be allowed to spill over to other jobs.
