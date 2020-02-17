jan.immediate_drawing = "off"
delete(HistCargas);
clear HistCargas
HistCargas = [];
T1 = evstr(NewmarkBeta(4).string); if isempty(T1) then; T1=3*t1; end
Tipo = [" - FX" " - FY" " - MZ"]

for i=1:length(Cargas)
    x = Cargas(i).user_data(1);
    y = Cargas(i).user_data(2);
    CarDir = Cargas(i).user_data(3);
    opC    = Cargas(i).user_data(4);
    t0     = Cargas(i).user_data(5);
    t1     = Cargas(i).user_data(6);
    w1     = Cargas(i).user_data(6);
    F      = Cargas(i).user_data(7);
    Ft=[];
    for t=[0:T1/1000:T1]
        Ft($+1)=Carregamento(1,1,opC,1,t0,t1,w1,F,t)
    end
    noh = vectorfind(coord,[x y],"r")
    Texto = "P"+string(3*noh+CarDir-3)+" - Noh "+string(noh)+Tipo(CarDir)
    plot(Axes(1),[0:T1/1000:T1]',Ft)
    HistCargas = [HistCargas; gce().children]
    HistCargas($).foreground = length(HistCargas)
//    HistCargas($).visible = "off"
    HistCargas($).tag = Texto
    Axes(1).data_bounds(2) = T1
end
jan.immediate_drawing = "on"


