jan.immediate_drawing = "off"

Historico = {HistCargas HistDesloc}

for i=1:2
    Item = listaGraficos(i).value
    if listaGraficos(i).enable=="on" && ~isempty(Item) && Item<>0 then
        if Item==1 then
            Historico{i}.visible = "on"
            legend(Historico{i},Historico{i}.tag)
        else
            Historico{i}.visible = "off"
            Historico{i}(Item-1).visible = "on"
            legend(Historico{i}(Item-1),Historico{i}(Item-1).tag)
        end
    end
end

Item = listaGraficos(3).value
if listaGraficos(3).enable=="on" && ~isempty(Item) && Item<>0 then
    
    HistATSstr.visible = "off"
    HistATSstr(Item).visible = "on"
    legend(HistATSstr(Item).children,HistATSstr(Item).children.tag)
    
    ValMax = max(HistATSstr(Item).children.data(:,2))
    Axes(3).data_bounds = [0 0; T1 5/4*ValMax]
    
end

jan.immediate_drawing = "on"



    
