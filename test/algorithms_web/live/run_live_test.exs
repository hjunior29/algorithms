defmodule AlgorithmsWeb.RunLiveTest do
  use AlgorithmsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "mount/3" do
    test "renders the run page with default algorithm", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      assert html =~ "Generate"
      assert html =~ "Start"
      assert html =~ "Reset"
      assert html =~ "Insertion"
    end

    test "accepts algorithm from query params", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run?algorithm=bubble")

      assert html =~ "Bubble"
    end

    test "shows control sliders", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      assert html =~ "Quantity"
      assert html =~ "Max Value"
      assert html =~ "Delay"
      assert html =~ "Algorithm"
    end

    test "buttons have correct initial state", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      # Generate should be enabled
      refute has_element?(view, "button[phx-click='generate'][disabled]")

      # Start should be disabled (no numbers generated)
      assert has_element?(view, "button[phx-click='start'][disabled]")

      # Reset should be disabled (no original numbers)
      assert has_element?(view, "button[phx-click='reset'][disabled]")
    end
  end

  describe "generate event" do
    test "generates random numbers and displays bars", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      html = view |> element("button[phx-click='generate']") |> render_click()

      # Should show bars (blue color indicates bars are rendered)
      assert html =~ "bg-blue-500"

      # Should show results section
      assert html =~ "Status"
      assert html =~ "Operations"
    end

    test "enables start button after generating", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      view |> element("button[phx-click='generate']") |> render_click()

      # Start should now be enabled
      refute has_element?(view, "button[phx-click='start'][disabled]")
    end

    test "enables reset button after generating", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      view |> element("button[phx-click='generate']") |> render_click()

      # Reset should now be enabled
      refute has_element?(view, "button[phx-click='reset'][disabled]")
    end
  end

  describe "select_algorithm event" do
    test "changes the selected algorithm", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      # Select bubble sort
      html = render_click(view, "select_algorithm", %{"algorithm" => "bubble"})

      assert html =~ "Bubble"
    end

    test "can select all algorithms", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      algorithms = ~w(insertion selection bubble shell merge heap quick quick3)

      for algo <- algorithms do
        html = render_click(view, "select_algorithm", %{"algorithm" => algo})
        expected_name = String.capitalize(algo)
        assert html =~ expected_name, "Expected #{expected_name} to be shown for #{algo}"
      end
    end
  end

  describe "change_settings event" do
    test "updates delay setting", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      html = render_change(view, "change_settings", %{"delay" => "250"})

      assert html =~ "250ms"
    end

    test "updates count setting", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      html = render_change(view, "change_settings", %{"delay" => "100", "count" => "30"})

      assert html =~ "30"
    end

    test "updates max_value setting", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      html = render_change(view, "change_settings", %{"delay" => "100", "max_value" => "150"})

      assert html =~ "150"
    end
  end

  describe "reset event" do
    test "resets numbers to original state", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      # Generate numbers
      view |> element("button[phx-click='generate']") |> render_click()

      # Reset
      view |> element("button[phx-click='reset']") |> render_click()

      # Should still show bars (original numbers restored)
      html = render(view)
      assert html =~ "bg-blue-500"

      # Status should be ready
      assert html =~ "Ready"
    end
  end

  describe "status display" do
    test "shows waiting status initially when results visible", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/run")

      # Generate to make results section visible
      html = view |> element("button[phx-click='generate']") |> render_click()

      # After generate, status is ready
      assert html =~ "Ready"
    end
  end

  describe "algorithm dropdown" do
    test "displays all algorithm options", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      assert html =~ "Insertion"
      assert html =~ "Selection"
      assert html =~ "Bubble"
      assert html =~ "Shell"
      assert html =~ "Merge"
      assert html =~ "Heap"
      assert html =~ "Quick"
      assert html =~ "Quick3"
    end
  end

  describe "history" do
    test "history is empty initially", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      refute html =~ "History"
    end
  end

  describe "navigation" do
    test "includes nav header", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      assert html =~ "<header"
    end

    test "includes nav footer", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/run")

      assert html =~ "Phoenix LiveView"
    end
  end
end
