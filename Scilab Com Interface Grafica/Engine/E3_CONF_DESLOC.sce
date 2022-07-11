// PLOTA GRÁFICOS DOS DESLOCAMENTOS NODAIS

jan.immediate_drawing = "off"

delete(Axes(2).children)            // Deleta as polylines que estejam no eixo
plot(Axes(2),t',D')                 // Plota os deslocamentos nodais
replot(Axes(2))
Axes(2).data_bounds(2) = T1
HistDesloc = gce().children         // Recupera as polylines atuais do eixo
HistDesloc = flipdim(HistDesloc,1)  // Inverte o vetor de polylines

// (Esse último comando é necessário no Scilab: o comando plot acumula as
// polylines da primeira plotada até a última plotada de trás para frente)

// Encontra direção do deslocamento em 'ii': (1) para X; (2) para Y; (3) para Z
[ii jj] =find(modulo([GL+2;GL+1;GL+0],3)==0)

// Recupera número do nó de cada deslocamento
noh = string((GL+(3-ii))/3)

// Define rótulo do tipo de deslocamento
tipo = [" - DESLOCX" " - DESLOCY" " - ROTZ"](ii)

// Legendas dos gráficos de deslocamentos
legenda = "D" + string(GL) + " - Nó " + noh + tipo
for i=1:n
    HistDesloc(i).tag = legenda(i)
end

// Lista dos gráficos de deslocamentos
listaGraficos(2).string = ["Todos os deslocamentos nodais"; HistDesloc.tag]
listaGraficos(2).enable = "on"

HistDesloc.visible = "off"
listaGraficos(2).value =[1]
execstr(listaGraficos(3).callback)
jan.immediate_drawing = "on"
