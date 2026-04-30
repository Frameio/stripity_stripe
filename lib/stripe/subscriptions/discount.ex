defmodule StripeFork.Discount do
  @moduledoc """
  Work with Stripe discounts.

  Stripe API reference: https://stripe.com/docs/api#discounts
  """

  use StripeFork.Entity

  @type t :: %__MODULE__{
          object: String.t(),
          coupon: StripeFork.Coupon.t(),
          customer: StripeFork.id() | StripeFork.Customer.t() | nil,
          deleted: boolean | nil,
          end: StripeFork.timestamp() | nil,
          start: StripeFork.timestamp(),
          subscription: StripeFork.id() | nil
        }

  defstruct [
    :object,
    :coupon,
    :customer,
    :deleted,
    :end,
    :start,
    :subscription
  ]
end
