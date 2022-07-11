% M�TODO DE NEWMARK COM AUTOMATIC TIME STEPPING DE CINTRA
clc
fprintf('\n6 - M�TODO NUM�RICO =======================================\n');

fprintf('\n6.1 - Par�metros do algoritmo de Newmark...................\n');
gama = input('Valor do par�metro "gama" (entre 1/2 e 1): GAMA = ');
beta = input('Valor do par�metro "beta" (entre   0 e 1): BETA = ');
if beta>=gama/2; Dtmax = input('Incremento m�ximo: Dtmax = '); end

fprintf('\n6.2 - Par�metros do algoritmo de Cintra....................\n');
T1 = input('Intervalo de plotagem das respostas/cargas: T = ');
Dt(1) = input('Comprimento do primeiro incremento de tempo: Dt(1) = ');
cp = input('Valor da constante positiva cp: cp = ');
ct = input('Valor da constante positiva ct: ct = ');
alf = input('Valor da constante positiva alpha: alpha = ');

% Valores cr�tico, m�ximo e m�nimo para o passo de tempo
if beta>=gama/2 % M�todo incondicionalmente est�vel    
    Dtcrit = Dtmax; % Valor cr�tico livre, escolhido pelo usu�rio    
else% Valor cr�tico conservativo dado pela equa��o XXX para o menor per�odo
    Dtcrit = Tj/(pi*sqrt(2*(gama-2*beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0;                                

% Intervalos de regulariza��o da curvatura
Dtreg = ct*Dtcrit;
tj = 0:Dtreg:T1;
if max(tj) < T1;    tj(length(tj)+1) = max(tj) + Dtreg;     end 

% Instante de tempo inicial e condi��es iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

% Condi��es iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

% Curvatura inicial para condi��es nulas - Equa��o XXX
kapa(1) = norm(A(:,1));
kapaReg(1) = kapa(1);

% Intervalo de tempo inicial para condi��es n�o quiescentes
if norm(A(:,1))>0; Dt(1) = Dtmax/(1 + cp*kapaReg(1)); end

% Matriz de Rigidez efetiva para o passo 1, dada pela equa��o XXX
k_ = K + (1/(beta*Dt(1)^2))*M + (gama/(beta*Dt(1)))*C;

i=2; j=1;
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
    
    % Atualiza��o do passo de tempo - algoritmo de Cintra (2008)
    % C�lculo da Curvatura - Equa��o XXX
    kapa(i) = sqrt( ( 1+dot(V(:,i),V(:,i)) )*dot(A(:,i),A(:,i)) ...     
                  - dot(V(:,i),A(:,i))^2)/(( 1+dot(V(:,i),V(:,i)) )^(3/2));
    % Regulariza��o da Curvatura segundo Figura XXX
    if t(i) > tj(j+1)   
        j = 1 + floor(t(i)/Dtreg);
        kapaReg(i)=alf*kapaReg(i-1)+(1-alf)*maxkapatjt(tj(j),t(i),kapa,t);
        if maxkapatjt(tj(j),t(i),kapa,t)>kapaReg(i)
            kapaReg(i) = maxkapatjt(tj(j),t(i),kapa,t);
        end        
    else
        if maxkapatjt(tj(j),t(i),kapa,t)>kapaReg(i-1)
            kapaReg(i) = maxkapatjt(tj(j),t(i),kapa,t);
        else
            kapaReg(i) = kapaReg(i-1);
        end
    end
    % Correla��o da Equa��o XXX
    Dt(i) = Dtmax/(1 + cp*kapaReg(i));  
    Dt(i) = max(Dt(i),Dtmin); % Incremento limitado a um valor m�nimo
       
    % Matriz de Rigidez efetiva para o passo seguinte, equa��o XXX
    if Dt(i) ~= Dt(i-1)
        k_ = K + (1/(beta*Dt(i)^2))*M + (gama/(beta*Dt(i)))*C;
    end
   
    i = i+1;
end

% N�mero de pontos no hist�rico das cargas e respostas
N1 = length(t);

% Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;