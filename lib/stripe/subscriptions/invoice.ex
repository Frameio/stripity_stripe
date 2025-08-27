defmodule StripeFork.Invoice do
  @moduledoc """
  Work with Stripe invoice objects.

  You can:

  - Create an invoice
  - Retrieve an invoice
  - Update an invoice

  Does not take options yet.

  Stripe API reference: https://stripe.com/docs/api#invoice
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount_due: integer,
          amount_paid: integer,
          amount_remaining: integer,
          application_fee: integer | nil,
          attempt_count: non_neg_integer,
          attempted: boolean,
          auto_advance: boolean,
          billing: String.t() | nil,
          billing_reason: String.t() | nil,
          charge: StripeFork.id() | StripeFork.Charge.t() | nil,
          closed: boolean,
          currency: String.t(),
          customer: StripeFork.id() | StripeFork.Customer.t(),
          date: StripeFork.timestamp(),
          default_source: String.t() | nil,
          description: String.t() | nil,
          discount: StripeFork.Discount.t() | nil,
          due_date: StripeFork.timestamp() | nil,
          ending_balance: integer | nil,
          finalized_at: StripeFork.timestamp() | nil,
          forgiven: boolean,
          hosted_invoice_url: String.t() | nil,
          invoice_pdf: String.t() | nil,
          lines: StripeFork.List.t(StripeFork.LineItem.t()),
          livemode: boolean,
          metadata: StripeFork.Types.metadata() | nil,
          next_payment_attempt: StripeFork.timestamp() | nil,
          number: String.t() | nil,
          paid: boolean,
          period_end: StripeFork.timestamp(),
          period_start: StripeFork.timestamp(),
          receipt_number: String.t() | nil,
          starting_balance: integer,
          statement_descriptor: String.t() | nil,
          status: String.t() | nil,
          subscription: StripeFork.id() | StripeFork.Subscription.t() | nil,
          subscription_proration_date: StripeFork.timestamp(),
          subtotal: integer,
          tax: integer | nil,
          tax_percent: number | nil,
          total: integer,
          total_tax_amounts: StripeFork.List.t(map) | nil,
          webhooks_delivered_at: StripeFork.timestamp() | nil
        }

  defstruct [
    :id,
    :object,
    :amount_due,
    :amount_paid,
    :amount_remaining,
    :application_fee,
    :attempt_count,
    :attempted,
    :auto_advance,
    :billing,
    :billing_reason,
    :charge,
    :closed,
    :currency,
    :customer,
    :date,
    :default_source,
    :description,
    :discount,
    :due_date,
    :ending_balance,
    :finalized_at,
    :forgiven,
    :hosted_invoice_url,
    :invoice_pdf,
    :lines,
    :livemode,
    :metadata,
    :next_payment_attempt,
    :number,
    :paid,
    :period_end,
    :period_start,
    :receipt_number,
    :status,
    :starting_balance,
    :statement_descriptor,
    :subscription,
    :subscription_proration_date,
    :subtotal,
    :tax,
    :tax_percent,
    :total,
    :total_tax_amounts,
    :webhooks_delivered_at
  ]

  @plural_endpoint "invoices"

  @doc """
  Create an invoice.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:application_fee) => integer,
                 optional(:billing) => String.t(),
                 :customer => StripeFork.id() | StripeFork.Customer.t(),
                 optional(:days_until_due) => integer,
                 optional(:default_source) => String.t(),
                 optional(:description) => String.t(),
                 optional(:due_date) => StripeFork.timestamp(),
                 optional(:metadata) => StripeFork.Types.metadata(),
                 optional(:statement_descriptor) => String.t(),
                 optional(:subscription) => StripeFork.id() | StripeFork.Subscription.t(),
                 optional(:tax_percent) => number
               }
               | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:subscription])
    |> make_request()
  end

  @doc """
  Retrieve an invoice.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update an invoice.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:application_fee) => integer,
                 optional(:closed) => boolean,
                 optional(:days_until_due) => integer,
                 optional(:default_source) => String.t(),
                 optional(:description) => String.t(),
                 optional(:due_date) => StripeFork.timestamp(),
                 optional(:forgiven) => boolean,
                 optional(:metadata) => StripeFork.Types.metadata(),
                 optional(:paid) => boolean,
                 optional(:statement_descriptor) => String.t(),
                 optional(:tax_percent) => number
               }
               | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Retrieve an upcoming invoice.
  """
  @spec upcoming(map, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def upcoming(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/upcoming")
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all invoices.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:billing) => String.t(),
                 optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
                 optional(:date) => StripeFork.date_query(),
                 optional(:due_date) => StripeFork.timestamp(),
                 optional(:ending_before) => t | StripeFork.id(),
                 optional(:limit) => 1..100,
                 optional(:starting_after) => t | StripeFork.id(),
                 optional(:subscription) => StripeFork.id() | StripeFork.Subscription.t()
               }
               | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :starting_after, :subscription])
    |> make_request()
  end

  @doc """
  Pay an invoice.
  """
  @spec pay(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 :id => String.t(),
                 optional(:forgive) => boolean,
                 optional(:source) => StripeFork.id() | StripeFork.Source.t() | nil
               }
               | %{}
  def pay(id, params, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/pay")
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:source])
    |> make_request()
  end
end
