defmodule StripeFork.FeeRefund do
  @moduledoc """
  Work with Stripe Connect application fees refund.

  Stripe API reference: https://stripe.com/docs/api#fee_refunds
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t(),
          created: StripeFork.timestamp(),
          currency: String.t(),
          fee: String.t(),
          metadata: StripeFork.Types.metadata()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :balance_transaction,
    :created,
    :currency,
    :fee,
    :metadata
  ]

  @endpoint "application_fees"

  @doc """
  Create a application fee refund
  """
  @spec create(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:amount) => pos_integer,
               optional(:metadata) => StripeFork.Types.metadata()
             }
  def create(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/refunds")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a application fee refund.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, fee_id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/refunds/#{fee_id}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a transfer.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:metadata) => StripeFork.Types.metadata(),
             }
  def update(id, fee_id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/refunds/#{fee_id}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all transfers.
  """
  @spec list(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             }
  def list(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/refunds")
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
