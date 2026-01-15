defmodule AlgorithmsWeb.Plugs.Locale do
  @moduledoc """
  Plug to set the locale based on session or accept-language header.
  """
  import Plug.Conn

  @locales ["en", "pt"]
  @default_locale "en"

  def init(opts), do: opts

  def call(conn, _opts) do
    locale = get_locale_from_session(conn) || get_locale_from_header(conn) || @default_locale
    Gettext.put_locale(AlgorithmsWeb.Gettext, locale)
    assign(conn, :locale, locale)
  end

  defp get_locale_from_session(conn) do
    locale = get_session(conn, :locale)
    if locale in @locales, do: locale, else: nil
  end

  defp get_locale_from_header(conn) do
    conn
    |> get_req_header("accept-language")
    |> List.first()
    |> parse_accept_language()
  end

  defp parse_accept_language(nil), do: nil

  defp parse_accept_language(header) do
    header
    |> String.split(",")
    |> Enum.map(&parse_language_tag/1)
    |> Enum.sort_by(fn {_lang, quality} -> quality end, :desc)
    |> Enum.find_value(fn {lang, _quality} ->
      lang = String.slice(lang, 0, 2)
      if lang in @locales, do: lang, else: nil
    end)
  end

  defp parse_language_tag(tag) do
    case String.split(String.trim(tag), ";") do
      [lang] -> {lang, 1.0}
      [lang, "q=" <> quality] -> {lang, String.to_float(quality)}
      _ -> {"", 0.0}
    end
  end
end
