// CÓDIGO PRINCIPAL

clearglobal     // Limpa as variáveis globais
clear           // Limpa as variáveis locais
xdel(winsid())  // Fecha as janelas ativas
clc             // Limpa a tela do console
winId=progressionbar("Iniciando . . .")

exec("A0_PRECOD1_OBJS.sce",-1) // Funções de criar objeto e criar uicontrol
exec("A0_PRECOD2_PTOS.sce",-1) // Função de encontrar ponto mais próximo
exec("A0_PRECOD3_RETA.sce",-1) // Função de encontrar reta mais próxima
exec("A0_PRECOD4_VARS.sce",-1) // Funções (NodesInMat, DeleteItem, loadHist)
exec("A1_INTERFACE.sce"   ,-1) // Inicia interface Gráfica
exec("Funcoes.sce"        ,-1) // Funções dos algoritmos de análise dinâmica
exec("ValoresPadrao.sce"  ,-1) // Valores padrão dos dados de entrada

// Callbacks Auxiliares:
// Botão de configurar grid da estrutura, checkboxes laterais, Listas PopUp
ConfGrid.callback       = "exec(""A2_CONFIGURAR-GRID.sce"",-1)"
checkBox.callback       = "exec(""A3_CHECKBOXES.sce"",-1)"
listaGraficos.callback  = "exec(""A4_POPUPS.sce"",-1);"
for i=1:3
    listaGraficos(i).callback=listaGraficos(i).callback+"Axes("+string(i)+").zoom_box=[];"
end

// Limpa resposta da análise
DefOff = "Deformada.visible = ""off"";"
ClResp = DefOff + "listaGraficos(2).string = ["" ""];" + ...
                  "listaGraficos(2).enable = ""off"";" + ...
                  "listaGraficos(2).value = 1;"        + ...
                  "listaGraficos(3).string = ["" ""];" + ...
                  "listaGraficos(3).enable = ""off"";" + ... 
                  "listaGraficos(3).value = 1;"        + ...
                  "Axes(2:3).children.visible = ""off"";"

// Rotinas de editar a Geometria da estrutura
InsBar = DefOff + "exec(""B1_Geometria_Inserir_Barras.sce"",-1);" + ClResp
DelBar = DefOff + "exec(""B2_Geometria_Excluir_Barras.sce"",-1);" + ClResp
InsSup = DefOff + "exec(""B3_Geometria_Inserir_Apoios.sce"",-1);" + ClResp
DelSup = DefOff + "exec(""B4_Geometria_Excluir_Apoios.sce"",-1);" + ClResp

// Rotinas de editar o carregamento da estrutura
InsCar = DefOff + "exec(""B5_Inserir_Cargas.sce"",-1);" + ClResp
DelCar = DefOff + "exec(""B6_Excluir_Cargas.sce"",-1);" + ClResp

// Rotinas de rodar a análise
RunEst = DefOff + "exec(""B7_Executa_Analise.sce"",-1)"
ModMat = DefOff + "exec(""B7_MatrizesMKC.sce"",-1)"

// Rotinas Extras para configurar os eixos de gráficos
ConfEstruc = ";exec(""E1_CONF_ESTRUC.sce"",-1)" // Configura eixo da estrutura
ConfCargas = ";exec(""E2_CONF_CARGAS.sce"",-1)" // Configura eixo das cargas
ConfDesloc = ";exec(""E3_CONF_DESLOC.sce"",-1)" // Configura eixo das respostas
ConfStratg = ";exec(""E4_CONF_STRATG.sce"",-1)" // Configura eixo de estratégias
CheckBoxes = ";exec(""A3_CHECKBOXES.sce"",-1)"  // Re-executa checkboxes

// Botões de editar a Geometria da estrutura
BotoesGeomet(1).callback = InsBar + ConfEstruc + CheckBoxes
BotoesGeomet(2).callback = DelBar + ConfCargas + ConfEstruc + CheckBoxes
BotoesGeomet(3).callback = InsSup + CheckBoxes
BotoesGeomet(4).callback = DelSup

// Botões de editar o carregamento da estrutura
BotoesCargas(1).callback = InsCar + ConfCargas + ConfEstruc + CheckBoxes
BotoesCargas(2).callback = DelCar + ConfCargas + ConfEstruc + CheckBoxes

// Botão de rodar a análise
BotoesAnalise(1).callback = RunEst + ConfDesloc + ConfStratg
BotoesAnalise(2).callback = "exec(""B7_Plota_Static_Deform.sce"",-1);"
BotoesAnalise(3).callback = "exec(""B7_Plota_Dinamic_Deform.sce"",-1);"

Menu(1).callback = "exec(""B8_Salva_Dados.sce"",-1);"
Menu(2).callback = "exec(""B8_Carrega_Dados.sce"",-1);" + ClResp + ConfCargas + ConfEstruc + CheckBoxes
Menu(3).callback = "exec(""B8_Limpa_Dados.sce"",-1);" + ClResp + ConfCargas + ConfEstruc + CheckBoxes

// Botoes de Exibir/Editar matrizes
for i=1:3
    BotoesMatrizes(i).callback = "Opcao =" + string(i) + ";" + ModMat
end

// Campos de edicao do Material, Secao, Amortecimento e Metodo Numerico
DisableAnalise = DefOff + "BotoesAnalise(2:3).enable = ""off"";"
DisableAllMats = DefOff + "BotoesMatrizes.enable = ""off"";"
DisableDumpMat = DefOff + "BotoesMatrizes(3).enable = ""off"";"
ClearFrequency = DefOff + "for i=1:3; frequencias(i).string = """"; end;"
ClearDumpingTx = DefOff + "frequencias(3).string = """";"
RedefineLoadT1 = "exec(""RedefinirT1.sce"",-1);exec(""A4_POPUPS.sce"",-1);"
MaterialData.callback = DisableAnalise + DisableAllMats + ClearFrequency + ClResp
SectionData.callback  = DisableAnalise + DisableAllMats + ClearFrequency + ClResp
DampingData.callback  = DisableAnalise + DisableDumpMat + ClearDumpingTx + ClResp
NewmarkBeta.callback  = DisableAnalise + RedefineLoadT1 + ClResp
DeltaT_CTS.callback   = DisableAnalise + ClResp
ATS_Bergan.callback   = DisableAnalise + ClResp
ATS_Hulbert.callback  = DisableAnalise + ClResp
ATS_Cintra.callback   = DisableAnalise + ClResp
radioBut.callback     = radioBut.callback + DisableAnalise + ClResp

Barras     = []; Restricoes = []; Cargas     = []
HistCargas = []; HistDesloc = []; HistATSstr = []
LabelNohs  = []; LabelBars  = []; LabelLoad  = []

close(winId);
