defmodule AlgorithmsWeb.SortingLive do
  use AlgorithmsWeb, :live_view

  alias Algorithms.Sorting

  @default_count 20
  @default_max 100
  @default_delay 100

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       numbers: [],
       original_numbers: [],
       count: @default_count,
       max_value: @default_max,
       delay: @default_delay,
       algorithm: "insertion",
       running: false,
       highlight: {nil, nil},
       operations: 0,
       start_time: nil,
       elapsed_time: nil,
       status: :idle,
       history: [],
       generated_count: @default_count,
       generated_max_value: @default_max,
       initial_delay: @default_delay
     )}
  end

  def handle_event("change_settings", params, socket) do
    updates = [
      delay: String.to_integer(params["delay"])
    ]

    updates =
      if params["count"] do
        Keyword.put(updates, :count, String.to_integer(params["count"]))
      else
        updates
      end

    updates =
      if params["max_value"] do
        Keyword.put(updates, :max_value, String.to_integer(params["max_value"]))
      else
        updates
      end

    updates =
      if params["algorithm"] do
        Keyword.put(updates, :algorithm, params["algorithm"])
      else
        updates
      end

    {:noreply, assign(socket, updates)}
  end

  def handle_event("generate", _params, socket) do
    numbers = Sorting.generate_random_numbers(socket.assigns.count, socket.assigns.max_value)

    {:noreply,
     assign(socket,
       numbers: numbers,
       original_numbers: numbers,
       highlight: {nil, nil},
       operations: 0,
       elapsed_time: nil,
       status: :ready,
       generated_count: socket.assigns.count,
       generated_max_value: socket.assigns.max_value
     )}
  end

  def handle_event("start", _params, socket) do
    if socket.assigns.numbers != [] and not socket.assigns.running do
      send(self(), :run_algorithm)
      {:noreply,
       assign(socket,
         running: true,
         start_time: System.monotonic_time(:millisecond),
         status: :running,
         initial_delay: socket.assigns.delay
       )}
    else
      {:noreply, socket}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     assign(socket,
       numbers: socket.assigns.original_numbers,
       highlight: {nil, nil},
       operations: 0,
       elapsed_time: nil,
       running: false,
       status: :ready
     )}
  end

  def handle_info(:run_algorithm, socket) do
    lv_pid = self()
    numbers = socket.assigns.numbers
    algorithm = socket.assigns.algorithm

    Task.start(fn ->
      callback = fn event ->
        send(lv_pid, {:sorting_event, event})
        current_delay = GenServer.call(lv_pid, :get_delay)
        Process.sleep(current_delay)
      end

      case algorithm do
        "insertion" -> Sorting.insertion_sort(numbers, callback)
        "selection" -> Sorting.selection_sort(numbers, callback)
        "bubble" -> Sorting.bubble_sort(numbers, callback)
        "shell" -> Sorting.shell_sort(numbers, callback)
        "merge" -> Sorting.merge_sort(numbers, callback)
        "heap" -> Sorting.heap_sort(numbers, callback)
        "quick" -> Sorting.quick_sort(numbers, callback)
        "quick3" -> Sorting.quick3_sort(numbers, callback)
      end
    end)

    {:noreply, socket}
  end

  def handle_info({:sorting_event, {:step, numbers, i, j, ops}}, socket) do
    {:noreply, assign(socket, numbers: numbers, highlight: {i, j}, operations: ops)}
  end

  def handle_info({:sorting_event, {:compare, numbers, i, j, ops}}, socket) do
    {:noreply, assign(socket, numbers: numbers, highlight: {i, j}, operations: ops)}
  end

  def handle_info({:sorting_event, {:found_min, numbers, idx, ops}}, socket) do
    {:noreply, assign(socket, numbers: numbers, highlight: {idx, idx}, operations: ops)}
  end

  def handle_info({:sorting_event, {:done, numbers, ops}}, socket) do
    elapsed = System.monotonic_time(:millisecond) - socket.assigns.start_time

    run_record = %{
      id: System.unique_integer([:positive]),
      algorithm: socket.assigns.algorithm,
      count: socket.assigns.generated_count,
      max_value: socket.assigns.generated_max_value,
      delay: socket.assigns.initial_delay,
      operations: ops,
      elapsed_time: elapsed,
      timestamp: DateTime.utc_now()
    }

    {:noreply,
     assign(socket,
       numbers: numbers,
       highlight: {nil, nil},
       operations: ops,
       elapsed_time: elapsed,
       running: false,
       status: :done,
       history: [run_record | socket.assigns.history]
     )}
  end

  def handle_call(:get_delay, _from, socket) do
    {:reply, socket.assigns.delay, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-900 text-white p-4 sm:p-8">
      <h1 class="text-2xl sm:text-3xl font-bold text-center mb-6 sm:mb-8">Algorithms</h1>

      <div class="max-w-4xl mx-auto">
        <div class="bg-gray-800 rounded-lg p-4 sm:p-6 mb-4 sm:mb-6">
          <form phx-change="change_settings" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4 mb-4">
            <div>
              <label class="block text-sm mb-2">Quantity</label>
              <input
                type="range"
                name="count"
                min="5"
                max="50"
                value={@count}
                class="w-full"
                disabled={@running}
              />
              <span class="text-sm">{@count}</span>
            </div>

            <div>
              <label class="block text-sm mb-2">Max Value</label>
              <input
                type="range"
                name="max_value"
                min="10"
                max="200"
                value={@max_value}
                class="w-full"
                disabled={@running}
              />
              <span class="text-sm">{@max_value}</span>
            </div>

            <div>
              <label class="block text-sm mb-2">Delay (ms)</label>
              <input
                type="range"
                name="delay"
                min="0"
                max="500"
                value={@delay}
                class="w-full"
              />
              <span class="text-sm">{@delay}ms</span>
            </div>

            <div>
              <label class="block text-sm mb-2">Algorithm</label>
              <select
                name="algorithm"
                class="w-full bg-gray-700 rounded p-2"
                disabled={@running}
              >
                <option value="insertion" selected={@algorithm == "insertion"}>Insertion</option>
                <option value="selection" selected={@algorithm == "selection"}>Selection</option>
                <option value="bubble" selected={@algorithm == "bubble"}>Bubble</option>
                <option value="shell" selected={@algorithm == "shell"}>Shell</option>
                <option value="merge" selected={@algorithm == "merge"}>Merge</option>
                <option value="heap" selected={@algorithm == "heap"}>Heap</option>
                <option value="quick" selected={@algorithm == "quick"}>Quick</option>
                <option value="quick3" selected={@algorithm == "quick3"}>Quick3</option>
              </select>
            </div>
          </form>

          <div class="flex flex-wrap gap-2 sm:gap-4 justify-center">
            <button
              phx-click="generate"
              class="bg-blue-600 hover:bg-blue-700 px-4 sm:px-6 py-2 rounded font-semibold disabled:opacity-50 text-sm sm:text-base"
              disabled={@running}
            >
              Generate
            </button>

            <button
              phx-click="start"
              class="bg-green-600 hover:bg-green-700 px-4 sm:px-6 py-2 rounded font-semibold disabled:opacity-50 text-sm sm:text-base"
              disabled={@running or @numbers == []}
            >
              Start
            </button>

            <button
              phx-click="reset"
              class="bg-yellow-600 hover:bg-yellow-700 px-4 sm:px-6 py-2 rounded font-semibold disabled:opacity-50 text-sm sm:text-base"
              disabled={@running or @original_numbers == []}
            >
              Reset
            </button>
          </div>
        </div>

        <div class="bg-gray-800 rounded-lg p-4 sm:p-6 mb-4 sm:mb-6">
          <div class="flex items-end justify-center gap-[1px] sm:gap-1 h-48 sm:h-64 overflow-hidden">
            <%= for {num, idx} <- Enum.with_index(@numbers) do %>
              <div
                class={[
                  "transition-all duration-75 min-w-[2px]",
                  bar_color(idx, @highlight)
                ]}
                style={"flex: 1; max-width: #{bar_width(@generated_count)}px; height: #{bar_height(num, @generated_max_value)}%;"}
              >
              </div>
            <% end %>
          </div>

          <%= if @numbers == [] do %>
            <p class="text-center text-gray-400 mt-4 text-sm sm:text-base">Click "Generate" to begin</p>
          <% end %>
        </div>

        <%= if @status != :idle do %>
          <div class="bg-gray-800 rounded-lg p-4 sm:p-6">
            <h2 class="text-lg sm:text-xl font-semibold mb-3 sm:mb-4">Results</h2>
            <div class="grid grid-cols-3 gap-2 sm:gap-4 text-center">
              <div>
                <p class="text-gray-400 text-xs sm:text-sm">Status</p>
                <p class="text-sm sm:text-lg font-semibold">{status_text(@status)}</p>
              </div>
              <div>
                <p class="text-gray-400 text-xs sm:text-sm">Operations</p>
                <p class="text-sm sm:text-lg font-semibold">{@operations}</p>
              </div>
              <div>
                <p class="text-gray-400 text-xs sm:text-sm">Time</p>
                <p class="text-sm sm:text-lg font-semibold">
                  <%= if @elapsed_time do %>
                    {@elapsed_time}ms
                  <% else %>
                    -
                  <% end %>
                </p>
              </div>
            </div>
          </div>
        <% end %>

        <%= if @history != [] do %>
          <div class="bg-gray-800 rounded-lg p-4 sm:p-6 mt-4 sm:mt-6">
            <h2 class="text-lg sm:text-xl font-semibold mb-3 sm:mb-4">History</h2>
            <div class="overflow-x-auto -mx-4 sm:mx-0">
              <table class="w-full text-xs sm:text-sm min-w-[500px]">
                <thead>
                  <tr class="text-gray-400 border-b border-gray-700">
                    <th class="text-left py-2 px-2">#</th>
                    <th class="text-left py-2 px-2">Algo</th>
                    <th class="text-center py-2 px-2">N</th>
                    <th class="text-center py-2 px-2">Max</th>
                    <th class="text-center py-2 px-2">Delay</th>
                    <th class="text-center py-2 px-2">Ops</th>
                    <th class="text-center py-2 px-2">Time</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for {run, idx} <- Enum.with_index(@history) do %>
                    <tr class="border-b border-gray-700 hover:bg-gray-700">
                      <td class="py-2 px-2">{length(@history) - idx}</td>
                      <td class="py-2 px-2">{algorithm_name(run.algorithm)}</td>
                      <td class="text-center py-2 px-2">{run.count}</td>
                      <td class="text-center py-2 px-2">{run.max_value}</td>
                      <td class="text-center py-2 px-2">{run.delay}</td>
                      <td class="text-center py-2 px-2">{run.operations}</td>
                      <td class="text-center py-2 px-2">{run.elapsed_time}ms</td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp bar_color(idx, {i, j}) when idx == i or idx == j, do: "bg-red-500"
  defp bar_color(_idx, _highlight), do: "bg-blue-500"

  defp bar_width(count) do
    max(4, div(600, count))
  end

  defp bar_height(value, max_value) do
    max(2, div(value * 100, max_value))
  end

  defp status_text(:idle), do: "Waiting"
  defp status_text(:ready), do: "Ready"
  defp status_text(:running), do: "Running..."
  defp status_text(:done), do: "Done"

  defp algorithm_name("insertion"), do: "Insertion"
  defp algorithm_name("selection"), do: "Selection"
  defp algorithm_name("bubble"), do: "Bubble"
  defp algorithm_name("shell"), do: "Shell"
  defp algorithm_name("merge"), do: "Merge"
  defp algorithm_name("heap"), do: "Heap"
  defp algorithm_name("quick"), do: "Quick"
  defp algorithm_name("quick3"), do: "Quick3"
  defp algorithm_name(other), do: other
end
