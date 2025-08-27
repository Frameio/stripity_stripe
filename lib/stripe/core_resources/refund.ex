defmodule StripeFork.Refund do
  @moduledoc """
  Work with [Stripe `refund` objects](https://stripe.com/docs/api#refund_object).

  You can:
  - [Create a refund](https://stripe.com/docs/api#create_refund)
  - [Retrieve a refund](https://stripe.com/docs/api#retrieve_refund)
  - [Update a refund](https://stripe.com/docs/api#update_refund)
  - [List all refunds](https://stripe.com/docs/api#list_refunds)
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: non_neg_integer,
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t() | nil,
          charge: StripeFork.id() | StripeFork.Charge.t() | nil,
          created: StripeFork.timestamp(),
          currency: String.t(),
          failure_balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t() | nil,
          failure_reason: String.t() | nil,
          metadata: StripeFork.Types.metadata(),
          payment: StripeFork.id() | StripeFork.Charge.t() | nil,
          reason: String.t() | nil,
          receipt_number: String.t() | nil,
          status: String.t() | nil
        }

  defstruct [
    :id,
    :object,
    :amount,
    :balance_transaction,
    :charge,
    :created,
    :currency,
    :failure_balance_transaction,
    :failure_reason,
    :metadata,
    :payment,
    :reason,
    :receipt_number,
    :status
  ]

  @plural_endpoint "refunds"

  @doc """
  Create a refund.

  When you create a new refund, you must specify a charge to create it on.

  Creating a new refund will refund a charge that has previously been created
  but not yet refunded. Funds will be refunded to the credit or debit card
  that was originally charged.

  You can optionally refund only part of a charge. You can do so as many times
  as you wish until the entire charge has been refunded.

  Once entirely refunded, a charge can't be refunded again. This method will
  return an error when called on an already-refunded charge, or when trying to
  refund more money than is left on a charge.

  See the [Stripe docs](https://stripe.com/docs/api#create_refund).
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :charge => StripeFork.Charge.t() | StripeFork.id(),
               optional(:amount) => pos_integer,
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:reason) => String.t(),
               optional(:refund_application_fee) => boolean,
               optional(:reverse_transfer) => boolean
             } | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:charge])
    |> make_request()
  end

  @doc """
  Retrieve a refund.

  Retrieves the details of an existing refund.

  See the [Stripe docs](https://stripe.com/docs/api#retrieve_refund).
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a refund.

  Updates the specified refund by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.

  This request only accepts `:metadata` as an argument.

  See the [Stripe docs](https://stripe.com/docs/api#update_refund).
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:metadata) => StripeFork.Types.metadata()
             } | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all refunds.

  Returns a list of all refunds you’ve previously created. The refunds are
  returned in sorted order, with the most recent refunds appearing first. For
  convenience, the 10 most recent refunds are always available by default on
  the charge object.

  See the [Stripe docs](https://stripe.com/docs/api#list_refunds).
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:charget) => StripeFork.id() | StripeFork.Charge.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:charge, :ending_before, :starting_after])
    |> make_request()
  end
end
