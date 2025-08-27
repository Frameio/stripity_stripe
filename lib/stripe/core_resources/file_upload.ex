defmodule StripeFork.FileUpload do
  @moduledoc """
  Work with Stripe file_upload objects.

  You can:

  - Create a file
  - Retrieve a file
  - List all files

  Stripe API reference: https://stripe.com/docs/api#file_uploads
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
    id: StripeFork.id,
    object: String.t,
    created: StripeFork.timestamp,
    filename: String.t | nil,
    purpose: String.t,
    size: integer,
    type: String.t | nil,
    url: String.t | nil
  }

  defstruct [
    :id,
    :object,
    :created,
    :filename,
    :purpose,
    :size,
    :type,
    :url
  ]

  @plural_endpoint "files"

  @doc """
  Create a file according to Stripe's file_upload rules.

  Takes the filepath and the purpose.
  """
  @spec create(map, Keyword.t) :: {:ok, t} | {:error, StripeFork.Error.t}
  def create(%{file: _, purpose: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:post)
    |> put_params(params)
    |> make_file_upload_request()
  end

  @doc """
  Retrieve a file_upload.
  """
  @spec retrieve(StripeFork.id | t, StripeFork.options) :: {:ok, t} | {:error, StripeFork.Error.t}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_file_upload_request()
  end

  @doc """
  List all file uploads, going back up to 30 days.
  """
  @spec list(params, StripeFork.options) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t}
        when params: %{
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:purpose) => String.t(),
               optional(:starting_after) => t | StripeFork.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after, :limit, :purpose])
    |> make_file_upload_request()
  end
end
