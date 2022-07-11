% MATRIZ DE RIGIDEZ E DE MASSA LOCAIS SIMB�LICAS
% A execu��o deste programa assume que os seguintes j� foram executados:
% C0_INIC | C1_BARRAS

% Vari�veis simb�licas gen�ricas
x = sym('x','real');    % Vari�vel independente das fun��es Ni
L = sym('L','real');    % Comprimento da barra
E = sym('E','real');    % M�dulo de elasticidade do material
A = sym('A','real');    % �rea da se��o transversal
I = sym('I','real');    % Momento de in�rcia da se��o transversal
p = sym('p','real');    % Massa por unidade de comprimento da barra 

% Vetor-linha de vari�veis simb�licas dado na equa��o XXX
X = [1 x x^2 x^3];

% Matriz do sistema linear dado na equa��o XXX
Q = [ subs(X,        x,0) ;
      subs(diff(X,x),x,0) ;
      subs(X,        x,L) ;
      subs(diff(X,x),x,L) ];

% Vetores-coluna de termos independentes dados na equa��o XXX
b(:,1) = [1; -1/L; 0; -1/L];
b(:,2) = [0;  1/L; 1;  1/L];
b(:,3) = [1; 0; 0; 0];
b(:,4) = [0; 1; 0; 0];
b(:,5) = [0; 0; 1; 0];
b(:,6) = [0; 0; 0; 1];

% Obten��o das 6 fun��es Ni pela equa��o XXX
for i=1:6
    N(i) = X*(Q\b(:,i));
end

% Matriz simb�lica das fun��es Ni, exibida na equa��o XXX
MN = [ N(1)  0    0   N(2)  0    0   ;
        0   N(3) N(4)  0   N(5) N(6) ];

% Matriz simb�lica das derivadas das fun��es Ni, exibida na equa��o XXX
B(1,:) = diff(MN(1,:),x);           % Linha 1
B(2,:) = diff(diff(MN(2,:),x),x);   % Linha 2

% Matriz simb�lica com propriedades da se��o, exibida na equa��o XXX
S = [ A 0 ; 0 I ];

% Obten��o das matrizes de rigidez e de massa simb�licas do elemento
ke = E*int(B'*S*B,x,0,L);   % Express�o XXX
me = p*int(MN'*MN,x,0,L);   % Express�o XXX