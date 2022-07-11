// SELEÇÃO DE NÓS NO EIXO DA ESTRUTURA, DADA LISTA DE COORDENADAS

function nos = SelectNodesInMat(Mat)
    sca(eixoEstr)
    //[botao,x,y]=xclick();
    [Rect,But]=rubberbox(%T);
    plot(%nan,%nan,'s','MarkSize',15)
    selecao = gce().children
    nos = []
    
    while and(But~=[2]) // Enquanto não clicar no botão direito
        if Rect(3)<%eps & Rect(4)<%eps then
            [x y] = PtoMaisProx(eixoEstr,[Rect(1) Rect(2)],Mat)
        else
            Sel = EncontrarPontosDentro(Rect,Mat);
            x = Sel(:,1)
            y = Sel(:,2)
        end   
        if ~isempty([x y]) then
            for i=1:size(x,"*")
                noh = vectorfind(Mat,[x(i) y(i)],"r")
                nos = [nos; noh']
                selecao.data = [selecao.data; x y]
            end
        end
        [Rect,But]=rubberbox(%T);
    end
    delete(selecao.parent)
    nos = unique(nos)
endfunction

function struc = DeleteItemInArrayStructure(inds,struc)
    if ~isempty(inds) then
        Temp = struc(setdiff(1:length(struc),inds))
        delete(struc(inds).parent)
        struc = Temp
    end 
endfunction

// Parece que não precisou desta
function Historico = LoadHist(dados,T)
    t = [0:0.01:T]
    opC = dados(3)
    t0  = dados(4)
    t1  = dados(5)
    w1  = dados(5)
    F   = dados(6)
    Ft  = []
    for i=t
        Ft = [Ft Carregamento(1,1,opC,1,t0,t1,w1,F,i)]
    end
    Historico = [t' Ft']
endfunction
