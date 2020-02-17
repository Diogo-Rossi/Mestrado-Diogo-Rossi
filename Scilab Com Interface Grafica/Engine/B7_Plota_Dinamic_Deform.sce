if nao_calculado
// A deformada é calculada somente no caso em que já não tenha 
// sido, pois esse processo (esse loop) é muito demorado                
    DX = zeros(np,m,N1);
    DY = zeros(np,m,N1);
    CDX = zeros(np,m,N1);
    CDY = zeros(np,m,N1);
    d = zeros(6,1);                          
    
    winH = waitbar(0,"Calculando deformada . . .");
    tot = m*N1*np;
    for i=1:m
        N = MN(Lx(i));  
        R2 = [c(i) -s(i);
              s(i)  c(i)];                                        
        DxL = Lx(i)/(np-1);              
        for k=1:N1                
            for j=1:6
                d(j) = DJ(Des(i,j),k);
            end
            // O vetor 'd' é colocado em coordenadas nos eixos
            // locais, usando a equação XXX
            d = Rt(:,:,i)*d;
            // O campo de deslocamentos em eixos locais é obtido
            // usando a equação XXX                                            
            fi = N*d;
            // A deformada é obtida para np pontos ao longo da barra   
            xL = 0; 
            for j=1:np
                des = horner(fi,xL);
                xL = xL + DxL;
                // Mudança de base executada com a equação XXX
                des = R2*des;
                DX(j,i,k) = des(1);
                DY(j,i,k) = des(2);
                waitbar((np*N1*(i-1)+np*(k-1)+np)/tot,winH)
            end                                        
        end
    end
    close(winH);                
end

// Informa que a deformada dinâmica já foi calculada ao menos
// uma vez e delcara o fator de escala da deformada
nao_calculado = 0;

// Delcara o fator de escala da deformada e Tempo que se pretende rolar o filme
resposta = evstr(x_mdialog("Fator de escala e tempo:", ...
                          ["Fator de escala:" "Tempo do Filme (seg):"], ...
                          ["100" "10"]));
[fs,tempo] = (resposta(1),resposta(2));

if ~isempty(fs) then
    
    // Calcula as coordenadas da deformada para todos os instantes
    winH = waitbar(0,"Calculando deformada . . .")
    for k=1:N1
        CDX(:,:,k) = CX + fs*DX(:,:,k);
        CDY(:,:,k) = CY + fs*DY(:,:,k);
        waitbar(k/N1,winH)
    end
    close(winH);
    
    BoundX = eixoEstr.data_bounds(2)
    BoundY = eixoEstr.data_bounds(4)
    delete(Deformada(1).parent)
    plot(eixoEstr,CDX(:,:,1),CDY(:,:,1),'r');
    Deformada = gce().children
    eixoEstr.data_bounds = [0 BoundX 0 BoundY]
    
    for i=1:3
        Axes(i).tight_limits(2) = "on"
        plot(Axes(i),[0;0],Axes(i).data_bounds(3:4))
        TimeBar(i) = gce().children
    end
    for k=1:N1
        for i=1:m
            Deformada(i).data = [CDX(:,i,k),CDY(:,i,k)];
        end
        for i=1:3
            TimeBar(i).data(:,1) = [t(k);t(k)]
        end
        sleep(tempo/N1,"s");
    end
    delete(TimeBar)
end              
