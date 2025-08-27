defmodule StripeFork.Sku do
  @moduledoc """
  Work with Stripe Sku objects.

  Stripe API reference: https://stripe.com/docs/api#sku_object
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          active: boolean,
          attributes: %{
            optional(String.t()) => String.t()
          },
          created: StripeFork.timestamp(),
          currency: String.t(),
          image: String.t(),
          inventory: %{
            quantity: non_neg_integer | nil,
            type: String.t(),
            value: String.t() | nil
          },
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          package_dimensions:
            %{
              height: float,
              length: float,
              weight: float,
              width: float
            }
            | nil,
          price: non_neg_integer,
          product: StripeFork.id() | StripeFork.Relay.Product.t(),
          updated: StripeFork.timestamp()
        }

  defstruct [
    :id,
    :object,
    :active,
    :attributes,
    :created,
    :currency,
    :image,
    :inventory,
    :livemode,
    :metadata,
    :package_dimensions,
    :price,
    :product,
    :updated
  ]

  @endpoint "skus"

  @doc """
  Create a order.
  """
  @spec create(params, Keyword.t()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :currency => String.t(),
              :inventory => map,
              :price => non_neg_integer,
              :product => StripeFork.id() | StripeFork.Relay.Product.t(),
              optional(:active) => boolean,
              optional(:attributes) => map,
              optional(:image) => String.t(),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:package_dimensions) => map
            }
  def create(%{currency: _, inventory: _, price: _, product: _} = params, opts \\ []) do
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
              optional(:active) => boolean,
              optional(:attributes) => map,
              optional(:currency) => String.t(),
              optional(:image) => String.t(),
              optional(:inventory) => map,
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:package_dimensions) => map,
              optional(:price) => non_neg_integer,
              optional(:product) => StripeFork.id() | StripeFork.Relay.Product.t()
            }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  delete an order.
  """
  @spec delete(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all skus.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:active) => boolean,
              optional(:attributes) => map,
              optional(:ending_before) => t | StripeFork.id(),
              optional(:ids) => StripeFork.List.t(StripeFork.id()),
              optional(:in_stock) => boolean,
              optional(:limit) => 1..100,
              optional(:product) => StripeFork.id() | StripeFork.Relay.Product.t(),
              optional(:starting_after) => t | StripeFork.id()
            }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
