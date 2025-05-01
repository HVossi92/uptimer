/**
 * Uptimer SEO Helper Functions
 * Improves user interaction metrics that Google considers for SEO ranking
 */

// Lazy loading for images to improve performance
document.addEventListener('DOMContentLoaded', () => {
  const lazyImages = document.querySelectorAll('img[data-src]');

  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
          imageObserver.unobserve(img);
        }
      });
    });

    lazyImages.forEach(img => imageObserver.observe(img));
  } else {
    // Fallback for browsers without IntersectionObserver
    lazyImages.forEach(img => {
      img.src = img.dataset.src;
      img.removeAttribute('data-src');
    });
  }
});

// Improve page speed by deferring non-critical JS
function loadDeferredScripts() {
  const deferredScripts = document.querySelectorAll('script[data-defer]');
  deferredScripts.forEach(script => {
    const newScript = document.createElement('script');
    if (script.src) newScript.src = script.src;
    if (script.textContent) newScript.textContent = script.textContent;
    document.body.appendChild(newScript);
    script.remove();
  });
}

// Execute deferred loading after page loads
window.addEventListener('load', loadDeferredScripts); 