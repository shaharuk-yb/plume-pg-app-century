
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

## Migrating to yugabyte

- install yb-voyager using docker 
```sh
docker pull yugabytedb/yb-voyager:1.8.2-rc2
wget -O ./yb-voyager https://raw.githubusercontent.com/yugabyte/yb-voyager/main/docker/yb-voyager-docker && chmod +x ./yb-voyager && sudo mv yb-voyager /usr/local/bin/yb-voyager

yb-voyager version
```

- start yugabytedb service
```sh
docker-compose up -d yugabyte
```

- create plume db, ybvoyager user with appropriate permissions in yugabytedb database(target)
```sql
create database plume with colocation=true;
CREATE USER ybvoyager SUPERUSER PASSWORD 'password';


CREATE USER ybvoyager PASSWORD 'password';
GRANT yb_superuser TO ybvoyager;

```

## Migrations steps

- create assessment directory and run assessment
```sh
mkdir assess-dir

yb-voyager assess-migration --source-db-host localhost --source-db-port 5432 --source-db-type postgresql --source-db-user plume --source-db-name plume --source-db-password passw0rd --source-db-schema "public" --send-diagnostics false --export-dir assess-dir
```

- export schema
```sh
yb-voyager export schema --export-dir assess-dir --source-db-host localhost --source-db-port 5432 --source-db-type postgresql --source-db-user plume --source-db-name plume --source-db-password passw0rd --source-db-schema "public" --send-diagnostics false
```

- analyze-schema
```sh
yb-voyager analyze-schema --export-dir assess-dir --send-diagnostics false
```

- export data
```sh
yb-voyager export data --export-dir assess-dir --source-db-host localhost --source-db-port 5432 --source-db-type postgresql --source-db-user plume --source-db-name plume --source-db-password passw0rd --source-db-schema "public" --send-diagnostics false
```

- export data status
```sh
yb-voyager export data status --export-dir assess-dir
```

- import schema
```sh
yb-voyager import schema --export-dir assess-dir --target-db-host localhost --target-db-user ybvoyager --target-db-password password --target-db-name plume 
```

- import data
```sh
yb-voyager import data --export-dir assess-dir --target-db-host localhost --target-db-user ybvoyager --target-db-password password --target-db-name plume 
```

- import data status
```sh
yb-voyager import data status --export-dir assess-dir
```

- end migration
```sh
yb-voyager end migration --export-dir assess-dir --backup-log-files true --backup-data-files true --backup-schema-files true --save-migration-reports true --backup-dir backup-dir/
```


## Change the app config to point to Yugabyte databse 

- remove following contents from the .env file
```sh
# DATABASE SETUP
POSTGRES_PASSWORD=passw0rd
POSTGRES_USER=plume
POSTGRES_DB=plume

# you can safely leave those defaults
DATABASE_URL=postgres://plume:passw0rd@postgres:5432/plume
MIGRATION_DIRECTORY=migrations/postgres
```

- add following content to the .env file

```sh
DATABASE_URL=postgres://ybvoyager:password@yugabyte:5433/plume
MIGRATION_DIRECTORY=migrations/yugabyte
```


- restart the app

```sh
docker-compose down
docker-compose up -d
```


### Congratulations! You have successfully migrated Plume from PG to YB
