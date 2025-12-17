(function(){
    function initOne(root){
        if (!root || root.__scInit) return;
        root.__scInit = true;

        var stage = root.querySelector('.sc-slider-stage');
        var range = root.querySelector('.sc-range');
        var beforeFig = root.querySelector('.sc-figure.sc-before');

        // Read initial pos from JSON config (non-executable)
        var cfg = document.getElementById(root.id + '-cfg');
        var initPos = 50;
        if (cfg) {
            try { var json = JSON.parse(cfg.textContent || '{}'); if (typeof json.pos === 'number') initPos = json.pos; } catch(_){}
        }

        function setPos(pct){
            pct = Math.max(0, Math.min(100, pct));
            var v = pct + '%';
            root.style.setProperty('--pos', v);
            if (stage) stage.style.setProperty('--pos', v);
            if (beforeFig) beforeFig.style.setProperty('--pos', v);
            if (range && document.activeElement !== range) range.value = pct;
        }

        function pctFromClientX(clientX){
            var rect = stage.getBoundingClientRect();
            var x = Math.max(0, Math.min(rect.width, clientX - rect.left));
            return (x / rect.width) * 100;
        }

        function clientXFromEvent(e){
            if (e.clientX != null) return e.clientX;
            if (e.touches && e.touches[0]) return e.touches[0].clientX;
            if (e.changedTouches && e.changedTouches[0]) return e.changedTouches[0].clientX;
            return 0;
        }

        var dragging = false;
        function onDown(e){
            dragging = true;
            if (stage.setPointerCapture && e.pointerId != null) { try { stage.setPointerCapture(e.pointerId); } catch(_){} }
            setPos(pctFromClientX(clientXFromEvent(e)));
            if (e.cancelable) e.preventDefault();
        }
        function onMove(e){
            if (!dragging) return;
            setPos(pctFromClientX(clientXFromEvent(e)));
            if (e.cancelable) e.preventDefault();
        }
        function onUp(e){
            dragging = false;
            if (stage.releasePointerCapture && e.pointerId != null) { try { stage.releasePointerCapture(e.pointerId); } catch(_){} }
            if (e.cancelable) e.preventDefault();
        }
        function onClick(e){
            setPos(pctFromClientX(clientXFromEvent(e)));
        }

        // Events (pointer + mouse + touch)
        stage.addEventListener('pointerdown', onDown);
        stage.addEventListener('pointermove', onMove);
        stage.addEventListener('pointerup', onUp);
        stage.addEventListener('pointercancel', onUp);
        root.addEventListener('click', onClick);

        stage.addEventListener('mousedown', onDown);
        window.addEventListener('mousemove', onMove);
        window.addEventListener('mouseup', onUp);

        stage.addEventListener('touchstart', onDown, {passive:false});
        stage.addEventListener('touchmove',  onMove, {passive:false});
        stage.addEventListener('touchend',   onUp,   {passive:false});
        stage.addEventListener('touchcancel',onUp,   {passive:false});

        if (range) {
            range.addEventListener('input',  function(e){ setPos(parseFloat(e.target.value)); });
            range.addEventListener('change', function(e){ setPos(parseFloat(e.target.value)); });
            range.addEventListener('keydown', function(e){
                var step = (e.shiftKey ? 10 : 2);
                var val = parseFloat(range.value || 50);
                if (e.key === 'ArrowLeft')  { setPos(val - step); e.preventDefault(); }
                if (e.key === 'ArrowRight') { setPos(val + step); e.preventDefault(); }
                if (e.key === 'Home') { setPos(0); e.preventDefault(); }
                if (e.key === 'End')  { setPos(100); e.preventDefault(); }
            });
        }

        // Initialize to starting position
        setPos(initPos);
    }

    function initAll(){
        document.querySelectorAll('.sc-slider[data-sc-slider="true"]').forEach(initOne);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAll);
    } else {
        initAll();
    }
})();