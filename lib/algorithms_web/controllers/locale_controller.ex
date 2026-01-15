defmodule AlgorithmsWeb.LocaleController do
  use AlgorithmsWeb, :controller

  @locales ["en", "pt"]

  def switch(conn, %{"locale" => locale}) when locale in @locales do
    conn
    |> put_session(:locale, locale)
    |> redirect(to: get_referer(conn))
  end

  def switch(conn, _params) do
    conn
    |> redirect(to: get_referer(conn))
  end

  defp get_referer(conn) do
    case get_req_header(conn, "referer") do
      [referer] ->
        uri = URI.parse(referer)
        uri.path || "/"

      _ ->
        "/"
    end
  end
end
