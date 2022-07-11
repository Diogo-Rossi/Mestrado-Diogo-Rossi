
if checkBox(3).value then
    checkBox(6).enable = "on"
else 
    checkBox(6).enable = "off"
end

Elemento = {GridEstrutura Restricoes Cargas LabelNohs LabelBars LabelLoad}

for i=1:6
    if checkBox(i).value && checkBox(i).enable=="on" then
        Elemento{i}.visible = "on"
    else 
        Elemento{i}.visible = "off"
    end
end
if ~isempty(Barras) then
    if checkBox(7).value && checkBox(7).enable=="on" then
        Barras.mark_mode = 'on'
    else
        Barras.mark_mode = 'off'
    end
end
jan.immediate_drawing = "on"
