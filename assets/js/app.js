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

