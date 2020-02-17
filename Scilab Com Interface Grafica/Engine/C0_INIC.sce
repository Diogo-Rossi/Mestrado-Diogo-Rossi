// PROGRAMA PRINCIPAL
// Primeiro programa a ser executado
// Esse código é usado para limpar a tela e as variáveis atuais do software
// Além de executar as rotinas separadas em cada arquivo
clearglobal
clear
close
clc

// Escolha do algoritmo de integração
mprintf("Escolha algoritimo de integracao");
mprintf("\n(1) - Newmark-Beta com CTS");
mprintf("\n(2) - Newmark-Beta com ATS de Bergan e Mollestad");
Algoritmo = input("Escolha = ");

// Rotinas gerais
exec("Funcoes.sce",-1)
exec("C1_BARRAS.sce",-1)
exec("C2_MAT_LOC.sce",-1)
exec("C3_MAT_GLOB.sce",-1)
exec("C4_REST_APOIO.sce",-1)
exec("C5_AMORTEC.sce",-1)
exec("C6_CARGAS.sce",-1)

// Alterância entre os algoritmos de integração
switch Algoritmo
    case 1
        exec("C7a_NEWMARK_CTS.sce",-1)
    case 2
        exec("C7b_NEWMARK_ATS_BERGAN.sce",-1)
end
exec("C8_RESULTADOS.sce",-1)
