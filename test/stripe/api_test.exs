defmodule StripeFork.APITest do
  use ExUnit.Case

  import Mox

  test "works with 301 responses without issue" do
    {:error, %StripeFork.Error{extra: %{http_status: 301}}} =
      StripeFork.API.request(%{}, :get, "/", %{}, [])
  end

  test "oauth_request works" do
    verify_on_exit!()

    StripeFork.APIMock
    |> expect(:oauth_request, fn(method, _endpoint, _body) -> method end)

    assert StripeFork.APIMock.oauth_request(:post, "www", %{body: "body"}) == :post
  end
end
