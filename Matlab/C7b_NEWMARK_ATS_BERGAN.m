% MÉTODO DE NEWMARK COM AUTOMATIC TIME STEPPING DE BERGAN E MOLLESTAD
clc
fprintf('\n6 - MÉTODO NUMÉRICO =======================================\n');

fprintf('\n6.1 - Parâmetros do algoritmo de Newmark...................\n');
gama = input('Valor do parâmetro "gama" (entre 1/2 e 1): GAMA = ');
beta = input('Valor do parâmetro "beta" (entre   0 e 1): BETA = ');
if beta>=gama/2; Dtmax = input('Incremento máximo: Dtmax = '); end

fprintf('\n6.2 - Parâmetros do algoritmo de Bergan & Mollestad........\n');
T1 = input('Intervalo de plotagem das respostas/cargas: T = ');
Dt(1) = input('Comprimento do primeiro incremento de tempo: Dt(1) = ');
lambda = input('Valor do parâmetro "lambda" (step-length): LAMBDA = ');
CSIp = input('Valor do parâmetro "csi p": CSIp = ');
CSIm = input('Valor do parâmetro "csi m": CSIm = ');
EPS = 0.1;
NDu(1) = 0;

% Valores crítico, máximo e mínimo para o passo de tempo
if beta>gama/2 % Método incondicionalmente estável    
    Dtcrit = Dtmax; % Valor crítico livre, escolhido pelo usuário   
else% Valor crítico conservativo dado pela equação XXX para o menor período
    Dtcrit = Tj/(pi*sqrt(2*(gama-2*beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0;

% Instante de tempo inicial e condições iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

% Condições iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

% Matriz de Rigidez efetiva para o passo 1, dada pela equação XXX
k_ = K + (1/(beta*Dt(1)^2))*M + (gama/(beta*Dt(1)))*C;

i=2;
while t(i-1)<T1
    % Atualização do instante de tempo
    t(i) = t(i-1) + Dt(i-1);
       
    % Vetor de Carga efetiva incremental, dado pela equação XXX
    p(:,i) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(i));
    Dp = p(:,i) - p(:,i-1);
    Dp_ = Dp + ...
           + M*((1/(beta*Dt(i-1)))*V(:,i-1)  +  (1/(2*beta))*A(:,i-1) ) ...
           + C*((gama/beta)*V(:,i-1) + (gama/(2*beta)-1)*Dt(i-1)*A(:,i-1));
              
    % Incremento no deslocamento, encontrado ao resolver a equação XXX 
    Du = k_\Dp_;
    
    % Incremento na Velocidade, obtido com a equação XXX
    Dv = (gama/(beta*Dt(i-1)))*Du + (1-gama/(2*beta))*Dt(i-1)*A(:,i-1) ...
         -(gama/beta)*V(:,i-1);
     
    % Deslocamento e velocidade no final do passo, equações XXX e XXX
    D(:,i) = D(:,i-1) + Du;
    V(:,i) = V(:,i-1) + Dv;
    
    % Aceleração no final do passo, equação XXX
    A(:,i) = M\( p(:,i) - C*V(:,i) - K*D(:,i));
    
    % Atualização do passo de tempo - algoritmo de Bergan & Mollestad
    NDu(i) = norm(Du);
    if NDu(i)<EPS*NDu(i-1) % Verificação da condição XXX
        w2(i) = w2(i-1);
    else    
        w2(i) = (Du'*K*Du)/(Du'*M*Du); % Frequência característica 
    end                                % atual - eq. XXX
    
    T(i) = 2*pi/(sqrt(abs(w2(i))));  % Período característico 
                                     % atual - eq. XXX   
    CSI(i) = lambda*T(i)/Dt(i-1); % Taxa de incremento de 
                                  % tempo atual - eq. XXX
    Dt(i) = f(CSI(i),CSIp,CSIm)*Dt(i-1); % Incremento de tempo para o  
                                         % próximo passo - eq. XXX
                                              
    Dt(i) = min(Dt(i),Dtmax);   % Incremento limitado a um valor máximo
    Dt(i) = max(Dt(i),Dtmin);   % Incremento limitado a um valor mínimo
    
    % Matriz de Rigidez efetiva para o passo seguinte, equação XXX
    if Dt(i) ~= Dt(i-1)
        k_ = K + (1/(beta*Dt(i)^2))*M + (gama/(beta*Dt(i)))*C;
    end
    
    i = i+1;
end

% Número de pontos no histórico das cargas e respostas
N1 = length(t);

% Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;