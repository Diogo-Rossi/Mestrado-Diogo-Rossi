// BOTÃO EXCLUIR BARRAS
frame_left_estr.enable ="off"
sca(eixoEstr)
[botao,x0,y0]=xclick(); // ponto clicado na janela de eixos

// Enquanto não clicar no botão central e houver barras para apagar
while and(botao~=[2 5]) && size(Barras,1)>0
    
    // Cria lista com ponto inicial e final das barras
    Lista = list()
    for i=1:length(Barras)
        Lista(i) = Barras(i).data
    end
    
    // Encontra barra mais próxima
    NumBarra = RetaMaisProx(eixoEstr,[x0 y0],Lista)
    
    // Apaga barras da estrutura de manipuladores de polyines
    Barras = DeleteItemInArrayStructure(NumBarra,Barras)
    
    if ~isempty(Barras) then
        
        BotoesGeomet(2).enable='on'
        [dummy order] = unique(Barras.data,"r")     // Elimina nós repetidos
        coord = Barras.data(gsort(order,"g","i"),:) // Extrai nós não repetidos
        
        // Deleta restrições de apoio nos nós que não estão mais em barras
        BCtoDel = []
        for i=1:size(Restricoes,"*")
            if isempty(vectorfind(coord,Restricoes(i).data,"r")) then
                BCtoDel = [BCtoDel i]
            end
        end
        Restricoes = DeleteItemInArrayStructure(BCtoDel,Restricoes)
        if isempty(Restricoes) then; BotoesGeomet(4).enable='off'; end    

        // Deleta cargas nos nós que não estão mais em barras
        LoadstoDel = []
        for i=1:size(Cargas,"*")
            if isempty(vectorfind(coord,Cargas(i).user_data(:,1:2),"r")) then
                LoadstoDel = [LoadstoDel i]
            end
        end
        Cargas = DeleteItemInArrayStructure(LoadstoDel,Cargas)
        HistCargas = DeleteItemInArrayStructure(LoadstoDel,HistCargas)
        if isempty(Cargas) then; BotoesCargas(2).enable='off'; end 
        
        [botao,x0,y0]=xclick();
        
    else
        delete(Cargas);delete(Restricoes);delete(HistCargas)
        coord = []; Restricoes = []; Cargas=[]; HistCargas=[]
        BotoesGeomet(2:4).enable = "off"
        BotoesCargas(1:2).enable = "off"
        botao=2
        
    end
    
    BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
    BotoesMatrizes.enable = "off"
    for i=1:3; frequencias(i).string = ""; end;
end

frame_left_estr.enable ="on"
