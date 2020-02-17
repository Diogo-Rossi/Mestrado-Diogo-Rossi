
jan.immediate_drawing = "off"

delete(Axes(3).children)            // Deleta as polylines que estejam no eixo
plot(Axes(3),t',Dt')                 // Plota os deslocamentos nodais
Axes(3).data_bounds(2) = T1

select find(radioBut.value)
    case 2
        plot(Axes(3),t',[T' Dt'/lambda])
        legendas = ["Dt/lambda" "T"]
    case 3
        plot(Axes(3),t',[NormaErro' RL'])
        legendas = ["RL" "||e||*"+string(FSnormaErro)]
    case 4
        plot(Axes(3),t',[kapa' kapaReg'])
        legendas = ["Curvatura Regularizada" "Curvatura Não-Regularizada"]
end

HistATSstr = gce().parent.children  // Recupera os compounds atuais do eixo
HistATSstr = flipdim(HistATSstr,1)  // Inverte o vetor de compounds
HistATSstr(1).children.tag = "Dt"
if find(radioBut.value)>1 then
    for i=1:2
        HistATSstr(2).children(i).tag = legendas(i)
    end
end

// Lista dos gráficos de deslocamentos
listaGraficos(3).string = ["Intervalo de tempo - Dt"]
if find(radioBut.value)>1 then;
    listaGraficos(3).string($+1) = "Parâmetros da estratégia"
end
listaGraficos(3).enable = "on"

HistATSstr.visible = "off"
listaGraficos(3).value =[1]
execstr(listaGraficos(3).callback)
jan.immediate_drawing = "on"
