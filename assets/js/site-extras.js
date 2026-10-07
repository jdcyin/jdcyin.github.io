// Site extras: email popup, sidebar fret lights, presentations filter.
// Kept in a separate file because the production build minifies inline HTML
// onto one line, which breaks // comments inside inline <script> tags.

(function () {
  var dialog = document.getElementById('_emailDialog');
  if (!dialog || typeof dialog.showModal !== 'function') return;
  var email = dialog.querySelector('.email-dialog-address').textContent.trim();
  var copyBtn = dialog.querySelector('[data-email-copy]');

  // The sidebar persists across page loads, so delegate from the document.
  document.addEventListener('click', function (e) {
    var link = e.target.closest && e.target.closest('.sidebar-social a[href^="mailto:"]');
    if (!link) return;
    e.preventDefault();
    copyBtn.textContent = 'Copy';
    dialog.showModal();
  });

  dialog.addEventListener('click', function (e) {
    // close on the x button or on a click outside the box
    if (e.target === dialog || e.target.closest('[data-email-close]')) dialog.close();
  });

  copyBtn.addEventListener('click', function () {
    var done = function () { copyBtn.textContent = 'Copied!'; };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(email).then(done, fallback);
    } else {
      fallback();
    }
    function fallback() {
      var range = document.createRange();
      range.selectNodeContents(dialog.querySelector('.email-dialog-address'));
      var sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
      try { document.execCommand('copy'); done(); } catch (err) {}
    }
  });
})();

// Sidebar fret lights: every 回 tile in the sidebar pattern takes a turn
// to glow, in random order, very slowly. The sidebar persists across page
// loads, so this runs once.
(function () {
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  var bg = document.querySelector('.sidebar-bg');
  var sidebar = document.querySelector('.sidebar');
  if (!bg || !sidebar) return;

  var TILE = 48;          // matches background-size in my-inline.scss
  var EVERY = 900;        // ms between one tile starting to light and the next
  var HOLD = 2500;        // ms a tile stays lit before fading (fades take 4s each way)
  var layer = document.createElement('div');
  layer.className = 'deco-lights';
  bg.appendChild(layer);

  var tiles = [], bag = [];

  function build() {
    layer.innerHTML = '';
    tiles = []; bag = [];
    // The pattern starts at the top-left of .sidebar-bg (background-position 0 0),
    // so tiles sit on a 48px grid in that box. Only fill the part the sidebar shows.
    var bgRect = bg.getBoundingClientRect(), sideRect = sidebar.getBoundingClientRect();
    var x0 = sideRect.left - bgRect.left, x1 = x0 + sideRect.width;
    var h = sidebar.offsetHeight;
    for (var x = Math.floor(x0 / TILE) * TILE; x < x1; x += TILE) {
      for (var y = 0; y < h; y += TILE) {
        var el = document.createElement("span");
        el.className = "deco-light";
        el.style.left = x + "px";
        el.style.top = y + "px";
        layer.appendChild(el);
        tiles.push(el);
      }
    }
  }

  function next() {
    if (!bag.length) {
      // shuffle so every tile lights once per round, in a fresh random order
      bag = tiles.slice();
      for (var i = bag.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1)), t = bag[i];
        bag[i] = bag[j]; bag[j] = t;
      }
    }
    var el = bag.pop();
    if (el) {
      el.classList.add('lit');
      setTimeout(function () { el.classList.remove('lit'); }, 4000 + HOLD);
    }
  }

  build();
  setInterval(next, EVERY);
  var resizeTimer;
  window.addEventListener('resize', function () {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(build, 300);
  });
})();

// Presentations filter (All / Moderator / Speaker). Page content is swapped
// in without a full reload, so listen on the document.
document.addEventListener('change', function (e) {
  if (!e.target.matches || !e.target.matches('[data-presentations-filter]')) return;
  var kind = e.target.value;
  var list = e.target.closest('.presentations-head').nextElementSibling;
  Array.prototype.forEach.call(list.querySelectorAll('.presentation'), function (li) {
    var kinds = (li.getAttribute('data-kinds') || '').split(' ');
    li.hidden = kind !== 'all' && kinds.indexOf(kind) === -1;
  });
});
