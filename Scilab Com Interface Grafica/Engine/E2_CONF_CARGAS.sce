jan.immediate_drawing = "off"
if ~isempty(Cargas) then
    
    CargaMax = max(HistCargas.data(:,2))
    CargaMin = min(HistCargas.data(:,2))
    Axes(1).data_bounds(3) = CargaMin - (CargaMax-CargaMin)/4
    Axes(1).data_bounds(4) = CargaMax + (CargaMax-CargaMin)/4
    
    listaGraficos(1).enable = "on"    
    listaGraficos(1).string = ["Todas as Cargas"; HistCargas.tag]
    listaGraficos(1).value =[1]    
    BotoesCargas(2).enable  = "on"
    execstr(listaGraficos(1).callback)
else
    listaGraficos(1).enable = "off"
    listaGraficos(1).string = [""]
    listaGraficos(1).value =[1]    
    BotoesCargas(2).enable  = "off"
end
