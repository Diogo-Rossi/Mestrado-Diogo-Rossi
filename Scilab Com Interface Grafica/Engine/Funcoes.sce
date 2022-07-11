function p = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t)
    p = zeros(n,1);
    for i=1:nc
        switch opC(i)
            case 1  // ------------------------ Carga Impulsiva Constante          
                if t < t0(i)
                    p(desC(i)) = 0;
                elseif t <= t0(i)+t1(i)
                    p(desC(i)) = F(desC(i));
                else
                    p(desC(i)) = 0; 
                end
            case 2  // ------------------------ Carga Triangular Decrescente
                slope = F(desC(i))/t1(i);
                if t < t0(i)           
                    p(desC(i)) = 0; 
                elseif t <= t0(i)+t1(i)
                    p(desC(i)) = F(desC(i)) - slope*(t-t0(i));           
                else
                    p(desC(i)) = 0;                
                end
            case 3  // ------------------------ Carga Triangular Simétrica
                slope = F(desC(i))/(t1(i)/2);
                if t < t0(i)           
                    p(desC(i)) = 0; 
                elseif t <= t0(i)+t1(i)/2
                    p(desC(i)) = slope*(t-t0(i));           
                elseif t <= t0(i)+t1(i)
                    p(desC(i)) = F(desC(i)) - slope*(t-(t0(i)+t1(i)/2));
                else
                    p(desC(i)) = 0;
                end           
            case 4  // ------------------------ Carga Harmônica Senoidal
                p(desC(i)) = F(desC(i))*sin(w1(i)*t);
            case 5  // ------------------------ Rampa até carga constante (NOVO)
                slope = F(desC(i))/t1(i);
                if t < t0(i)           
                    p(desC(i)) = 0; 
                elseif t <= t0(i)+t1(i)
                    p(desC(i)) = slope*(t-t0(i));           
                else
                    p(desC(i)) = F(desC(i));
                end               
        end
    end
end

function f=f(x,CSIp,CSIm)
    if 0<=x && x<(1/CSIp)    ; f = x; end
    if (1/CSIp)<=x && x<CSIp ; f = 1; end
    if CSIp<=x && x<CSIm     ; f = x; end
    if CSIm<=x               ; f = CSIm; end
end

function maxkapatjt=maxkapatjt(tj,t,kapa,vett)
    if abs(tj-t)<1e-14
        maxkapatjt = kapa(vett==t);
    else
        maxkapatjt = max(kapa((vett>=tj)&(vett<=t)));
    end
end
