defmodule StripeFork.Invoiceitem do
  @moduledoc """
  Work with Stripe invoiceitem objects.

  Stripe API reference: https://stripe.com/docs/api#invoiceitems

  Note: this module is named `Invoiceitem` and not `InvoiceItem` on purpose, to
  match the Stripe terminology of `invoiceitem`.
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          currency: String.t(),
          customer: StripeFork.id() | StripeFork.Customer.t(),
          date: StripeFork.timestamp(),
          description: String.t(),
          discountable: boolean,
          invoice: StripeFork.id() | StripeFork.Invoice.t(),
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          period: %{
            start: StripeFork.timestamp(),
            end: StripeFork.timestamp()
          },
          plan: StripeFork.Plan.t() | nil,
          proration: boolean,
          quantity: integer,
          subscription: StripeFork.id() | StripeFork.Subscription.t() | nil,
          subscription_item: StripeFork.id() | StripeFork.SubscriptionItem.t() | nil,
          unit_amount: integer
        }

  defstruct [
    :id,
    :object,
    :amount,
    :currency,
    :customer,
    :date,
    :description,
    :discountable,
    :invoice,
    :livemode,
    :metadata,
    :period,
    :plan,
    :proration,
    :quantity,
    :subscription,
    :subscription_item,
    :unit_amount
  ]

  @plural_endpoint "invoiceitems"

  @doc """
  Create an invoiceitem.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:amount) => integer,
               :currency => String.t(),
               :customer => StripeFork.id() | StripeFork.Customer.t(),
               optional(:description) => String.t(),
               optional(:discountable) => boolean,
               optional(:invoice) => StripeFork.id() | StripeFork.Invoice.t(),
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:quantity) => integer,
               optional(:subscription) => StripeFork.id() | StripeFork.Subscription.t(),
               optional(:unit_amount) => integer
             } | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:subscription])
    |> make_request()
  end

  @doc """
  Retrieve an invoiceitem.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update an invoiceitem.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:amount) => integer,
               optional(:description) => String.t(),
               optional(:discountable) => boolean,
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:quantity) => integer,
               optional(:unit_amount) => integer
             } | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all invoiceitems.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:created) => StripeFork.timestamp(),
               optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:invoice) => StripeFork.id() | StripeFork.Invoice.t(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :starting_after])
    |> make_request()
  end
end
