defmodule StripeFork.Transfer do
  @moduledoc """
  Work with Stripe transfer objects.

  Stripe API reference: https://stripe.com/docs/api#transfers
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          amount_reversed: integer,
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t(),
          created: StripeFork.timestamp(),
          currency: String.t(),
          description: String.t(),
          destination: StripeFork.id() | StripeFork.Account.t(),
          destination_payment: String.t(),
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          reversals: StripeFork.List.t(StripeFork.TransferReversal.t()),
          reversed: boolean,
          source_transaction: StripeFork.id() | StripeFork.Charge.t(),
          source_type: String.t(),
          transfer_group: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :amount_reversed,
    :balance_transaction,
    :created,
    :currency,
    :description,
    :destination,
    :destination_payment,
    :livemode,
    :metadata,
    :reversals,
    :reversed,
    :source_transaction,
    :source_type,
    :transfer_group
  ]

  @plural_endpoint "transfers"

  @doc """
  Create a transfer.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :amount => pos_integer,
               :currency => String.t(),
               :destination => StripeFork.id() | StripeFork.Account.t(),
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:source_transaction) => StripeFork.id() | StripeFork.Charge.t(),
               optional(:transfer_group) => String.t()
             }
  def create(%{amount: _, currency: _, destination: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :customer, :source])
    |> make_request()
  end

  @doc """
  Retrieve a transfer.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a transfer.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:description) => String.t(),
               optional(:metadata) => StripeFork.Types.metadata()
             }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:coupon, :source])
    |> make_request()
  end

  @doc """
  List all transfers.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:created) => StripeFork.date_query(),
               optional(:destination) => StripeFork.id() | StripeFork.Account.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id(),
               optional(:transfer_group) => String.t()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :plan, :starting_after])
    |> make_request()
  end
end
