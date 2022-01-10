defmodule LiveuploadWeb.ProductLive.FormComponent do
  use LiveuploadWeb, :live_component

  alias Liveupload.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:upload,
       accept: ~w(image/*),
       max_entries: 1
     )}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :upload, ref)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :upload, fn %{path: path}, _entry ->
        dest = Path.join("priv/static/uploads", Path.basename(path))
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
      end)

    params =
      case uploaded_files do
        [] -> product_params
        [image] -> Map.put(product_params, "image", image)
      end

    # params =
    #   case consume_uploaded_entries(socket, :upload, &copy_to_destination!/2) do
    #     [] ->
    #       product_params

    #     [image] ->
    #       Map.put(product_params, "image", image)
    #   end

    save_product(
      socket,
      socket.assigns.action,
      params
    )
  end

  defp copy_to_destination!(%{path: path}, entry) do
    filename =
      case entry.client_type do
        "image/png" ->
          "#{entry.uuid}.png"

        "image/jpeg" ->
          "#{entry.uuid}.jpg"
      end

    dest = Path.join([Application.app_dir(:liveupload, "priv"), "static", "uploads", filename])
    File.cp!(path, dest)
    "/uploads/#{filename}"
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: Routes.product_show_path(socket, :show, product))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
