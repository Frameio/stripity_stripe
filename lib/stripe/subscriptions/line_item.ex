defmodule StripeFork.LineItem do
  @moduledoc """
  Work with Stripe (invoice) line item objects.

  Stripe API reference: https://stripe.com/docs/api/ruby#invoice_line_item_object
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: integer,
          currency: String.t(),
          description: String.t(),
          discountable: boolean,
          invoice_item: StripeFork.id() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          period: %{
            start: StripeFork.timestamp(),
            end: StripeFork.timestamp()
          },
          plan: StripeFork.Plan.t() | nil,
          proration: boolean,
          quantity: integer,
          subscription: StripeFork.id() | nil,
          subscription_item: StripeFork.id() | nil,
          type: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :currency,
    :description,
    :discountable,
    :invoice_item,
    :livemode,
    :metadata,
    :period,
    :plan,
    :proration,
    :quantity,
    :subscription,
    :subscription_item,
    :type
  ]

  @doc """
  Retrieve an invoice line item.
  """
  @spec retrieve(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
               optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id(),
               optional(:subscription) => StripeFork.id() | StripeFork.Subscription.t(),
               optional(:subscription_billing_cycle_anchor) => integer,
               optional(:subscription_items) => StripeFork.List.t(StripeFork.SubscriptionItem.t()),
               optional(:subscription_prorate) => boolean,
               optional(:subscription_proration_date) => StripeFork.timestamp(),
               optional(:subscription_tax_percent) => integer,
               optional(:subscription_trial_from_plan) => boolean
             } | %{}
  def retrieve(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint("invoices" <> "/#{get_id!(id)}" <> "lines")
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end
end
