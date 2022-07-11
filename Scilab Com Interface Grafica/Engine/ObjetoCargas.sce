jan.immediate_drawing = "off"

T1 = evstr(NewmarkBeta(4).string); if isempty(T1) then; T1=3*t1; end

if CarDir(1) then
    sca(eixoEstr)
    champ(coord(nos(i),1),coord(nos(i),2),1*sign(F),0)
    Cargas = [Cargas; gce()]            
    glue(Cargas($))
    Cargas($).arrow_size = 2
    Cargas($).user_data = [Cargas($).data.x Cargas($).data.y 1 opC t0 t1 F]
end
if CarDir(2) then
    sca(eixoEstr)
    champ(coord(nos(i),1),coord(nos(i),2),0,1*sign(F))
    Cargas = [Cargas; gce()]            
    glue(Cargas($))
    Cargas($).arrow_size = 2
    Cargas($).user_data = [Cargas($).data.x Cargas($).data.y 2 opC t0 t1 F]
end
if CarDir(3) then
    sca(eixoEstr)
    tt = [0:%pi/4:2*%pi]*sign(F)
    plot2d4(coord(nos(i),1)+0.5*cos(tt),coord(nos(i),2)+0.5*sin(tt))
    Cargas = [Cargas; gce().children]
    Cargas($).arrow_size_factor = 1.5
    Cargas($).user_data = [coord(nos(i),1) coord(nos(i),2) 3 opC t0 t1 F]
end

Ft=[];
for t=[0:T1/1000:T1]
    Ft($+1)=Carregamento(1,1,opC,1,t0,t1,w1,F,t)
end

Tipo = [" - FX" " - FY" " - MZ"]
for k=find(CarDir)
    Texto = "P"+string(3*nos(i)+k-3)+" - Noh "+string(nos(i))+Tipo(k)
    plot(Axes(1),[0:T1/1000:T1]',Ft)
    HistCargas = [HistCargas; gce().children]
    HistCargas($).foreground = length(HistCargas)
    HistCargas($).visible = "off"
    HistCargas($).tag = Texto
    Axes(1).data_bounds(2) = T1
end
