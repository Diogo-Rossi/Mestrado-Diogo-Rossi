    if ~isempty(LabelNohs); delete(LabelNohs(1).parent);LabelNohs=[];end
    if ~isempty(LabelBars); delete(LabelBars(1).parent);LabelBars=[];end
    if ~isempty(LabelLoad); delete(LabelLoad(1).parent);LabelLoad=[];end

    if ~isempty(Barras); delete(Barras.parent);Barras=[];end
    if ~isempty(Cargas); delete(Cargas.parent);Cargas=[];end
    if ~isempty(Restricoes); delete(Restricoes.parent);Restricoes=[];end
    if ~isempty(HistCargas); delete(HistCargas.parent);HistCargas=[];end
    listaGraficos(1).string = [""]
    listaGraficos(1).enable = "off"
