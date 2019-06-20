# Fashionscape

This repository is to help the maintainer, [Nick Pierson](https://nick.exposed),
deploy to scape.fashion.

## Dependencies

In order to deploy, you will need to reveal the secrets in the repo.
You will need your GPG key.
You will also need to be added as a member of git secret.

### Install GPG

In most linux distros:

```
sudo apt-get install gnupg
```

### Export private gpg key

On whatever machine you have your gpg key:

```
gpg --list-secret-keys # copy id (second column)
gpg --export-secret-keys $ID > private-key.asc
```

### Import private gpg key

On the machine in which you intend to deploy:

```
gpg --import private-key.asc
```

### Reveal secrets

```
git secret reveal
```

## Deploy

Once you have fulfilled all the dependencies, simply run:

```
./scripts/deploy.sh
```

## Test Run

If you want to run Fashionscape locally:

First, make sure you have fulfilled all dependencies, then run:

```
sudo mkdir -p /opt/traefik
sudo ln -s ./acme.json /opt/traefik/acme.json
./scripts/up.sh
```
