frame_left_estr.enable ="off"

// Escolha dos nós
BCtoDel = SelectNodesInMat(Restricoes.data)

// Restrições de apoio a deletar
Restricoes = DeleteItemInArrayStructure(BCtoDel,Restricoes)

if isempty(Restricoes) then
    BotoesGeomet(4).enable='off'
end

frame_left_estr.enable ="on"

if ~isempty(BCtoDel) then
    BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
    BotoesMatrizes.enable = "off"
    for i=1:3; frequencias(i).string = ""; end;
end
