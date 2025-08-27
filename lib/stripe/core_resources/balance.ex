defmodule StripeFork.Balance do
  @moduledoc """
  Work with [Stripe `balance` objects](https://stripe.com/docs/api#balance).

  You can:
  - [Retrieve the current balance](https://stripe.com/docs/api#retrieve_balance)
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type funds :: %{
          currency: String.t(),
          amount: integer,
          source_types: %{
            StripeFork.Source.source_type() => integer
          }
        }

  @type t :: %__MODULE__{
          object: String.t(),
          available: list(funds),
          connect_reserved: list(funds) | nil,
          livemode: boolean,
          pending: list(funds)
        }

  defstruct [
    :object,
    :available,
    :connect_reserved,
    :livemode,
    :pending
  ]

  @endpoint "balance"

  @doc """
  Retrieves the current account balance.

  This is based on the authentication that was used to make the request.

  See the [Stripe docs](https://stripe.com/docs/api#retrieve_balance).
  """
  @spec retrieve(StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint)
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Retrieves a balance transaction

  See the [Stripe docs](https://stripe.com/docs/api#balance_transaction_retrieve).
  """
  @spec retrieve_transaction(String.t(), StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve_transaction(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/history/" <> id)
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List balance history

  See the [Stripe docs](https://stripe.com/docs/api#balance_history).
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:available_on) => StripeFork.date_query(),
               optional(:created) => StripeFork.date_query(),
               optional(:currency) => String.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:payout) => String.t(),
               optional(:source) => %{
                 optional(:object) => String.t()
               },
               optional(:starting_after) => t | StripeFork.id(),
               optional(:type) => String.t()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@endpoint <> "/history")
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:available_on, :created, :ending_before, :starting_after])
    |> make_request()
  end
end
