defmodule StripeFork.Review do
  @moduledoc """
  Work with Stripe review objects.

  Stripe API reference: https://stripe.com/docs/api#reviews
  """

  use StripeFork.Entity

  @type t :: %__MODULE__{
          id: StripeFork.id(),
          object: String.t(),
          charge: StripeFork.id() | StripeFork.Charge.t(),
          created: StripeFork.timestamp(),
          livemode: boolean,
          open: boolean,
          reason: String.t()
        }

  defstruct [
    :id,
    :object,
    :charge,
    :created,
    :livemode,
    :open,
    :reason
  ]
end
