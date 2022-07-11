// INTERFACE GRÁFICA DO PROGRAMA DA DISSERTAÇÃO

//@ Figura principal
deff("Fechar(win,x,y,ibut)",["if ibut==-1000 then";"close(win)";"quit";"end"])
clear o;
//o.figure_position           = [0 0]
o.figure_size               = [1366 742]//get(0, "screensize_px")(3:4) - [0 40]
o.layout                    = "border"
o.infobar_visible           = "off"
o.toolbar_visible           = "off"
o.toolbar                   = "none"
o.menubar_visible           = "on"
//o.menubar                   = "none"
o.dockable                  = "off"
o.visible                   = "off"
o.immediate_drawing         = "on"
o.event_handler             = "Fechar"
o.event_handler_enable      = "on"
o.background                = color(240,240,240)
o.figure_name="Programa para analise dinâmica de estruturas planas reticuladas"
jan                         = CriarObjeto("figure",o);

borda  = createBorder("line","lightGray"); // Objetos 'borda' e 'fonte' a serem
fonte  = createBorderFont("",14,"bold");   // usados nos frames mais abaixo
Menu(1) = uimenu(jan,"label","Salvar Dados")
Menu(2) = uimenu(jan,"label","Carregar Dados")
Menu(3) = uimenu(jan,"label","Limpar Dados")

//% Frame da direita
clear o;
o.layout          = "gridbag"
o.layout_options  = createLayoutOptions("gridbag")
frame_right       = CriarUicontrol("frame",o)

//% Frame da esrtutura
Titulo = "Geometria da Estrutura"
clear o
o.border      = createBorder("titled",borda,Titulo,"center","top",fonte)          
o.parent      = frame_right
o.layout      = "border"
o.constraints = createConstraints("gridbag",[1 1 2 1],[1 1],"both");
frameEstr     = CriarUicontrol("frame",o);

//% Frame das Frequencias
clear o
Titulo = "Modos de Vibração Natural"
o.parent      = frame_right
o.constraints = createConstraints("gridbag",[3 1 1 1],[1 1],"both");
o.border      = createBorder("titled",borda,Titulo,"center","top",fonte)
o.layout      = "gridbag"
frameFreq     = CriarUicontrol("frame",o);
    
//% Frames dos gráficos
Titulos = ["Cargas Nodais";"Deslocamentos Nodais";"Algoritimo de Adaptavidade"];
clear o
for i=1:3    
    o.parent      = frame_right
    o.constraints = createConstraints("gridbag",[i 2 1 1],[1 1],"both");
    o.border      = createBorder("titled",borda,Titulos(i),"center","top",fonte)
    o.layout      = "border"
    frameGrafs(i) = CriarUicontrol("frame",o);
end

//% Frames das opções na estrutura
clear o
o.parent = frameEstr
o.constraints = createConstraints("border","left",[114 0])
o.layout      = "gridbag"
frame_left_estr  = CriarUicontrol("frame",o)
o.constraints = createConstraints("border","center")
frame_right_estr = CriarUicontrol("frame",o)

//% Opções e eixo da estutura
clear o
o.parent      = frame_left_estr
o.constraints = createConstraints("gridbag",[1 1 1 1],[1 1],"none","center");
o.String      = "Configurar Grid"
ConfGrid      = CriarUicontrol("pushbutton",o)

Rotulos = ["Mostrar Grid"; "Mostrar Apoios"; "Mostrar Forças";
           "Nº dos nós"  ; "Nº das barras" ; "Nº das forças" ; "Mostrar Nós"]
for i=1:7
    o.constraints = createConstraints("gridbag",[1 i+1 1 1],[1 1],"none","left")
    o.String      = Rotulos(i)
    checkBox(i)   = CriarUicontrol("checkbox",o)
end
checkBox(2:3).value = 1 // Mostrar Apoios e Cargas, inicia ligado
checkBox(7).value = 1 // Mostrar Nós inicia ligado

