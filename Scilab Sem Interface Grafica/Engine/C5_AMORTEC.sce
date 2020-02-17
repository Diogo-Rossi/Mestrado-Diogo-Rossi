// FREQUENCIAS NATURAIS E MATRIZ DE AMORTECIMENTO
// A execução deste programa assume que os seguintes já foram executados:
// C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO

clc
mprintf('\n4 - AMORTECIMENTO PROPORCIONAL================================\n\n');

modo1 = input('  Numero do Modo onde se conhece a 1a taxa de amortecimento = ');
modo2 = input('  Numero do Modo onde se conhece a 2a taxa de amortecimento = ');
mprintf('\n');
frase1 = strcat(['  Taxa de amortecimento no ',string(modo1),'o modo: csi = ']);
frase2 = strcat(['  Taxa de amortecimento no ',string(modo2),'o modo: csi = ']);

csi(1,1) = input(frase1);
csi(2,1) = input(frase2);

// Vetor de frequências naturais da estrutura
// Raiz quadrada dos autovalores do problema generalizado da equação XXX 
w = sqrt(spec(K,M)); w = real(w); // Esse último comando força que 'w' seja real

// Ordena as frequências em ordem crescente dentro do vetor w
w = gsort(w,"g","i");

// Calcula o período de vibração natual mais curto, associado à maior freq.
Tj = 2*%pi/max(w);   // Equação XXX

// Matriz dos coeficientes do sistema linear composto por duas equações de
// duas incógnitas, iguais à expressão XXX
Q = [ 1/(2*w(modo1)) w(modo1)/2 ;
      1/(2*w(modo2)) w(modo2)/2 ];

// Solução do sistema linear de duas equações e duas incógnitas
a = Q\csi; // Também exibida na equação XXX

// Taxas de amortecimento modais, encontradas com a equação XXX
csi = zeros(n,1);
for i=1:n
    csi(i) = (1/(2*w(i)))*a(1) + (w(i)/2)*a(2);
end

// Matriz de amortecimento proporcional, dada pela equação XXX
C = a(1)*M + a(2)*K;
