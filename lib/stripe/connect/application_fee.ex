defmodule StripeFork.ApplicationFee do
  @moduledoc """
  Work with Stripe Connect application fees.

  Stripe API reference: https://stripe.com/docs/api#application_fees
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          account: StripeFork.id() | StripeFork.Account.t(),
          amount: integer,
          amount_refunded: integer,
          application: StripeFork.id(),
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t(),
          charge: StripeFork.id() | StripeFork.Charge.t(),
          created: StripeFork.timestamp(),
          currency: String.t(),
          livemode: boolean,
          originating_transaction: StripeFork.id() | StripeFork.Charge.t(),
          refunded: boolean,
          refunds: StripeFork.List.t(StripeFork.FeeRefund.t())
        }

  defstruct [
    :id,
    :object,
    :account,
    :amount,
    :amount_refunded,
    :application,
    :balance_transaction,
    :charge,
    :created,
    :currency,
    :livemode,
    :originating_transaction,
    :refunded,
    :refunds
  ]

  @endpoint "application_fees"

  @doc """
  Retrieves the details of the application fees
  """
  @spec retrieve(StripeFork.id()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id) do
    new_request()
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all application fees
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:charge) => StripeFork.id(),
               optional(:created) => StripeFork.date_query(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