eixoEstr = newaxes(frame_right_estr)
eixoEstr.margins = [0.001 0.001 0.001 0.001]
eixoEstr.isoview = "on"

EixoX = [0:1:17]    // Grid inicial
EixoY = [0:1:10]    // Grid inicial
PontosX = repmat(EixoX,1,size(EixoY,2))
PontosY=[]
for i=EixoY
    PontosY = [PontosY repmat(i,1,size(EixoX,2))]
end

sca(eixoEstr)
plot(PontosX,PontosY,'bo')
GridEstrutura = gce().children
GridEstrutura.visible = "off"
eixoEstr.axes_visible = ["off" "off" "off"]

//% Frame das Listas das frequencias
Titulos = ["Frequencias (rad/s)";"Frequencias (Hz)";"Taxas (%):"]
clear o
o.parent = frameFreq
for i=1:3
    o.constraints  = createConstraints("gridbag",[i 1 1 0],[1 1],"both");
    o.border       = createBorder("titled",borda,Titulos(i),"center","top")
    o.layout       = "border"
    listaFreq(i)   = CriarUicontrol("frame",o)
end

//% Listas de Frequencias
clear o
for i=1:3
    o.parent       = listaFreq(i)
    o.constraints  = createConstraints("border", "center", [0 0])
    o.callback     = "frequencias.value = [frequencias(" + string(i) +").value];" + ...
                     "frequencias.listboxtop = frequencias(" + string(i) +").listboxtop;" 
    frequencias(i) = CriarUicontrol("listbox",o)
end

//% Frames dos PopUps, PopUp dos gráficos e seus eixos
clear o
for i=1:3
    o.parent        = frameGrafs(i)        
    o.constraints   = createConstraints("border","center") // Posição eixos
    frameAxes(i)    = CriarUicontrol("frame",o);           // Frames eixos
    Axes(i)         = newaxes(frameAxes(i))                // Eixo no seu frame
    xlabel(Axes(i),"Tempo (t)")
    plot(Axes(i),%nan,%nan)
    Axes(i).margins([3 4]) = [0.05 0.15]
    Axes(i).grid = [1 1]*color("gray")
    
    o.constraints   = createConstraints("border","top",[0 50]) // Posição PopUps
    o.layout        = "border"
    // o.layout        = "gridbag"
    framePopUp(i)   = CriarUicontrol("frame",o);               // Frames PopUps          
    o.parent        = framePopUp(i)
    //o.units         = "normalized"
    //o.position      = [0.25 0.25 0.5 0.4]
    //o.position      = [75 15 207 20]
    o.constraints   = createConstraints("border","right",[90 0])
    // o.constraints   = createConstraints("gridbag",[1 3 1 1],[.5 1],"both")
    fr1= CriarUicontrol("frame",o);
    
    o.constraints   = createConstraints("border","left",[90 0])
    // o.constraints   = createConstraints("gridbag",[2 1 1 1],[1 3],"both")
    fr2= CriarUicontrol("frame",o);
    
    o.constraints   = createConstraints("border","top",[0 15])
    // o.constraints   = createConstraints("gridbag",[2 3 1 1],[1 3],"both")
    fr3= CriarUicontrol("frame",o);
    
    o.constraints   = createConstraints("border","bottom",[0 15])
    // o.constraints   = createConstraints("gridbag",[3 1 1 1],[.5 1],"both")
    fr4= CriarUicontrol("frame",o);
    
    o.constraints   = createConstraints("border","center",[20 200])
    //o.constraints   = createConstraints("gridbag",[1 1 10 1],[1 1],"none","center")
    o.string        = " "
    o.value         = [1]
    listaGraficos(i)= CriarUicontrol("popupmenu",o); // PopUp no seus frames    
end
listaGraficos.enable="off" // Desabilita pois não há gráficos no início

