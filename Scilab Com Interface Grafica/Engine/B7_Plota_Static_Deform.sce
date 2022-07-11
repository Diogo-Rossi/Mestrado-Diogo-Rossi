// Exibe a deformada estática da estrutura considerando F (valores 
// máximos para as cargas nodais) como carregamento estático  
DJE = zeros(3*nj,1);  
DE = K\F;      // Solução estática para os graus de liberdade      
DJE(GL) = DE;  // Deslocamentos globais     

DEX = zeros(np,m);
DEY = zeros(np,m);
d = zeros(6,1);
for i=1:m
    N = MN(Lx(i));
    R2 = [c(i) -s(i);
          s(i)  c(i)];
    DxL = Lx(i)/(np-1);                
    for j=1:6
        d(j) = DJE(Des(i,j));
    end
    // O vetor 'd' é colocado em coordenadas nos eixos locais,
    // usando a equação XXX                
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
        DEX(j,i) = des(1);
        DEY(j,i) = des(2);
    end
end

// Delcara o fator de escala da deformada
fs = evstr(x_mdialog("Fator de escala Deformada",["Fator de escala:"],["100"]))

if ~isempty(fs) then

    // Calcula as coordenadas da deformada
    CDEX = CX + fs*DEX;
    CDEY = CY + fs*DEY;

    BoundX = eixoEstr.data_bounds(2)
    BoundY = eixoEstr.data_bounds(4)
    delete(Deformada(1).parent)
    sca(eixoEstr)
    plot(CDEX(:,:),CDEY(:,:),'r')
    Deformada = gce().children
    eixoEstr.data_bounds = [0 BoundX 0 BoundY]
    
end

