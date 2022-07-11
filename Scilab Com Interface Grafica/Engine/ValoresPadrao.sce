// Dados do Material
MaterialData(1).string = "205000000" // Young em kPa
MaterialData(2).string = "7.85"      // Densidade em t/m³

// Dados da Seção Transversal das barras
SectionData(1).string = "0.0303"     // Área em m²
SectionData(2).string = "0.000592"   // Momento de Inércia em m^4

// Dados do amortecimento viscoso
DampingData(1).string = "1"    // 1º modo de taxa conhecida
DampingData(2).string = "3"    // 2º modo de taxa conhecida
DampingData(3).string = "0.05" // Valor da taxa conhecida no 1º modo
DampingData(4).string = "0.05" // Valor da taxa conhecida no 2º modo

// Parâmetros do método de Newmark-Beta
NewmarkBeta(1).string = "1/2" // Beta
NewmarkBeta(2).string = "1/4" // Gamma
NewmarkBeta(3).string = "0.1" // Dtmax (Passo de tempo máximo)
NewmarkBeta(4).string = "0.6" // Intervalo de plotagem da resposta

// Parâmetros das estratégias de adaptatividade
DeltaT_CTS.string = "0.001"     // Passo de tempo constante

// Estratégia de Bergan e Mollestad (1985)
ATS_Bergan(1).string = "0.001" // Passo de tempo inicial
ATS_Bergan(2).string = "0.05"  // lambda
ATS_Bergan(3).string = "1.4"   // CSIp
ATS_Bergan(4).string = "2.0"   // CSIm

// Estratégia de Hulbert e Jang (1995)
ATS_Hulbert(1).string = "0.001" // Passo de tempo inicial
ATS_Hulbert(2).string = "0.1"   // Dt/T alvo
ATS_Hulbert(3).string = "0.75"    // lb
ATS_Hulbert(4).string = "2.0"   // Pinc
ATS_Hulbert(5).string = "2.0"   // Pdec

// Estratégia de Cintra (2008)
ATS_Cintra(1).string = "0.001" // Passo de tempo inicial
ATS_Cintra(2).string = "0.7"   // alpha
ATS_Cintra(3).string = "0.1"   // Cp
ATS_Cintra(4).string = "1.0"   // Ct
