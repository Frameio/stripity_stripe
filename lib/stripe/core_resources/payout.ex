defmodule StripeFork.Payout do
  @moduledoc """
  Work with Stripe payouts.

  Stripe API reference: https://stripe.com/docs/api#payouts
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          arrival_date: StripeFork.timestamp(),
          automatic: boolean,
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t() | nil,
          created: StripeFork.timestamp(),
          currency: String.t(),
          deleted: boolean | nil,
          description: String.t() | nil,
          destination: StripeFork.id() | StripeFork.Card.t() | StripeFork.BankAccount.t() | String.t() | nil,
          failure_balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t() | nil,
          failure_code: String.t() | nil,
          failure_message: String.t() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          method: String.t(),
          source_type: String.t(),
          statement_descriptor: String.t() | nil,
          status: String.t(),
          type: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :arrival_date,
    :automatic,
    :balance_transaction,
    :created,
    :currency,
    :deleted,
    :description,
    :destination,
    :failure_balance_transaction,
    :failure_code,
    :failure_message,
    :livemode,
    :metadata,
    :method,
    :source_type,
    :statement_descriptor,
    :status,
    :type
  ]

  @plural_endpoint "payouts"

  @doc """
  Create a payout.

  If your API key is in test mode, the supplied payment source (e.g., card) won't actually be
  payoutd, though everything else will occur as if in live mode.
  (Stripe assumes that the payout would have completed successfully).

  See the [Stripe docs](https://stripe.com/docs/api#create_payout).
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :amount => pos_integer,
               :currency => String.t(),
               optional(:description) => String.t(),
               optional(:destination) => StripeFork.id() | StripeFork.Card.t() | StripeFork.BankAccount.t() | String.t(),
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:method) => String.t(),
               optional(:source_type) => String.t(),
               optional(:statement_descriptor) => String.t()
             } | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a payout.

  See the [Stripe docs](https://stripe.com/docs/api#retrieve_payout).
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a payout.

  Updates the specified payout by setting the values of the parameters passed. Any parameters
  not provided will be left unchanged.

  This request accepts only the `:payout` or `:metadata`.

  The payout to be updated may either be passed in as a struct or an ID.

  See the [Stripe docs](https://stripe.com/docs/api#update_payout).
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
  List all payouts.

  Returns a list of payouts. The payouts are returned in sorted order,
  with the most recent payouts appearing first.

  See the [Stripe docs](https://stripe.com/docs/api#list_payouts).
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:arrival_date) => StripeFork.date_query(),
               optional(:created) => StripeFork.date_query(),
               optional(:destination) => String.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id(),
               optional(:status) => String.t()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Cancel a payout.

  See the [Stripe docs](https://stripe.com/docs/api#cancel_payout).
  """
  @spec cancel(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def cancel(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}" <> "/cancel")
    |> put_method(:post)
    |> make_request()
  end
end
