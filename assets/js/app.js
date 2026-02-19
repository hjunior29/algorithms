// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/algorithms"
import topbar from "../vendor/topbar"

// Custom hooks
const Hooks = {
  ScrollHeader: {
    mounted() {
      const header = this.el

      const handleScroll = () => {
        if (window.scrollY > 50) {
          header.classList.add('header-scrolled')
        } else {
          header.classList.remove('header-scrolled')
        }
      }

      window.addEventListener('scroll', handleScroll)
      handleScroll()

      this.cleanup = () => window.removeEventListener('scroll', handleScroll)
    },
    destroyed() {
      if (this.cleanup) this.cleanup()
    }
  },
  ThemeToggle: {
    mounted() {
      const checkbox = this.el.querySelector('input[type="checkbox"]')

      // Set initial state based on current theme
      const currentTheme = localStorage.getItem('phx:theme') ||
        (document.documentElement.getAttribute('data-theme'))
      checkbox.checked = currentTheme === 'dark'

      checkbox.addEventListener('change', () => {
        const newTheme = checkbox.checked ? 'dark' : 'light'
        localStorage.setItem('phx:theme', newTheme)
        document.documentElement.setAttribute('data-theme', newTheme)

        // Update highlight.js theme
        const lightTheme = document.querySelector('link[data-highlight-theme="light"]')
        const darkTheme = document.querySelector('link[data-highlight-theme="dark"]')
        if (lightTheme && darkTheme) {
          const isDark = newTheme === 'dark'
          lightTheme.media = isDark ? 'not all' : 'all'
          darkTheme.media = isDark ? 'all' : 'not all'
        }
      })
    }
  },
  TypingEffect: {
    mounted() {
      const words = JSON.parse(this.el.dataset.words)
      let wordIndex = 0
      let charIndex = words[0].length
      let isDeleting = true
      let isPausing = false

      const type = () => {
        const currentWord = words[wordIndex]

        if (isPausing) {
          isPausing = false
          setTimeout(type, 1500)
          return
        }

        if (isDeleting) {
          this.el.textContent = currentWord.substring(0, charIndex - 1)
          charIndex--

          if (charIndex === 0) {
            isDeleting = false
            wordIndex = (wordIndex + 1) % words.length
          }
          setTimeout(type, 50)
        } else {
          const nextWord = words[wordIndex]
          this.el.textContent = nextWord.substring(0, charIndex + 1)
          charIndex++

          if (charIndex === nextWord.length) {
            isDeleting = true
            isPausing = true
          }
          setTimeout(type, 100)
        }
      }

      setTimeout(type, 2000)
    }
  },
  SortingDemo: {
    mounted() {
      this.stopped = false
      this.bars = []
      this.container = this.el
      this.initBars()
      this.runLoop()
    },
    destroyed() {
      this.stopped = true
    },
    setColor(bar, type) {
      bar.classList.remove("bg-primary", "bg-error", "bg-success")
      bar.classList.add(type)
    },
    initBars() {
      const count = 24
      this.values = Array.from({length: count}, (_, i) => ((i + 1) / count) * 100)
      this.shuffle(this.values)

      this.container.innerHTML = ""
      this.bars = this.values.map((val) => {
        const bar = document.createElement("div")
        bar.className = "bg-primary rounded-t transition-all duration-200"
        bar.style.height = `${val}%`
        bar.style.flex = "1"
        this.container.appendChild(bar)
        return bar
      })
    },
    shuffle(arr) {
      for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]]
      }
    },
    sleep(ms) {
      return new Promise(r => setTimeout(r, ms))
    },
    updateBars() {
      this.bars.forEach((bar, i) => {
        bar.style.height = `${this.values[i]}%`
        this.setColor(bar, "bg-primary")
      })
    },
    highlight(i, j) {
      this.bars.forEach((bar, idx) => {
        this.setColor(bar, (idx === i || idx === j) ? "bg-error" : "bg-primary")
      })
    },
    async markSorted() {
      for (let i = 0; i < this.bars.length; i++) {
        if (this.stopped) return
        this.setColor(this.bars[i], "bg-success")
        await this.sleep(30)
      }
    },
    async bubbleSort() {
      const arr = this.values
      const n = arr.length
      for (let i = 0; i < n - 1; i++) {
        for (let j = 0; j < n - i - 1; j++) {
          if (this.stopped) return
          this.highlight(j, j + 1)
          await this.sleep(60)
          if (arr[j] > arr[j + 1]) {
            [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]]
            this.updateBars()
            this.highlight(j, j + 1)
            await this.sleep(60)
          }
        }
      }
    },
    async insertionSort() {
      const arr = this.values
      for (let i = 1; i < arr.length; i++) {
        let j = i
        while (j > 0 && arr[j - 1] > arr[j]) {
          if (this.stopped) return
          this.highlight(j - 1, j);
          [arr[j - 1], arr[j]] = [arr[j], arr[j - 1]]
          this.updateBars()
          this.highlight(j - 1, j)
          await this.sleep(50)
          j--
        }
      }
    },
    async selectionSort() {
      const arr = this.values
      for (let i = 0; i < arr.length - 1; i++) {
        let minIdx = i
        for (let j = i + 1; j < arr.length; j++) {
          if (this.stopped) return
          this.highlight(minIdx, j)
          await this.sleep(50)
          if (arr[j] < arr[minIdx]) minIdx = j
        }
        if (minIdx !== i) {
          [arr[i], arr[minIdx]] = [arr[minIdx], arr[i]]
          this.updateBars()
          this.highlight(i, minIdx)
          await this.sleep(50)
        }
      }
    },
    async runLoop() {
      const algorithms = [
        () => this.bubbleSort(),
        () => this.insertionSort(),
        () => this.selectionSort()
      ]
      let algoIdx = 0

      while (!this.stopped) {
        this.shuffle(this.values)
        this.updateBars()
        await this.sleep(800)

        await algorithms[algoIdx]()
        if (this.stopped) return

        await this.markSorted()
        await this.sleep(1500)

        algoIdx = (algoIdx + 1) % algorithms.length
      }
    }
  },
  HighlightCode: {
    mounted() {
      this.highlight()
    },
    updated() {
      this.highlight()
    },
    highlight() {
      if (typeof hljs !== 'undefined') {
        this.el.querySelectorAll('pre code').forEach((block) => {
          hljs.highlightElement(block)
        })
      }
    }
  }
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...Hooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// Close popovers when menu items are clicked
document.addEventListener("click", (e) => {
  const menuItem = e.target.closest("[popover] li a")
  if (menuItem) {
    const popover = menuItem.closest("[popover]")
    if (popover && popover.hidePopover) {
      popover.hidePopover()
    }
  }
})

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

