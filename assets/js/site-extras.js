// Site extras: email popup, sidebar fret lights, presentations filter.
// Kept in a separate file because the production build minifies inline HTML
// onto one line, which breaks // comments inside inline <script> tags.

// True when a click landed outside the dialog box (on the backdrop).
function clickedOutside(dialog, e) {
  if (e.target !== dialog) return false;
  var r = dialog.getBoundingClientRect();
  return e.clientX < r.left || e.clientX > r.right || e.clientY < r.top || e.clientY > r.bottom;
}

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
    if (clickedOutside(dialog, e) || e.target.closest('[data-email-close]')) dialog.close();
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
  // re-measure once fonts, images and the async stylesheet have loaded
  window.addEventListener('load', build);
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

// Session popup: clicking a presentation title that has a description opens
// it in a dialog (content comes from the hidden .presentation-detail block).
(function () {
  var dialog = document.getElementById('_talkDialog');
  if (!dialog || typeof dialog.showModal !== 'function') return;
  var titleEl = dialog.querySelector('.talk-dialog-title');
  var bodyEl = dialog.querySelector('.talk-dialog-body');

  document.addEventListener('click', function (e) {
    var btn = e.target.closest && e.target.closest('[data-presentation-open]');
    if (!btn) return;
    var item = btn.closest('.presentation');
    var detail = item && item.querySelector('.presentation-detail');
    if (!detail) return;
    titleEl.textContent = btn.textContent.trim();
    bodyEl.innerHTML = detail.innerHTML;
    dialog.showModal();
  });

  dialog.addEventListener('click', function (e) {
    // close on a click outside the box
    if (clickedOutside(dialog, e)) dialog.close();
  });
})();

// Scrollytelling articles: as each .scrolly-step reaches the middle of the
// screen, show the visual named by its data-viz and update the section label.
// Pages are swapped in without a full reload, so re-run after each navigation.
(function () {
  function setup(root) {
    if (root.getAttribute('data-ready')) return;
    root.setAttribute('data-ready', '1');
    var steps = root.querySelectorAll('.scrolly-step');
    var vizzes = root.querySelectorAll('.viz');
    var label = root.querySelector('.scrolly-section-label');
    var pillars = root.querySelectorAll('.scrolly-pillars [data-pillar]');

    function activate(step) {
      var key = step.getAttribute('data-viz');
      Array.prototype.forEach.call(steps, function (s) { s.classList.toggle('is-active', s === step); });
      // data-stage on a step builds a visual up in stages: the active visual gets
      // classes stage-1 ... stage-N, which reveal elements marked s1 ... sN
      var stage = parseInt(step.getAttribute('data-stage') || '', 10) || 1;
      Array.prototype.forEach.call(vizzes, function (v) {
        var on = v.getAttribute('data-viz') === key;
        v.classList.toggle('is-active', on);
        for (var k = 1; k <= 6; k++) v.classList.toggle('stage-' + k, on && k <= stage);
      });
      if (label) label.textContent = step.getAttribute('data-section') || '';
      var pillar = step.getAttribute('data-pillar');
      Array.prototype.forEach.call(pillars, function (p) { p.classList.toggle('is-active', p.getAttribute('data-pillar') === pillar); });
    }

    if (!('IntersectionObserver' in window)) {
      // very old browsers: show every visual's first state
      if (steps.length) activate(steps[0]);
      return;
    }
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) { if (entry.isIntersecting) activate(entry.target); });
    }, {
      // wide chapters: the step whose card is docked at the bottom of the panel
      // is the active one; elsewhere, the step in the middle of the screen
      rootMargin: root.classList.contains('scrolly--wide') ? '-87% 0px -12% 0px' : '-45% 0px -45% 0px'
    });
    Array.prototype.forEach.call(steps, function (s) { observer.observe(s); });
    if (steps.length) activate(steps[0]);
  }

  function init() {
    Array.prototype.forEach.call(document.querySelectorAll('.scrolly'), setup);
  }

  init();
  var pushState = document.getElementById('_pushState');
  if (pushState) pushState.addEventListener('hy-push-state-after', init);
})();

// Full-width scrolly chapters: stretch across the whole area right of the
// sidebar (CSS alone can only centre them on the text column). Desktop only.
(function () {
  function widen() {
    var desktop = window.matchMedia('(min-width: 64em)').matches;
    var drawer = document.querySelector('hy-drawer');
    Array.prototype.forEach.call(document.querySelectorAll('.scrolly--wide'), function (sec) {
      if (!desktop) { sec.style.width = ''; sec.style.marginLeft = ''; return; }
      var parent = sec.parentElement;
      var pLeft = parent.getBoundingClientRect().left + parseFloat(getComputedStyle(parent).paddingLeft || 0);
      var left = (drawer ? drawer.getBoundingClientRect().right : 0) + 32;
      var right = document.documentElement.clientWidth - 32;
      var w = Math.min(right - left, 1800);
      var x = left + (right - left - w) / 2;
      sec.style.width = w + 'px';
      sec.style.marginLeft = (x - pLeft) + 'px';
    });
  }
  widen();
  window.addEventListener('load', widen);
  var t;
  window.addEventListener('resize', function () { clearTimeout(t); t = setTimeout(widen, 150); });
  var pushState = document.getElementById('_pushState');
  if (pushState) pushState.addEventListener('hy-push-state-after', widen);
})();
