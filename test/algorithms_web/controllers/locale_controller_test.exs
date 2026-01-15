defmodule AlgorithmsWeb.LocaleControllerTest do
  use AlgorithmsWeb.ConnCase, async: true

  describe "switch/2" do
    test "sets locale to pt and redirects", %{conn: conn} do
      conn =
        conn
        |> put_req_header("referer", "http://localhost:4000/run")
        |> get("/locale/pt")

      assert redirected_to(conn) == "/run"
      assert get_session(conn, :locale) == "pt"
    end

    test "sets locale to en and redirects", %{conn: conn} do
      conn =
        conn
        |> put_req_header("referer", "http://localhost:4000/")
        |> get("/locale/en")

      assert redirected_to(conn) == "/"
      assert get_session(conn, :locale) == "en"
    end

    test "redirects to root when no referer", %{conn: conn} do
      conn = get(conn, "/locale/pt")

      assert redirected_to(conn) == "/"
      assert get_session(conn, :locale) == "pt"
    end

    test "ignores invalid locale and redirects", %{conn: conn} do
      conn =
        conn
        |> put_req_header("referer", "http://localhost:4000/run")
        |> get("/locale/invalid")

      assert redirected_to(conn) == "/run"
      # Session should not have the invalid locale
      refute get_session(conn, :locale) == "invalid"
    end

    test "handles referer with query params", %{conn: conn} do
      conn =
        conn
        |> put_req_header("referer", "http://localhost:4000/run?algorithm=bubble")
        |> get("/locale/pt")

      # Only path is extracted, not query string
      assert redirected_to(conn) == "/run"
    end
  end
end
