% DADOS DAS CARGAS NODAIS
% A execu��o deste programa assume que os seguintes j� foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO

clc
fprintf('\n5 - CARGAS NODAIS =========================================\n');
nc = input('N�mero de cargas nodais = ');

% Inicia o vetor-coluna F com zeros em todos os deslocamentos da estrutura
F = zeros(3*nj,1);

% Inicia com zeros os dados de todas as cargas a serem declaradas
desC = zeros(1,nc);
opC  = zeros(1,nc);
t0   = zeros(1,nc);
t1   = zeros(1,nc);
w1   = zeros(1,nc);

% Recolhe os dados introduzidos para as cargas nodais
for i=1:nc
    fprintf('\nCarga nodal n�mero %d:...............................\n',i);
    noh = input('N� do n� = ');
    
    fprintf('Dire��o correspondente:');
    fprintf('\n(1)-X | (2)-Y -> For�as  |  (3)-Z -> Momento');
    op = input('\nOp��o = ');
    
    % Identifica o n�mero do deslocamento atrav�s das rela��es XXX
    desC(i) = 3*noh + (op-3);
    F(desC(i)) = input('Valor M�ximo da carga = ');
    
    fprintf('Fun��o do hist�rico de carga:')
    fprintf('\n  (1)-Carga impulsiva constante. ')
    fprintf('\n  (2)-Carga triangular decrescente.')
    fprintf('\n  (3)-Carga triangular sim�trica. ')
    fprintf('\n  (4)-Carga senoidal. ')    
    opC(i) = input('\nOp��o de Carga = ');
    
    if opC(i)==4
        w1(i) = input('Frequ�ncia do carregamento senoidal: w = ');
    else
        t0(i) =input('Instante de in�cio da carga impulsiva: t0 = ');
        t1(i) =input('Intervalo de dura��o da carga impulsiva: t1 = ');
    end    
end

% Corrige dados de cargas mal introduzidos 
aux1 = zeros(1,nc);
for i=1:n
    aux1 = aux1 | desC==GL(i);      
end                                 
desC = desC(aux1);          % Caso seja declarada uma carga sobre um        
opC  =  opC(aux1);          % deslocamento restringido, esse carregamento    
t0   =   t0(aux1);          % � eliminado dos vetores com os dados das 
t1   =   t1(aux1);          % cargas. S�o tomadas apenas as cargas sobre 
w1   =   w1(aux1);          % deslocamento livres.

% Reduz o 'nc' declarado ao n�mero de cargas sobre deslocamentos livres
nc = length(desC);

% Corrige o vetor 'desC' para corresponder a sua defini��o
aux2 = [];
for i=1:nc                           % Identifica o n�mero do grau de                                         
    aux2 = [aux2 find(GL==desC(i))]; % liberdade correspondente ao 
end                                  % deslocamento 'desC(i)' e reconstr�i 
desC = aux2;                         % o vetor 'desC' com esses n�meros

% Reduz o vetor-coluna F �s posi��es dos deslocamentos livres 
F = F(GL);

% Inicia com zeros a matriz de cargas p (apenas a primeira coluna)
p = zeros(n,1);