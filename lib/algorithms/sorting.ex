defmodule Algorithms.Sorting do
  def bubble_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    do_bubble_sort(list, n, 0, callback)
  end

  defp do_bubble_sort(numbers, n, ops, callback) when n <= 1 do
    callback.({:done, numbers, ops})
  end

  defp do_bubble_sort(numbers, n, ops, callback) do
    {new_numbers, swapped, new_ops} = bubble_pass(numbers, 0, n - 1, false, ops, callback)

    if swapped do
      do_bubble_sort(new_numbers, n - 1, new_ops, callback)
    else
      callback.({:done, new_numbers, new_ops})
    end
  end

  defp bubble_pass(numbers, i, limit, swapped, ops, _callback) when i >= limit do
    {numbers, swapped, ops}
  end

  defp bubble_pass(numbers, i, limit, swapped, ops, callback) do
    a = Enum.at(numbers, i)
    b = Enum.at(numbers, i + 1)

    if a > b do
      new_numbers = swap(numbers, i, i + 1)
      callback.({:step, new_numbers, i, i + 1, ops + 1})
      bubble_pass(new_numbers, i + 1, limit, true, ops + 1, callback)
    else
      callback.({:compare, numbers, i, i + 1, ops + 1})
      bubble_pass(numbers, i + 1, limit, swapped, ops + 1, callback)
    end
  end

  def selection_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    do_selection_sort(list, 0, length(list), 0, callback)
  end

  defp do_selection_sort(numbers, i, n, ops, callback) when i >= n - 1 do
    callback.({:done, numbers, ops})
  end

  defp do_selection_sort(numbers, i, n, ops, callback) do
    {min_idx, new_ops} = find_min(numbers, i, i, i + 1, n, ops, callback)

    if min_idx != i do
      new_numbers = swap(numbers, i, min_idx)
      callback.({:step, new_numbers, i, min_idx, new_ops + 1})
      do_selection_sort(new_numbers, i + 1, n, new_ops + 1, callback)
    else
      do_selection_sort(numbers, i + 1, n, new_ops, callback)
    end
  end

  defp find_min(_numbers, _start, min_idx, j, n, ops, _callback) when j >= n do
    {min_idx, ops}
  end

  defp find_min(numbers, start, min_idx, j, n, ops, callback) do
    callback.({:compare, numbers, min_idx, j, ops + 1})

    new_min = if Enum.at(numbers, j) < Enum.at(numbers, min_idx), do: j, else: min_idx
    find_min(numbers, start, new_min, j + 1, n, ops + 1, callback)
  end

  def insertion_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    do_insertion_sort(list, 1, length(list), 0, callback)
  end

  defp do_insertion_sort(numbers, i, n, ops, callback) when i >= n do
    callback.({:done, numbers, ops})
  end

  defp do_insertion_sort(numbers, i, n, ops, callback) do
    {new_numbers, new_ops} = insert(numbers, i, ops, callback)
    do_insertion_sort(new_numbers, i + 1, n, new_ops, callback)
  end

  defp insert(numbers, 0, ops, _callback) do
    {numbers, ops}
  end

  defp insert(numbers, i, ops, callback) do
    current = Enum.at(numbers, i)
    prev = Enum.at(numbers, i - 1)

    callback.({:compare, numbers, i - 1, i, ops + 1})

    if prev > current do
      new_numbers = swap(numbers, i - 1, i)
      callback.({:step, new_numbers, i - 1, i, ops + 1})
      insert(new_numbers, i - 1, ops + 1, callback)
    else
      {numbers, ops + 1}
    end
  end

  defp swap(list, i, j) do
    val_i = Enum.at(list, i)
    val_j = Enum.at(list, j)

    list
    |> List.replace_at(i, val_j)
    |> List.replace_at(j, val_i)
  end

  # Shell Sort
  def shell_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    gaps = generate_gaps(n)
    do_shell_sort(list, gaps, n, 0, callback)
  end

  defp generate_gaps(n) do
    Stream.iterate(1, &(&1 * 3 + 1))
    |> Enum.take_while(&(&1 < n))
    |> Enum.reverse()
  end

  defp do_shell_sort(numbers, [], _n, ops, callback) do
    callback.({:done, numbers, ops})
  end

  defp do_shell_sort(numbers, [gap | rest_gaps], n, ops, callback) do
    {new_numbers, new_ops} = shell_gap_pass(numbers, gap, gap, n, ops, callback)
    do_shell_sort(new_numbers, rest_gaps, n, new_ops, callback)
  end

  defp shell_gap_pass(numbers, _gap, i, n, ops, _callback) when i >= n do
    {numbers, ops}
  end

  defp shell_gap_pass(numbers, gap, i, n, ops, callback) do
    {new_numbers, new_ops} = shell_insert(numbers, i, gap, ops, callback)
    shell_gap_pass(new_numbers, gap, i + 1, n, new_ops, callback)
  end

  defp shell_insert(numbers, i, gap, ops, _callback) when i < gap do
    {numbers, ops}
  end

  defp shell_insert(numbers, i, gap, ops, callback) do
    current = Enum.at(numbers, i)
    prev_idx = i - gap
    prev = Enum.at(numbers, prev_idx)

    callback.({:compare, numbers, prev_idx, i, ops + 1})

    if prev > current do
      new_numbers = swap(numbers, prev_idx, i)
      callback.({:step, new_numbers, prev_idx, i, ops + 1})
      shell_insert(new_numbers, prev_idx, gap, ops + 1, callback)
    else
      {numbers, ops + 1}
    end
  end

  # Merge Sort
  def merge_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    {sorted, ops} = do_merge_sort(list, 0, n - 1, 0, callback)
    callback.({:done, sorted, ops})
  end

  defp do_merge_sort(numbers, left, right, ops, _callback) when left >= right do
    {numbers, ops}
  end

  defp do_merge_sort(numbers, left, right, ops, callback) do
    mid = div(left + right, 2)
    {numbers1, ops1} = do_merge_sort(numbers, left, mid, ops, callback)
    {numbers2, ops2} = do_merge_sort(numbers1, mid + 1, right, ops1, callback)
    merge(numbers2, left, mid, right, ops2, callback)
  end

  defp merge(numbers, left, mid, right, ops, callback) do
    left_part = Enum.slice(numbers, left..(mid))
    right_part = Enum.slice(numbers, (mid + 1)..right)
    do_merge(numbers, left_part, right_part, left, ops, callback)
  end

  defp do_merge(numbers, [], [], _idx, ops, _callback) do
    {numbers, ops}
  end

  defp do_merge(numbers, [], [h | t], idx, ops, callback) do
    new_numbers = List.replace_at(numbers, idx, h)
    callback.({:step, new_numbers, idx, idx, ops + 1})
    do_merge(new_numbers, [], t, idx + 1, ops + 1, callback)
  end

  defp do_merge(numbers, [h | t], [], idx, ops, callback) do
    new_numbers = List.replace_at(numbers, idx, h)
    callback.({:step, new_numbers, idx, idx, ops + 1})
    do_merge(new_numbers, t, [], idx + 1, ops + 1, callback)
  end

  defp do_merge(numbers, [lh | lt] = left, [rh | rt] = right, idx, ops, callback) do
    callback.({:compare, numbers, idx, idx, ops + 1})

    if lh <= rh do
      new_numbers = List.replace_at(numbers, idx, lh)
      callback.({:step, new_numbers, idx, idx, ops + 1})
      do_merge(new_numbers, lt, right, idx + 1, ops + 1, callback)
    else
      new_numbers = List.replace_at(numbers, idx, rh)
      callback.({:step, new_numbers, idx, idx, ops + 1})
      do_merge(new_numbers, left, rt, idx + 1, ops + 1, callback)
    end
  end

  # Heap Sort
  def heap_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    {heapified, ops1} = build_heap(list, n, 0, callback)
    {sorted, ops2} = extract_heap(heapified, n - 1, ops1, callback)
    callback.({:done, sorted, ops2})
  end

  defp build_heap(numbers, n, ops, callback) do
    start_idx = div(n, 2) - 1
    do_build_heap(numbers, start_idx, n, ops, callback)
  end

  defp do_build_heap(numbers, i, _n, ops, _callback) when i < 0 do
    {numbers, ops}
  end

  defp do_build_heap(numbers, i, n, ops, callback) do
    {heapified, new_ops} = heapify(numbers, n, i, ops, callback)
    do_build_heap(heapified, i - 1, n, new_ops, callback)
  end

  defp heapify(numbers, n, i, ops, callback) do
    largest = i
    left = 2 * i + 1
    right = 2 * i + 2

    {largest, ops1} =
      if left < n do
        callback.({:compare, numbers, largest, left, ops + 1})
        if Enum.at(numbers, left) > Enum.at(numbers, largest) do
          {left, ops + 1}
        else
          {largest, ops + 1}
        end
      else
        {largest, ops}
      end

    {largest, ops2} =
      if right < n do
        callback.({:compare, numbers, largest, right, ops1 + 1})
        if Enum.at(numbers, right) > Enum.at(numbers, largest) do
          {right, ops1 + 1}
        else
          {largest, ops1 + 1}
        end
      else
        {largest, ops1}
      end

    if largest != i do
      new_numbers = swap(numbers, i, largest)
      callback.({:step, new_numbers, i, largest, ops2 + 1})
      heapify(new_numbers, n, largest, ops2 + 1, callback)
    else
      {numbers, ops2}
    end
  end

  defp extract_heap(numbers, i, ops, _callback) when i < 0 do
    {numbers, ops}
  end

  defp extract_heap(numbers, i, ops, callback) do
    new_numbers = swap(numbers, 0, i)
    callback.({:step, new_numbers, 0, i, ops + 1})
    {heapified, new_ops} = heapify(new_numbers, i, 0, ops + 1, callback)
    extract_heap(heapified, i - 1, new_ops, callback)
  end

  # Quick Sort
  def quick_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    {sorted, ops} = do_quick_sort(list, 0, n - 1, 0, callback)
    callback.({:done, sorted, ops})
  end

  defp do_quick_sort(numbers, low, high, ops, _callback) when low >= high do
    {numbers, ops}
  end

  defp do_quick_sort(numbers, low, high, ops, callback) do
    {partitioned, pivot_idx, ops1} = partition(numbers, low, high, ops, callback)
    {left_sorted, ops2} = do_quick_sort(partitioned, low, pivot_idx - 1, ops1, callback)
    do_quick_sort(left_sorted, pivot_idx + 1, high, ops2, callback)
  end

  defp partition(numbers, low, high, ops, callback) do
    pivot = Enum.at(numbers, high)
    do_partition(numbers, low, low, high, pivot, ops, callback)
  end

  defp do_partition(numbers, i, j, high, _pivot, ops, _callback) when j >= high do
    new_numbers = swap(numbers, i, high)
    {new_numbers, i, ops + 1}
  end

  defp do_partition(numbers, i, j, high, pivot, ops, callback) do
    callback.({:compare, numbers, j, high, ops + 1})

    if Enum.at(numbers, j) < pivot do
      new_numbers = swap(numbers, i, j)
      callback.({:step, new_numbers, i, j, ops + 1})
      do_partition(new_numbers, i + 1, j + 1, high, pivot, ops + 1, callback)
    else
      do_partition(numbers, i, j + 1, high, pivot, ops + 1, callback)
    end
  end

  # Quick3 (3-way QuickSort / Dutch National Flag partitioning)
  def quick3_sort(numbers, callback) do
    list = Enum.to_list(numbers)
    n = length(list)
    {sorted, ops} = do_quick3_sort(list, 0, n - 1, 0, callback)
    callback.({:done, sorted, ops})
  end

  defp do_quick3_sort(numbers, low, high, ops, _callback) when low >= high do
    {numbers, ops}
  end

  defp do_quick3_sort(numbers, low, high, ops, callback) do
    {partitioned, lt, gt, ops1} = partition3(numbers, low, high, ops, callback)
    {left_sorted, ops2} = do_quick3_sort(partitioned, low, lt - 1, ops1, callback)
    do_quick3_sort(left_sorted, gt + 1, high, ops2, callback)
  end

  defp partition3(numbers, low, high, ops, callback) do
    pivot = Enum.at(numbers, low)
    do_partition3(numbers, low, low, high, pivot, ops, callback)
  end

  defp do_partition3(numbers, lt, i, gt, _pivot, ops, _callback) when i > gt do
    {numbers, lt, gt, ops}
  end

  defp do_partition3(numbers, lt, i, gt, pivot, ops, callback) do
    current = Enum.at(numbers, i)
    callback.({:compare, numbers, i, lt, ops + 1})

    cond do
      current < pivot ->
        new_numbers = swap(numbers, lt, i)
        callback.({:step, new_numbers, lt, i, ops + 1})
        do_partition3(new_numbers, lt + 1, i + 1, gt, pivot, ops + 1, callback)

      current > pivot ->
        new_numbers = swap(numbers, i, gt)
        callback.({:step, new_numbers, i, gt, ops + 1})
        do_partition3(new_numbers, lt, i, gt - 1, pivot, ops + 1, callback)

      true ->
        do_partition3(numbers, lt, i + 1, gt, pivot, ops + 1, callback)
    end
  end

  def generate_random_numbers(count, max_value) do
    Enum.map(1..count, fn _ -> :rand.uniform(max_value) end)
  end
end
