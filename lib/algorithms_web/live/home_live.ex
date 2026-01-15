defmodule AlgorithmsWeb.HomeLive do
  use AlgorithmsWeb, :live_view

  @typing_words ["Insertion Sort", "Bubble Sort", "Quick Sort", "Merge Sort", "Heap Sort", "Shell Sort"]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       typing_words: @typing_words,
       current_word_index: 0,
       page_title: "Algorithms run"
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100 text-base-content">
      <.nav_header />

      <!-- Hero Section -->
      <section class="min-h-screen flex flex-col items-center justify-center px-4 relative overflow-hidden">
        <!-- Background gradient effects -->
        <div class="absolute inset-0 bg-gradient-to-br from-primary/10 via-base-100 to-secondary/10"></div>
        <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-primary/5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-secondary/5 rounded-full blur-3xl"></div>

        <div class="relative z-10 text-center max-w-4xl mx-auto">
          <h1 class="text-4xl sm:text-6xl lg:text-7xl font-bold mb-6">
            Run
            <span
              id="typing-text"
              phx-hook="TypingEffect"
              data-words={Jason.encode!(@typing_words)}
              class="text-primary"
            >{@typing_words |> List.first()}</span><span class="typing-cursor">|</span>
          </h1>

          <p class="text-lg sm:text-xl text-base-content/60 mb-12 max-w-2xl mx-auto">
            Watch sorting algorithms come to life. Understand how different algorithms work by seeing them in action, step by step.
          </p>

          <a
            href="/run"
            class="btn btn-primary btn-lg gap-2 text-lg px-8"
          >
            Run
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
            </svg>
          </a>
        </div>

        <!-- Scroll indicator -->
        <div class="absolute bottom-8 left-1/2 -translate-x-1/2 animate-bounce">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-base-content/40" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3" />
          </svg>
        </div>
      </section>

      <!-- About Section -->
      <section class="py-20 px-4 bg-base-200/50">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="text-3xl sm:text-4xl font-bold mb-4">Why Algorithm Visualization?</h2>
            <p class="text-base-content/60 max-w-2xl mx-auto">
              Understanding sorting algorithms is fundamental to computer science. Watching them work visually transforms abstract concepts into intuitive knowledge.
            </p>
          </div>

          <div class="grid md:grid-cols-3 gap-8">
            <div class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="text-4xl mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </div>
                  <h3 class="card-title">Learn Visually</h3>
                  <p class="text-base-content/60">See exactly how each algorithm processes data, making complex logic easy to understand.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>

            <div class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="text-4xl mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                  </div>
                  <h3 class="card-title">Compare Performance</h3>
                  <p class="text-base-content/60">Track operations and execution time to understand the efficiency of different approaches.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>

            <div class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="text-4xl mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-accent" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                    </svg>
                  </div>
                  <h3 class="card-title">Interactive Controls</h3>
                  <p class="text-base-content/60">Adjust speed, array size, and values in real-time to explore different scenarios.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </div>
          </div>
        </div>
      </section>

      <!-- Algorithms Section -->
      <section class="py-20 px-4">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="text-3xl sm:text-4xl font-bold mb-4">Featured Algorithms</h2>
            <p class="text-base-content/60 max-w-2xl mx-auto">
              Explore 8 classic sorting algorithms, from simple to advanced. Each one has its own strengths and ideal use cases.
            </p>
          </div>

          <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Insertion Sort -->
            <a href="/run?algorithm=insertion" class="hover-3d">
              <div class="card bg-base-200 border border-primary/20 hover:border-primary/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-primary mb-2">O(n²)</div>
                  <h3 class="card-title">Insertion Sort</h3>
                  <p class="text-base-content/60 text-sm">Builds the sorted array one element at a time. Efficient for small or nearly sorted data.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Selection Sort -->
            <a href="/run?algorithm=selection" class="hover-3d">
              <div class="card bg-base-200 border border-success/20 hover:border-success/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-success mb-2">O(n²)</div>
                  <h3 class="card-title">Selection Sort</h3>
                  <p class="text-base-content/60 text-sm">Repeatedly finds the minimum element and moves it to the sorted portion.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Bubble Sort -->
            <a href="/run?algorithm=bubble" class="hover-3d">
              <div class="card bg-base-200 border border-warning/20 hover:border-warning/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-warning mb-2">O(n²)</div>
                  <h3 class="card-title">Bubble Sort</h3>
                  <p class="text-base-content/60 text-sm">Repeatedly swaps adjacent elements if they are in the wrong order.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Shell Sort -->
            <a href="/run?algorithm=shell" class="hover-3d">
              <div class="card bg-base-200 border border-secondary/20 hover:border-secondary/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-secondary mb-2">O(n log n)</div>
                  <h3 class="card-title">Shell Sort</h3>
                  <p class="text-base-content/60 text-sm">Generalization of insertion sort that allows exchange of far apart elements.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Merge Sort -->
            <a href="/run?algorithm=merge" class="hover-3d">
              <div class="card bg-base-200 border border-info/20 hover:border-info/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-info mb-2">O(n log n)</div>
                  <h3 class="card-title">Merge Sort</h3>
                  <p class="text-base-content/60 text-sm">Divide and conquer algorithm that splits, sorts, and merges arrays.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Heap Sort -->
            <a href="/run?algorithm=heap" class="hover-3d">
              <div class="card bg-base-200 border border-error/20 hover:border-error/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-error mb-2">O(n log n)</div>
                  <h3 class="card-title">Heap Sort</h3>
                  <p class="text-base-content/60 text-sm">Uses a binary heap data structure to sort elements efficiently.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Quick Sort -->
            <a href="/run?algorithm=quick" class="hover-3d">
              <div class="card bg-base-200 border border-warning/20 hover:border-warning/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-warning mb-2">O(n log n)</div>
                  <h3 class="card-title">Quick Sort</h3>
                  <p class="text-base-content/60 text-sm">Fast divide and conquer using a pivot element to partition arrays.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <!-- Quick3 Sort -->
            <a href="/run?algorithm=quick3" class="hover-3d">
              <div class="card bg-base-200 border border-secondary/20 hover:border-secondary/40 transition-colors">
                <div class="card-body">
                  <div class="badge badge-secondary mb-2">O(n log n)</div>
                  <h3 class="card-title">Quick3 Sort</h3>
                  <p class="text-base-content/60 text-sm">3-way partitioning variant, excellent for arrays with many duplicates.</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="py-20 px-4 bg-base-200/50">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl sm:text-4xl font-bold mb-6">Ready to Explore?</h2>
          <p class="text-base-content/60 mb-8 max-w-xl mx-auto">
            Start visualizing sorting algorithms now. Generate random data, pick an algorithm, and watch the magic happen.
          </p>
          <a href="/run" class="btn btn-primary btn-lg gap-2">
            Run
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
            </svg>
          </a>
        </div>
      </section>

      <.nav_footer />
    </div>
    """
  end
end
