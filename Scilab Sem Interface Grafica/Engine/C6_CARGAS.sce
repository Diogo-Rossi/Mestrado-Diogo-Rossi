// DADOS DAS CARGAS NODAIS
// A execução deste programa assume que os seguintes já foram executados:
// C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO

clc
mprintf('\n5 - CARGAS NODAIS ==============================================\n');
nc = input('Numero de cargas nodais = ');

// Inicia o vetor-coluna F com zeros em todos os deslocamentos da estrutura
F = zeros(3*nj,1);

// Inicia com zeros os dados de todas as cargas a serem declaradas
desC = zeros(1,nc);
opC  = zeros(1,nc);
t0   = zeros(1,nc);
t1   = zeros(1,nc);
w1   = zeros(1,nc);

// Recolhe os dados introduzidos para as cargas nodais
for i=1:nc
    mprintf('\nCarga nodal numero %d: ___________________________________\n',i);
    noh = input('  Numero do noh = ');
    
    mprintf('  Direcao correspondente:');
    mprintf('\n  (1)-X | (2)-Y -> Forcas  |  (3)-Z -> Momento');
    op = input('  Opcao = ');
    
    // Identifica o número do deslocamento através das relações XXX
    desC(i) = 3*noh + (op-3);
    F(desC(i)) = input('  Valor Maximo da carga = ');
    
    mprintf('  Funcao do historico de carga:')
    mprintf('\n    (1)-Carga impulsiva constante. ')
    mprintf('\n    (2)-Carga triangular decrescente.')
    mprintf('\n    (3)-Carga triangular simetrica. ')
    mprintf('\n    (4)-Carga senoidal. ')    
    opC(i) = input('  Opcao de Carga = ');
    
    if opC(i)==4
        w1(i) = input('  Frequencia do carregamento senoidal: w = ');
    else
        t0(i) =input('  Instante de inicio da carga impulsiva: t0 = ');
        t1(i) =input('  Intervalo de duracao da carga impulsiva: t1 = ');
    end    
end

// Corrige dados de cargas mal introduzidos 
aux1 = zeros(1,nc);
for i=1:n
    aux1 = aux1 | desC==GL(i);      
end                                 
desC = desC(aux1);          // Caso seja declarada uma carga sobre um        
opC  =  opC(aux1);          // deslocamento restringido, esse carregamento    
t0   =   t0(aux1);          // é eliminado dos vetores com os dados das 
t1   =   t1(aux1);          // cargas. São tomadas apenas as cargas sobre 
w1   =   w1(aux1);          // deslocamentos livres.

// Reduz o 'nc' declarado ao número de cargas sobre deslocamentos livres
nc = length(desC);

// Corrige o vetor 'desC' para corresponder a sua definição
aux2 = [];
for i=1:nc                           // Identifica o número do grau de                                         
    aux2 = [aux2 find(GL==desC(i))]; // liberdade correspondente ao 
end                                  // deslocamento 'desC(i)' e reconstrói 
desC = aux2;                         // o vetor 'desC' com esses números

// Reduz o vetor-coluna F às posições dos deslocamentos livres 
F = F(GL);

// Inicia com zeros a matriz de cargas p (apenas a primeira coluna)
p = zeros(n,1);
