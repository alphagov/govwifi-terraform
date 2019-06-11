# Automation with Secrets

## dependencies

When setting up a Concourse Pipeline, ensure these tools are in your runner:

- pass (<https://www.passwordstore.org/>)
- gpg

## GPG

A GPG key has been generated for automated tools to decrypt the secrets.
It is currently stored in `.private/passwords/keys/jenkins-gpg-key`.

In the event of the key expiring, generate a new key, and update in the passwords store.

**note**: the key is set to expire in January 2021.
