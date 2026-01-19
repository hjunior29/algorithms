defmodule AlgorithmsWeb.LearnLiveTest do
  use AlgorithmsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "mount/3 without algorithm" do
    test "renders the learn page with all algorithms", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Learn Sorting Algorithms"
      assert html =~ "Insertion Sort"
      assert html =~ "Selection Sort"
      assert html =~ "Bubble Sort"
      assert html =~ "Shell Sort"
      assert html =~ "Merge Sort"
      assert html =~ "Heap Sort"
      assert html =~ "Quick Sort"
      assert html =~ "Quick3 Sort"
    end

    test "displays comparative chart", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Comparative Chart"
      assert html =~ "Average"
      assert html =~ "Worst"
      assert html =~ "Space"
      assert html =~ "Stable"
    end

    test "displays understanding the concepts section", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Understanding the Concepts"
      assert html =~ "Before diving into algorithms"
    end

    test "displays complexity growth visualization chart", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Complexity Growth Visualization"
      assert html =~ "Input Size (n)"
      assert html =~ "Operations"
      # Check SVG elements for each complexity curve
      assert html =~ "O(1)"
      assert html =~ "O(log n)"
      assert html =~ "O(n log n)"
    end

    test "displays time complexity card with best/avg/worst explanations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Time Complexity"
      assert html =~ "Time complexity describes how the runtime"
      assert html =~ "The minimum time the algorithm takes"
      assert html =~ "Expected time for random input"
      assert html =~ "Maximum time the algorithm can take"
    end

    test "displays space complexity card", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Space Complexity"
      assert html =~ "Space complexity measures the additional memory"
      assert html =~ "Constant space"
      assert html =~ "Logarithmic - typically from recursion stack"
      assert html =~ "Linear - memory grows with input size"
    end

    test "displays stability card with example", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Stability"
      assert html =~ "A stable sorting algorithm maintains the relative order"
      assert html =~ "Example:"
      assert html =~ "Input: [(A,2), (B,1), (C,2), (D,1)]"
      assert html =~ "Stable: [(B,1), (D,1), (A,2), (C,2)]"
      assert html =~ "Unstable: [(D,1), (B,1), (C,2), (A,2)]"
    end

    test "displays big o notation card with table", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Big O Notation"
      assert html =~ "Big O describes the upper bound"
      assert html =~ "Notation"
      assert html =~ "Name"
      assert html =~ "Ops for n=1000"
      # Check table content
      assert html =~ "Constant"
      assert html =~ "Logarithmic"
      assert html =~ "Linear"
      assert html =~ "Linearithmic"
      assert html =~ "Quadratic"
      # Check explanation text
      assert html =~ "The table shows how many operations each complexity requires"
    end

    test "displays practical tips section", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Practical Tips for Choosing an Algorithm"
      assert html =~ "Small Data (n &lt; 50)"
      assert html =~ "Nearly Sorted Data"
      assert html =~ "Large Data"
      assert html =~ "Simple algorithms like Insertion Sort"
      assert html =~ "Insertion Sort and Bubble Sort approach O(n)"
      assert html =~ "Use O(n log n) algorithms"
    end

    test "complexity legend shows all complexity types", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      # Check legend items
      assert html =~ "O(1) - "
      assert html =~ "O(log n) - "
      assert html =~ "O(n) - "
      assert html =~ "O(n log n) - "
      assert html =~ "O(n²) - "
    end

    test "shows complexity badges on algorithm cards", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "O(n²)"
      assert html =~ "O(n log n)"
    end

    test "algorithm cards are links to detail pages", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ ~s(href="/learn/insertion")
      assert html =~ ~s(href="/learn/bubble")
      assert html =~ ~s(href="/learn/quick")
    end
  end

  describe "mount/3 with algorithm parameter" do
    test "renders insertion sort detail page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/insertion")

      assert html =~ "Insertion Sort"
      assert html =~ "How it works"
      assert html =~ "When to use"
      assert html =~ "Complexity"
      assert html =~ "Back to all algorithms"
    end

    test "renders bubble sort detail page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/bubble")

      assert html =~ "Bubble Sort"
      assert html =~ "How it works"
    end

    test "renders quick sort detail page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/quick")

      assert html =~ "Quick Sort"
      assert html =~ "Tony Hoare"
    end

    test "renders merge sort detail page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/merge")

      assert html =~ "Merge Sort"
      assert html =~ "John von Neumann"
    end

    test "shows complexity card with best/average/worst cases", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/insertion")

      assert html =~ "Best Case"
      assert html =~ "Average Case"
      assert html =~ "Worst Case"
      assert html =~ "Space"
      assert html =~ "Stable"
    end

    test "shows link to run visualizer", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/bubble")

      assert html =~ "Run"
      assert html =~ ~s(href="/run?algorithm=bubble")
    end

    test "shows other algorithms in sidebar", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/insertion")

      assert html =~ "Other algorithms"
      # Should show other algorithms but not insertion
      assert html =~ "Bubble"
      assert html =~ "Quick"
    end

    test "shows implementation section with code tabs", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/insertion")

      assert html =~ "Implementation"
      assert html =~ "Python"
      assert html =~ "JavaScript"
      assert html =~ "Go"
      assert html =~ "Rust"
    end

    test "code blocks have language classes for highlight.js", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn/quick")

      # Highlight.js uses language-* classes
      assert html =~ "language-python"
      assert html =~ "language-javascript"
      assert html =~ "language-go"
      assert html =~ "language-rust"
      # Check for actual code content
      assert html =~ "quick_sort" or html =~ "quickSort"
    end
  end

  describe "navigation" do
    test "can navigate from list to detail via card", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/learn")

      # Use the card link (has hover-3d class)
      {:ok, _view, html} = view |> element("a.hover-3d[href='/learn/insertion']") |> render_click() |> follow_redirect(conn)

      assert html =~ "Insertion Sort"
      assert html =~ "How it works"
    end

    test "can navigate back to list from detail", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/learn/bubble")

      # Use the back button (has btn class)
      {:ok, _view, html} = view |> element("a.btn[href='/learn']") |> render_click() |> follow_redirect(conn)

      assert html =~ "Learn Sorting Algorithms"
      assert html =~ "Comparative Chart"
    end

    test "can navigate between algorithms via sidebar", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/learn/insertion")

      # Use the sidebar link (has btn-ghost class)
      {:ok, _view, html} = view |> element("a.btn-ghost[href='/learn/bubble']") |> render_click() |> follow_redirect(conn)

      assert html =~ "Bubble Sort"
    end
  end

  describe "includes header and footer" do
    test "has navigation header", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "<header"
    end

    test "has footer", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/learn")

      assert html =~ "Phoenix LiveView"
    end
  end
end
