// Limpa as variáveis da análise dinâmica
clear D V A p t Dt w csi w2 T NDu CSI e RL kapa kapaReg N1

// Limpa as ListBoxes das frequências naturais
frequencias(1).string = []
frequencias(2).string = []
frequencias(3).string = []

// Executa as rotinas C1 a C4 apenas se as matrizes M e K forem redefinidas
if BotoesMatrizes(1).enable == "off" then
    exec("C1_BARRAS.sce",-1)
    exec("C2_MAT_LOC.sce",-1)
    exec("C3_MAT_GLOB.sce",-1)
    exec("C4_REST_APOIO.sce",-1)
end

// Executa a rotina do amortecimento e das cargas
exec("C5_AMORTEC.sce",-1)
exec("C6_CARGAS.sce",-1)

// Executa algoritmo de Adaptatividade
select find(radioBut.value)
    case 1
        exec("C7a_NEWMARK_CTS.sce",-1)
    case 2
        exec("C7b_NEWMARK_ATS_BERGAN.sce",-1)
    case 3
        exec("C7c_NEWMARK_ATS_HULBERT.sce",-1)
    case 4
        exec("C7d_NEWMARK_ATS_CINTRA.sce",-1)
end

// Preenche as ListBoxes das frequências naturais
frequencias(1).string = string([1:n])' + " - " + string(w)
frequencias(2).string = string([1:n])' + " - " + string(w/(2*%pi))
frequencias(3).string = string([1:n])' + " - " + string(csi*100)

BotoesAnalise(2:3).enable = "on"; nao_calculado = 1;
BotoesMatrizes.enable = "on"
