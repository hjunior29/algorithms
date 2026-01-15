defmodule AlgorithmsWeb.HomeLiveTest do
  use AlgorithmsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "mount/3" do
    test "renders the home page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "Insertion Sort"
      assert html =~ "Bubble Sort"
      assert html =~ "Quick Sort"
    end

    test "displays typing animation element", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "typing-text"
      assert html =~ "TypingEffect"
    end

    test "shows all algorithm cards", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      algorithms = [
        "Insertion Sort",
        "Selection Sort",
        "Bubble Sort",
        "Shell Sort",
        "Merge Sort",
        "Heap Sort",
        "Quick Sort",
        "Quick3 Sort"
      ]

      for algo <- algorithms do
        assert html =~ algo, "Expected to find #{algo} on the page"
      end
    end

    test "algorithm cards link to run page with correct algorithm", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ ~s(href="/run?algorithm=insertion")
      assert html =~ ~s(href="/run?algorithm=selection")
      assert html =~ ~s(href="/run?algorithm=bubble")
      assert html =~ ~s(href="/run?algorithm=shell")
      assert html =~ ~s(href="/run?algorithm=merge")
      assert html =~ ~s(href="/run?algorithm=heap")
      assert html =~ ~s(href="/run?algorithm=quick")
      assert html =~ ~s(href="/run?algorithm=quick3")
    end

    test "displays complexity badges", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "O(n²)"
      assert html =~ "O(n log n)"
    end

    test "includes navigation header", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "<header"
      assert html =~ "/run"
    end

    test "includes footer", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "Phoenix LiveView"
    end
  end

  describe "sections" do
    test "renders hero section", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      # Hero has the main title and CTA
      assert html =~ "Run"
      assert html =~ "btn-primary"
    end

    test "renders about section with feature cards", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "Why Algorithm Visualization?"
      assert html =~ "Learn Visually"
      assert html =~ "Compare Performance"
      assert html =~ "Interactive Controls"
    end

    test "renders CTA section", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "Ready to Explore?"
    end
  end
end
