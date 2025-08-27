ExUnit.start()
# StripeFork.start
Application.ensure_all_started(:erlexec)
Application.ensure_all_started(:exexec)
Application.ensure_all_started(:mox)
ExUnit.configure(exclude: [disabled: true], seed: 0)
Logger.configure(level: :info)

{:ok, pid} = StripeFork.StripeMock.start_link(port: 12123, global: true)


Application.put_env(:stripity_stripe_fork, :api_base_url, "http://localhost:12123/v1/")
Application.put_env(:stripity_stripe_fork, :api_upload_url, "http://localhost:12123/v1/")
Application.put_env(:stripity_stripe_fork, :api_key, "sk_test_123")
Application.put_env(:stripity_stripe_fork, :log_level, :debug)

Mox.defmock(StripeFork.Connect.OAuthMock, for: StripeFork.Connect.OAuth)
Mox.defmock(StripeFork.APIMock, for: StripeFork.API)

defmodule Helper do
  @fixture_path "./test/fixtures/"

  def load_fixture(filename) do
    File.read!(@fixture_path <> filename) |> Poison.decode!()
  end

  def wait_until_stripe_mock_launch() do
    case StripeFork.Charge.list() do
      {:error, %StripeFork.Error{code: :network_error}} ->
        # It might be connection refused.
        Process.sleep(250)
        wait_until_stripe_mock_launch()
      _ ->
        true
    end
  end
end

Helper.wait_until_stripe_mock_launch()
