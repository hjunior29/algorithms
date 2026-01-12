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

  def generate_random_numbers(count, max_value) do
    Enum.map(1..count, fn _ -> :rand.uniform(max_value) end)
  end
end
