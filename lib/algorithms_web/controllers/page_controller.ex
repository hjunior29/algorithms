defmodule AlgorithmsWeb.PageController do
  use AlgorithmsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
