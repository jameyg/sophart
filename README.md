# Sophart

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

----

- use SQLite
- allow exporting of your entire site as static files where the cart/checkout is replaced with buy buttons (possible?)
- allow hosting the site yourself maybe? open source
- 

-----

binary IDs
add /priv/static/uploads/ to the .gitignore
don't require the "image" model attribute
validate the number of price > 0
in the form component update() method add:
    |> allow_upload(:upload,
       accept: ~w(image/*),
       max_entries: 1
    )}

add this to the form component:
    @impl true
    def handle_event("cancel-upload", %{"ref" => ref}, socket) do
        {:noreply, cancel_upload(socket, :upload, ref)}
    end

--

config.exs:

  config :sophart,
    ecto_repos: [Sophart.Repo],
    generators: [binary_id: true]

create table(:products, primary_key: false) do
  add :id, :binary_id, primary_key: true

above the schema "products" add:
    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id

this method:
    defp save_product(socket, :edit, product_params) do
had this at the end originally from the generator:
    |> push_redirect(to: socket.assigns.return_to)}

<%= if @live_action in [:new, :edit] do %>
  <.modal return_to={Routes.product_index_path(@socket, :index)}>
    <.live_component
      module={SophartWeb.ProductLive.FormComponent}
      id={@product.id || :new}
      title={@page_title}
      action={@live_action}
      product={@product}
      return_to={Routes.product_index_path(@socket, :index)}
    />
  </.modal>
<% end %>