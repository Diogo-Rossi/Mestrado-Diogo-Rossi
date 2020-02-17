// DADOS DAS CARGAS NODAIS

nc = length(Cargas)

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
    noh = vectorfind(coord,Cargas(i).user_data(1:2),"r")
    
    op = Cargas(i).user_data(3)
    
    // Identifica o número do deslocamento através das relações XXX
    desC(i) = 3*noh + (op-3);
    
    F(desC(i)) = Cargas(i).user_data(7)
    
    opC(i) = Cargas(i).user_data(4)
    
    if opC(i)==4
        t0(i) = Cargas(i).user_data(5)
        w1(i) = Cargas(i).user_data(6)
    else
        t0(i) = Cargas(i).user_data(5)
        t1(i) = Cargas(i).user_data(6)
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
