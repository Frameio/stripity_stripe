defmodule StripeFork.TransferReversal do
  @moduledoc """
  Work with Stripe transfer_reversal objects.

  Stripe API reference: https://stripe.com/docs/api#transfer_reversal_object
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          balance_transaction: String.t() | StripeFork.BalanceTransaction.t(),
          created: StripeFork.timestamp(),
          currency: String.t(),
          description: boolean,
          metadata: StripeFork.Types.metadata(),
          transfer: StripeFork.id() | StripeFork.Transfer.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :balance_transaction,
    :created,
    :currency,
    :description,
    :metadata,
    :transfer
  ]

  @endpoint "transfers"

  @doc """
  Create a transfer reversal
  """
  @spec create(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:amount) => pos_integer,
               optional(:description) => String.t(),
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:refund_application_fee) => boolean
             }
  def create(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/reversals")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a transfer reversal.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, reversal_id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/reversals/#{reversal_id}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a transfer.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:metadata) => StripeFork.Types.metadata()
             }
  def update(id, reversal_id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{id}/reversals/#{reversal_id}")
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
    |> put_endpoint(@endpoint <> "/#{id}/reversals")
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