//% Frame da esquerda
clear o
o.parent      = jan
o.layout      = "gridbag"
o.constraints = createConstraints("border", "left", [270 0])
frame_left    = CriarUicontrol("frame",o)

//% Sub-Frames no frame da esquerda
Titulos  = ["Geometria";"Material";"Seção Transversal";"Taxas de amortecimento";
            "Carregamento";"Método Numérico de Newmark-beta";"Adaptatividade"];
clear o
o.parent = frame_left
for i=1:7   
    o.constraints = createConstraints("gridbag",[1 i 1 1],[1 0],"both","center")
    o.border      = createBorder("titled",borda,Titulos(i),"center","top",fonte)
    o.layout      = "gridbag"
    frameDatas(i) = CriarUicontrol("frame",o) // Frames da introdução de dados
end

// Frame dos botões de rodar análise
o.border         = null()
o.constraints    = createConstraints("gridbag",[1 8 1 1],[1 0],"both", "center")
o.layout         = "grid"
o.layout_options = createLayoutOptions("grid", [3,1]);
frameDatas(8)    = CriarUicontrol("frame",o) //Frame dos botões de rodar análise

// Frame dos botões de mostar matrizes
o.border         = null()
o.constraints    = createConstraints("gridbag",[1 9 1 1],[1 0],"both", "center")
o.layout         = "grid"
o.layout_options = createLayoutOptions("grid", [1,3]);
frameDatas(9)    = CriarUicontrol("frame",o) //Frame botões de mostar matrizes

// Frame inferior extra que impedirá redimensionamento os outros acima
o.border        = null()
o.constraints   = createConstraints("gridbag",[1 10 1 1],[1 1],"both", "center")
frameDatas(10)   = CriarUicontrol("frame",o) // Frame inferior extra

//% GEOMETRIA
Grid    = [1 1 1 1;1 2 1 1;2 1 1 1;2 2 1 1];
Rotulos = ["Inserir Barras";"Excluir Barras";"Inserir Apoios";"Excluir Apoios"];
clear o    
o.parent = frameDatas(1) // Geometria
for i=1:4
    o.String        = Rotulos(i)
    o.constraints   = createConstraints("gridbag",Grid(i,:),[1 1],"both")
    BotoesGeomet(i) = CriarUicontrol("pushbutton",o)
end
BotoesGeomet(2:4).enable  = "off" // Desabilita-os pois não há barras no início

//% MATERIAL
Titulos = ["Young";"Densidade"];
clear o
for i=1:2
    o.parent      = frameDatas(2) // Material
    o.constraints = createConstraints("gridbag",[i 1 1 1],[1 0],"both","center")
    o.border      = createBorder("titled",Titulos(i))
    o.layout      = "border"
    frameTemp     = CriarUicontrol("frame",o)
    o.parent      = frameTemp
    o.constraints = createConstraints("border","center",[0 20])
    MaterialData(i) = CriarUicontrol("edit",o)
end

//% SECAO
Titulos = ["Area";"Inercia"];
clear o
for i=1:2
    o.parent      = frameDatas(3) // Seção
    o.constraints = createConstraints("gridbag",[i 1 1 1],[1 0],"both","center")
    o.border      = createBorder("titled",Titulos(i))
    o.layout      = "border"
    frameTemp     = CriarUicontrol("frame",o)
    o.parent      = frameTemp
    o.constraints = createConstraints("border","center",[0 20])
    SectionData(i) = CriarUicontrol("edit",o)
end

//% AMORTECIMENTO
Titulos  = ["Nº do 1º modo com amortecimento conhecido:";
            "Nº do 2º modo com amortecimento conhecido:";
            "Valor da Taxa no 1º modo conhecido:";
            "Valor da Taxa no 2º modo conhecido:"];
