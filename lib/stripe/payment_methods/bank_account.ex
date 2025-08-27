defmodule StripeFork.BankAccount do
  @moduledoc """
  Work with Stripe bank account objects.

  Stripe API reference: https://stripe.com/docs/api#bank_accounts
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          account: StripeFork.id() | StripeFork.Account.t() | nil,
          account_holder_name: String.t() | nil,
          account_holder_type: String.t() | nil,
          bank_name: String.t() | nil,
          country: String.t(),
          currency: String.t(),
          customer: StripeFork.id() | StripeFork.Customer.t() | nil,
          default_for_currency: boolean | nil,
          deleted: boolean | nil,
          fingerprint: String.t() | nil,
          last4: String.t(),
          metadata: StripeFork.Types.metadata() | nil,
          routing_number: String.t() | nil,
          status: String.t()
        }

  defstruct [
    :id,
    :object,
    :account,
    :account_holder_name,
    :account_holder_type,
    :bank_name,
    :country,
    :currency,
    :customer,
    :default_for_currency,
    :deleted,
    :fingerprint,
    :last4,
    :metadata,
    :routing_number,
    :status
  ]

  defp plural_endpoint(%{customer: id}) do
    "customers/" <> id <> "/sources"
  end

  @doc """
  Create a bank account.
  """
  @spec create(params, Keyword.t()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :customer => StripeFork.id() | StripeFork.Customer.t(),
              :source => StripeFork.id() | StripeFork.Source.t(),
              optional(:metadata) => StripeFork.Types.metadata()
            }
  def create(%{customer: _, source: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(params |> plural_endpoint())
    |> put_params(params |> Map.delete(:customer))
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a bank account.
  """
  @spec retrieve(StripeFork.id() | t, map, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, %{customer: _} = params, opts \\ []) do
    endpoint = params |> plural_endpoint()

    new_request(opts)
    |> put_endpoint(endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a bank account.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :customer => StripeFork.id() | StripeFork.Customer.t(),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:account_holder_name) => String.t(),
              optional(:account_holder_type) => String.t()
            }
  def update(id, %{customer: _} = params, opts \\ []) do
    endpoint = params |> plural_endpoint()

    new_request(opts)
    |> put_endpoint(endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params |> Map.delete(:customer))
    |> make_request()
  end

  @doc """
  Delete a bank account.
  """
  @spec delete(StripeFork.id() | t, map, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, %{customer: _} = params, opts \\ []) do
    endpoint = params |> plural_endpoint()

    new_request(opts)
    |> put_endpoint(endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  Verify a bank account.
  """
  @spec verify(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :customer => StripeFork.id() | StripeFork.Customer.t(),
              optional(:amounts) => list(integer),
              optional(:verification_method) => String.t()
            }
  def verify(id, %{customer: _} = params, opts \\ []) do
    endpoint = params |> plural_endpoint()

    new_request(opts)
    |> put_endpoint(endpoint <> "/#{get_id!(id)}/verify")
    |> put_method(:post)
    |> put_params(params |> Map.delete(:customer))
    |> make_request()
  end

  @doc """
  List all bank accounts.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
              :customer => StripeFork.id() | StripeFork.Customer.t(),
              optional(:ending_before) => t | StripeFork.id(),
              optional(:limit) => 1..100,
              optional(:starting_after) => t | StripeFork.id(),
            }
  def list(%{customer: _} = params, opts \\ []) do
    endpoint = params |> plural_endpoint()
    params = params |> Map.put(:object, "card")

    new_request(opts)
    |> put_endpoint(endpoint)
    |> put_method(:get)
    |> put_params(params |> Map.delete(:customer))
    |> make_request()
  end
end
