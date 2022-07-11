// FUNÇÃO PARA ACHAR PONTO MAIS PRÓXIMO
// Função que encontra dentro de um conjunto de 'PONTOS' [X Y] o ponto mais
// próximo de um dado 'ponto' [x y], num dado 'eixo' gráfico. O último argumento
// pula a etapa de verificação de distância mínima (1/5 do comprimento do eixo)
function [Xp,Yp] = PtoMaisProx(eixo,ponto,PONTOS,varargin)
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

    // Ponto e conjunto de pontos dados
    x = ponto(1);
    y = sclfac*ponto(2);
    X = PONTOS(:,1);
    Y = sclfac*PONTOS(:,2);
    
    // Distancias
    dists = sqrt((x-X)^2+(y-Y)^2);
    
    // Verifica distânica mínima, caso não haja argumento varargin
    if min(dists)<=min(LX,sclfac*LY)/5 || ~isempty(varargin) then
        pos = find(dists==min(dists));
        pto = unique(PONTOS(pos,:),"r")
        Xp = pto(:,1);
        Yp = pto(:,2);
    else
        Xp = [];
        Yp = [];
    end
endfunction

function [PontosDentro] = EncontrarPontosDentro(retangulo,PONTOS)
    Xmin = retangulo(1);
    Ymax = retangulo(2);
    W = retangulo(3);
    H = retangulo(4);
    Xmax = Xmin + W;
    Ymin = Ymax - H;
    
    x = PONTOS(:,1);
    y = PONTOS(:,2);
    
    PontosDentro = PONTOS(x>=Xmin & x<=Xmax & y>=Ymin & y<=Ymax,:);
    //g.teste = PontosDentro //(02/out/2017)
    
endfunction
