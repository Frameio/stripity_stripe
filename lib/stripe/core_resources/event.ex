defmodule StripeFork.Event do
  @moduledoc """
  Work with Stripe event objects.

  You can:
  - Retrieve an event
  - List all events

  Stripe API reference: https://stripe.com/docs/api#event
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type event_data :: %{
          object: event_data_object,
          previous_attributes: map
        }

  # TODO: add Scheduled query run
  @type event_data_object ::
          StripeFork.Account.t()
          | StripeFork.ApplicationFee.t()
          | StripeFork.Charge.t()
          | StripeFork.Coupon.t()
          | StripeFork.Customer.t()
          | StripeFork.FileUpload.t()
          | StripeFork.Invoice.t()
          | StripeFork.Invoiceitem.t()
          | StripeFork.Order.t()
          | StripeFork.OrderReturn.t()
          | StripeFork.Payout.t()
          | StripeFork.Plan.t()
          | StripeFork.Relay.Product.t()
          | StripeFork.Product.t()
          | StripeFork.Recipient.t()
          | StripeFork.Review.t()
          | StripeFork.Sku.t()
          | StripeFork.Source.t()
          | StripeFork.Transfer.t()
          | map

  @type event_request :: %{
          id: String.t() | nil,
          idempotency_key: String.t() | nil
        }

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          api_version: String.t() | nil,
          created: StripeFork.timestamp(),
          data: event_data,
          livemode: boolean,
          pending_webhooks: non_neg_integer,
          request: event_request | nil,
          type: String.t()
        }

  defstruct [
    :id,
    :object,
    :api_version,
    :created,
    :data,
    :livemode,
    :pending_webhooks,
    :request,
    :type,
    :account
  ]

  @plural_endpoint "events"

  @doc """
  Retrieve an event.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all events, going back up to 30 days.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:created) => StripeFork.date_query(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id(),
               optional(:type) => String.t(),
               optional(:types) => list
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
