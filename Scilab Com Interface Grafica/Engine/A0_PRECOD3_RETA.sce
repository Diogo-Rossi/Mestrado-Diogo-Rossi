// FUNÇÃO PARA ACHAR SEGUIMENTO DE RETA MAIS PRÓXIMO
// Função que encontra o índice de um seguimento de reta, dentro de uma lista de
// seguimenos de retas, L(i), aquela que seja a mais próxima de um dado 'ponto' 
// [x y]. O elemento da lista que define o seguimento de reta é uma matriz 2x2
// que contém seu ponto inicial e final nas linhas da matriz
function pos = RetaMaisProx(eixo,ponto,L,varargin)
    // Ajusta a escala dos eixos
    LX = eixo.data_bounds(2)-eixo.data_bounds(1);
    LY = eixo.data_bounds(4)-eixo.data_bounds(3);
    if eixo.isoview == "on" then
        sclfac = 1
    else        
        W = eixo.parent.position(3)*(1 - sum(eixo.margins(1:2)))
        H = eixo.parent.position(4)*(1 - sum(eixo.margins(3:4)))
        sclfac = (LX/W)*(H/LY);
    end
    
    // Ponto dado
    x = ponto(1);
    y = sclfac*ponto(2);
    
    for i=1:length(L)
        x1=L(i)(1,1); y1=L(i)(1,2)*sclfac;
        x2=L(i)(2,1); y2=L(i)(2,2)*sclfac;
        D  = gsort([x1 x2],"g","i")
        Im = gsort([y1 y2],"g","i")
        a = (y2-y1)/(x2-x1)
        b = -1
        c = y1-a*x1
        xInt = (y+x/a-c)/(a+1/a)
        [x1 x2] = (D(1),D(2))
        [y1 y2] = (Im(1),Im(2))
        if abs(x1-x2)<=%eps & y>=y1 & y<=y2 then 
            dist(i) = abs(x-x1) //------------------------ Caso reta vertical
        elseif abs(y1-y2)<=%eps & x>=x1 & x<=x2 then
            dist(i) = abs(y-y1) //------------------------ Caso reta horizontal
        elseif abs(x1-x2)>%eps & abs(y1-y2)>%eps & xInt>=x1 & xInt<=x2 then
            dist(i) = abs(a*x+b*y+c)/sqrt(a^2+b^2) //----- Caso reta inclinada
        else // Interseção fora do domínio (menor distânica não perpendicular)
            dist(i) = min(sqrt((x-[x1 x2])^2+(y-[y1 y2])^2))
        end
    end

    // Verifica distânica mínima, caso não haja argumento varargin
    if min(dist)<=min(LX,sclfac*LY)/5 || ~isempty(varargin) then 
        pos = find(dist==min(dist));
    else
        pos = [];
    end
endfunction
