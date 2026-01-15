defmodule Algorithms.SortingTest do
  use ExUnit.Case, async: true

  alias Algorithms.Sorting

  describe "bubble_sort/2" do
    test "sorts an unsorted list" do
      numbers = [5, 3, 8, 4, 2]
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == [2, 3, 4, 5, 8]
    end

    test "handles already sorted list" do
      numbers = [1, 2, 3, 4, 5]
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5]
    end

    test "handles reverse sorted list" do
      numbers = [5, 4, 3, 2, 1]
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5]
    end

    test "handles single element list" do
      numbers = [42]
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == [42]
    end

    test "handles empty list" do
      numbers = []
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == []
    end

    test "handles list with duplicates" do
      numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5]
      result = run_sort(&Sorting.bubble_sort/2, numbers)
      assert result == [1, 1, 2, 3, 4, 5, 5, 6, 9]
    end
  end

  describe "selection_sort/2" do
    test "sorts an unsorted list" do
      numbers = [64, 25, 12, 22, 11]
      result = run_sort(&Sorting.selection_sort/2, numbers)
      assert result == [11, 12, 22, 25, 64]
    end

    test "handles already sorted list" do
      numbers = [1, 2, 3, 4, 5]
      result = run_sort(&Sorting.selection_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5]
    end

    test "handles list with duplicates" do
      numbers = [5, 2, 5, 1, 2]
      result = run_sort(&Sorting.selection_sort/2, numbers)
      assert result == [1, 2, 2, 5, 5]
    end
  end

  describe "insertion_sort/2" do
    test "sorts an unsorted list" do
      numbers = [12, 11, 13, 5, 6]
      result = run_sort(&Sorting.insertion_sort/2, numbers)
      assert result == [5, 6, 11, 12, 13]
    end

    test "handles nearly sorted list efficiently" do
      numbers = [1, 2, 4, 3, 5]
      result = run_sort(&Sorting.insertion_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5]
    end

    test "handles list with all same elements" do
      numbers = [7, 7, 7, 7]
      result = run_sort(&Sorting.insertion_sort/2, numbers)
      assert result == [7, 7, 7, 7]
    end
  end

  describe "shell_sort/2" do
    test "sorts an unsorted list" do
      numbers = [23, 29, 15, 19, 31, 7, 9, 5, 2]
      result = run_sort(&Sorting.shell_sort/2, numbers)
      assert result == [2, 5, 7, 9, 15, 19, 23, 29, 31]
    end

    test "handles large gaps correctly" do
      numbers = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
      result = run_sort(&Sorting.shell_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end
  end

  describe "merge_sort/2" do
    test "sorts an unsorted list" do
      numbers = [38, 27, 43, 3, 9, 82, 10]
      result = run_sort(&Sorting.merge_sort/2, numbers)
      assert result == [3, 9, 10, 27, 38, 43, 82]
    end

    test "handles power of 2 length list" do
      numbers = [8, 4, 2, 1]
      result = run_sort(&Sorting.merge_sort/2, numbers)
      assert result == [1, 2, 4, 8]
    end

    test "handles odd length list" do
      numbers = [5, 2, 9]
      result = run_sort(&Sorting.merge_sort/2, numbers)
      assert result == [2, 5, 9]
    end
  end

  describe "heap_sort/2" do
    test "sorts an unsorted list" do
      numbers = [12, 11, 13, 5, 6, 7]
      result = run_sort(&Sorting.heap_sort/2, numbers)
      assert result == [5, 6, 7, 11, 12, 13]
    end

    test "handles list with negative-like ordering" do
      numbers = [1, 12, 9, 5, 6, 10]
      result = run_sort(&Sorting.heap_sort/2, numbers)
      assert result == [1, 5, 6, 9, 10, 12]
    end
  end

  describe "quick_sort/2" do
    test "sorts an unsorted list" do
      numbers = [10, 7, 8, 9, 1, 5]
      result = run_sort(&Sorting.quick_sort/2, numbers)
      assert result == [1, 5, 7, 8, 9, 10]
    end

    test "handles worst case (already sorted)" do
      numbers = [1, 2, 3, 4, 5]
      result = run_sort(&Sorting.quick_sort/2, numbers)
      assert result == [1, 2, 3, 4, 5]
    end

    test "handles list with all same elements" do
      numbers = [5, 5, 5, 5, 5]
      result = run_sort(&Sorting.quick_sort/2, numbers)
      assert result == [5, 5, 5, 5, 5]
    end
  end

  describe "quick3_sort/2" do
    test "sorts an unsorted list" do
      numbers = [4, 9, 4, 4, 1, 9, 4, 4, 9, 4]
      result = run_sort(&Sorting.quick3_sort/2, numbers)
      assert result == [1, 4, 4, 4, 4, 4, 4, 9, 9, 9]
    end

    test "handles many duplicates efficiently" do
      numbers = [2, 2, 2, 1, 1, 1, 3, 3, 3]
      result = run_sort(&Sorting.quick3_sort/2, numbers)
      assert result == [1, 1, 1, 2, 2, 2, 3, 3, 3]
    end

    test "handles two unique values" do
      numbers = [1, 0, 1, 0, 1, 0]
      result = run_sort(&Sorting.quick3_sort/2, numbers)
      assert result == [0, 0, 0, 1, 1, 1]
    end
  end

  describe "generate_random_numbers/2" do
    test "generates correct count of numbers" do
      result = Sorting.generate_random_numbers(10, 100)
      assert length(result) == 10
    end

    test "generates numbers within range" do
      result = Sorting.generate_random_numbers(100, 50)
      assert Enum.all?(result, &(&1 >= 1 and &1 <= 50))
    end
  end

  describe "count_operations/2" do
    test "counts operations for bubble sort" do
      numbers = [5, 3, 8, 4, 2]
      ops = Sorting.count_operations(numbers, "bubble")
      assert is_integer(ops)
      assert ops > 0
    end

    test "counts operations for all algorithms" do
      numbers = [5, 3, 8, 4, 2]

      algorithms = ~w(insertion selection bubble shell merge heap quick quick3)

      for algo <- algorithms do
        ops = Sorting.count_operations(numbers, algo)
        assert is_integer(ops), "#{algo} should return integer ops"
        assert ops > 0, "#{algo} should have positive ops"
      end
    end

    test "sorted list has fewer operations for insertion sort" do
      sorted = [1, 2, 3, 4, 5]
      unsorted = [5, 4, 3, 2, 1]

      sorted_ops = Sorting.count_operations(sorted, "insertion")
      unsorted_ops = Sorting.count_operations(unsorted, "insertion")

      assert sorted_ops < unsorted_ops
    end
  end

  describe "callback behavior" do
    test "bubble sort calls callback with correct events" do
      numbers = [3, 1, 2]
      events = collect_events(&Sorting.bubble_sort/2, numbers)

      assert Enum.any?(events, fn
        {:compare, _, _, _, _} -> true
        _ -> false
      end)

      assert Enum.any?(events, fn
        {:step, _, _, _, _} -> true
        _ -> false
      end)

      assert List.last(events) |> elem(0) == :done
    end

    test "all algorithms emit done event with sorted list" do
      numbers = [5, 3, 1, 4, 2]
      sorted = [1, 2, 3, 4, 5]

      algorithms = [
        &Sorting.bubble_sort/2,
        &Sorting.selection_sort/2,
        &Sorting.insertion_sort/2,
        &Sorting.shell_sort/2,
        &Sorting.merge_sort/2,
        &Sorting.heap_sort/2,
        &Sorting.quick_sort/2,
        &Sorting.quick3_sort/2
      ]

      for algo <- algorithms do
        events = collect_events(algo, numbers)
        {:done, result, _ops} = List.last(events)
        assert result == sorted, "Algorithm #{inspect(algo)} should produce sorted list"
      end
    end

    test "operations count increases with each step" do
      numbers = [4, 2, 3, 1]
      events = collect_events(&Sorting.bubble_sort/2, numbers)

      ops_sequence =
        events
        |> Enum.filter(fn
          {:compare, _, _, _, _} -> true
          {:step, _, _, _, _} -> true
          _ -> false
        end)
        |> Enum.map(&elem(&1, 4))

      # Operations should be monotonically increasing
      assert ops_sequence == Enum.sort(ops_sequence)
    end
  end

  # Helper functions

  defp run_sort(sort_fn, numbers) do
    result_ref = make_ref()
    parent = self()

    callback = fn
      {:done, sorted, _ops} -> send(parent, {result_ref, sorted})
      _ -> :ok
    end

    sort_fn.(numbers, callback)

    receive do
      {^result_ref, sorted} -> sorted
    after
      5000 -> raise "Sorting timed out"
    end
  end

  defp collect_events(sort_fn, numbers) do
    events_ref = make_ref()
    parent = self()

    {:ok, agent} = Agent.start_link(fn -> [] end)

    callback = fn event ->
      Agent.update(agent, &[event | &1])

      case event do
        {:done, _, _} -> send(parent, {events_ref, :done})
        _ -> :ok
      end
    end

    sort_fn.(numbers, callback)

    receive do
      {^events_ref, :done} -> :ok
    after
      5000 -> raise "Sorting timed out"
    end

    events = Agent.get(agent, & &1) |> Enum.reverse()
    Agent.stop(agent)
    events
  end
end
