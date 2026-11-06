(function () {
  document.querySelectorAll("[data-copy]").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var el = document.getElementById(btn.getAttribute("data-copy"));
      if (!el) return;
      var text = (el.textContent || "").trim();
      var old = btn.textContent;
      function show(label) {
        btn.textContent = label;
        setTimeout(function () {
          btn.textContent = old;
        }, 2000);
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(
          function () {
            show("Copied");
          },
          function () {
            show("Copy it from the box");
          }
        );
      } else {
        show("Copy it from the box");
      }
    });
  });
})();
