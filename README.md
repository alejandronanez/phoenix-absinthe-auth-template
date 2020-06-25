# Phoenix Absinthe Auth Template

This is a base template for starting out a Phoenix project with Absinthe, plus authentication.

## About this project

This is a template that's meant to be used as a starting point for your next Phoenix project, it's a GraphQL API that let you create/login/logout users and also has a `tokenRefresh` mutation. It also has a `docker-compose.yml` file so you don't have to worry about installing `Postgres` locally.

I wouldn't consider this to be production ready because I'm not an expert in Elixir/Phoenix so this template might have some bad patterns and a bunch things that can be improved. That said, if you want to improve this project, feel free to open an issue or pull request.

## Why is it called Ticketo?

There's no real reason for this, I had to pick a name for the project and that was the first thing that came to my mind

## Versions

```
Phoenix: 1.4.16
Absinthe: 1.4.0
Guardian: 2.0
```

## How to run this

- For convenience, this project contains a `docker-compose.yml` files that spins up a `Postgres` database so you don't have to deal with local installations of `Postgres`. If you want to change the credentials, or use any other DB feel free to update `docker-compose.yml` or completely ignore it.
- `mix ecto.setup` Will setup the databse, run the necessary migrations and will seed the database with initial data
- `mix phx.server` will start the Phoenix server in `localhost:4000`
- Open `localhost:4000/graphiql` to visit project's GraphiQL

## Available queries/mutations

### Queries

- Me (current user)

![](https://cdn.zappy.app/1ec94aae61c20f65840fa5314d9da3f8.png)

### Mutations

- Create an user
- Login
- Logout
- Refresh Token

![](https://cdn.zappy.app/34f6fdeaec1ceb238d33a871bb780be0.png)
