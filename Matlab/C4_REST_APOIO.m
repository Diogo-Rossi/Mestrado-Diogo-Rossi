% RESTRIÇÕES DE APOIO
% A execução deste programa assume que os seguintes já foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB

clc
fprintf('\n3 - RESTRIÇÕES DE APOIO ====================================\n');
nr = input('Número de restrições de apoio = ');

% Inicia os vetores dos graus de liberdade livres e restringidos como se
% não houvesse restrições (vetor GL completo e vetor GLR vazio)
GL = [1:1:3*nj];
GLR = [];

% Constrói o vetor de graus de liberdae restringidos
for i=1:nr
    fprintf('\nRestrição número %d:.................................\n',i);
    noh = input('Nº do nó = ');
    fprintf('Deslocamento restringido:');
    fprintf('\n(1)-X | (2)-Y -> Translações  |  (3)-Z -> Rotação');
    op = input('\nOpção = ');
    
    % Identifica o número do deslocamento através das relações XXX
    des = 3*noh + (op-3);
    
    % Adiciona o deslocamento ao vetor de graus de liberdae restringidos
    GLR = [GLR des];
end

% Subtrai de todos os graus de liberdade, aqueles que foram restringidos
GL = setdiff(GL,GLR);

% Seleciona as linhas e colunas correspondentes aos graus de liberdade não
% restringidos, nas matrizes de rigidez e massa globais
K = K(GL,GL);
M = M(GL,GL);

% Nº de graus e liberdade (Deslocamentos livres) do problema
n = length(GL); 