defmodule AlgorithmsWeb.LearnLive do
  use AlgorithmsWeb, :live_view

  @algorithms [
    %{
      id: "insertion",
      name: "Insertion Sort",
      complexity_best: "O(n)",
      complexity_avg: "O(n²)",
      complexity_worst: "O(n²)",
      space: "O(1)",
      stable: true,
      color: "primary"
    },
    %{
      id: "selection",
      name: "Selection Sort",
      complexity_best: "O(n²)",
      complexity_avg: "O(n²)",
      complexity_worst: "O(n²)",
      space: "O(1)",
      stable: false,
      color: "success"
    },
    %{
      id: "bubble",
      name: "Bubble Sort",
      complexity_best: "O(n)",
      complexity_avg: "O(n²)",
      complexity_worst: "O(n²)",
      space: "O(1)",
      stable: true,
      color: "warning"
    },
    %{
      id: "shell",
      name: "Shell Sort",
      complexity_best: "O(n log n)",
      complexity_avg: "O(n^1.3)",
      complexity_worst: "O(n²)",
      space: "O(1)",
      stable: false,
      color: "secondary"
    },
    %{
      id: "merge",
      name: "Merge Sort",
      complexity_best: "O(n log n)",
      complexity_avg: "O(n log n)",
      complexity_worst: "O(n log n)",
      space: "O(n)",
      stable: true,
      color: "info"
    },
    %{
      id: "heap",
      name: "Heap Sort",
      complexity_best: "O(n log n)",
      complexity_avg: "O(n log n)",
      complexity_worst: "O(n log n)",
      space: "O(1)",
      stable: false,
      color: "error"
    },
    %{
      id: "quick",
      name: "Quick Sort",
      complexity_best: "O(n log n)",
      complexity_avg: "O(n log n)",
      complexity_worst: "O(n²)",
      space: "O(log n)",
      stable: false,
      color: "warning"
    },
    %{
      id: "quick3",
      name: "Quick3 Sort",
      complexity_best: "O(n)",
      complexity_avg: "O(n log n)",
      complexity_worst: "O(n log n)",
      space: "O(log n)",
      stable: false,
      color: "secondary"
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       algorithms: @algorithms,
       selected: nil,
       page_title: gettext("Learn")
     )}
  end

  def handle_params(%{"algorithm" => algo_id}, _uri, socket) do
    algorithm = Enum.find(@algorithms, fn a -> a.id == algo_id end)
    {:noreply, assign(socket, selected: algorithm)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, selected: nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100 text-base-content">
      <.nav_header />

      <div class="max-w-6xl mx-auto px-4 pt-20 pb-12">
        <%= if @selected do %>
          <!-- Algorithm Detail View -->
          <div class="mb-8">
            <.link navigate={~p"/learn"} class="btn btn-ghost btn-sm gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              {gettext("Back to all algorithms")}
            </.link>
          </div>

          <!-- Algorithm Name Header -->
          <div class="text-center mb-12">
            <h1 class="text-4xl sm:text-5xl font-bold mb-4 flex items-center justify-center gap-4">
              {@selected.name}
              <div class={"badge badge-lg badge-#{@selected.color}"}>{@selected.complexity_avg}</div>
            </h1>
          </div>

          <div class="grid lg:grid-cols-3 gap-8">
            <!-- Main Content -->
            <div class="lg:col-span-2 space-y-8">
              <!-- History -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-xl mb-4">{gettext("History")}</h3>
                  <div class="prose prose-sm max-w-none">
                    {raw(algorithm_description(@selected.id))}
                  </div>
                </div>
              </div>

              <!-- How it works -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-xl mb-4">{gettext("How it works")}</h3>
                  <div class="prose prose-sm max-w-none">
                    {raw(algorithm_how_it_works(@selected.id))}
                  </div>
                </div>
              </div>

              <!-- When to use -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-xl mb-4">{gettext("When to use")}</h3>
                  <div class="prose prose-sm max-w-none">
                    {raw(algorithm_when_to_use(@selected.id))}
                  </div>
                </div>
              </div>
            </div>

            <!-- Sidebar -->
            <div class="space-y-6">
              <!-- Complexity Card -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-lg mb-4">{gettext("Complexity")}</h3>
                  <div class="space-y-3">
                    <div class="flex justify-between items-center">
                      <span class="text-base-content/60">{gettext("Best Case")}</span>
                      <span class="font-mono font-semibold text-success">{@selected.complexity_best}</span>
                    </div>
                    <div class="flex justify-between items-center">
                      <span class="text-base-content/60">{gettext("Average Case")}</span>
                      <span class="font-mono font-semibold text-warning">{@selected.complexity_avg}</span>
                    </div>
                    <div class="flex justify-between items-center">
                      <span class="text-base-content/60">{gettext("Worst Case")}</span>
                      <span class="font-mono font-semibold text-error">{@selected.complexity_worst}</span>
                    </div>
                    <div class="divider my-2"></div>
                    <div class="flex justify-between items-center">
                      <span class="text-base-content/60">{gettext("Space")}</span>
                      <span class="font-mono font-semibold">{@selected.space}</span>
                    </div>
                    <div class="flex justify-between items-center">
                      <span class="text-base-content/60">{gettext("Stable")}</span>
                      <span class={"badge badge-sm " <> if(@selected.stable, do: "badge-success", else: "badge-error")}>
                        {if @selected.stable, do: gettext("Yes"), else: gettext("No")}
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Try it -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-lg mb-2">{gettext("Try it yourself")}</h3>
                  <p class="text-base-content/60 text-sm mb-4">
                    {gettext("See this algorithm in action with the visualizer.")}
                  </p>
                  <a href={"/run?algorithm=#{@selected.id}"} class="btn btn-primary btn-block">
                    {gettext("Run")}
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </a>
                </div>
              </div>

              <!-- Other algorithms -->
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body">
                  <h3 class="card-title text-lg mb-4">{gettext("Other algorithms")}</h3>
                  <div class="space-y-2">
                    <%= for algo <- @algorithms, algo.id != @selected.id do %>
                      <.link navigate={~p"/learn/#{algo.id}"} class="btn btn-ghost btn-sm justify-start w-full">
                        <div class={"badge badge-#{algo.color} badge-xs"}></div>
                        {algo.name}
                      </.link>
                    <% end %>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <% else %>
          <!-- Header -->
          <div class="text-center mb-12">
            <h1 class="text-4xl sm:text-5xl font-bold mb-4">{gettext("Learn Sorting Algorithms")}</h1>
            <p class="text-base-content/60 max-w-2xl mx-auto">
              {gettext("Understand the history, complexity, and best use cases for each sorting algorithm.")}
            </p>
          </div>

          <!-- Algorithm Grid -->
          <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <%= for algo <- @algorithms do %>
              <.link navigate={~p"/learn/#{algo.id}"} class="hover-3d">
              <div class="hover-3d">
                <div class="card bg-base-200 border border-base-300 h-full">
                  <div class="card-body">
                    <div class={"badge badge-#{algo.color} mb-2"}>{algo.complexity_avg}</div>
                    <h3 class="card-title">{algo.name}</h3>
                    <p class="text-base-content/60 text-sm">{algorithm_short_desc(algo.id)}</p>
                    <div class="mt-4 flex flex-wrap gap-2">
                      <div class={"badge badge-sm " <> space_badge_class(algo.space)}>
                        {gettext("Space")}: {algo.space}
                      </div>
                      <div class={"badge badge-sm " <> if(algo.stable, do: "badge-success", else: "badge-error")}>
                        {if algo.stable, do: gettext("Stable"), else: gettext("Unstable")}
                      </div>
                    </div>
                  </div>
                </div>
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
              </div>
              </.link>
            <% end %>
          </div>

          <!-- Theoretical Ranking -->
          <div class="mt-16">
            <h2 class="text-2xl font-bold mb-6 text-center">{gettext("Theoretical Ranking")}</h2>
            <div class="overflow-x-auto">
              <table class="table bg-base-200 rounded-lg">
                <thead>
                  <tr class="bg-base-300">
                    <th class="text-base-content">#</th>
                    <th class="text-base-content">{gettext("Algorithm")}</th>
                    <th class="text-center text-base-content">{gettext("Average")}</th>
                    <th class="text-center text-base-content">{gettext("Worst")}</th>
                    <th class="text-center text-base-content">{gettext("Space")}</th>
                    <th class="text-center text-base-content">{gettext("Stable")}</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for {algo, index} <- Enum.with_index(ranked_algorithms(@algorithms), 1) do %>
                    <tr class="hover border-b border-base-300">
                      <td class="font-bold text-lg text-primary">{index}</td>
                      <td>
                        <.link navigate={~p"/learn/#{algo.id}"} class="font-medium hover:text-primary transition-colors">
                          {algo.name}
                        </.link>
                      </td>
                      <td class="text-center">
                        <span class={"badge badge-sm " <> complexity_badge_class(algo.complexity_avg)}>
                          {algo.complexity_avg}
                        </span>
                      </td>
                      <td class="text-center">
                        <span class={"badge badge-sm " <> complexity_badge_class(algo.complexity_worst)}>
                          {algo.complexity_worst}
                        </span>
                      </td>
                      <td class="text-center">
                        <span class={"badge badge-sm " <> space_badge_class(algo.space)}>
                          {algo.space}
                        </span>
                      </td>
                      <td class="text-center">
                        <span class={"badge badge-sm " <> if(algo.stable, do: "badge-success", else: "badge-ghost")}>
                          {if algo.stable, do: gettext("Yes"), else: gettext("No")}
                        </span>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        <% end %>
      </div>

      <.nav_footer />
    </div>
    """
  end

  # Ranking algorithms by theoretical efficiency
  defp ranked_algorithms(algorithms) do
    Enum.sort_by(algorithms, fn algo ->
      {complexity_rank(algo.complexity_avg), complexity_rank(algo.complexity_worst), space_rank(algo.space)}
    end)
  end

  defp complexity_rank("O(n)"), do: 1
  defp complexity_rank("O(n log n)"), do: 2
  defp complexity_rank("O(n^1.3)"), do: 3
  defp complexity_rank("O(n²)"), do: 4
  defp complexity_rank(_), do: 5

  defp space_rank("O(1)"), do: 1
  defp space_rank("O(log n)"), do: 2
  defp space_rank("O(n)"), do: 3
  defp space_rank(_), do: 4

  defp complexity_badge_class("O(n)"), do: "badge-success"
  defp complexity_badge_class("O(n log n)"), do: "badge-info"
  defp complexity_badge_class("O(n^1.3)"), do: "badge-warning"
  defp complexity_badge_class("O(n²)"), do: "badge-error"
  defp complexity_badge_class(_), do: "badge-ghost"

  defp space_badge_class("O(1)"), do: "badge-success"
  defp space_badge_class("O(log n)"), do: "badge-info"
  defp space_badge_class("O(n)"), do: "badge-warning"
  defp space_badge_class(_), do: "badge-ghost"

  # Short descriptions for grid view
  defp algorithm_short_desc("insertion"), do: gettext("Builds sorted array one element at a time.")
  defp algorithm_short_desc("selection"), do: gettext("Finds minimum and moves to sorted portion.")
  defp algorithm_short_desc("bubble"), do: gettext("Swaps adjacent elements repeatedly.")
  defp algorithm_short_desc("shell"), do: gettext("Insertion sort with diminishing gaps.")
  defp algorithm_short_desc("merge"), do: gettext("Divide and conquer with merging.")
  defp algorithm_short_desc("heap"), do: gettext("Uses binary heap data structure.")
  defp algorithm_short_desc("quick"), do: gettext("Partition around pivot element.")
  defp algorithm_short_desc("quick3"), do: gettext("3-way partitioning for duplicates.")

  # Full descriptions
  defp algorithm_description("insertion") do
    """
    <p><strong>Insertion Sort</strong> #{gettext("is one of the simplest sorting algorithms. It was developed based on how people typically sort playing cards in their hands.")}</p>
    <p>#{gettext("The algorithm was first described by John Mauchly in 1946, making it one of the earliest sorting algorithms to be formally analyzed.")}</p>
    <p>#{gettext("Despite its O(n²) average complexity, it remains widely used due to its simplicity, low overhead, and excellent performance on small or nearly sorted datasets.")}</p>
    """
  end

  defp algorithm_description("selection") do
    """
    <p><strong>Selection Sort</strong> #{gettext("is an in-place comparison sorting algorithm. It divides the input into a sorted and unsorted region.")}</p>
    <p>#{gettext("The algorithm was one of the first sorting methods to be formally studied in computer science, appearing in early computing literature in the 1950s.")}</p>
    <p>#{gettext("While not efficient for large datasets, it has the advantage of making the minimum number of swaps (O(n)), which can be useful when memory writes are expensive.")}</p>
    """
  end

  defp algorithm_description("bubble") do
    """
    <p><strong>Bubble Sort</strong> #{gettext("is perhaps the most well-known sorting algorithm, often taught as an introduction to sorting concepts.")}</p>
    <p>#{gettext("The name comes from the way smaller elements 'bubble' to the top of the list. It was analyzed as early as 1956 by mathematician Edward Friend.")}</p>
    <p>#{gettext("Despite being inefficient for most real-world applications, it's valuable for educational purposes and can be optimized with an early termination flag.")}</p>
    """
  end

  defp algorithm_description("shell") do
    """
    <p><strong>Shell Sort</strong> #{gettext("was invented by Donald Shell in 1959. It was one of the first algorithms to break the O(n²) barrier.")}</p>
    <p>#{gettext("The algorithm is a generalization of insertion sort that allows the exchange of items that are far apart, progressively reducing the gap between elements to compare.")}</p>
    <p>#{gettext("The efficiency depends heavily on the gap sequence used. Shell's original sequence gives O(n²), but better sequences can achieve O(n log² n) or better.")}</p>
    """
  end

  defp algorithm_description("merge") do
    """
    <p><strong>Merge Sort</strong> #{gettext("was invented by John von Neumann in 1945. It's one of the most respected sorting algorithms due to its guaranteed O(n log n) performance.")}</p>
    <p>#{gettext("The algorithm uses the divide-and-conquer paradigm: it divides the array in half, recursively sorts each half, then merges the sorted halves.")}</p>
    <p>#{gettext("Merge Sort is stable and predictable, making it ideal for sorting linked lists and external sorting (sorting data that doesn't fit in memory).")}</p>
    """
  end

  defp algorithm_description("heap") do
    """
    <p><strong>Heap Sort</strong> #{gettext("was invented by J. W. J. Williams in 1964. It uses a binary heap data structure to efficiently find and remove the maximum element.")}</p>
    <p>#{gettext("The algorithm first builds a max-heap from the input, then repeatedly extracts the maximum element and rebuilds the heap.")}</p>
    <p>#{gettext("While it has guaranteed O(n log n) complexity and uses O(1) extra space, it typically performs slower than Quick Sort in practice due to poor cache locality.")}</p>
    """
  end

  defp algorithm_description("quick") do
    """
    <p><strong>Quick Sort</strong> #{gettext("was developed by Tony Hoare in 1959 and published in 1961. It's often the fastest sorting algorithm in practice.")}</p>
    <p>#{gettext("The algorithm works by selecting a 'pivot' element and partitioning the array around it, placing smaller elements before and larger elements after.")}</p>
    <p>#{gettext("Despite its O(n²) worst case, careful pivot selection (like median-of-three) makes this scenario extremely rare in practice.")}</p>
    """
  end

  defp algorithm_description("quick3") do
    """
    <p><strong>Quick3 Sort</strong> #{gettext("(3-way Quick Sort) is a variation developed by Dijkstra for handling arrays with many duplicate keys.")}</p>
    <p>#{gettext("Instead of two partitions, it creates three: elements less than, equal to, and greater than the pivot.")}</p>
    <p>#{gettext("This variant was later improved by Bentley and McIlroy (1993) and is now the default sorting algorithm in many standard libraries when duplicates are common.")}</p>
    """
  end

  # How it works
  defp algorithm_how_it_works("insertion") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Start from the second element (index 1)")}</li>
      <li>#{gettext("Compare it with elements before it")}</li>
      <li>#{gettext("Shift larger elements one position ahead")}</li>
      <li>#{gettext("Insert the element at the correct position")}</li>
      <li>#{gettext("Repeat for all remaining elements")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("selection") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Find the minimum element in the unsorted portion")}</li>
      <li>#{gettext("Swap it with the first unsorted element")}</li>
      <li>#{gettext("Move the boundary of sorted portion one element ahead")}</li>
      <li>#{gettext("Repeat until the entire array is sorted")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("bubble") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Compare adjacent elements from the beginning")}</li>
      <li>#{gettext("Swap them if they are in the wrong order")}</li>
      <li>#{gettext("Continue to the end of the array")}</li>
      <li>#{gettext("Repeat passes until no swaps are needed")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("shell") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Start with a large gap (typically n/2)")}</li>
      <li>#{gettext("Compare elements that are 'gap' positions apart")}</li>
      <li>#{gettext("Swap if they are in the wrong order")}</li>
      <li>#{gettext("Reduce the gap (typically by half)")}</li>
      <li>#{gettext("Repeat until gap becomes 1 (final insertion sort)")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("merge") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Divide the array into two halves")}</li>
      <li>#{gettext("Recursively sort each half")}</li>
      <li>#{gettext("Merge the sorted halves by comparing elements")}</li>
      <li>#{gettext("Copy remaining elements from either half")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("heap") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Build a max-heap from the input array")}</li>
      <li>#{gettext("Swap the root (maximum) with the last element")}</li>
      <li>#{gettext("Reduce heap size by one")}</li>
      <li>#{gettext("Heapify the root to restore heap property")}</li>
      <li>#{gettext("Repeat until heap size is 1")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("quick") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Choose a pivot element")}</li>
      <li>#{gettext("Partition: place smaller elements left, larger right")}</li>
      <li>#{gettext("Recursively sort the left partition")}</li>
      <li>#{gettext("Recursively sort the right partition")}</li>
    </ol>
    """
  end

  defp algorithm_how_it_works("quick3") do
    """
    <ol class="list-decimal list-inside space-y-2">
      <li>#{gettext("Choose a pivot element")}</li>
      <li>#{gettext("Partition into three: less than, equal to, greater than pivot")}</li>
      <li>#{gettext("Recursively sort the 'less than' partition")}</li>
      <li>#{gettext("Recursively sort the 'greater than' partition")}</li>
      <li>#{gettext("Elements equal to pivot are already in place")}</li>
    </ol>
    """
  end

  # When to use
  defp algorithm_when_to_use("insertion") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Small datasets")}</strong>: #{gettext("Overhead is minimal for n < 50")}</li>
      <li><strong>#{gettext("Nearly sorted data")}</strong>: #{gettext("Approaches O(n) performance")}</li>
      <li><strong>#{gettext("Online sorting")}</strong>: #{gettext("Can sort data as it arrives")}</li>
      <li><strong>#{gettext("As a subroutine")}</strong>: #{gettext("Used in hybrid algorithms like Timsort")}</li>
    </ul>
    """
  end

  defp algorithm_when_to_use("selection") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Minimal swaps needed")}</strong>: #{gettext("Only O(n) swaps are made")}</li>
      <li><strong>#{gettext("Memory writes are expensive")}</strong>: #{gettext("Like flash memory")}</li>
      <li><strong>#{gettext("Small datasets")}</strong>: #{gettext("Simple implementation")}</li>
      <li><strong>#{gettext("Checking if sorted")}</strong>: #{gettext("Easy to verify correctness")}</li>
    </ul>
    """
  end

  defp algorithm_when_to_use("bubble") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Educational purposes")}</strong>: #{gettext("Easy to understand and implement")}</li>
      <li><strong>#{gettext("Detecting sorted arrays")}</strong>: #{gettext("With early termination optimization")}</li>
      <li><strong>#{gettext("Very small datasets")}</strong>: #{gettext("Where simplicity matters more than speed")}</li>
    </ul>
    <p class="mt-4 text-warning">⚠️ #{gettext("Generally not recommended for production use")}</p>
    """
  end

  defp algorithm_when_to_use("shell") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Medium-sized arrays")}</strong>: #{gettext("Good balance of simplicity and speed")}</li>
      <li><strong>#{gettext("Embedded systems")}</strong>: #{gettext("Low memory overhead, no recursion")}</li>
      <li><strong>#{gettext("When code size matters")}</strong>: #{gettext("Compact implementation")}</li>
      <li><strong>#{gettext("Partially sorted data")}</strong>: #{gettext("Adapts well to existing order")}</li>
    </ul>
    """
  end

  defp algorithm_when_to_use("merge") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Linked lists")}</strong>: #{gettext("No random access needed, O(1) extra space")}</li>
      <li><strong>#{gettext("External sorting")}</strong>: #{gettext("Sorting data larger than memory")}</li>
      <li><strong>#{gettext("Stable sort required")}</strong>: #{gettext("Preserves order of equal elements")}</li>
      <li><strong>#{gettext("Guaranteed performance")}</strong>: #{gettext("Always O(n log n)")}</li>
      <li><strong>#{gettext("Parallel processing")}</strong>: #{gettext("Naturally parallelizable")}</li>
    </ul>
    """
  end

  defp algorithm_when_to_use("heap") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Memory constrained")}</strong>: #{gettext("Only O(1) extra space")}</li>
      <li><strong>#{gettext("Guaranteed O(n log n)")}</strong>: #{gettext("No worst case degradation")}</li>
      <li><strong>#{gettext("Finding k largest/smallest")}</strong>: #{gettext("Partial sorting is efficient")}</li>
      <li><strong>#{gettext("Priority queues")}</strong>: #{gettext("Natural fit for heap operations")}</li>
    </ul>
    """
  end

  defp algorithm_when_to_use("quick") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("General-purpose sorting")}</strong>: #{gettext("Fastest on average")}</li>
      <li><strong>#{gettext("Arrays")}</strong>: #{gettext("Excellent cache performance")}</li>
      <li><strong>#{gettext("When stability not needed")}</strong>: #{gettext("Many practical applications")}</li>
      <li><strong>#{gettext("Large datasets")}</strong>: #{gettext("Scales well with size")}</li>
    </ul>
    <p class="mt-4 text-info">💡 #{gettext("Used as the default sort in C, Java, and many other languages")}</p>
    """
  end

  defp algorithm_when_to_use("quick3") do
    """
    <ul class="list-disc list-inside space-y-2">
      <li><strong>#{gettext("Many duplicate keys")}</strong>: #{gettext("Linear time for all equal elements")}</li>
      <li><strong>#{gettext("Limited key range")}</strong>: #{gettext("Like sorting grades or categories")}</li>
      <li><strong>#{gettext("String sorting")}</strong>: #{gettext("Common prefixes are handled efficiently")}</li>
      <li><strong>#{gettext("General-purpose")}</strong>: #{gettext("As good as Quick Sort, better with duplicates")}</li>
    </ul>
    """
  end
end
