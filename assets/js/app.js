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

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Define Hooks
const Hooks = {}

Hooks.IframeLoader = {
  mounted() {
    const iframeEl = this.el;
    const websiteId = this.el.dataset.websiteId;
    const thumbnailEl = document.getElementById(`thumbnail-${websiteId}`);
    const useThumbnail = this.el.dataset.useThumbnail === "true";

    // Get icon elements
    const loadingIcon = document.getElementById(`loading-icon-${websiteId}`);
    const liveIcon = document.getElementById(`live-icon-${websiteId}`);
    const thumbnailIcon = document.getElementById(`thumbnail-icon-${websiteId}`);
    const previewStatus = document.getElementById(`preview-status-${websiteId}`);

    // Track if we've already handled this iframe
    let iframeHandled = false;

    // Functions to update status icons
    const showLiveIcon = () => {
      if (loadingIcon) loadingIcon.classList.add('hidden');
      // if (liveIcon) liveIcon.classList.remove('hidden');
      // if (thumbnailIcon) thumbnailIcon.classList.add('hidden');
      if (previewStatus) previewStatus.setAttribute('title', 'Live preview');
    };

    const showThumbnailIcon = () => {
      if (loadingIcon) loadingIcon.classList.add('hidden');
      // if (liveIcon) liveIcon.classList.add('hidden');
      // if (thumbnailIcon) thumbnailIcon.classList.remove('hidden');
      if (previewStatus) previewStatus.setAttribute('title', 'Thumbnail preview');
    };

    // Function to switch to thumbnail view
    const showThumbnail = () => {
      if (iframeHandled) return;
      iframeHandled = true;

      iframeEl.style.display = 'none';
      if (thumbnailEl) {
        // thumbnailEl.style.display = 'block';
        showThumbnailIcon();
      }
    };

    // Function to show iframe
    const showIframe = () => {
      if (iframeHandled) return;
      iframeHandled = true;

      iframeEl.style.display = 'block';
      if (thumbnailEl) {
        // thumbnailEl.style.display = 'none';
      }
      showLiveIcon();
    };

    // If user preference is to use thumbnail, show it
    if (useThumbnail && thumbnailEl) {
      showThumbnail();
      return;
    }

    // Otherwise start with iframe visible
    iframeEl.style.display = 'block';
    if (thumbnailEl) {
      // thumbnailEl.style.display = 'none';
    }

    // Handle iframe load and always show iframe regardless of CORS
    iframeEl.addEventListener('load', () => {
      showIframe();
    });

    // Handle iframe error but still show iframe
    iframeEl.addEventListener('error', () => {
      showIframe();
    });

    // Ensure iframe is shown if not handled yet
    setTimeout(() => {
      if (!iframeHandled) {
        showIframe();
      }
    }, 2000);
  }
};

// Register event handlers for loading indicators
window.addEventListener("phx:show-loading", (e) => {
  const id = e.detail.id;
  const loadingIcon = document.getElementById(`loading-icon-${id}`);
  const liveIcon = document.getElementById(`live-icon-${id}`);
  const thumbnailIcon = document.getElementById(`thumbnail-icon-${id}`);
  const thumbnailEl = document.getElementById(`thumbnail-${id}`);

  // Show the loading spinner in the top controls
  if (loadingIcon) loadingIcon.classList.remove('hidden');

  // Hide the regular icons temporarily
  if (liveIcon) liveIcon.classList.add('hidden');
  if (thumbnailIcon) thumbnailIcon.classList.add('hidden');

  // Add loading effect to the thumbnail if it's visible
  if (thumbnailEl && thumbnailEl.style.display !== 'none') {
    // Add a loading overlay or effect to the thumbnail
    thumbnailEl.classList.add('opacity-30');
    thumbnailEl.classList.add('transition-opacity');
    thumbnailEl.parentElement.classList.add('relative');

    // Create or show a central loading indicator
    let centralLoader = document.getElementById(`central-loader-${id}`);
    if (!centralLoader) {
      centralLoader = document.createElement('div');
      centralLoader.id = `central-loader-${id}`;
      centralLoader.className = 'absolute inset-0 flex items-center justify-center z-10';
      centralLoader.innerHTML = `
        <div class="bg-gray-800/70 dark:bg-gray-900/70 rounded-full p-3">
          <svg class="animate-spin h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
      `;
      thumbnailEl.parentElement.appendChild(centralLoader);
    } else {
      centralLoader.classList.remove('hidden');
    }
  }
});

