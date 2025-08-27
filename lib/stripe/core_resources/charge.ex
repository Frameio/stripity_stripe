defmodule StripeFork.Charge do
  @moduledoc """
  Work with [Stripe `charge` objects](https://stripe.com/docs/api#charges).

  You can:
  - [Create a charge](https://stripe.com/docs/api#create_charge)
  - [Retrieve a charge](https://stripe.com/docs/api#retrieve_charge)
  - [Update a charge](https://stripe.com/docs/api#update_charge)
  - [Capture a charge](https://stripe.com/docs/api#capture_charge)
  - [List all charges](https://stripe.com/docs/api#list_charges)
  """

  use StripeFork.Entity
  import StripeFork.Request
  require StripeFork.Util

  @type user_fraud_report :: %{
          user_report: String.t()
        }

  @type stripe_fraud_report :: %{
          stripe_report: String.t()
        }

  @type charge_outcome :: %{
          network_status: String.t() | nil,
          reason: String.t() | nil,
          risk_level: String.t(),
          rule: StripeFork.id() | charge_outcome_rule,
          seller_message: String.t() | nil,
          type: String.t()
        }

  @type charge_outcome_rule :: %{
          action: String.t(),
          id: String.t(),
          predicate: String.t()
        }

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
          amount: non_neg_integer,
          amount_refunded: non_neg_integer,
          application: StripeFork.id() | nil,
          application_fee: StripeFork.id() | StripeFork.ApplicationFee.t() | nil,
          balance_transaction: StripeFork.id() | StripeFork.BalanceTransaction.t() | nil,
          captured: boolean,
          created: StripeFork.timestamp(),
          currency: String.t(),
          customer: StripeFork.id() | StripeFork.Customer.t() | nil,
          description: String.t() | nil,
          destination: StripeFork.id() | StripeFork.Account.t() | nil,
          dispute: StripeFork.id() | StripeFork.Dispute.t() | nil,
          failure_code: StripeFork.Error.card_error_code() | nil,
          failure_message: String.t() | nil,
          fraud_details: user_fraud_report | stripe_fraud_report | %{},
          invoice: StripeFork.id() | StripeFork.Invoice.t() | nil,
          livemode: boolean,
          metadata: StripeFork.Types.metadata(),
          on_behalf_of: StripeFork.id() | StripeFork.Account.t() | nil,
          order: StripeFork.id() | StripeFork.Order.t() | nil,
          outcome: charge_outcome | nil,
          paid: boolean,
          receipt_email: String.t() | nil,
          receipt_number: String.t() | nil,
          refunded: boolean,
          refunds: StripeFork.List.t(StripeFork.Refund.t()),
          review: StripeFork.id() | StripeFork.Review.t() | nil,
          shipping: StripeFork.Types.shipping() | nil,
          source: StripeFork.Card.t() | map,
          source_transfer: StripeFork.id() | StripeFork.Transfer.t() | nil,
          statement_descriptor: String.t() | nil,
          status: String.t(),
          transfer: StripeFork.id() | StripeFork.Transfer.t() | nil,
          transfer_group: String.t() | nil
        }

  defstruct [
    :id,
    :object,
    :amount,
    :amount_refunded,
    :application,
    :application_fee,
    :balance_transaction,
    :captured,
    :created,
    :currency,
    :customer,
    :description,
    :destination,
    :dispute,
    :failure_code,
    :failure_message,
    :fraud_details,
    :invoice,
    :livemode,
    :metadata,
    :on_behalf_of,
    :order,
    :outcome,
    :paid,
    :receipt_email,
    :receipt_number,
    :refunded,
    :refunds,
    :review,
    :shipping,
    :source,
    :source_transfer,
    :statement_descriptor,
    :status,
    :transfer,
    :transfer_group
  ]

  @plural_endpoint "charges"

  @doc """
  Create a charge.

  If your API key is in test mode, the supplied payment source (e.g., card) won't actually be
  charged, though everything else will occur as if in live mode.
  (Stripe assumes that the charge would have completed successfully).

  See the [Stripe docs](https://stripe.com/docs/api#create_charge).
  """
  @spec create(params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               :amount => pos_integer,
               :currency => String.t(),
               optional(:application_fee) => non_neg_integer,
               optional(:capture) => boolean,
               optional(:description) => String.t(),
               optional(:destination) => %{
                 :account => StripeFork.id() | StripeFork.Account.t(),
                 optional(:amount) => non_neg_integer
               },
               optional(:transfer_group) => String.t(),
               optional(:on_behalf_of) => StripeFork.id() | StripeFork.Account.t(),
               optional(:metadata) => map,
               optional(:receipt_email) => String.t(),
               optional(:shipping) => StripeFork.Types.shipping(),
               optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
               optional(:source) => StripeFork.id() | StripeFork.Card.t() | card_info,
               optional(:statement_descriptor) => String.t()
             } | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_path_to_id([:destination, :account])
    |> cast_to_id([:on_behalf_of, :customer, :source])
    |> make_request()
  end

  @doc """
  Retrieve a charge.

  Retrieves the details of a charge that has previously been created.
  Supply the unique charge ID that was returned from your previous request, and Stripe will return
  the corresponding charge information. The same information is returned when creating or refunding
  the charge.

  See the [Stripe docs](https://stripe.com/docs/api#retrieve_charge).
  """
  @spec retrieve(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a charge.

  Updates the specified charge by setting the values of the parameters passed. Any parameters
  not provided will be left unchanged.

  This request accepts only the `:description`, `:metadata`, `:receipt_email`, `:fraud_details`,
  and `:shipping` as arguments, as well as `:transfer_group` in some cases.

  The charge to be updated may either be passed in as a struct or an ID.

  See the [Stripe docs](https://stripe.com/docs/api#update_charge).
  """
  @spec update(StripeFork.id() | t, params, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:customer) => StripeFork.id() | StripeFork.Customer.t(),
               optional(:description) => String.t(),
               optional(:fraud_details) => user_fraud_report,
               optional(:metadata) => StripeFork.Types.metadata(),
               optional(:receipt_email) => String.t(),
               optional(:shipping) => StripeFork.Types.shipping(),
               optional(:transfer_group) => String.t()
             } | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Capture a charge.

  Capture the payment of an existing, uncaptured, charge. This is the second
  half of the two-step payment flow, where first you created a charge with the
  capture option set to false.

  Uncaptured payments expire exactly seven days after they are created. If they
  are not captured by that point in time, they will be marked as refunded and
  will no longer be capturable.

  See the [Stripe docs](https://stripe.com/docs/api#capture_charge).
  """
  @spec capture(StripeFork.id() | t, params, StripeFork.options()) ::
          {:ok, t} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:amount) => non_neg_integer,
               optional(:application_fee) => non_neg_integer,
               optional(:destination) => %{
                 optional(:amount) => non_neg_integer
               },
               optional(:receipt_email) => String.t(),
               optional(:statement_descriptor) => String.t()
             }
  def capture(id, params, opts) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/capture")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  [DEPRECATED] Capture a charge.

  This version of the function is deprecated. Please use `capture/3` instead.
  """
  @spec capture(StripeFork.id() | t, StripeFork.options()) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def capture(id, opts) when is_list(opts) do
    StripeFork.Util.log_deprecation("Please use `capture/3` instead.")
    capture(id, %{}, opts)
  end

  @spec capture(StripeFork.id() | t, map) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def capture(id, params) when is_map(params) do
    capture(id, params, [])
  end

  @spec capture(StripeFork.id() | t) :: {:ok, t} | {:error, StripeFork.Error.t()}
  def capture(id) do
    StripeFork.Util.log_deprecation("Please use `capture/3` instead.")
    capture(id, %{}, [])
  end

  @doc """
  List all charges.

  Returns a list of charges you’ve previously created. The charges are returned in sorted order,
  with the most recent charges appearing first.

  See the [Stripe docs](https://stripe.com/docs/api#list_charges).
  """
  @spec list(params, StripeFork.options()) :: {:ok, StripeFork.List.t(t)} | {:error, StripeFork.Error.t()}
        when params: %{
               optional(:created) => StripeFork.date_query(),
               optional(:customer) => StripeFork.Customer.t() | StripeFork.id(),
               optional(:ending_before) => t | StripeFork.id(),
               optional(:limit) => 1..100,
               optional(:source) => %{
                 optional(:object) => String.t()
               },
               optional(:starting_after) => t | StripeFork.id(),
               optional(:transfer_group) => String.t()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:customer, :ending_before, :starting_after])
    |> make_request()
  end
end
