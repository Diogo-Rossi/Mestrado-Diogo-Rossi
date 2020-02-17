% MATRIZ DE RIGIDEZ E DE MASSA GLOBAIS NUM�RICAS
% A execu��o deste programa assume que os seguintes j� foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC

clc
fprintf('\n2 - MATERIAL E SE��ES =====================================\n');

fprintf('\n2.1 - Material.............................................\n');
Ex = input('M�dulo de Elasticidade: E = ');
ro = input('Massa espec�fica: r� = ');

fprintf('\n2.2 - Se��es...............................................\n');
Ax = input('�rea da se��o transversal: A = ');
Ix = input('Momento de In�rcia da se��o transversal: I = ');

% Massa por unidade de comprimento das barras
px = ro*Ax;

% Inicializa��o da matrizes globais com zeros
K = zeros(3*nj);
M = zeros(3*nj);

for i=1:m
    
    % C�lculo dos comprimentos das barras e cossenos e senos dos angulos de 
    % inclina��o, com base nas coordenadas dos n�s inicial e final
    Lx(i) = sqrt(  ( CX(np,i)-CX(1,i) )^2 + ( CY(np,i)-CY(1,i) )^2  );
    c(i) = ( CX(np,i)-CX(1,i) )/Lx(i);
    s(i) = ( CY(np,i)-CY(1,i) )/Lx(i);
    
    % Matriz num�rica de mudan�a de base para um vetor de tr�s componentes
    R = [c(i) s(i) 0;                   % Exibida na equa��o XXX
        -s(i) c(i) 0;
          0    0   1];
    
    % Matriz num�rica de mudan�a de base dos deslocamentos do elemento i  
    Rt(:,:,i) = [    R       zeros(3);  % Exibida na equa��o XXX
                 zeros(3)      R    ];
    
    % Matrizes de rigidez e de massa locais simb�licas do elemento i         
    ks = Rt(:,:,i)'*ke*Rt(:,:,i);       % Exibidas na equa��o XXX
    ms = Rt(:,:,i)'*me*Rt(:,:,i);
    
    % Matrizes de rigidez e de massa locais num�ricas do elemento i
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