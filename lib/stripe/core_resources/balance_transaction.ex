defmodule StripeFork.BalanceTransaction do
  @moduledoc """
  Work with [Stripe `balance_transaction` objects]  (https://stripe.com/docs/api#balance_transaction_object).

  You can:
  - [Retrieve a balance transaction](https://stripe.com/docs/api#balance_transaction_retrieve)
  - [List all balance history](https://stripe.com/docs/api#balance_history)
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          available_on: StripeFork.timestamp(),
          created: StripeFork.timestamp(),
          currency: String.t(),
          description: String.t() | nil,
          exchange_rate: integer | nil,
          fee: integer,
          fee_details: list(StripeFork.Types.fee()) | [],
          net: integer,
          source: StripeFork.id() | StripeFork.Source.t() | nil,
          status: String.t(),
          type: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :available_on,
    :created,
    :currency,
    :description,
    :exchange_rate,
    :fee,
    :fee_details,
    :net,
    :source,
    :status,
    :type
  ]

  @endpoint "balance/history"

  @doc """
  Retrieves the balance transaction with the given ID.

  Requires the ID of the balance transaction to retrieve and takes no other parameters.

  See the [Stripe docs](https://stripe.com/docs/api#balance_transaction_retrieve).
  """
  @spec retrieve(StripeFork.id(), StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Returns a list of transactions that have contributed to the Stripe account balance.

  Examples of such transactions are charges, transfers, and so forth.
  The transactions are returned in sorted order, with the most recent transactions appearing first.

  See `t:StripeFork.BalanceTransaction.All.t/0` or the
  [Stripe docs](https://stripe.com/docs/api#balance_history) for parameter structure.
  """
  @spec all(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:available_on) => String.t() | StripeFork.date_query(),
               optional(:created) => String.t() | StripeFork.date_query(),
               optional(:currency) => String.t(),
               optional(:ending_before) => StripeFork.id() | StripeFork.BalanceTransaction.t(),
               optional(:limit) => 1..100,
               optional(:payout) => StripeFork.id() | StripeFork.Payout.t(),
               optional(:source) => StripeFork.id() | StripeFork.Source.t(),
               optional(:starting_after) => StripeFork.id() | StripeFork.BalanceTransaction.t(),
               optional(:type) => String.t()
             }
  def all(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :payout, :source, :starting_after])
    |> make_request()
  end
end