clear o
o.parent = frameDatas(4) // Amortecimento
for i=1:4
    o.constraints = createConstraints("gridbag",[1 i 1 1],[1 0],"both","left")
    o.string      = Titulos(i)
    Texto         = CriarUicontrol("text",o)
    o.string      = null()
    o.constraints = createConstraints("gridbag",[2 i 1 1],[5 0],"both","right",)
    o.constraints.preferredsize = [0 20]
    DampingData(i)= CriarUicontrol("edit",o)
end

//% CARGAS
Rotulos = ["Inserir Cargas";"Excluir Cargas"];
clear o
o.parent = frameDatas(5) // Carregamento
for i=1:2
    o.String        = Rotulos(i)
    o.constraints   = createConstraints("gridbag",[i 1 1 1],[1 1],"both")
    BotoesCargas(i) = CriarUicontrol("pushbutton",o)
end
BotoesCargas.enable = "off" // Desabilita-os pois não há barras no início

//% METODO NUMERICO
Titulos  = ["Parametro Gama (entre 1/2 e 1):"; "Parametro Beta (entre 0 e 1):";
            "Incremento maximo:"; "Intervalo de solução da resposta:";
            "$\gamma=$"; "$\beta=$";
            "$\Delta t_{max}=$";"$T=$"];
clear o
o.parent = frameDatas(6) // Método Numérico
o.horizontalalignment = "right"
for i=1:4
    o.constraints  = createConstraints("gridbag",[1 i 1 1],[1 0],"both","right")
    o.String       = Titulos(i)
    CriarUicontrol("text",o)
    
    o.constraints  = createConstraints("gridbag",[2 i 1 1],[1 0],"both","right")
    o.String       = Titulos(i+4)
    CriarUicontrol("text",o)
    
    o.constraints  = createConstraints("gridbag",[3 i 1 1],[5 0],"both","right")
    o.constraints.preferredsize = [0 20]
    o.String       = null()
    NewmarkBeta(i) = CriarUicontrol("edit",o)
end

//% ADAPTATIVIDADE
NomesFrames = ["Método de Adaptatividade";
               "Time-steps constantes";
               "Algoritmo de Bergan & Mollestad (1985)";
               "Algoritmo de Hulbert & Jang (1995)";
               "Algoritmo de Cintra (2008)"];
clear o
o.parent    = frameDatas(7); //Adaptatividade
for i=1:5
   o.constraints    = createConstraints("gridbag",[1 i 1 1],[1 2],"both","left")
   o.border         = createBorder("titled",borda,NomesFrames(i),"center","top")
   o.layout         = "grid"
   o.layout_options = createLayoutOptions("grid", [2,6])
   frameATS(i)      = CriarUicontrol("frame",o) // Frame Strategy
end
frameATS(1).layout_options    = createLayoutOptions("grid", [1,6])
frameATS(2).layout_options    = createLayoutOptions("grid", [1,6])

//% Escolha do Metodo
NomesDasEstrategias = ["CTS";"Bergan";"Hulbert";"Cintra"]
frameATS(3:5).visible = "off"
clear o
o.parent = frameATS(1) // Radios buttons para escolha do método
for i=4:-1:1
    o.String      = NomesDasEstrategias(i)
    o.constraints = createConstraints("gridbag",[i 1 1 1])
    o.callback    = "jan.immediate_drawing = ""off"";"
    o.callback    = o.callback + "frameATS(2:5).visible=""off"";"
    o.callback    = o.callback + "frameATS(" + string(i+1) + ").visible=""on"";"
    o.callback    = o.callback + "jan.immediate_drawing = ""on"";"
    o.groupname   = "Estrategias"
    radioBut(i)   = CriarUicontrol("radiobutton",o)
end
radioBut(1).value = 1

//% Opções Método 1: CTS
clear o
o.parent        = frameATS(2)
o.horizontalalignment = "right"
CriarUicontrol("frame",o)
CriarUicontrol("frame",o)
DeltaT_CTS      = CriarUicontrol("edit",o)
o.String        = "$\Delta t=$"
CriarUicontrol("text",o)
CriarUicontrol("frame",o)
CriarUicontrol("frame",o)    

