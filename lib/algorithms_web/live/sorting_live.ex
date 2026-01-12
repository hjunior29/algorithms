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
       algorithm: "bubble",
       running: false,
       highlight: {nil, nil},
       operations: 0,
       start_time: nil,
       elapsed_time: nil,
       status: :idle
     )}
  end

  def handle_event("change_settings", params, socket) do
    count = String.to_integer(params["count"])
    max_value = String.to_integer(params["max_value"])
    delay = String.to_integer(params["delay"])
    algorithm = params["algorithm"]

    {:noreply,
     assign(socket,
       count: count,
       max_value: max_value,
       delay: delay,
       algorithm: algorithm
     )}
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
       status: :ready
     )}
  end

  def handle_event("start", _params, socket) do
    if socket.assigns.numbers != [] and not socket.assigns.running do
      send(self(), :run_algorithm)
      {:noreply, assign(socket, running: true, start_time: System.monotonic_time(:millisecond), status: :running)}
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
    delay = socket.assigns.delay
    numbers = socket.assigns.numbers
    algorithm = socket.assigns.algorithm

    Task.start(fn ->
      callback = fn event ->
        send(lv_pid, {:sorting_event, event})
        Process.sleep(delay)
      end

      case algorithm do
        "bubble" -> Sorting.bubble_sort(numbers, callback)
        "selection" -> Sorting.selection_sort(numbers, callback)
        "insertion" -> Sorting.insertion_sort(numbers, callback)
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

    {:noreply,
     assign(socket,
       numbers: numbers,
       highlight: {nil, nil},
       operations: ops,
       elapsed_time: elapsed,
       running: false,
       status: :done
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-900 text-white p-8">
      <h1 class="text-3xl font-bold text-center mb-8">Algorithms</h1>

      <div class="max-w-4xl mx-auto">
        <div class="bg-gray-800 rounded-lg p-6 mb-6">
          <form phx-change="change_settings" class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
            <div>
              <label class="block text-sm mb-1">Quantity</label>
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
              <label class="block text-sm mb-1">Max Value</label>
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
              <label class="block text-sm mb-1">Delay (ms)</label>
              <input
                type="range"
                name="delay"
                min="1"
                max="500"
                value={@delay}
                class="w-full"
                disabled={@running}
              />
              <span class="text-sm">{@delay}ms</span>
            </div>

            <div>
              <label class="block text-sm mb-1">Algorithm</label>
              <select
                name="algorithm"
                class="w-full bg-gray-700 rounded p-2"
                disabled={@running}
              >
                <option value="bubble" selected={@algorithm == "bubble"}>Bubble Sort</option>
                <option value="selection" selected={@algorithm == "selection"}>Selection Sort</option>
                <option value="insertion" selected={@algorithm == "insertion"}>Insertion Sort</option>
              </select>
            </div>
          </form>

          <div class="flex gap-4 justify-center">
            <button
              phx-click="generate"
              class="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-semibold disabled:opacity-50"
              disabled={@running}
            >
              Generate
            </button>

            <button
              phx-click="start"
              class="bg-green-600 hover:bg-green-700 px-6 py-2 rounded font-semibold disabled:opacity-50"
              disabled={@running or @numbers == []}
            >
              Start
            </button>

            <button
              phx-click="reset"
              class="bg-yellow-600 hover:bg-yellow-700 px-6 py-2 rounded font-semibold disabled:opacity-50"
              disabled={@running or @original_numbers == []}
            >
              Reset
            </button>
          </div>
        </div>

        <div class="bg-gray-800 rounded-lg p-6 mb-6">
          <div class="flex items-end justify-center gap-1 h-64">
            <%= for {num, idx} <- Enum.with_index(@numbers) do %>
              <div
                class={[
                  "transition-all duration-75",
                  bar_color(idx, @highlight)
                ]}
                style={"width: #{bar_width(@count)}px; height: #{bar_height(num, @max_value)}px;"}
              >
              </div>
            <% end %>
          </div>

          <%= if @numbers == [] do %>
            <p class="text-center text-gray-400 mt-4">Click "Generate Numbers" to begin</p>
          <% end %>
        </div>

        <%= if @status != :idle do %>
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold mb-4">Results</h2>
            <div class="grid grid-cols-3 gap-4 text-center">
              <div>
                <p class="text-gray-400 text-sm">Status</p>
                <p class="text-lg font-semibold">{status_text(@status)}</p>
              </div>
              <div>
                <p class="text-gray-400 text-sm">Operations</p>
                <p class="text-lg font-semibold">{@operations}</p>
              </div>
              <div>
                <p class="text-gray-400 text-sm">Time</p>
                <p class="text-lg font-semibold">
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
      </div>
    </div>
    """
  end

  defp bar_color(idx, {i, j}) when idx == i or idx == j, do: "bg-red-500"
  defp bar_color(_idx, _highlight), do: "bg-blue-500"

  defp bar_width(count) do
    max(2, div(600, count))
  end

  defp bar_height(value, max_value) do
    max(4, div(value * 240, max_value))
  end

  defp status_text(:idle), do: "Waiting"
  defp status_text(:ready), do: "Ready"
  defp status_text(:running), do: "Running..."
  defp status_text(:done), do: "Done"
end
