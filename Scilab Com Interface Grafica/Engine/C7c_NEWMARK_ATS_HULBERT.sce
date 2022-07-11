// MÉTODO DE NEWMARK COM AUTOMATIC TIME STEPPING DE HULBERT E JANG

Gama = evstr(NewmarkBeta(1).string)
Beta = evstr(NewmarkBeta(2).string)
if Beta>=Gama/2; Dtmax = evstr(NewmarkBeta(3).string); end

T1 = evstr(NewmarkBeta(4).string)
Dt(1)     = evstr(ATS_Hulbert(1).string)
Dt_T_alvo = evstr(ATS_Hulbert(2).string)
lb   = evstr(ATS_Hulbert(3).string)
pinc = evstr(ATS_Hulbert(4).string)
pdec = evstr(ATS_Hulbert(5).string)

Cd = ((2*%pi)^2)*abs((Beta-1/6));           // Fator multiplicador, eq. XXX
tol = Cd*(Dt_T_alvo)^2;                    // Tolerância no erro, eq. XXX
lcount = double(1*int8(1/Dt_T_alvo)); // Limite do contador, eq. XXX
count = 0;
sclfac(1) = 0;

// Valores crítico, máximo e mínimo para o passo de tempo
if Beta>=Gama/2 // Método incondicionalmente estável    
    Dtcrit = Dtmax; // Valor crítico livre, escolhido pelo usuário    
else// Valor crítico conservativo dado pela equação XXX para o menor período
    Dtcrit = Tj/(%pi*sqrt(2*(Gama-2*Beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0; 

Dt(1) = min(Dt(1),Dtmax); // Primeiro incremento limitado a um valor máximo
Dt(1) = max(Dt(1),Dtmin); // Primeiro incremento limitado a um valor mínimo

// Instante de tempo inicial e condições iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

// Condições iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

// Matriz de Rigidez efetiva para o passo 1, dada pela equação XXX
k_ = K + (1/(Beta*Dt(1)^2))*M + (Gama/(Beta*Dt(1)))*C;

// Executa função se o problema tiver condições iniciais quiescentes
if norm(p(:,1))==0; exec("Quiescent.sce"); i=4; else i=2; end

while t(i-1)<T1
    // Atualização do instante de tempo
    t(i) = t(i-1) + Dt(i-1);
       
    // Vetor de Carga efetiva incremental, dado pela equação XXX
    p(:,i) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(i));
    Dp = p(:,i) - p(:,i-1);
    Dp_ = Dp + ...
           + M*((1/(Beta*Dt(i-1)))*V(:,i-1)  +  (1/(2*Beta))*A(:,i-1) ) ...
           + C*((Gama/Beta)*V(:,i-1) + (Gama/(2*Beta)-1)*Dt(i-1)*A(:,i-1));
              
    // Incremento no deslocamento, encontrado ao resolver a equação XXX 
    Du = k_\Dp_;
    
    // Incremento na Velocidade, obtido com a equação XXX
    Dv = (Gama/(Beta*Dt(i-1)))*Du + (1-Gama/(2*Beta))*Dt(i-1)*A(:,i-1) ...
         -(Gama/Beta)*V(:,i-1);
     
    // Deslocamento e velocidade no final do passo, equações XXX e XXX
    D(:,i) = D(:,i-1) + Du;
    V(:,i) = V(:,i-1) + Dv;
    
    // Aceleração no final do passo, equação XXX
    A(:,i) = M\( p(:,i) - C*V(:,i) - K*D(:,i));
    
    // Atualização do passo de tempo - algoritmo de Hulbert & Jang
    Da = A(:,i) - A(:,i-1);             // Incremento na Aceleração
    e(:,i) = (Dt(i-1)^2)*(Beta-1/6)*Da; // Erro local, Eq. XXX
    sclfac(i) = max(norm(Du),0.9*sclfac(i-1)); // Fator de escala, Eq. XXX  
    RL(i) = norm(e(:,i))/sclfac(i); // Erro local normalizado, Eq. XXX
    
    if lb*tol<=RL(i) && RL(i)<=tol // Verificação da condição XXX
        Dt(i) = Dt(i-1);
        count = 0;
        nao_reduziu_Dt = 1;
    elseif RL(i)<lb*tol
        count = count + 1;
        if count > lcount
            RLmax = max(RL(i-lcount:i));
            finc = (tol/RLmax)^(1/pinc); // Fator de amplificação, eq. XXX   
            Dt(i) = finc*Dt(i-1);   // Amplificação do incremento, eq. XXX
            Dt(i) = min(Dt(i),Dtmax);    // Dt limitado a um valor máximo            
            count = 0;
        else
            Dt(i) = Dt(i-1);
        end
        nao_reduziu_Dt = 1;
    elseif RL(i)>tol
        if i>2 && Dt(i-1)>Dt(i-2)   // Verificação do caso 1
            Dt(i-1) = Dt(i-2);      // Redução do incremento no caso 1
            ocorreu_caso_1 = 1; 
            ocorreu_caso_2 = 0;          
        else           
            fdec = (tol/RL(i))^(1/pdec);  // Fator de redução, eq. XXX
            Dt(i-1) = fdec*Dt(i-1);       // Redução do incremento, eq. XXX
            Dt(i-1) = max(Dt(i-1),Dtmin); // Dt limitado a um valor mínimo
            count = 0;
            ocorreu_caso_1 = 0;
            ocorreu_caso_2 = 1;
        end
        nao_reduziu_Dt = 0;
    end

// Matriz de Rigidez efetiva - equação XXX - e atualização do passo
    if nao_reduziu_Dt        
        if Dt(i) > Dt(i-1)
            k_anterior = k_;
            k_ = K + (1/(Beta*Dt(i)^2))*M + (Gama/(Beta*Dt(i)))*C;
        end
        i = i+1;
    elseif ocorreu_caso_1
        k_ = k_anterior;
    elseif ocorreu_caso_2
        k_ = K + (1/(Beta*Dt(i-1)^2))*M + (Gama/(Beta*Dt(i-1)))*C;
    end           
    
end

// Número de pontos no histórico das cargas e respostas
N1 = length(t);

// Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;

// Tranpõe para obter vetor-linha (o padrão do Scilab é vetor-coluna)
t=t'; Dt=Dt';  RL=RL'; NormaErro=sqrt(diag(e'*e))'

FSnormaErro = max(RL)/max(NormaErro) // fator de escala para mostrar no gráfico
NormaErro = NormaErro*FSnormaErro
