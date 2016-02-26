# Docker Magento 2

This project aims to help Magento 2 developers.

## Prerequisite

### Software

1. [Docker](https://www.docker.com)
2. [Docker Composer](https://docs.docker.com/compose/install)
3. [Vim](http://www.vim.org)

### Authentication and authorization

1. [GitHub Personal Access Token](https://github.com/settings/tokens/new?scopes=repo&description=Composer)
2. [Magento Connect](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html)

### Setup

Add credentials generated at the steps before by running

```console
make setup
```

### Clone

Clone Magento 2 repository locally

```console
make clone
```

### Build and run

```console
make
```

### Magento install

Only need for the first time install

```console
make magento-install
```

### Other

Take a look at [Makefile](https://github.com/daime/docker-magento2/blob/master/Makefile) for other common tasks.
