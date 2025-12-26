var __DEV__ = (typeof window !== 'undefined' && window.__DX_DEV__ === true);
if (__DEV__) { try { console.log('dx: dx-photo.js loaded'); } catch(e){} }

(function () {
    function resetAll() {
        // Collapse any open panels/bars
        document.querySelectorAll('.photo__overlaybar.is-visible, .photo__meta.is-visible')
            .forEach(el => el.classList.remove('is-visible'));

        // Hide any meta text blocks
        document.querySelectorAll('.photo__meta-text')
            .forEach(el => el.classList.add('is-hidden'));

        // Ensure buttons show collapsed state
        document.querySelectorAll('.photo__info-btn')
            .forEach(btn => btn.setAttribute('aria-expanded', 'false'));

        // Ensure panels/bars are hidden by default
        document.querySelectorAll('.photo__overlaybar, .photo__meta [id], .photo__meta')
            .forEach(el => {
                if (el.classList.contains('photo__overlaybar') || el.id) {
                    el.classList.add('is-hidden');
                    el.classList.remove('is-visible');
                }
            });
    }

    function toggle(e) {
        const btn = e.target.closest('.photo__info-btn');
        if (!btn) return;

        e.preventDefault();

        const id = btn.getAttribute('aria-controls');
        if (!id) return;

        const target = document.getElementById(id);
        if (!target) return;

        const next = btn.getAttribute('aria-expanded') !== 'true';
        btn.setAttribute('aria-expanded', String(next));

        target.classList.toggle('is-hidden', !next);
        target.classList.toggle('is-visible', next);

        // If there’s a nested meta text element, toggle it too
        const metaText = target.querySelector('.photo__meta-text');
        if (metaText) metaText.classList.toggle('is-hidden', !next);
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (__DEV__) { try { console.log('dx: dx-photo.js DOMContentLoaded'); } catch(e){} }
        resetAll();
    });

    document.addEventListener('click', toggle, false);
})();