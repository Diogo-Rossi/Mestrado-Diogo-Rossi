% MATRIZ DE RIGIDEZ E DE MASSA LOCAIS SIMBÓLICAS
% A execução deste programa assume que os seguintes já foram executados:
% C0_INIC | C1_BARRAS

% Variáveis simbólicas genéricas
x = sym('x','real');    % Variável independente das funções Ni
L = sym('L','real');    % Comprimento da barra
E = sym('E','real');    % Módulo de elasticidade do material
A = sym('A','real');    % Área da seção transversal
I = sym('I','real');    % Momento de inércia da seção transversal
p = sym('p','real');    % Massa por unidade de comprimento da barra 

% Vetor-linha de variáveis simbólicas dado na equação XXX
X = [1 x x^2 x^3];

% Matriz do sistema linear dado na equação XXX
Q = [ subs(X,        x,0) ;
      subs(diff(X,x),x,0) ;
      subs(X,        x,L) ;
      subs(diff(X,x),x,L) ];

% Vetores-coluna de termos independentes dados na equação XXX
b(:,1) = [1; -1/L; 0; -1/L];
b(:,2) = [0;  1/L; 1;  1/L];
b(:,3) = [1; 0; 0; 0];
b(:,4) = [0; 1; 0; 0];
b(:,5) = [0; 0; 1; 0];
b(:,6) = [0; 0; 0; 1];

% Obtenção das 6 funções Ni pela equação XXX
for i=1:6
    N(i) = X*(Q\b(:,i));
end

% Matriz simbólica das funções Ni, exibida na equação XXX
MN = [ N(1)  0    0   N(2)  0    0   ;
        0   N(3) N(4)  0   N(5) N(6) ];

% Matriz simbólica das derivadas das funções Ni, exibida na equação XXX
B(1,:) = diff(MN(1,:),x);           % Linha 1
B(2,:) = diff(diff(MN(2,:),x),x);   % Linha 2

% Matriz simbólica com propriedades da seção, exibida na equação XXX
S = [ A 0 ; 0 I ];

% Obtenção das matrizes de rigidez e de massa simbólicas do elemento
ke = E*int(B'*S*B,x,0,L);   % Expressão XXX
me = p*int(MN'*MN,x,0,L);   % Expressão XXX