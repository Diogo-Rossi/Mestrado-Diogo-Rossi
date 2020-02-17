Arquivo = uigetfile(["*.dinam","Arquivos de Análise Dinâmica"], ...
                    fileparts(pwd()),"Escolha arquivo contendo dados");

jan.immediate_drawing = "off"

if ~isempty(Arquivo) then

    load(Arquivo)

    Campos = {MaterialData SectionData DampingData NewmarkBeta DeltaT_CTS ATS_Bergan ATS_Hulbert ATS_Cintra}

    k=1
    for i=1:size(Campos,"*")
        for j=1:size(Campos{i},"*")
            Campos{i}(j).string = EditBoxData(k)
            k=k+1
        end
    end
    
    if ~isempty(LabelNohs); delete(LabelNohs(1).parent);LabelNohs=[];end
    if ~isempty(LabelBars); delete(LabelBars(1).parent);LabelBars=[];end
    if ~isempty(LabelLoad); delete(LabelLoad(1).parent);LabelLoad=[];end

    if ~isempty(Barras); delete(Barras.parent);Barras=[];end
    if ~isempty(Cargas); delete(Cargas.parent);Cargas=[];end
    if ~isempty(Restricoes); delete(Restricoes.parent);Restricoes=[];end
    if ~isempty(HistCargas); delete(HistCargas.parent);HistCargas=[];end
    listaGraficos(1).string = [""]
    listaGraficos(1).enable = "off"
    
    for i=1:2:size(BarrasData,1)-1
        X=BarrasData([i i+1],1);
        Y=BarrasData([i i+1],2);
        plot(eixoEstr,X,Y,"-x")
        Barras = [Barras; gce().children]
    end

    Symbol = ["<" "^" "p" "d" "v" "s" "o"]
    for i=1:size(ApoiosData{1},1)
        
        // Seleciona o símbolo: e caso seja o 3, vira o 7
        SymIndex = sum(find(ApoiosData{2}(i,:)))
        if SymIndex==3 then; SymIndex=SymIndex+(length(find(ApoiosData{2}(i,:)))-1)*4; end

        // Plota a restrição
        plot(ApoiosData{1}(i,1),ApoiosData{1}(i,2),Symbol(SymIndex),'MarkSize',15)
        gce().children.mark_background = [1 0 0]
        
        // Armazena a restrição na estrutura de manipuladores de polylines
        Restricoes = [Restricoes; gce().children]
        Restricoes($).user_data = ApoiosData{2}(i,:)
    end 

    T1 = evstr(NewmarkBeta(4).string); if isempty(T1) then; T1=3*t1; end
    
    for i=1:size(CargasData,1)
        x = CargasData(i,1);
        y = CargasData(i,2);
        Direcao = CargasData(i,3);
        opC = CargasData(i,4);
        t0  = CargasData(i,5);
        t1  = CargasData(i,6);
        w1  = CargasData(i,6);
        F   = CargasData(i,7);

        if Direcao == 1 then
            sca(eixoEstr)
            champ(x,y,1*sign(F),0)
            Cargas = [Cargas; gce()]
            glue(Cargas($))
            Cargas($).arrow_size = 2
            Cargas($).user_data = [Cargas($).data.x Cargas($).data.y 1 opC t0 t1 F]
        end
        if Direcao == 2 then
            sca(eixoEstr)
            champ(x,y,0,1*sign(F))
            Cargas = [Cargas; gce()]            
            glue(Cargas($))
            Cargas($).arrow_size = 2
            Cargas($).user_data = [Cargas($).data.x Cargas($).data.y 2 opC t0 t1 F]
        end
        if Direcao == 3 then
            sca(eixoEstr)
            tt = [0:%pi/4:2*%pi]*sign(F)
            plot2d4(x+0.5*cos(tt),y+0.5*sin(tt))
            Cargas = [Cargas; gce().children]
            Cargas($).arrow_size_factor = 1.5
            Cargas($).user_data = [x y 3 opC t0 t1 F]
        end
        
        Ft=[];
        for t=[0:T1/1000:T1]
            Ft($+1)=Carregamento(1,1,opC,1,t0,t1,w1,F,t)
        end

        // Coleta coordenadas dos nós
        [dummy order] = unique(Barras.data,"r")     // Elimina nós repetidos
        coord = Barras.data(gsort(order,"g","i"),:) // Extrai nós não repetidos
        noh = vectorfind(coord,[x y])
        
        Tipo = [" - FX" " - FY" " - MZ"]
        k=Direcao
        Texto = "P"+string(3*noh+k-3)+" - Noh "+string(noh)+Tipo(k)
        plot(Axes(1),[0:T1/1000:T1]',Ft)
        HistCargas = [HistCargas; gce().children]
        HistCargas($).foreground = length(HistCargas)
        HistCargas($).visible = "off"
        HistCargas($).tag = Texto
        Axes(1).data_bounds(2) = T1
    end

    BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
    BotoesMatrizes.enable = "off"
    for i=1:3; frequencias(i).string = ""; end;

end

jan.immediate_drawing = "on"
