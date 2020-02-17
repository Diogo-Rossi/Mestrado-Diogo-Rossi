% MATRIZ DE RIGIDEZ E DE MASSA GLOBAIS NUMÉRICAS
% A execução deste programa assume que os seguintes já foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC

clc
fprintf('\n2 - MATERIAL E SEÇÕES =====================================\n');

fprintf('\n2.1 - Material.............................................\n');
Ex = input('Módulo de Elasticidade: E = ');
ro = input('Massa específica: rô = ');

fprintf('\n2.2 - Seções...............................................\n');
Ax = input('Área da seção transversal: A = ');
Ix = input('Momento de Inércia da seção transversal: I = ');

% Massa por unidade de comprimento das barras
px = ro*Ax;

% Inicialização da matrizes globais com zeros
K = zeros(3*nj);
M = zeros(3*nj);

for i=1:m
    
    % Cálculo dos comprimentos das barras e cossenos e senos dos angulos de 
    % inclinação, com base nas coordenadas dos nós inicial e final
    Lx(i) = sqrt(  ( CX(np,i)-CX(1,i) )^2 + ( CY(np,i)-CY(1,i) )^2  );
    c(i) = ( CX(np,i)-CX(1,i) )/Lx(i);
    s(i) = ( CY(np,i)-CY(1,i) )/Lx(i);
    
    % Matriz numérica de mudança de base para um vetor de três componentes
    R = [c(i) s(i) 0;                   % Exibida na equação XXX
        -s(i) c(i) 0;
          0    0   1];
    
    % Matriz numérica de mudança de base dos deslocamentos do elemento i  
    Rt(:,:,i) = [    R       zeros(3);  % Exibida na equação XXX
                 zeros(3)      R    ];
    
    % Matrizes de rigidez e de massa locais simbólicas do elemento i         
    ks = Rt(:,:,i)'*ke*Rt(:,:,i);       % Exibidas na equação XXX
    ms = Rt(:,:,i)'*me*Rt(:,:,i);
    
    % Matrizes de rigidez e de massa locais numéricas do elemento i
    kl(:,:,i) = subs(ks,{E,A,I,L},{Ex,Ax,Ix,Lx(i)});
    ml(:,:,i) = subs(ms,{p,L},{px,Lx(i)});
    
    % Matrizes de rigidez e de massa globais das estrutura
    for j=1:6
        for k=1:6
            % Soma-se as propriedades correspondentes a cada deslocamento
            % nodal que seja comum a um ou mais elementos da estrutura
            K(Des(i,j),Des(i,k)) = K(Des(i,j),Des(i,k)) + kl(j,k,i);
            M(Des(i,j),Des(i,k)) = M(Des(i,j),Des(i,k)) + ml(j,k,i);            
        end
    end

end