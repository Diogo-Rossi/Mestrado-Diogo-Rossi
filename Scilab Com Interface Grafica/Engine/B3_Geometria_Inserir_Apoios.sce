frame_left_estr.enable ="off"
Apoios =[]

// Escolha dos nós da estrutura
nos = SelectNodesInMat(coord)

// Apaga a restrição nos nós selecionados que eventualmente já tivessem apoiados
if ~isempty(Restricoes) then
    JahApoiados = []
    for i=1:size(nos,"*") 
        JahApoiado = vectorfind(Restricoes.data,coord(nos(i),:),"r")
        JahApoiados = [JahApoiados JahApoiado]
    end
    Restricoes = DeleteItemInArrayStructure(JahApoiados,Restricoes)
end

// Escolha das restrições
if ~isempty(nos) then
    Labels = ["Translação em X"; "Translação em Y"; "Rotação em Z"];
    Apoios = evstr(x_mdialog("Restrições de apoio",Labels,["%F";"%F";"%F"]))
end

if ~isempty(Apoios) & or(Apoios) then
    
    // Símbolo das restrições
    Symbol = ["<" "^" "p" "d" "v" "s" "o"]
    for i=1:size(nos,"*")
        
        // Seleciona o símbolo: e caso seja o 3, vira o 7
        SymIndex = sum(find(Apoios'))
        if SymIndex==3 then; SymIndex=SymIndex+(length(find(Apoios'))-1)*4; end

        // Plota a restrição
        plot(coord(nos(i),1),coord(nos(i),2),Symbol(SymIndex),'MarkSize',15)
        gce().children.mark_background = [1 0 0]
        
        // Armazena a restrição na estrutura de manipuladores de polylines
        Restricoes = [Restricoes; gce().children]
        Restricoes($).user_data = Apoios'
    end
    
    BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
    BotoesMatrizes.enable = "off"
    for i=1:3; frequencias(i).string = ""; end;
end

if ~isempty(Restricoes) then
    BotoesGeomet(4).enable='on'
end

frame_left_estr.enable ="on"

