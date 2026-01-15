defmodule Algorithms.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Algorithms.DataCase
    end
  end

  setup _tags do
    :ok
  end

  @doc """
  Sets up the test case. No-op since we don't use a database.
  """
  def setup_sandbox(_tags), do: :ok
end
