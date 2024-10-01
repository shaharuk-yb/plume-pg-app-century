## Run it on postgres

- start docker daemon

- generate random secret key 
```sh 
openssl rand -base64 32
```

- And put it in the .env file
```sh 
ROCKET_SECRET_KEY=XnIj3tzQE8KNfnoDRmgTKX5zXOZo93eKgB3D5ltSWtw=
```

- run cleanup script to create clean dir structure
```sh
./clean-start.sh
```

- start the yugabyte docker container only
```sh
docker-compose up -d postgres
```


- run migration in throaway plum instance
```sh
docker-compose run --rm plume plm migration run
```

- run search init 
```sh
docker-compose run --rm plume plm search init
```

- create new local instance
```sh
docker-compose run --rm plume plm instance new -d 'localhost:7878' -n 'sshaikh-blog'
```

- create the admin users
```sh
docker-compose run --rm plume plm users new -n 'sshaikh' -N 'shahrukh' -b 'bio' -e 'sshaikh@localhost.com' -p 'pass123' --admin
```

- start Plume docker service
```sh
docker-compose up -d plume
```

- Plume is accessible at http://localhost:7878/


- take down the services/app
```sh
docker-compose down
```
