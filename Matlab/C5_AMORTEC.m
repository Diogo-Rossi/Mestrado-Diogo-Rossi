% FREQUENCIAS NATURAIS E MATRIZ DE AMORTECIMENTO
% A execu��o deste programa assume que os seguintes j� foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO

clc
fprintf('\n4 - AMORTECIMENTO PROPORCIONAL=============================\n');

modo1 = input('N� do Modo onde � conhecida a 1� taxa de amortecimento = ');
modo2 = input('N� do Modo onde � conhecida a 2� taxa de amortecimento = ');
fprintf('\n');
frase1 = ['Taxa de amortecimento no ',int2str(modo1),'� modo: csi = ']; 
frase2 = ['Taxa de amortecimento no ',int2str(modo2),'� modo: csi = '];

csi(1,1) = input(frase1);
csi(2,1) = input(frase2);

% Vetor de frequ�ncias naturais da estrutura
% Raiz quadrada dos autovalores do problema generalizado da equa��o XXX 
w = sqrt(eig(K,M));

% Ordena as frequ�ncias em ordem crescente dentro do vetor w
w = sort(w);

% Calcula o per�odo de vibra��o natual mais curto, associado � maior freq.
Tj = 2*pi/max(w);   % Equa��o XXX

% Matriz dos coeficientes do sistema linear composto por duas equa��es de
% duas inc�gnitas, iguais � express�o XXX
Q = [ 1/(2*w(modo1)) w(modo1)/2 ;
      1/(2*w(modo2)) w(modo2)/2 ];

% Solu��o do sistema linear de duas equa��es e duas inc�gnitas
a = Q\csi; % Tamb�m exibida na equa��o XXX

% Taxas de amortecimento modais, encontradas com a equa��o XXX
csi = zeros(n,1);
for i=1:n
    csi(i) = (1/(2*w(i)))*a(1) + (w(i)/2)*a(2);
end

% Matriz de amortecimento proporcional, dada pela equa��o XXX
C = a(1)*M + a(2)*K;