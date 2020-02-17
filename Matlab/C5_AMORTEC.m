% FREQUENCIAS NATURAIS E MATRIZ DE AMORTECIMENTO
% A execução deste programa assume que os seguintes já foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO

clc
fprintf('\n4 - AMORTECIMENTO PROPORCIONAL=============================\n');

modo1 = input('Nº do Modo onde é conhecida a 1ª taxa de amortecimento = ');
modo2 = input('Nº do Modo onde é conhecida a 2ª taxa de amortecimento = ');
fprintf('\n');
frase1 = ['Taxa de amortecimento no ',int2str(modo1),'º modo: csi = ']; 
frase2 = ['Taxa de amortecimento no ',int2str(modo2),'º modo: csi = '];

csi(1,1) = input(frase1);
csi(2,1) = input(frase2);

% Vetor de frequências naturais da estrutura
% Raiz quadrada dos autovalores do problema generalizado da equação XXX 
w = sqrt(eig(K,M));

% Ordena as frequências em ordem crescente dentro do vetor w
w = sort(w);

% Calcula o período de vibração natual mais curto, associado à maior freq.
Tj = 2*pi/max(w);   % Equação XXX

% Matriz dos coeficientes do sistema linear composto por duas equações de
% duas incógnitas, iguais à expressão XXX
Q = [ 1/(2*w(modo1)) w(modo1)/2 ;
      1/(2*w(modo2)) w(modo2)/2 ];

% Solução do sistema linear de duas equações e duas incógnitas
a = Q\csi; % Também exibida na equação XXX

% Taxas de amortecimento modais, encontradas com a equação XXX
csi = zeros(n,1);
for i=1:n
    csi(i) = (1/(2*w(i)))*a(1) + (w(i)/2)*a(2);
end

% Matriz de amortecimento proporcional, dada pela equação XXX
C = a(1)*M + a(2)*K;