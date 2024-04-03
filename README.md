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


# Create container and upload to Docker Hub

1. `docker build . -t a-table:3`
2. `docker tag a-table:3 cybberbobby/a-table`
3. `docker push cybberbobby/a-table`

# Deploy on Raspberry Pi server

1. ssh server
2. Pull latest docker image from docker hub : 
`docker pull cybberbobby/a-table(:latest)`
3. Create network to allow the app and db containers to communicate `docker create network a_table_network`
4. Pull and run official postgres container
`docker run -p 5432:5432 --name a-table-postgres -e POSTGRES_PASSWORD=atablepassword -d postgres`
`docker run --network a_table_network --name a-table-postgres -e POSTGRES_PASSWORD=atablepassword -d postgres`
5. Mount and start container and make it available on port 3000
`docker run -d -p 3000:3000 --name a-table cybberbobby/a-table`

`docker run -d -p 3000:3000 --network a_table_network --name a-table cybberbobby/a-table`

# Setup DB for the first time

After the container is up and running 
1. `docker exec -it a-table bash`
2. `rails db:create`
3. `rails db:migrate`

# Useful commands

- `docker ps` see running containers
- `docker ps -a` see all containers
- `docker rm CONTAINER_NAME` remove container
- `docker start CONTAINERT_NAME` start container
- `docker stop CONTAINER_NAME` stop container
- `docker image prune` delete all dangling images
