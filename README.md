# plume-pg-app-century
Migrating Plume app from PG to YB with Voyager

## Tech & versions used
- Postgres docker image ```postgres:10.5```
- YugabyteDB docker image ```yugabytedb/yugabyte:2.23.0.0-b710```
- Yugabyte Voygaer docker image ```yugabytedb/yb-voyager:1.8.2-rc2```

## 1. Run Plume on YB

Follow steps mentioned in [yb/steps.md](yb/steps.md)

## 2. Run Plume on PG

Follow steps mentioned in [pg/steps.md](pg/steps.md)

## 3. Migrate app from PG to YB using yb-voyager

Follow steps mentioned in [migrate/steps.md](migrate/steps.md)