//% Opções Método 2: ATS Bergan
Rotulos = ["$\Delta t_{1}=$";
           "$\lambda=$";
           "$\xi_{p}=$";
           "$\xi_{m}=$"]
clear o
o.parent = frameATS(3)
o.constraints = createConstraints("grid")
o.horizontalalignment = "right"
for i=4:-1:1
    ATS_Bergan(i) = CriarUicontrol("edit",o)
    o.String = Rotulos(i)
    CriarUicontrol("text",o)
    o.String = null()
end

//% Opções Método 3: Hulbert
Rotulos = ["$\Delta t_{1}=$";
           "$(\Delta t/T)^{alvo}=$";
           "$lb=$";
           "$p_{inc}=$";
           "$p_{dec}=$";]
clear o
o.parent = frameATS(4)
o.parent.layout_options = createLayoutOptions("grid", [1,1])
o.layout = "gridbag"
Frame_ATS_Hulbert = CriarUicontrol("frame",o)

clear o
o.parent = Frame_ATS_Hulbert
o.constraints = createConstraints("gridbag",[1 1 1 1],[1 1],"both")
o.String = Rotulos(1)
o.horizontalalignment = "right"
CriarUicontrol("text",o)
o.String = null()
o.constraints = createConstraints("gridbag",[2 1 1 1],[3 1],"none")
o.constraints.preferredsize = [40 20]
ATS_Hulbert(1) = CriarUicontrol("edit",o)

o.constraints = createConstraints("gridbag",[3 1 3 1],[1 1],"both")
o.String = Rotulos(2)
CriarUicontrol("text",o)
o.String = null()
o.constraints = createConstraints("gridbag",[6 1 1 1],[1 1],"none")
o.constraints.preferredsize = [40 20]
ATS_Hulbert(2) = CriarUicontrol("edit",o)

for i=3:5
    o.constraints = createConstraints("gridbag",[2*(i-2)-1 2 1 1],[1 1],"both")
    o.String = Rotulos(i)
    CriarUicontrol("text",o)
    o.String = null()
    o.constraints = createConstraints("gridbag",[2*(i-2) 2 1 1],[4 1],"none")
    o.constraints.preferredsize = [40 20]
    ATS_Hulbert(i) = CriarUicontrol("edit",o)
end

//% Opções Método 4: ATS Cintra
Rotulos = ["$\Delta t_{1}=$";
           "$\alpha=$";
           "$c_{p}=$";
           "$c_{t}=$"]
clear o
o.parent = frameATS(5)
o.constraints = createConstraints("grid")
o.horizontalalignment = "right"
for i=4:-1:1
    ATS_Cintra(i) = CriarUicontrol("edit",o)
    o.String = Rotulos(i)
    CriarUicontrol("text",o)
    o.String = null()
end

//% Botões de análise
Rotulos = ["RODAR ANÁLISE DINÂMICA";
           "Plotar deformada estatica da estrutura";
           "Plotar deformada dinâmica da estrutura"]
clear o
o.parent = frameDatas(8) // Botões de análise
for i=3:-1:1
    o.String = Rotulos(i)
    BotoesAnalise(i) = CriarUicontrol("pushbutton",o)
end
BotoesAnalise(2:3).enable = "off" // Desablita pois não há deformada no início

plot(eixoEstr,%nan,%nan,'r')
Deformada = gce().children


//% Botões de mostrar matrizes
Rotulos = ["M";"K";"C"]
clear o
o.parent = frameDatas(9) // Botões de matrizes
for i=3:-1:1
    o.String = "Matriz " + Rotulos(i)
    o.enable = "off"
    BotoesMatrizes(i) = CriarUicontrol("pushbutton",o)
end

//*
jan.visible = "on"
