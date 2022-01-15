defmodule Sophart.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sophart.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "/some-image.jpg",
        name: "some name",
        price: 120.5
      })
      |> Sophart.Catalog.create_product()

    product
  end
end
