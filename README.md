# README

Original project : [A Table from Julien Varlet](https://github.com/juvarlet/a_table)  

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Create container and upload to Docker Hub

1. `docker build . -t a-table:3`
2. `docker tag a-table:3 cybberbobby/a-table`
3. `docker push cybberbobby/a-table`

# Deploy A Taaable

## First Ever Deploy on Raspberry Pi server

1. ssh server
2. Pull latest docker image from docker hub <br>`docker pull cybberbobby/a-table(:latest)`
3. Create network to allow the app and db containers to communicate (if not present already) <br>`docker create network a_table_network`
4. Create volume to store the images (if not present already) <br>`docker volume create a_table_images`
5. Pull and run official postgres container (if not present already) <br>
`docker run -p 5432:5432 --name a-table-postgres -e POSTGRES_PASSWORD=atablepassword -d postgres`
`docker run --network a_table_network --name a-table-postgres -e POSTGRES_PASSWORD=atablepassword -d postgres`
6. Remove old app container (if already present) <br>`docker stop a-table && docker rm a-table`
7. Mount, start container and make it available on port 3000 <br>`docker run -d -p 3000:3000 --network a_table_network --name a-table -v a_table_images:/app/public/images cybberbobby/a-table`

## Setup DB for the first time

After the container is up and running 
1. `docker exec -it a-table bash`
2. `rails db:create`
3. `rails db:migrate`

## Update A Taaable's container

1. ssh server
2. Remove old app container <br>`docker stop a-table && docker rm a-table`
3. Pull latest docker image from docker hub <br>`docker pull cybberbobby/a-table(:latest)`
4. Mount, start container and make it available on port 3000 <br>`docker run -d -p 3000:3000 --network a_table_network --name a-table -v a_table_images:/app/public/images cybberbobby/a-table`

## Useful commands

- `docker ps` see running containers
- `docker ps -a` see all containers
- `docker rm CONTAINER_NAME` remove container
- `docker start CONTAINERT_NAME` start container
- `docker stop CONTAINER_NAME` stop container
- `docker image prune` delete all dangling images
