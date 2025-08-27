defmodule StripeFork.CountrySpec do
  @moduledoc """
  Work with the Stripe country specs API.

  Stripe API reference: https://stripe.com/docs/api#country_specs
  """

  use StripeFork.Entity
  import StripeFork.Request

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          default_currency: String.t(),
          supported_bank_account_currencies: %{
            String.t() => list(String.t())
          },
          supported_payment_currencies: list(String.t()),
          supported_payment_methods: list(StripeFork.Source.source_type() | String.t()),
          verification_fields: %{
            individual: %{
              minimum: list(String.t()),
              additional: list(String.t())
            },
            company: %{
              minimum: list(String.t()),
              additional: list(String.t())
            }
          }
        }

  defstruct [
    :id,
    :object,
    :default_currency,
    :supported_bank_account_currencies,
    :supported_payment_currencies,
    :supported_payment_methods,
    :verification_fields
  ]

  @plural_endpoint "country_specs"

  @doc """
  Retrieve a country spec.
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all country specs.
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | StripeFork.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end
end
