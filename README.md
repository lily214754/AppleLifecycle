# Apple Tree Life Cycle Portal

The **Apple Tree Life Cycle Portal** hosts the natural life cycle, the orchard life cycle and the annual reproductive cycle. Stage and sub-stage characteristics are structured according to four dimensions. For orchard management operations, the portal integrates links to a list of relevant third-party databases and guidelines. For apple tree research, all references used throughout the life cycle are cited and traceable within the portal for further exploration and validation.

🔗 [https://applelifecycle-3094d65c1fea.herokuapp.com/](https://applelifecycle-3094d65c1fea.herokuapp.com/)


## Run locally

Requires Node and Docker.

```bash
npm install
cp .env.example .env      # already points at the local container
docker compose up -d db   # Postgres 15 on port 55432
npm start                 # http://localhost:3000/tree_lifecycle?env=orchard
```

Or `docker compose up` to run the app in a container too.

## Deploy

Heroku container stack, built from `Dockerfile` via `heroku.yml`, deployed from `main`. Set `DATABASE_URL` and leave `PGSSL` unset. The server binds its port before running the SQL sequence, so a slow rebuild cannot cause a boot timeout.
