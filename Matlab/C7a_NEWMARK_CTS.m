% M�TODO DE NEWMARK COM CONSTANTES TIME STEPS
clc
fprintf('\n6 - M�TODO NUM�RICO =======================================\n');

fprintf('\n6.1 - Par�metros do algoritmo de Newmark...................\n');
gama = input('Valor do par�metro "gama" (entre 1/2 e 1): GAMA = ');
beta = input('Valor do par�metro "beta" (entre   0 e 1): BETA = ');
if beta>=gama/2; Dtmax = input('Incremento m�ximo: Dtmax = '); end

fprintf('\n6.2 - Par�metros do algoritmo step by step.................\n');
T1 = input('Intervalo de plotagem das respostas/cargas: T = ');
Dt(1) = input('Comprimento do incremento de tempo: Dt = ');

% Valores cr�tico, m�ximo e m�nimo para o passo de tempo
if beta>gama/2 % M�todo incondicionalmente est�vel    
    Dtcrit = Dtmax; % Valor cr�tico livre, escolhido pelo usu�rio    
else% Valor cr�tico conservativo dado pela equa��o XXX para o menor per�odo
    Dtcrit = Tj/(pi*sqrt(2*(gama-2*beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0;
Dt(1) = min(Dt(1),Dtmax);   % Incremento limitado a um valor m�ximo
Dt(1) = max(Dt(1),Dtmin);   % Incremento limitado a um valor m�nimo

% Instante de tempo inicial e condi��es iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

% Condi��es iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

% Matriz de Rigidez efetiva, dada pela equa��o XXX
k_ = K + (1/(beta*Dt(1)^2))*M + (gama/(beta*Dt(1)))*C;

i=2;
while t(i-1)<T1
    % Atualiza��o do instante de tempo
    t(i) = t(i-1) + Dt(i-1);
       
    % Vetor de Carga efetiva incremental, dado pela equa��o XXX
    p(:,i) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(i));
    Dp = p(:,i) - p(:,i-1);
    Dp_ = Dp + ...
           + M*((1/(beta*Dt(i-1)))*V(:,i-1)  +  (1/(2*beta))*A(:,i-1) ) ...
           + C*((gama/beta)*V(:,i-1) + (gama/(2*beta)-1)*Dt(i-1)*A(:,i-1));
              
    % Incremento no deslocamento, encontrado ao resolver a equa��o XXX 
    Du = k_\Dp_;
    
    % Incremento na Velocidade, obtido com a equa��o XXX
    Dv = (gama/(beta*Dt(i-1)))*Du + (1-gama/(2*beta))*Dt(i-1)*A(:,i-1) ...
         -(gama/beta)*V(:,i-1);
     
    % Deslocamento e velocidade no final do time-step, equa��es XXX e XXX
    D(:,i) = D(:,i-1) + Du;
    V(:,i) = V(:,i-1) + Dv;
    
    % Acelera��o no final do time-step, equa��o XXX
    A(:,i) = M\( p(:,i) - C*V(:,i) - K*D(:,i));
    
    % Atualiza��o para o passo de tempo seguinte
    Dt(i) = Dt(i-1);            % Incremento de tempo constante
    i = i+1;
end

% N�mero de pontos no hist�rico das cargas e respostas
N1 = length(t);

% Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;