defmodule Ticketo.Repo.Migrations.AddRefreshTokenToAccounts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :refresh_token, :text
    end
  end
end
