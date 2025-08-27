defmodule StripeFork.Connect.OAuthTest do
  use ExUnit.Case

  import Mox

  test "oauth methods works" do
    verify_on_exit!()

    StripeFork.APIMock
    |> expect(:oauth_request, fn(method, _endpoint, _body) -> method end)

    StripeFork.Connect.OAuthMock
    |> expect(:token, fn(url) -> StripeFork.APIMock.oauth_request(:post, url, %{body: "body"}) end)
    |> expect(:deauthorize_url, fn(url) -> url end)
    |> expect(:authorize_url, fn(%{url: url}) -> url end)

    assert StripeFork.Connect.OAuthMock.token("1234") == :post
    assert StripeFork.Connect.OAuthMock.authorize_url(%{url: "www"}) == "www"
    assert StripeFork.Connect.OAuthMock.deauthorize_url("www.google.com") == "www.google.com"
  end
end
