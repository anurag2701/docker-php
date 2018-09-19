# Leadspeed API
APIs for Leadspeed webapp. Based on the Laravel framework.

## System Requirements
- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

# Available Services

This will install the following services on your machine:

| Service | Hostname | Local Port (Machine) | Internal Port (Container) |
| ------------- |-------------| -----:| -----:|
| App       | http://leadspeed.local | 8080 | 80 |
| MySQL     | http://localhost | 3306 | 3306 |


# Installation
1. [Modify /etc/hosts/ File](#modify-etchosts-file)
2. [Clone Repositories](#clone-repositories)
3. [Copy Environment Files](#copy-environment-files)
4. [Get The Latest MySQL Dump](#get-the-latest-mysql-dump)
5. [Run Command](#run-command)
6. [Helpful Commands](#helpful-commands)
7. [Troubleshooting](#troubleshooting)

## Modify /etc/hosts File
To open *hosts* file
```sh
sudo vi /etc/hosts
```

In order to support multiple applications running on the same port (:80) you must add the following to your hosts file:

```
127.0.0.1       leadspeed.local
127.0.0.1       mysqldb
```
## Clone Repositories

To install, first clone the repository (passing the second arguement to `clone` will place the repo is a new folder with that name):
```bash
git clone https://github.com/johnhowardfl/leadspeed-backend.git
```
## Copy Environment Files

Copy the environment file using 
```sh
cp .env.example .env
```
## Get The Latest MySQL Dump

1. Download and extract a recent database dump of MySQL database (Ask Backend developer for the dump files).
2. Unzip the `.tar.gz` file into the `storage` folder of your PHP project in a directory named `storage/mongodb-restore` (e.g. `tar -xf leadspeed*.tar.gz -C ~/Projects/leadspeed-backend/storage/`)
3. Rename the extracted file to `leadspeed.sql`. Make sure path for the sql file should be `leadspeed-backend/storage/storage/leadspeed.sql`.

## Run Command

To make setup easier, there is a `Makefile` in the project to automate the setup of the application.

> Note: All of our images run on a specific local network so they can communicate properly. For the first initial setup, you must run `make network` which will establish the `leadspeed-dev` network on your machine.

To get started, run the following command in the project root:

```bash
make up
```
This will run the following steps:

1. Install composer dependencies. (in case of vendor folder is not created, run `make composer`)
2. Build docker containers for (mysql, apache php, and a proxy).

That's it!
You should be able to see the PHP-Laravel application at http://leadspeed.local

# Reference

## Helpful Commands

To make things a little easier, there is a Makefile that allows you to speed up your local commands:


* `make stop` will shutdown the docker containers
* `make up` will start the containers, at the beginning of your work day
* `make composer` will install composer dependencies for the api
* `make cache-clear` clears the cache on the local api
* `make network` creates network for the containers to communicate
* `make permissions` sets proper permissions on the storage directory
* `make services` to see the status of running containers
* `make cache-folder` to create required cache folders, if not created
* `make database-restore` to restore the database dump file _leadspeed.sql_ located in 'storage/storage' folder. 

## SSH into a Container
1. Use `docker ps` to get the name of the existing container
2. Use the command `docker exec -it <container name> /bin/bash` to get a bash shell in the container

## Troubleshooting

### Unable to access leadspeed.local
If you are unable to view http://leadspeed.local on your machine, try visiting http://localhost:8080/. If you specify the port and it is working there is most likely an issue with the `proxy` service/container. Run the following command to view each containers status:

```bash
make services
```
Each service should be in the `up` state. If the proxy service is in any other state, you might need to ensure that the platform container is running as well.

to run it again, run `make up`

### Error response from daemon: network with name leadspeed-dev already exists
If you are trying to make the network using the Makefile and the above error message is displayed, the network has already been created. You can manually remove the network or prune your docker system to correct it.

### Updated environment variables are not being recognized
If you are adding new envrionment variables to the application and they are not display, you may need to run `make up` to recreate the service.

### ERROR: Network leadspeed-dev declared as external, but could not be found. 
Please create the network manually using `docker network create leadspeed-dev` and try again.
In order to communicate between all of the services, Docker will need an "external" network to communicate. This error means that the network needs to be created (only once per machine). Run the following command to make the network:

```bash
make network
```

### Unable To Run Makefile In Windows Machine
Open `Makefile` present in the project root and copy the defined commands and run it command prompt.

### Bind for 0.0.0.0:3306 failed: port is already allocated
Perhaps mysql is running on 3306 port already. You have to stop the services in order to leadspeed mysql service to be run.
`sudo service mysql stop`

## Official laravel/Docker Documentation
Documentation for the framework can be found on the [Laravel website](http://laravel.com/docs).
Documentation for the docker can be found on the [Docker website](https://docs.docker.com/)
