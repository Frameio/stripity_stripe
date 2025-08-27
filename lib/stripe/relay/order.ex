defmodule StripeFork.Order do
  @moduledoc """
  Work with Stripe orders.

  Stripe API reference: https://stripe.com/docs/api#orders
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type card_info :: %{
          exp_month: number,
          exp_year: number,
          number: String.t(),
          object: String.t(),
          cvc: String.t(),
          address_city: String.t() | nil,
          address_country: String.t() | nil,
          address_line1: String.t() | nil,
          address_line2: String.t() | nil,
          name: String.t() | nil,
          address_state: String.t() | nil,
          address_zip: String.t() | nil
        }

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: pos_integer,
          amount_returned: non_neg_integer,
          application: StripeFork.id(),
          application_fee: non_neg_integer,
          charge: StripeFork.id() | StripeFork.Charge.t(),
          currency: String.t(),
          customer: StripeFork.id() | StripeFork.Customer.t(),
          email: String.t(),
          external_coupon_code: String.t(),
          items: StripeFork.List.t(StripeFork.OrderItem.t()),
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          returns: StripeFork.List.t(StripeFork.OrderReturn.t()),
          selected_shipping_method: String.t(),
          shipping: %{
            address: %{
              city: String.t(),
              country: String.t(),
              line1: String.t(),
              line2: String.t(),
              postal_code: String.t(),
              state: String.t()
            },
            carrier: String.t(),
            name: String.t(),
            phone: String.t(),
            tracking_number: String.t()
          },
          shipping_methods: [
            %{
              id: String.t(),
              amount: pos_integer,
              currency: String.t(),
              delivery_estimate: %{
                date: String.t(),
                earliest: String.t(),
                latest: String.t(),
                type: String.t()
              },
              description: String.t()
            }
          ],
          status: String.t(),
          status_transitions: %{
            canceled: StripeFork.timestamp(),
            fulfiled: StripeFork.timestamp(),
            paid: StripeFork.timestamp(),
            returned: StripeFork.timestamp()
          },
          updated: StripeFork.timestamp(),
          upstream_id: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :amount_returned,
    :application,
    :application_fee,
    :charge,
    :currency,
    :customer,
    :email,
    :external_coupon_code,
    :items,
    :livemode,
    :metadata,
    :returns,
    :selected_shipping_method,
    :shipping,
    :shipping_methods,
    :status,
    :status_transitions,
    :updated,
    :upstream_id
  ]

  @endpoint "orders"

  @doc """
  Create a order.
  """
  @spec create(params, Keyword.t()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :currency => String.t(),
              optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
              optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
              optional(:email) => String.t(),
              optional(:items) => StripeFork.List.t(StripeFork.OrderItem.t()),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:shipping) => map
            }
  def create(%{currency: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a order.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a order.

  Takes the `id` and a map of changes
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:selected_shipping_method) => String.t(),
              optional(:shipping) => map,
              optional(:status) => String.t()
            }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Pay an order.
  """
  @spec pay(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:application_fee) => non_neg_integer,
              optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
              optional(:source) => StripeFork.id() | StripeFork.Card.t() | StripeFork.Customer.t() | card_info,
              optional(:email) => String.t(),
              optional(:metadata) => StripeFork.Types.metadata()
            }
  def pay(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}/" <> "pay")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  return an order.
  """
  @spec return(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:items) => StripeFork.List.t(StripeFork.OrderItem.t())
            }
  def return(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}/" <> "returns")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all orders.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
              optional(:ending_before) => t | StripeFork.id(),
              optional(:ids) => StripeFork.List.t(StripeFork.id()),
              optional(:limit) => 1..100,
              optional(:starting_after) => t | StripeFork.id(),
              optional(:status) => String.t(),
              optional(:status_transitions) => map,
              optional(:upstream_ids) => StripeFork.List.t(StripeFork.id())
            }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :starting_after])
    |> make_request()
  end
end
