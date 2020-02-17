% RESTRI��ES DE APOIO
% A execu��o deste programa assume que os seguintes j� foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB

clc
fprintf('\n3 - RESTRI��ES DE APOIO ====================================\n');
nr = input('N�mero de restri��es de apoio = ');

% Inicia os vetores dos graus de liberdade livres e restringidos como se
% n�o houvesse restri��es (vetor GL completo e vetor GLR vazio)
GL = [1:1:3*nj];
GLR = [];

% Constr�i o vetor de graus de liberdae restringidos
for i=1:nr
    fprintf('\nRestri��o n�mero %d:.................................\n',i);
    noh = input('N� do n� = ');
    fprintf('Deslocamento restringido:');
    fprintf('\n(1)-X | (2)-Y -> Transla��es  |  (3)-Z -> Rota��o');
    op = input('\nOp��o = ');
    
    % Identifica o n�mero do deslocamento atrav�s das rela��es XXX
    des = 3*noh + (op-3);
    
    % Adiciona o deslocamento ao vetor de graus de liberdae restringidos
    GLR = [GLR des];
end

% Subtrai de todos os graus de liberdade, aqueles que foram restringidos
GL = setdiff(GL,GLR);

% Seleciona as linhas e colunas correspondentes aos graus de liberdade n�o
% restringidos, nas matrizes de rigidez e massa globais
K = K(GL,GL);
M = M(GL,GL);

% N� de graus e liberdade (Deslocamentos livres) do problema
n = length(GL); 