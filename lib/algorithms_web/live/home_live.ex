defmodule AlgorithmsWeb.HomeLive do
  use AlgorithmsWeb, :live_view

  @typing_words ["Insertion Sort", "Bubble Sort", "Quick Sort", "Merge Sort", "Heap Sort", "Shell Sort"]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       typing_words: @typing_words,
       current_word_index: 0,
       page_title: gettext("Home")
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
            {gettext("Run")}
            <span
              id="typing-text"
              phx-hook="TypingEffect"
              data-words={Jason.encode!(@typing_words)}
              class="text-primary"
            >{@typing_words |> List.first()}</span><span class="typing-cursor">|</span>
          </h1>

          <p class="text-lg sm:text-xl text-base-content/60 mb-12 max-w-2xl mx-auto">
            {gettext("Watch sorting algorithms come to life. Understand how different algorithms work by seeing them in action, step by step.")}
          </p>

          <div class="flex flex-wrap gap-4 justify-center">
            <a
              href="/run"
              class="btn btn-primary btn-lg gap-2 text-lg px-8"
            >
              {gettext("Run")}
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </a>
            <a
              href="/learn"
              class="btn btn-outline btn-lg gap-2 text-lg px-8"
            >
              {gettext("Learn")}
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
              </svg>
            </a>
          </div>
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
            <h2 class="text-3xl sm:text-4xl font-bold mb-4">{gettext("Why Algorithm Visualization?")}</h2>
            <p class="text-base-content/60 max-w-2xl mx-auto">
              {gettext("Understanding sorting algorithms is fundamental to computer science. Watching them work visually transforms abstract concepts into intuitive knowledge.")}
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
                  <h3 class="card-title">{gettext("Learn Visually")}</h3>
                  <p class="text-base-content/60">{gettext("See exactly how each algorithm processes data, making complex logic easy to understand.")}</p>
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
                  <h3 class="card-title">{gettext("Compare Performance")}</h3>
                  <p class="text-base-content/60">{gettext("Track operations and execution time to understand the efficiency of different approaches.")}</p>
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
                  <h3 class="card-title">{gettext("Interactive Controls")}</h3>
                  <p class="text-base-content/60">{gettext("Adjust speed, array size, and values in real-time to explore different scenarios.")}</p>
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
            <h2 class="text-3xl sm:text-4xl font-bold mb-4">{gettext("Featured Algorithms")}</h2>
            <p class="text-base-content/60 max-w-2xl mx-auto">
              {gettext("Explore 8 classic sorting algorithms, from simple to advanced. Each one has its own strengths and ideal use cases.")}
            </p>
          </div>

          <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <a href="/run?algorithm=insertion" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-primary mb-2">O(n²)</div>
                  <h3 class="card-title">{gettext("Insertion Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Builds the sorted array one element at a time. Efficient for small or nearly sorted data.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=selection" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-success mb-2">O(n²)</div>
                  <h3 class="card-title">{gettext("Selection Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Repeatedly finds the minimum element and moves it to the sorted portion.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=bubble" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-warning mb-2">O(n²)</div>
                  <h3 class="card-title">{gettext("Bubble Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Repeatedly swaps adjacent elements if they are in the wrong order.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=shell" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-secondary mb-2">O(n log n)</div>
                  <h3 class="card-title">{gettext("Shell Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Generalization of insertion sort that allows exchange of far apart elements.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=merge" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-info mb-2">O(n log n)</div>
                  <h3 class="card-title">{gettext("Merge Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Divide and conquer algorithm that splits, sorts, and merges arrays.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=heap" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-error mb-2">O(n log n)</div>
                  <h3 class="card-title">{gettext("Heap Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Uses a binary heap data structure to sort elements efficiently.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=quick" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-warning mb-2">O(n log n)</div>
                  <h3 class="card-title">{gettext("Quick Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("Fast divide and conquer using a pivot element to partition arrays.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>

            <a href="/run?algorithm=quick3" class="hover-3d">
              <div class="card bg-base-200 border border-base-300 h-full">
                <div class="card-body">
                  <div class="badge badge-secondary mb-2">O(n log n)</div>
                  <h3 class="card-title">{gettext("Quick3 Sort")}</h3>
                  <p class="text-base-content/60 text-sm">{gettext("3-way partitioning variant, excellent for arrays with many duplicates.")}</p>
                </div>
              </div>
              <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
            </a>
          </div>
        </div>
      </section>

      <!-- Learn Section -->
      <section class="py-20 px-4 bg-base-200/50">
        <div class="max-w-6xl mx-auto">
          <div class="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 class="text-3xl sm:text-4xl font-bold mb-6">{gettext("Dive Deeper with Learn")}</h2>
              <p class="text-base-content/60 mb-6">
                {gettext("Go beyond visualization. Our Learn section provides comprehensive documentation for each algorithm, including historical context, step-by-step breakdowns, and practical use cases.")}
              </p>
              <ul class="space-y-4 mb-8">
                <li class="flex items-start gap-3">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                  </svg>
                  <div>
                    <span class="font-semibold">{gettext("Rich History")}</span>
                    <p class="text-base-content/60 text-sm">{gettext("Learn who invented each algorithm and when, understanding the evolution of sorting techniques.")}</p>
                  </div>
                </li>
                <li class="flex items-start gap-3">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-secondary flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                  </svg>
                  <div>
                    <span class="font-semibold">{gettext("Step-by-Step Guide")}</span>
                    <p class="text-base-content/60 text-sm">{gettext("Understand exactly how each algorithm works with clear, numbered instructions.")}</p>
                  </div>
                </li>
                <li class="flex items-start gap-3">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-accent flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                  </svg>
                  <div>
                    <span class="font-semibold">{gettext("When to Use")}</span>
                    <p class="text-base-content/60 text-sm">{gettext("Discover the ideal scenarios for each algorithm based on data characteristics.")}</p>
                  </div>
                </li>
              </ul>
              <a href="/learn" class="btn btn-primary gap-2">
                {gettext("Learn")}
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </a>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div class="hover-3d">
                <div class="card bg-base-200 border border-base-300">
                  <div class="card-body p-4">
                    <div class="badge badge-info mb-2">{gettext("History")}</div>
                    <p class="text-sm text-base-content/60">{gettext("Origins and inventors of each algorithm")}</p>
                  </div>
                </div>
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
              </div>
              <div class="hover-3d">
                <div class="card bg-base-200 border border-base-300">
                  <div class="card-body p-4">
                    <div class="badge badge-success mb-2">{gettext("Complexity")}</div>
                    <p class="text-sm text-base-content/60">{gettext("Best, average, and worst case analysis")}</p>
                  </div>
                </div>
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
              </div>
              <div class="hover-3d">
                <div class="card bg-base-200 border border-base-300">
                  <div class="card-body p-4">
                    <div class="badge badge-warning mb-2">{gettext("How it Works")}</div>
                    <p class="text-sm text-base-content/60">{gettext("Step-by-step algorithm breakdown")}</p>
                  </div>
                </div>
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
              </div>
              <div class="hover-3d">
                <div class="card bg-base-200 border border-base-300">
                  <div class="card-body p-4">
                    <div class="badge badge-error mb-2">{gettext("Ranking")}</div>
                    <p class="text-sm text-base-content/60">{gettext("Theoretical efficiency comparison")}</p>
                  </div>
                </div>
                <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="py-20 px-4">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-3xl sm:text-4xl font-bold mb-6">{gettext("Ready to Explore?")}</h2>
          <p class="text-base-content/60 mb-8 max-w-xl mx-auto">
            {gettext("Start visualizing sorting algorithms now. Generate random data, pick an algorithm, and watch the magic happen.")}
          </p>
          <a href="/run" class="btn btn-primary btn-lg gap-2">
            {gettext("Run")}
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
