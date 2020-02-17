function f=f(x,CSIp,CSIm)

if 0<=x && x<(1/CSIp)    ; f = x; end
if (1/CSIp)<=x && x<CSIp ; f = 1; end
if CSIp<=x && x<CSIm     ; f = x; end
if CSIm<=x               ; f = CSIm; end

end
    