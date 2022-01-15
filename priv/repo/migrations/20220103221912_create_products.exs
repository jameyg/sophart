defmodule Sophart.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :price, :float
      add :image, :string

      timestamps()
    end
  end
end
