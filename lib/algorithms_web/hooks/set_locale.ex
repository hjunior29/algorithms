defmodule AlgorithmsWeb.Hooks.SetLocale do
  @moduledoc """
  LiveView hook to set the locale from session.
  """
  import Phoenix.Component

  def on_mount(:default, _params, session, socket) do
    locale = session["locale"] || "en"
    Gettext.put_locale(AlgorithmsWeb.Gettext, locale)
    {:cont, assign(socket, :locale, locale)}
  end
end
