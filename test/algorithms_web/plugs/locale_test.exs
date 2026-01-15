defmodule AlgorithmsWeb.Plugs.LocaleTest do
  use AlgorithmsWeb.ConnCase, async: true

  alias AlgorithmsWeb.Plugs.Locale

  # Helper to prepare conn with session
  defp with_session(conn) do
    conn
    |> Plug.Test.init_test_session(%{})
  end

  describe "call/2" do
    test "sets default locale to en when no session or header", %{conn: conn} do
      conn =
        conn
        |> with_session()
        |> Locale.call([])

      assert conn.assigns[:locale] == "en"
      assert Gettext.get_locale(AlgorithmsWeb.Gettext) == "en"
    end

    test "uses locale from session", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(%{locale: "pt"})
        |> Locale.call([])

      assert conn.assigns[:locale] == "pt"
      assert Gettext.get_locale(AlgorithmsWeb.Gettext) == "pt"
    end

    test "ignores invalid locale from session", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(%{locale: "invalid"})
        |> Locale.call([])

      assert conn.assigns[:locale] == "en"
    end

    test "parses accept-language header", %{conn: conn} do
      conn =
        conn
        |> with_session()
        |> put_req_header("accept-language", "pt-BR,pt;q=0.9,en;q=0.8")
        |> Locale.call([])

      assert conn.assigns[:locale] == "pt"
    end

    test "handles accept-language with quality values", %{conn: conn} do
      conn =
        conn
        |> with_session()
        |> put_req_header("accept-language", "fr;q=0.9,en;q=0.8,pt;q=0.7")
        |> Locale.call([])

      # fr is not supported, en has higher quality than pt
      assert conn.assigns[:locale] == "en"
    end

    test "session locale takes precedence over accept-language", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(%{locale: "pt"})
        |> put_req_header("accept-language", "en-US,en;q=0.9")
        |> Locale.call([])

      assert conn.assigns[:locale] == "pt"
    end

    test "falls back to default when accept-language has no supported locale", %{conn: conn} do
      conn =
        conn
        |> with_session()
        |> put_req_header("accept-language", "fr-FR,de;q=0.9")
        |> Locale.call([])

      assert conn.assigns[:locale] == "en"
    end
  end
end