window.addEventListener("phx:hide-loading", (e) => {
  const id = e.detail.id;
  const loadingIcon = document.getElementById(`loading-icon-${id}`);
  const liveIcon = document.getElementById(`live-icon-${id}`);
  const thumbnailIcon = document.getElementById(`thumbnail-icon-${id}`);
  const website = document.querySelector(`[phx-value-id="${id}"]`).closest('.group');
  const thumbnailEl = document.getElementById(`thumbnail-${id}`);
  const isThumbnail = website.querySelector('img[id^="thumbnail-"]').style.display !== 'none';

  // Hide the loading spinner
  if (loadingIcon) loadingIcon.classList.add('hidden');

  // Remove loading effect from the thumbnail
  if (thumbnailEl) {
    thumbnailEl.classList.remove('opacity-30');

    // Hide central loader if it exists
    const centralLoader = document.getElementById(`central-loader-${id}`);
    if (centralLoader) {
      centralLoader.classList.add('hidden');
    }
  }

  // Show the appropriate icon based on current view mode
  if (isThumbnail) {
    if (thumbnailIcon) thumbnailIcon.classList.remove('hidden');
    if (liveIcon) liveIcon.classList.add('hidden');
  } else {
    if (liveIcon) liveIcon.classList.remove('hidden');
    if (thumbnailIcon) thumbnailIcon.classList.add('hidden');
  }
});

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Function to refresh all website previews (iframes and thumbnails)
function refreshAllWebsites() {
  // Update all iframes by reloading their source
  document.querySelectorAll('iframe[data-website-id]').forEach(iframe => {
    const websiteId = iframe.dataset.websiteId;
    const thumbnailEl = document.getElementById(`thumbnail-${websiteId}`);
    const useThumbnail = iframe.dataset.useThumbnail === "true";

    // If using iframe (not thumbnail), refresh the iframe
    if (!useThumbnail) {
      // Save current src
      const currentSrc = iframe.src;

      // Force reload by setting to empty and back to original
      iframe.src = '';
      setTimeout(() => {
        iframe.src = currentSrc;
      }, 50);
    }

    // If using thumbnail, refresh it by forcing a reload
    if (useThumbnail && thumbnailEl) {
      // For thumbnails, add a cache-busting parameter
      const timestamp = new Date().getTime();
      const thumbnailSrc = thumbnailEl.src.split('?')[0]; // Remove any existing query params
      thumbnailEl.src = `${thumbnailSrc}?t=${timestamp}`;
    }

    // Update the "Last checked" text if it exists
    const statusElement = document.querySelector(`[id="${websiteId}"] .text-xs`);
    if (statusElement) {
      statusElement.textContent = 'Last checked: Just now';
    }
  });

  toggleAllThumbnails();
}

// Function to toggle thumbnails for all websites where thumbnail is true
function toggleAllThumbnails() {
  // Get all buttons that trigger toggle_thumbnail event for websites with thumbnail=true
  document.querySelectorAll('img[id^="thumbnail-"]').forEach(thumbnail => {
    // Skip thumbnails that are hidden
    if (thumbnail.style.display === 'none') {
      return;
    }

    // Extract website ID from the thumbnail ID (format: thumbnail-{websiteId})
    const websiteId = thumbnail.id.replace('thumbnail-', '');

    // Find the toggle button for this website
    const refreshButton = document.querySelector(`button[phx-click="refresh_thumbnail"][phx-value-id="${websiteId}"]`);
    if (refreshButton) {
      refreshButton.click();
    }
  });
}

// Expose the refresh function to the window object so it can be called from the timer
window.refreshAllWebsites = refreshAllWebsites;

