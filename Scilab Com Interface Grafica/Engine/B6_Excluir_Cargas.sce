frame_left_estr.enable ="off"

// Escolha dos nós
LoadstoDel = SelectNodesInMat(Cargas.user_data(:,1:2))

if ~isempty(LoadstoDel) then
    Labels = ["Força em X"; "Força em Y"; "Momento em Z"];
    CarDir = evstr(x_mdialog("Direções das cargas",Labels,["%F";"%F";"%F"]))
    if ~isempty(CarDir) & or(CarDir) then
        DirLoad = []
        for i=LoadstoDel'
            if or(Cargas(i).user_data(:,3)==find(CarDir)) then
                DirLoad = [DirLoad i]
            end
        end
        Cargas = DeleteItemInArrayStructure(DirLoad,Cargas)
        HistCargas = DeleteItemInArrayStructure(DirLoad,HistCargas)
    end
end

frame_left_estr.enable ="on"
BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
