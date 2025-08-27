defmodule StripeFork.OrderReturn do
  @moduledoc """
  Work with Stripe order returns.

  Stripe API reference: https://stripe.com/docs/api#order_return_object
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          amount: pos_integer,
          created: StripeFork.timestamp(),
          currency: String.t(),
          items: StripeFork.List.t(StripeFork.OrderItem.t()),
          livemode: boolean,
          order: StripeFork.id() | StripeFork.Order.t() | nil,
          refund: StripeFork.id() | StripeFork.Refund.t() | nil
        }

  defstruct [
    :id,
    :object,
    :amount,
    :created,
    :currency,
    :items,
    :livemode,
    :order,
    :refund
  ]

  @plural_endpoint "order_returns"

  @doc """
  Retrieve a return.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all returns.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:created) => StripeFork.date_query(),
              optional(:ending_before) => t | StripeFork.id(),
              optional(:ids) => StripeFork.List.t(StripeFork.id()),
              optional(:limit) => 1..100,
              optional(:order) => StripeFork.Order.t(),
              optional(:starting_after) => t | StripeFork.id()
            }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end
end
