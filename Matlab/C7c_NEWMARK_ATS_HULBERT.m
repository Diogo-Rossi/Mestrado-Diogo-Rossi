% M�TODO DE NEWMARK COM AUTOMATIC TIME STEPPING DE HULBERT E JANG
clc
fprintf('\n6 - M�TODO NUM�RICO =======================================\n');

fprintf('\n6.1 - Par�metros do algoritmo de Newmark...................\n');
gama = input('Valor do par�metro "gama" (entre 1/2 e 1): GAMA = ');
beta = input('Valor do par�metro "beta" (entre   0 e 1): BETA = ');
if beta>=gama/2; Dtmax = input('Incremento m�ximo: Dtmax = '); end

fprintf('\n6.2 - Par�metros do algoritmo de Hulbert & Jang............\n');
T1 = input('Intervalo de plotagem das respostas/cargas: T = ');
Dt(1) = input('Comprimento do primeiro incremento de tempo: Dt(1) = ');
Dt_T_alvo = input('Raz�o alvo Dt/T: (Dt/T)alvo = ');
lb   = input('Valor do par�metro: lb = ');
pinc = input('Valor do par�metro: pinc = ');
pdec = input('Valor do par�metro: pdec = ');

Cd = ((2*pi)^2)*abs((beta-1/6));           % Fator multiplicador, eq. XXX
tol = Cd*(Dt_T_alvo)^2;                    % Toler�ncia no erro, eq. XXX
lcount = cast(int8(1/Dt_T_alvo),'double'); % Limite do contador, eq. XXX
count = 0;
sclfac(1) = 0;

% Valores cr�tico, m�ximo e m�nimo para o passo de tempo
if beta>gama/2 % M�todo incondicionalmente est�vel    
    Dtcrit = Dtmax; % Valor cr�tico livre, escolhido pelo usu�rio    
else% Valor cr�tico conservativo dado pela equa��o XXX para o menor per�odo
    Dtcrit = Tj/(pi*sqrt(2*(gama-2*beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0; 

Dt(1) = min(Dt(1),Dtmax); % Primeiro incremento limitado a um valor m�ximo
Dt(1) = max(Dt(1),Dtmin); % Primeiro incremento limitado a um valor m�nimo

% Instante de tempo inicial e condi��es iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

% Condi��es iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

% Matriz de Rigidez efetiva para o passo 1, dada pela equa��o XXX
k_ = K + (1/(beta*Dt(1)^2))*M + (gama/(beta*Dt(1)))*C;

% Executa fun��o se o problema tiver condi��es iniciais quiescentes
if norm(p(:,1))==0; Quiescent; i=4; else i=2; end

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
     
    % Deslocamento e velocidade no final do passo, equa��es XXX e XXX
    D(:,i) = D(:,i-1) + Du;
    V(:,i) = V(:,i-1) + Dv;
    
    % Acelera��o no final do passo, equa��o XXX
    A(:,i) = M\( p(:,i) - C*V(:,i) - K*D(:,i));
    
    % Atualiza��o do passo de tempo - algoritmo de Hulbert & Jang
    Da = A(:,i) - A(:,i-1);             % Incremento na Acelera��o
    e(:,i) = (Dt(i-1)^2)*(beta-1/6)*Da; % Erro local, Eq. XXX
    sclfac(i) = max(norm(Du),0.9*sclfac(i-1)); % Fator de escala, Eq. XXX  
    RL(i) = norm(e(:,i))/sclfac(i); % Erro local normalizado, Eq. XXX
    
    if lb*tol<=RL(i) && RL(i)<=tol % Verifica��o da condi��o XXX
        Dt(i) = Dt(i-1);
        count = 0;
        nao_reduziu_Dt = 1;
    elseif RL(i)<lb*tol
        count = count + 1;
        if count > lcount
            RLmax = max(RL(i-lcount:i));
            finc = (tol/RLmax)^(1/pinc); % Fator de amplifica��o, eq. XXX   
            Dt(i) = finc*Dt(i-1);   % Amplifica��o do incremento, eq. XXX
            Dt(i) = min(Dt(i),Dtmax);    % Dt limitado a um valor m�ximo            
            count = 0;
        else
            Dt(i) = Dt(i-1);
        end
        nao_reduziu_Dt = 1;
    elseif RL(i)>tol
        if i>2 && Dt(i-1)>Dt(i-2)   % Verifica��o do caso 1
            Dt(i-1) = Dt(i-2);      % Redu��o do incremento no caso 1
            ocorreu_caso_1 = 1; 
            ocorreu_caso_2 = 0;          
        else           
            fdec = (tol/RL(i))^(1/pdec); % Fator de redu��o, eq. XXX
            Dt(i-1) = fdec*Dt(i-1);       % Redu��o do incremento, eq. XXX
            Dt(i-1) = max(Dt(i-1),Dtmin); % Dt limitado a um valor m�nimo
            count = 0;
            ocorreu_caso_1 = 0;
            ocorreu_caso_2 = 1;
        end
        nao_reduziu_Dt = 0;
    end

% Matriz de Rigidez efetiva - equa��o XXX - e atualiza��o do passo
    if nao_reduziu_Dt        
        if Dt(i) > Dt(i-1)
            k_anterior = k_;
            k_ = K + (1/(beta*Dt(i)^2))*M + (gama/(beta*Dt(i)))*C;
        end
        i = i+1;
    elseif ocorreu_caso_1
        k_ = k_anterior;
    elseif ocorreu_caso_2
        k_ = K + (1/(beta*Dt(i-1)^2))*M + (gama/(beta*Dt(i-1)))*C;
    end              
end

% N�mero de pontos no hist�rico das cargas e respostas
N1 = length(t);

% Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;