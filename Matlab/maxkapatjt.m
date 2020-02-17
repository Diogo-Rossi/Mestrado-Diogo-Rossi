function maxkapatjt=maxkapatjt(tj,t,kapa,vett)
    if abs(tj-t)<1e-14
        maxkapatjt = kapa(vett==t);
    else
        maxkapatjt = max(kapa((vett>=tj)&(vett<=t)));
    end
end
    