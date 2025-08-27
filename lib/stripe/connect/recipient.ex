defmodule StripeFork.Recipient do
  @moduledoc """
  Work with Stripe recipient objects.

  Stripe API reference: https://stripe.com/docs/api#recipients
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          active_account:
            %{
              id: StripeFork.id(),
              object: String.t(),
              account: StripeFork.id(),
              account_holder_name: String.t(),
              account_holder_type: String.t(),
              bank_name: String.t(),
              country: String.t(),
              currency: String.t(),
              customer: StripeFork.id(),
              default_for_currency: boolean,
              fingerprint: String.t(),
              last4: String.t(),
              metadata: StripeFork.Types.metadata(),
              routing_number: String.t(),
              status: String.t()
            }
            | nil,
          cards: StripeFork.List.t(StripeFork.Card.t()),
          created: StripeFork.timestamp(),
          default_card: StripeFork.id() | StripeFork.Card.t(),
          description: String.t() | nil,
          email: String.t() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          migrated_to: StripeFork.id() | StripeFork.Account.t(),
          name: String.t() | nil,
          rolled_back_from: StripeFork.id() | StripeFork.Account.t(),
          type: String.t()
        }

  defstruct [
    :id,
    :object,
    :active_account,
    :cards,
    :created,
    :default_card,
    :description,
    :email,
    :livemode,
    :metadata,
    :migrated_to,
    :name,
    :rolled_back_from,
    :type
  ]

  @plural_endpoint "recipients"

  @doc """
  Create a recipient
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              :name => String.t(),
              :type => String.t(),
              optional(:bank_account) => StripeFork.id() | StripeFork.BankAccount.t(),
              optional(:recipient) => StripeFork.id() | StripeFork.Card.t(),
              optional(:description) => String.t(),
              optional(:email) => String.t(),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:tax_id) => String.t()
            }
  def create(%{name: _, type: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a recipient.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a recipient.

  Takes the `id` and a map of changes
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:bank_account) => StripeFork.id() | StripeFork.BankAccount.t(),
              optional(:card) => StripeFork.id() | StripeFork.Card.t(),
              optional(:default_card) => StripeFork.id() | StripeFork.Card.t(),
              optional(:description) => String.t(),
              optional(:email) => String.t(),
              optional(:metadata) => StripeFork.Types.metadata(),
              optional(:name) => String.t(),
              optional(:tax_id) => String.t()
            }
  def update(id, params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params |> Map.delete(:customer))
    |> make_request()
  end

  @doc """
  Delete a recipient.
  """
  @spec delete(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all recipients.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
              optional(:created) => StripeFork.timestamp(),
              optional(:ending_before) => t | StripeFork.id(),
              optional(:limit) => 1..100,
              optional(:starting_after) => t | StripeFork.id(),
              optional(:type) => String.t(),
              optional(:verified) => boolean
            }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end
end
