(function () {
  function codeElementFromBlock(block) {
    // Chroma with line numbers often renders a table with two columns:
    // left = line numbers, right = code. Prefer the right column.
    const lnTable = block.querySelector('table.lntable');
    if (lnTable) {
      const code = lnTable.querySelector('td:last-child pre code');
      if (code) return code;
    }

    // Fallback: pick the last <pre><code> (some layouts render multiple code blocks)
    const codes = block.querySelectorAll('pre code');
    if (!codes || codes.length === 0) return null;
    return codes[codes.length - 1];
  }

  function textFromBlock(block) {
    const code = codeElementFromBlock(block);
    if (!code) return '';
    // Use innerText so we preserve line breaks; strip one trailing newline
    return code.innerText.replace(/\n$/, '');
  }

  async function copyToClipboard(btn, block) {
    const txt = textFromBlock(block);
    if (!txt) return;

    try {
      await navigator.clipboard.writeText(txt);
      const old = btn.textContent;
      btn.textContent = 'Copied';
      setTimeout(() => (btn.textContent = old), 900);
    } catch (e) {
      // Fallback: select text
      const range = document.createRange();
      const code = codeElementFromBlock(block);
      if (!code) return;
      range.selectNodeContents(code);
      const sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    }
  }

  document.addEventListener('click', function (e) {
    const btn = e.target.closest('[data-dx-code-copy]');
    if (!btn) return;
    const block = btn.closest('[data-dx-code]');
    if (!block) return;
    e.preventDefault();
    copyToClipboard(btn, block);
  });
})();
