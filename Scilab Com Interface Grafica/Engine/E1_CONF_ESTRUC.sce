jan.immediate_drawing = "off"
sca(eixoEstr)
if ~isempty(Barras) then                
    
    // Coleta coordenadas dos nós
    [dummy order] = unique(Barras.data,"r")     // Elimina nós repetidos
    coord = Barras.data(gsort(order,"g","i"),:) // Extrai nós não repetidos
    
    if ~isempty(LabelNohs); delete(LabelNohs(1).parent);LabelNohs=[];end
    xstring(coord(:,1),coord(:,2),string([1:size(coord,1)]))
    if size(coord,1)==1 then
        LabelNohs = gce()
    else
        LabelNohs = gce().parent.children
    end
    LabelNohs.font_size = 3
    LabelNohs.font_foreground = color(0,0,255) // Labels dos nós em azul
    
    if ~isempty(LabelBars); delete(LabelBars(1).parent);LabelBars=[];end
    xLabel  = (Barras.data(1:2:$-1,1)+Barras.data(2:2:$,1))/2
    yLabel  = (Barras.data(1:2:$-1,2)+Barras.data(2:2:$,2))/2
    xstring(xLabel,yLabel,string([1:length(Barras)]))
    if length(Barras)==1 then
        LabelBars = gce()
        glue(LabelBars)
    else
        LabelBars = gce().parent.children
    end
    LabelBars.font_size = 4
    LabelBars.font_foreground = color(255,0,0) // Labels das barras em vermelho
       
    // Habilita poder excluir barras e inserir apoios, e inserir cargas
    BotoesGeomet(2:3).enable='on';
    BotoesCargas(1).enable='on'
else
    if ~isempty(LabelNohs); delete(LabelNohs(1).parent);LabelNohs=[];end
    if ~isempty(LabelBars); delete(LabelBars(1).parent);LabelBars=[];end
    //delete(LabelNohs); LabelNohs=[]
    //delete(LabelBars); LabelBars=[]
    BotoesGeomet(2:4).enable='off'
    BotoesCargas(1:2).enable='off'
end

if ~isempty(Cargas) then  
    if ~isempty(LabelLoad); delete(LabelLoad(1).parent);LabelLoad=[];end
    dados = Cargas.user_data
    xLabel = dados(:,1) + 0.5*abs(dados(:,3)-2).*sign(dados(:,7))
    yLabel = dados(:,2) + 0.5*abs(abs(dados(:,3)-2)-1).*sign(dados(:,7))
    xstring(xLabel,yLabel,part(HistCargas.tag,[1:3]))
    if length(Cargas)==1 then
        LabelLoad = gce()
        glue(LabelLoad)
    else
        LabelLoad = gce().parent.children
    end
    LabelLoad.font_size = 4
    LabelLoad.font_foreground = color(0,0,0)
else
    if ~isempty(LabelLoad); delete(LabelLoad(1).parent);LabelLoad=[];end
    //delete(LabelLoad); LabelLoad=[]
    BotoesCargas(2).enable='off'
end
