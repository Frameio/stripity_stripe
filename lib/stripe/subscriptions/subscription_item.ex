defmodule StripeFork.SubscriptionItem do
  @moduledoc """
  Work with Stripe subscription item objects.

  Stripe API reference: https://stripe.com/docs/api#subscription_items
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          created: StripeFork.timestamp(),
          deleted: boolean | nil,
          metadata: StripeFork.Types.metadata(),
          plan: StripeFork.Plan.t(),
          quantity: non_neg_integer,
          subscription: StripeFork.id() | StripeFork.Subscription.t() | nil
        }

  defstruct [
    :id,
    :object,
    :created,
    :deleted,
    :metadata,
    :plan,
    :quantity,
    :subscription
  ]

  @plural_endpoint "subscription_items"

  @doc """
  Create a subscription item.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :plan => StripeFork.id() | StripeFork.Plan.t(),
               :subscription => StripeFork.id() | StripeFork.Subscription.t(),
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:prorate) => boolean,
               optional(:proration_date) => StripeFork.timestamp(),
               optional(:quantity) => float
             }
  def create(%{plan: _, subscription: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:plan, :subscription])
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
  Update a subscription item.

  Takes the `id` and a map of changes.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:plan) => StripeFork.id() | StripeFork.Plan.t(),
               optional(:prorate) => boolean,
               optional(:proration_date) => StripeFork.timestamp(),
               optional(:quantity) => float
             }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> cast_to_id([:plan])
    |> make_request()
  end

  @doc """
  Delete a subscription.

  Takes the `id` and an optional map of `params`.
  """
  @spec delete(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:clear_usage) => boolean,
               optional(:prorate) => boolean,
               optional(:proration_date) => StripeFork.timestamp()
             }
  def delete(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all subscriptions.
  """
  @spec list(StripeFork.id(), params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             }
  def list(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "?subscription=" <> id)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
