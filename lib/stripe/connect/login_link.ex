defmodule StripeFork.LoginLink do
  @moduledoc """

  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          object: String.t(),
          created: StripeFork.timestamp(),
          url: String.t()
        }

  defstruct [
    :object,
    :created,
    :url
  ]

  @spec create(StripeFork.id() | StripeFork.Account.t(), map, StripeFork.options()) ::
          {:ok, t} | {:error, StripeFork.Error.t()}
  def create(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint("accounts/#{get_id!(id)}/login_links")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end
end
