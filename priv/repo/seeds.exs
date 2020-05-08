# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ticketo.Repo.insert!(%Ticketo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ticketo.Repo
alias Ticketo.Accounts.User

%User{}
|> User.changeset(%{
  email: "admin@example.com",
  password: "password"
})
|> Repo.insert!()

%User{}
|> User.changeset(%{
  email: "alejandro@example.com",
  password: "password"
})
|> Repo.insert!()

%User{}
|> User.changeset(%{
  email: "angela@example.com",
  password: "password"
})
|> Repo.insert!()
