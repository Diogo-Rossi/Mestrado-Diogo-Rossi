// MÉTODO DE NEWMARK COM CONSTANTES TIME STEPS
clc
mprintf("\n6 - METODO NUMERICO ============================================\n");

mprintf("\n6.1 - Parametros do algoritmo de Newmark _____________________\n\n");
Gama = input("  Valor do parametro ""Gama"" (entre 1/2 e 1): Gama = ");
Beta = input("  Valor do parametro ""Beta"" (entre   0 e 1): Beta = ");
if Beta>Gama/2; Dtmax = input('Incremento maximo: Dtmax = '); end

mprintf('\n6.2 - Parametros do algoritmo step by step ___________________\n\n');
T1 = input('  Intervalo de plotagem das respostas/cargas: T = ');
Dt(1) = input('  Comprimento do incremento de tempo: Dt = ');

// Valores crítico, máximo e mínimo para o passo de tempo
if Beta>Gama/2 // Método incondicionalmente estável    
    Dtcrit = Dtmax; // Valor crítico livre, escolhido pelo usuário    
else // Valor crítico conservativo dado pela equação XXX para o menor período
    Dtcrit = Tj/(%pi*sqrt(2*(Gama-2*Beta)));
end
Dtmax = Dtcrit;                                         
Dtmin = 0;
Dt(1) = min(Dt(1),Dtmax);   // Incremento limitado a um valor máximo
Dt(1) = max(Dt(1),Dtmin);   // Incremento limitado a um valor mínimo

// Instante de tempo inicial e condições iniciais de cargas
t(1) = 0;
p(:,1) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(1));

// Condições iniciais (nulas) das respostas
D(:,1) = zeros(n,1);
V(:,1) = zeros(n,1);
A      = zeros(n,1);
A(:,1) = M\( p(:,1) - C*V(:,1) - K*D(:,1));

// Matriz de Rigidez efetiva, dada pela equação XXX
k_ = K + (1/(Beta*Dt(1)^2))*M + (Gama/(Beta*Dt(1)))*C;

i=2;
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
     
    // Deslocamento e velocidade no final do time-step, equações XXX e XXX
    D(:,i) = D(:,i-1) + Du;
    V(:,i) = V(:,i-1) + Dv;
    
    // Aceleração no final do time-step, equação XXX
    A(:,i) = M\( p(:,i) - C*V(:,i) - K*D(:,i));
    
    // Atualização para o passo de tempo seguinte
    Dt(i) = Dt(i-1);            // Incremento de tempo constante
    i = i+1;
end

// Número de pontos no histórico das cargas e respostas
N1 = length(t);

// Vetor de deslocamentos globais (deslocamentos livres e restringidos)
DJ = zeros(3*nj,N1);
DJ(GL,:) = D;
