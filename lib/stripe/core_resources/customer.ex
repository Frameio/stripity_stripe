defmodule StripeFork.Customer do
  @moduledoc """
  Work with Stripe customer objects.

  You can:

  - Create a customer
  - Retrieve a customer
  - Update a customer
  - Delete a customer

  Stripe API reference: https://stripe.com/docs/api#customer
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          account_balance: integer,
          address: StripeFork.Types.address() | nil,
          created: StripeFork.timestamp(),
          currency: String.t() | nil,
          default_source: StripeFork.id() | StripeFork.Source.t() | nil,
          deleted: boolean | nil,
          delinquent: boolean | nil,
          description: String.t() | nil,
          discount: StripeFork.Discount.t() | nil,
          email: String.t() | nil,
          invoice_prefix: String.t() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          shipping: StripeFork.Types.shipping() | nil,
          sources: StripeFork.List.t(StripeFork.Source.t()),
          subscriptions: StripeFork.List.t(StripeFork.Subscription.t()),
          tax: StripeFork.Types.tax() | nil,
          tax_exempt: binary | nil,
          tax_ids: term,
          tax_info: StripeFork.Types.tax_info() | nil,
          tax_info_verification: StripeFork.Types.tax_info_verification() | nil
        }

  defstruct [
    :id,
    :object,
    :account_balance,
    :address,
    :created,
    :currency,
    :default_source,
    :deleted,
    :delinquent,
    :description,
    :discount,
    :email,
    :invoice_prefix,
    :livemode,
    :metadata,
    :shipping,
    :sources,
    :subscriptions,
    :tax,
    :tax_exempt,
    :tax_ids,
    :tax_info,
    :tax_info_verification
  ]

  @plural_endpoint "customers"

  @doc """
  Create a customer.
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:account_balance) => integer,
                 optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
                 optional(:default_source) => StripeFork.id() | StripeFork.Source.t(),
                 optional(:description) => String.t(),
                 optional(:email) => String.t(),
                 optional(:invoice_prefix) => String.t(),
                 optional(:metadata) => StripeFork.Types.metadata(),
                 optional(:shipping) => StripeFork.Types.shipping(),
                 optional(:source) => StripeFork.Source.t(),
                 optional(:tax_exempt) => :exempt | :none | :reverse,
                 optional(:tax_info) => StripeFork.Types.tax_info()
               }
               | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :default_source, :source])
    |> make_request()
  end

  @doc """
  Retrieve a customer.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a customer.
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:account_balance) => integer,
                 optional(:coupon) => StripeFork.id() | StripeFork.Coupon.t(),
                 optional(:default_source) => StripeFork.id() | StripeFork.Source.t(),
                 optional(:description) => String.t(),
                 optional(:email) => String.t(),
                 optional(:invoice_prefix) => String.t(),
                 optional(:metadata) => StripeFork.Types.metadata(),
                 optional(:shipping) => StripeFork.Types.shipping(),
                 optional(:source) => StripeFork.Source.t(),
                 optional(:tax_exempt) => :exempt | :none | :reverse,
                 optional(:tax_info) => StripeFork.Types.tax_info()
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
  Delete a customer.
  """
  @spec delete(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all customers.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params:
               %{
                 optional(:created) => String.t() | StripeFork.date_query(),
                 optional(:email) => String.t(),
                 optional(:ending_before) => t | StripeFork.id(),
                 optional(:limit) => 1..100,
                 optional(:starting_after) => t | StripeFork.id()
               }
               | %{}
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
  Deletes the discount on a customer
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
