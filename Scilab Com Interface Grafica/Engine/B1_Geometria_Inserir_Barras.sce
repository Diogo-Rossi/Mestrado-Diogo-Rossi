// BOTÃO INSERIR BARRAS
frame_left_estr.enable ="off"
Ndiv = evstr(x_mdialog("Número de divisões nas barras",["Divisões:"],["1"]))

if ~isempty(Ndiv) then
    sca(eixoEstr)
    [rep(3),x1,y1]=xclick(); // Primeiro ponto clicado na janela de eixos
    GRID=[0 0]
    if checkBox(1).value then         // Seleciona ponto do Grid caso exibido
        GRID = unique([Barras; GridEstrutura].data,"r")
    elseif ~isempty(Barras) then      // Seleção de nós existentes na estrutura
        GRID = unique(Barras.data,"r")
    end
    [X1 Y1] = PtoMaisProx(eixoEstr,[x1 y1],GRID)
    if ~isempty([X1 Y1]) then; x1=X1; y1=Y1; end

    // Plota o primeiro ponto e aguarda o segundo da primeira parra
    plot([x1],[y1])
    polyline = gce().children
    rep=[x1,y1,-1]
    while rep(3)==-1
        rep=xgetmouse();
        x2=rep(1)
        y2=rep(2)
        polyline.data = [x1 y1; x2 y2];
    end

    // Enquanto não clicar no botão central
    while and(rep(3)~=[2 5])
        if checkBox(1).value then     // Seleciona ponto do Grid caso exibido
            GRID = unique([Barras; GridEstrutura].data,"r")
        elseif ~isempty(Barras) then  // Seleção de nós existentes na estrutura
            GRID = unique(Barras.data,"r")
        end
        [X2 Y2] = PtoMaisProx(eixoEstr,[x2 y2],GRID)
        if ~isempty([X2 Y2]) then; x2=X2; y2=Y2; end
        polyline.data($,:) = [x2 y2]
        
        // Faz subdivisões na reta inserida e cria dados das barras
        for i=1:Ndiv
            X = [x1 + (i-1)*(x2-x1)/Ndiv ; x1 + i*(x2-x1)/Ndiv]
            Y = [y1 + (i-1)*(y2-y1)/Ndiv ; y1 + i*(y2-y1)/Ndiv]
            plot(X,Y,"-x")
            Barras = [Barras; gce().children]
        end

        // Plota temporariamente o segundo ponto das próximas barras
        x1 = x2
        y1 = y2
        atual = polyline.data
        rep(3) = -1
        while rep(3)==-1
            rep=xgetmouse();
            x2=rep(1)
            y2=rep(2)
            polyline.data = [atual; x2 y2];
        end
    end
    delete(polyline.parent) // Deleta a curva auxiliar temporária
    
    BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
    BotoesMatrizes.enable = "off"
    for i=1:3; frequencias(i).string = ""; end;
end
frame_left_estr.enable ="on"
