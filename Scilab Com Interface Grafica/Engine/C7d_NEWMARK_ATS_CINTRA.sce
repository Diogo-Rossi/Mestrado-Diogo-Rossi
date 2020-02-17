// MÉTODO DE NEWMARK COM AUTOMATIC TIME STEPPING DE CINTRA

Gama = evstr(NewmarkBeta(1).string)
Beta = evstr(NewmarkBeta(2).string)
if Beta>=Gama/2; Dtmax = evstr(NewmarkBeta(3).string); end

T1      = evstr(NewmarkBeta(4).string)
Dt(1)   = evstr(ATS_Cintra(1).string)
alf     = evstr(ATS_Cintra(2).string)
cp      = evstr(ATS_Cintra(3).string)
ct      = evstr(ATS_Cintra(4).string)

// Valores crítico, máximo e mínimo para o passo de tempo
if Beta>=Gama/2 // Método incondicionalmente estável    
    Dtcrit = Dtmax; // Valor crítico livre, escolhido pelo usuário    
else// Valor crítico conservativo dado pela equação XXX para o menor período
    Dtcrit = Tj/(%pi*sqrt(2*(Gama-2*Beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0;                                

// Intervalos de regularização da curvatura
Dtreg = ct*Dtcrit;
tj = 0:Dtreg:T1;
if max(tj) < T1;    tj(length(tj)+1) = max(tj) + Dtreg;     end 

// Instante de tempo inicial e condições iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

// Condições iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

// Curvatura inicial para condições nulas - Equação XXX
kapa(1) = norm(A(:,1));
kapaReg(1) = kapa(1);

// Intervalo de tempo inicial para condições não quiescentes
if norm(A(:,1))>0; Dt(1) = Dtmax/(1 + cp*kapaReg(1)); end

// Matriz de Rigidez efetiva para o passo 1, dada pela equação XXX
k_ = K + (1/(Beta*Dt(1)^2))*M + (Gama/(Beta*Dt(1)))*C;

i=2; j=1;
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
    
    // Atualização do passo de tempo - algoritmo de Cintra (2008)
    // Cálculo da Curvatura - Equação XXX
    kapa(i) = sqrt( ( 1+(V(:,i)'*V(:,i)) )*(A(:,i)'*A(:,i)) ...     
                  - (V(:,i)'*A(:,i))^2)/(( 1+(V(:,i)'*V(:,i)) )^(3/2));
    // Regularização da Curvatura segundo Figura XXX
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
    // Correlação da Equação XXX
    Dt(i) = Dtmax/(1 + cp*kapaReg(i));  
    Dt(i) = max(Dt(i),Dtmin); // Incremento limitado a um valor mínimo
       
    // Matriz de Rigidez efetiva para o passo seguinte, equação XXX
    if Dt(i) ~= Dt(i-1)
        k_ = K + (1/(Beta*Dt(i)^2))*M + (Gama/(Beta*Dt(i)))*C;
    end
   
    i = i+1;
end

// Número de pontos no histórico das cargas e respostas
N1 = length(t);

// Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;

// Tranpõe para obter vetor-linha (o padrão do Scilab é vetor-coluna)
t=t'; Dt=Dt';  kapa=kapa'; kapaReg=kapaReg'
