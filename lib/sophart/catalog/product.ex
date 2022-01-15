defmodule Sophart.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :image, :string
    field :name, :string
    field :price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :image])
    |> validate_required([:name, :description, :price])
    |> validate_number(:price, greater_than: 0)
  end
end
