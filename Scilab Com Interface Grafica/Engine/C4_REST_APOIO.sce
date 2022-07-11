// RESTRIÇÕES DE APOIO
nr = length(find(Restricoes.user_data))

// Inicia os vetores dos graus de liberdade livres e restringidos como se
// não houvesse restrições (vetor GL completo e vetor GLR vazio)
GL = [1:1:3*nj];
GLR = [];

// Constrói o vetor de graus de liberdae restringidos
for i=1:length(Restricoes)
    noh = vectorfind(coord,Restricoes(i).data,"r")


    op = find(Restricoes(i).user_data)
    
    // Identifica o número do deslocamento através das relações XXX
    des = 3*noh + (op-3);
    
    // Adiciona o deslocamento ao vetor de graus de liberdae restringidos
    GLR = [GLR des];
end

// Subtrai de todos os graus de liberdade, aqueles que foram restringidos
GL = setdiff(GL,GLR);

// Seleciona as linhas e colunas correspondentes aos graus de liberdade não
// restringidos, nas matrizes de rigidez e massa globais
K = K(GL,GL);
M = M(GL,GL);

// Nº de graus e liberdade (Deslocamentos livres) do problema
n = length(GL); 
