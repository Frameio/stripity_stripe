defmodule StripeFork.Subscription do
  @moduledoc """
  Work with Stripe subscription objects.

  You can:

  - Create a subscription
  - Retrieve a subscription
  - Update a subscription
  - Delete a subscription

  Stripe API reference: https://stripe.com/docs/api#subscription
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          application_fee_percent: float | nil,
          automatic_tax: map,
          billing: String.t() | nil,
          billing_cycle_anchor: StripeFork.timestamp() | nil,
          cancel_at_period_end: boolean,
          canceled_at: StripeFork.timestamp() | nil,
          cancellation_details: map,
          created: StripeFork.timestamp(),
          current_period_end: StripeFork.timestamp() | nil,
          current_period_start: StripeFork.timestamp() | nil,
          customer: StripeFork.id() | StripeFork.Customer.t(),
          days_until_due: integer | nil,
          discount: StripeFork.Discount.t() | nil,
          ended_at: StripeFork.timestamp() | nil,
          items: StripeFork.List.t(StripeFork.SubscriptionItem.t()),
          latest_invoice: StripeFork.Invoice.t() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          plan: StripeFork.Plan.t() | nil,
          quantity: integer | nil,
          start: StripeFork.timestamp(),
          status: String.t(),
          tax_percent: float | nil,
          trial_end: StripeFork.timestamp() | nil,
          trial_start: StripeFork.timestamp() | nil,
          trial_settings: map
        }

  defstruct [
    :id,
    :object,
    :application_fee_percent,
    :automatic_tax,
    :billing,
    :billing_cycle_anchor,
    :cancel_at_period_end,
    :canceled_at,
    :cancellation_details,
    :created,
    :current_period_end,
    :current_period_start,
    :customer,
    :days_until_due,
    :discount,
    :ended_at,
    :items,
    :latest_invoice,
    :livemode,
    :metadata,
    :plan,
    :quantity,
    :start,
    :status,
    :tax_percent,
    :trial_end,
    :trial_start,
    :trial_settings
  ]

  @plural_endpoint "subscriptions"

  @doc """
  Create a subscription.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :customer => StripeFork.id() | StripeFork.Customer.t(),
               optional(:application_fee_percent) => integer,
               optional(:billing) => String.t(),
               optional(:billing_cycle_anchor) => StripeFork.timestamp(),
               optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
               optional(:days_until_due) => non_neg_integer,
               optional(:items) => [
                 %{
                   :plan => StripeFork.id() | StripeFork.Plan.t(),
                   optional(:quantity) => non_neg_integer
                 }
               ],
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:prorate) => boolean,
               optional(:tax_percent) => float,
               optional(:trial_end) => StripeFork.timestamp(),
               optional(:trial_from_plan) => boolean,
               optional(:trial_period_days) => non_neg_integer
             }
  def create(%{customer: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :customer])
    |> make_request()
  end

  @doc """
  Retrieve a subscription.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a subscription.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:application_fee_percent) => float,
               optional(:billing) => String.t(),
               optional(:billing_cycle_anchor) => StripeFork.timestamp(),
               optional(:cancel_at_period_end) => boolean(),
               optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
               optional(:days_until_due) => non_neg_integer,
               optional(:items) => [
                 %{
                   :plan => StripeFork.id() | StripeFork.Plan.t(),
                   optional(:quantity) => non_neg_integer
                 }
               ],
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:prorate) => boolean,
               optional(:proration_date) => StripeFork.timestamp(),
               optional(:tax_percent) => float,
               optional(:trial_end) => StripeFork.timestamp(),
               optional(:trial_from_plan) => boolean
             }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:coupon])
    |> make_request()
  end

  @doc """
  Delete a subscription.

  Takes the subscription `id` or a `StripeFork.Subscription` struct.
  """
  @spec delete(StripeFork.id() | t) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id), do: delete(id, [])

  @doc """
  Delete a subscription.

  Takes the subscription `id` and an optional map of `params`.

  ### Deprecated Usage

  Passing a map with `at_period_end: true` to `Subscription.delete/2`
  is deprecated.  Use `Subscription.update/2` with
  `cancel_at_period_end: true` instead.
  """
  @deprecated "Use StripeFork.Subscription.update/2 with `cancel_at_period_end: true`"
  @spec delete(StripeFork.id() | t, %{at_period_end: true}) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, %{at_period_end: true}), do: update(id, %{cancel_at_period_end: true})

  @spec delete(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, opts) when is_list(opts) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  DEPRECATED: Use `Subscription.update/3` with `cancel_at_period_end: true` instead.
  """
  @deprecated "Use StripeFork.Subscription.update/3 with `cancel_at_period_end: true`"
  @spec delete(StripeFork.id() | t, %{at_period_end: true}, StripeFork.options()) ::
          {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, %{at_period_end: true}, opts) when is_list(opts),
    do: update(id, %{cancel_at_period_end: true}, opts)

  @doc """
  List all subscriptions.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:billing) => String.t(),
               optional(:created) => StripeFork.date_query(),
               optional(:customer) => StripeFork.Customer.t() | StripeFork.id(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:plan) => StripeFork.Plan.t() | StripeFork.id(),
               optional(:starting_after) => t | StripeFork.id(),
               optional(:status) => String.t()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :plan, :starting_after])
    |> make_request()
  end

  @doc """
  Deletes the discount on a subscription.
  """
  @spec delete_discount(StripeFork.id() | t, StripeFork.options()) ::
          {:ok, t} | {:error, StripeFork.Error.t()}
  def delete_discount(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/discount")
    |> put_method(:delete)
    |> make_request()
  end
end
