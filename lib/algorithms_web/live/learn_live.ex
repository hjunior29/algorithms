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
      complexity_worst: "O(n²)",
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

              <!-- Code Implementation -->
              <div class="card" id={"code-card-#{@selected.id}"} phx-hook="HighlightCode">
                  <h3 class="card-title text-xl mb-4">{gettext("Implementation")}</h3>
                  <div role="tablist" class="tabs tabs-boxed bg-base-300 mb-4 rounded-xl">
                    <%= for {{lang, label}, index} <- Enum.with_index(code_languages()) do %>
                      <input
                        type="radio"
                        name={"code_tabs_#{@selected.id}"}
                        role="tab"
                        class="tab"
                        aria-label={label}
                        checked={index == 0}
                      />
                      <div role="tabpanel" class="tab-content p-0 mt-4">
                        <pre class="rounded-b-xl !m-0 overflow-hidden"><code class={"language-#{lang}"}>{String.trim(algorithm_code(@selected.id)[lang])}</code></pre>
                      </div>
                    <% end %>
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

  # Code implementations for each algorithm
  defp algorithm_code("insertion") do
    %{
      "python" => """
def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    return arr
""",
      "javascript" => """
function insertionSort(arr) {
    for (let i = 1; i < arr.length; i++) {
        let key = arr[i];
        let j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
    return arr;
}
""",
      "go" => """
func insertionSort(arr []int) []int {
    for i := 1; i < len(arr); i++ {
        key := arr[i]
        j := i - 1
        for j >= 0 && arr[j] > key {
            arr[j+1] = arr[j]
            j--
        }
        arr[j+1] = key
    }
    return arr
}
""",
      "rust" => """
fn insertion_sort<T: Ord>(arr: &mut [T]) {
    for i in 1..arr.len() {
        let mut j = i;
        while j > 0 && arr[j - 1] > arr[j] {
            arr.swap(j - 1, j);
            j -= 1;
        }
    }
}
"""
    }
  end

  defp algorithm_code("selection") do
    %{
      "python" => """
def selection_sort(arr):
    n = len(arr)
    for i in range(n):
        min_idx = i
        for j in range(i + 1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr
""",
      "javascript" => """
function selectionSort(arr) {
    const n = arr.length;
    for (let i = 0; i < n; i++) {
        let minIdx = i;
        for (let j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        [arr[i], arr[minIdx]] = [arr[minIdx], arr[i]];
    }
    return arr;
}
""",
      "go" => """
func selectionSort(arr []int) []int {
    n := len(arr)
    for i := 0; i < n; i++ {
        minIdx := i
        for j := i + 1; j < n; j++ {
            if arr[j] < arr[minIdx] {
                minIdx = j
            }
        }
        arr[i], arr[minIdx] = arr[minIdx], arr[i]
    }
    return arr
}
""",
      "rust" => """
fn selection_sort<T: Ord>(arr: &mut [T]) {
    let n = arr.len();
    for i in 0..n {
        let min_idx = (i..n)
            .min_by_key(|&j| &arr[j])
            .unwrap();
        arr.swap(i, min_idx);
    }
}
"""
    }
  end

  defp algorithm_code("bubble") do
    %{
      "python" => """
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr
""",
      "javascript" => """
function bubbleSort(arr) {
    const n = arr.length;
    for (let i = 0; i < n; i++) {
        let swapped = false;
        for (let j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
                swapped = true;
            }
        }
        if (!swapped) break;
    }
    return arr;
}
""",
      "go" => """
func bubbleSort(arr []int) []int {
    n := len(arr)
    for i := 0; i < n; i++ {
        swapped := false
        for j := 0; j < n-i-1; j++ {
            if arr[j] > arr[j+1] {
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = true
            }
        }
        if !swapped {
            break
        }
    }
    return arr
}
""",
      "rust" => """
fn bubble_sort<T: Ord>(arr: &mut [T]) {
    let n = arr.len();
    for i in 0..n {
        let mut swapped = false;
        for j in 0..n - i - 1 {
            if arr[j] > arr[j + 1] {
                arr.swap(j, j + 1);
                swapped = true;
            }
        }
        if !swapped { break; }
    }
}
"""
    }
  end

  defp algorithm_code("shell") do
    %{
      "python" => """
def shell_sort(arr):
    n = len(arr)
    gap = n // 2
    while gap > 0:
        for i in range(gap, n):
            temp = arr[i]
            j = i
            while j >= gap and arr[j - gap] > temp:
                arr[j] = arr[j - gap]
                j -= gap
            arr[j] = temp
        gap //= 2
    return arr
""",
      "javascript" => """
function shellSort(arr) {
    const n = arr.length;
    let gap = Math.floor(n / 2);
    while (gap > 0) {
        for (let i = gap; i < n; i++) {
            let temp = arr[i];
            let j = i;
            while (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap];
                j -= gap;
            }
            arr[j] = temp;
        }
        gap = Math.floor(gap / 2);
    }
    return arr;
}
""",
      "go" => """
func shellSort(arr []int) []int {
    n := len(arr)
    gap := n / 2
    for gap > 0 {
        for i := gap; i < n; i++ {
            temp := arr[i]
            j := i
            for j >= gap && arr[j-gap] > temp {
                arr[j] = arr[j-gap]
                j -= gap
            }
            arr[j] = temp
        }
        gap /= 2
    }
    return arr
}
""",
      "rust" => """
fn shell_sort<T: Ord + Copy>(arr: &mut [T]) {
    let n = arr.len();
    let mut gap = n / 2;
    while gap > 0 {
        for i in gap..n {
            let temp = arr[i];
            let mut j = i;
            while j >= gap && arr[j - gap] > temp {
                arr[j] = arr[j - gap];
                j -= gap;
            }
            arr[j] = temp;
        }
        gap /= 2;
    }
}
"""
    }
  end

  defp algorithm_code("merge") do
    %{
      "python" => """
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
""",
      "javascript" => """
function mergeSort(arr) {
    if (arr.length <= 1) return arr;
    const mid = Math.floor(arr.length / 2);
    const left = mergeSort(arr.slice(0, mid));
    const right = mergeSort(arr.slice(mid));
    return merge(left, right);
}

function merge(left, right) {
    const result = [];
    let i = 0, j = 0;
    while (i < left.length && j < right.length) {
        if (left[i] <= right[j]) {
            result.push(left[i++]);
        } else {
            result.push(right[j++]);
        }
    }
    return result.concat(left.slice(i), right.slice(j));
}
""",
      "go" => """
func mergeSort(arr []int) []int {
    if len(arr) <= 1 {
        return arr
    }
    mid := len(arr) / 2
    left := mergeSort(arr[:mid])
    right := mergeSort(arr[mid:])
    return merge(left, right)
}

func merge(left, right []int) []int {
    result := make([]int, 0, len(left)+len(right))
    i, j := 0, 0
    for i < len(left) && j < len(right) {
        if left[i] <= right[j] {
            result = append(result, left[i])
            i++
        } else {
            result = append(result, right[j])
            j++
        }
    }
    result = append(result, left[i:]...)
    result = append(result, right[j:]...)
    return result
}
""",
      "rust" => """
fn merge_sort<T: Ord + Clone>(arr: &[T]) -> Vec<T> {
    if arr.len() <= 1 {
        return arr.to_vec();
    }
    let mid = arr.len() / 2;
    let left = merge_sort(&arr[..mid]);
    let right = merge_sort(&arr[mid..]);
    merge(&left, &right)
}

fn merge<T: Ord + Clone>(left: &[T], right: &[T]) -> Vec<T> {
    let mut result = Vec::with_capacity(left.len() + right.len());
    let (mut i, mut j) = (0, 0);
    while i < left.len() && j < right.len() {
        if left[i] <= right[j] {
            result.push(left[i].clone());
            i += 1;
        } else {
            result.push(right[j].clone());
            j += 1;
        }
    }
    result.extend_from_slice(&left[i..]);
    result.extend_from_slice(&right[j..]);
    result
}
"""
    }
  end

  defp algorithm_code("heap") do
    %{
      "python" => """
def heap_sort(arr):
    n = len(arr)
    for i in range(n // 2 - 1, -1, -1):
        heapify(arr, n, i)
    for i in range(n - 1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        heapify(arr, i, 0)
    return arr

def heapify(arr, n, i):
    largest = i
    left, right = 2 * i + 1, 2 * i + 2
    if left < n and arr[left] > arr[largest]:
        largest = left
    if right < n and arr[right] > arr[largest]:
        largest = right
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]
        heapify(arr, n, largest)
""",
      "javascript" => """
function heapSort(arr) {
    const n = arr.length;
    for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }
    for (let i = n - 1; i > 0; i--) {
        [arr[0], arr[i]] = [arr[i], arr[0]];
        heapify(arr, i, 0);
    }
    return arr;
}

function heapify(arr, n, i) {
    let largest = i;
    const left = 2 * i + 1, right = 2 * i + 2;
    if (left < n && arr[left] > arr[largest]) largest = left;
    if (right < n && arr[right] > arr[largest]) largest = right;
    if (largest !== i) {
        [arr[i], arr[largest]] = [arr[largest], arr[i]];
        heapify(arr, n, largest);
    }
}
""",
      "go" => """
func heapSort(arr []int) []int {
    n := len(arr)
    for i := n/2 - 1; i >= 0; i-- {
        heapify(arr, n, i)
    }
    for i := n - 1; i > 0; i-- {
        arr[0], arr[i] = arr[i], arr[0]
        heapify(arr, i, 0)
    }
    return arr
}

func heapify(arr []int, n, i int) {
    largest := i
    left, right := 2*i+1, 2*i+2
    if left < n && arr[left] > arr[largest] {
        largest = left
    }
    if right < n && arr[right] > arr[largest] {
        largest = right
    }
    if largest != i {
        arr[i], arr[largest] = arr[largest], arr[i]
        heapify(arr, n, largest)
    }
}
""",
      "rust" => """
fn heap_sort<T: Ord>(arr: &mut [T]) {
    let n = arr.len();
    for i in (0..n / 2).rev() {
        heapify(arr, n, i);
    }
    for i in (1..n).rev() {
        arr.swap(0, i);
        heapify(arr, i, 0);
    }
}

fn heapify<T: Ord>(arr: &mut [T], n: usize, i: usize) {
    let mut largest = i;
    let left = 2 * i + 1;
    let right = 2 * i + 2;
    if left < n && arr[left] > arr[largest] { largest = left; }
    if right < n && arr[right] > arr[largest] { largest = right; }
    if largest != i {
        arr.swap(i, largest);
        heapify(arr, n, largest);
    }
}
"""
    }
  end

  defp algorithm_code("quick") do
    %{
      "python" => """
def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)
""",
      "javascript" => """
function quickSort(arr) {
    if (arr.length <= 1) return arr;
    const pivot = arr[Math.floor(arr.length / 2)];
    const left = arr.filter(x => x < pivot);
    const middle = arr.filter(x => x === pivot);
    const right = arr.filter(x => x > pivot);
    return [...quickSort(left), ...middle, ...quickSort(right)];
}
""",
      "go" => """
func quickSort(arr []int) []int {
    if len(arr) <= 1 {
        return arr
    }
    pivot := arr[len(arr)/2]
    var left, middle, right []int
    for _, x := range arr {
        switch {
        case x < pivot:
            left = append(left, x)
        case x == pivot:
            middle = append(middle, x)
        default:
            right = append(right, x)
        }
    }
    result := quickSort(left)
    result = append(result, middle...)
    result = append(result, quickSort(right)...)
    return result
}
""",
      "rust" => """
fn quick_sort<T: Ord + Clone>(arr: &[T]) -> Vec<T> {
    if arr.len() <= 1 {
        return arr.to_vec();
    }
    let pivot = arr[arr.len() / 2].clone();
    let left: Vec<_> = arr.iter().filter(|x| **x < pivot).cloned().collect();
    let middle: Vec<_> = arr.iter().filter(|x| **x == pivot).cloned().collect();
    let right: Vec<_> = arr.iter().filter(|x| **x > pivot).cloned().collect();
    [quick_sort(&left), middle, quick_sort(&right)].concat()
}
"""
    }
  end

  defp algorithm_code("quick3") do
    %{
      "python" => """
def quick3_sort(arr, lo=0, hi=None):
    if hi is None:
        hi = len(arr) - 1
    if lo >= hi:
        return arr
    lt, gt = lo, hi
    pivot = arr[lo]
    i = lo + 1
    while i <= gt:
        if arr[i] < pivot:
            arr[lt], arr[i] = arr[i], arr[lt]
            lt += 1
            i += 1
        elif arr[i] > pivot:
            arr[gt], arr[i] = arr[i], arr[gt]
            gt -= 1
        else:
            i += 1
    quick3_sort(arr, lo, lt - 1)
    quick3_sort(arr, gt + 1, hi)
    return arr
""",
      "javascript" => """
function quick3Sort(arr, lo = 0, hi = arr.length - 1) {
    if (lo >= hi) return arr;
    let lt = lo, gt = hi, i = lo + 1;
    const pivot = arr[lo];
    while (i <= gt) {
        if (arr[i] < pivot) {
            [arr[lt], arr[i]] = [arr[i], arr[lt]];
            lt++; i++;
        } else if (arr[i] > pivot) {
            [arr[gt], arr[i]] = [arr[i], arr[gt]];
            gt--;
        } else {
            i++;
        }
    }
    quick3Sort(arr, lo, lt - 1);
    quick3Sort(arr, gt + 1, hi);
    return arr;
}
""",
      "go" => """
func quick3Sort(arr []int, lo, hi int) {
    if lo >= hi {
        return
    }
    lt, gt, i := lo, hi, lo+1
    pivot := arr[lo]
    for i <= gt {
        switch {
        case arr[i] < pivot:
            arr[lt], arr[i] = arr[i], arr[lt]
            lt++
            i++
        case arr[i] > pivot:
            arr[gt], arr[i] = arr[i], arr[gt]
            gt--
        default:
            i++
        }
    }
    quick3Sort(arr, lo, lt-1)
    quick3Sort(arr, gt+1, hi)
}
""",
      "rust" => """
fn quick3_sort<T: Ord>(arr: &mut [T]) {
    if arr.len() <= 1 { return; }
    let (mut lt, mut gt, mut i) = (0, arr.len() - 1, 1);
    while i <= gt {
        match arr[i].cmp(&arr[lt]) {
            std::cmp::Ordering::Less => {
                arr.swap(lt, i);
                lt += 1;
                i += 1;
            }
            std::cmp::Ordering::Greater => {
                arr.swap(i, gt);
                gt -= 1;
            }
            std::cmp::Ordering::Equal => i += 1,
        }
    }
    quick3_sort(&mut arr[..lt]);
    if gt + 1 < arr.len() {
        quick3_sort(&mut arr[gt + 1..]);
    }
}
"""
    }
  end

  # Supported languages with display names
  defp code_languages do
    [
      {"python", "Python"},
      {"javascript", "JavaScript"},
      {"go", "Go"},
      {"rust", "Rust"}
    ]
  end
end
