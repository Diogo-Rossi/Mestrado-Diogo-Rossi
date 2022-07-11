
Dt(2) = Dt(1);

for i=2:3
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
    
    % Algoritmo de Hulbert & Jang
    Da = A(:,i) - A(:,i-1);             % Incremento na Acelera��o
    e(:,i) = (Dt(i-1)^2)*(beta-1/6)*Da; % Erro local, Eq. XXX
    sclfac(i) = max(norm(Du),0.9*sclfac(i-1)); % Fator de escala, Eq. XXX  
    RL(i) = norm(e(:,i))/sclfac(i); % Erro local normalizado, Eq. XXX    
end

while RL(3)>tol
    % Algoritmo de Hulbert & Jang para redu��o do passo
    fdec = (tol/RL(3))^(1/pdec); % Fator de redu��o, eq. XXX
    Dt(2) = fdec*Dt(2);       % Redu��o do incremento, eq. XXX
    Dt(2) = max(Dt(2),Dtmin); % Dt limitado a um valor m�nimo
    k_ = K + (1/(beta*Dt(2)^2))*M + (gama/(beta*Dt(2)))*C;
         
    % Atualiza��o do instante de tempo
    t(3) = t(2) + Dt(2);
       
    % Vetor de Carga efetiva incremental, dado pela equa��o XXX
    p(:,3) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(3));
    Dp = p(:,3) - p(:,2);
    Dp_ = Dp + ...
           + M*((1/(beta*Dt(2)))*V(:,2)  +  (1/(2*beta))*A(:,2) ) ...
           + C*((gama/beta)*V(:,2) + (gama/(2*beta)-1)*Dt(2)*A(:,2));
              
    % Incremento no deslocamento, encontrado ao resolver a equa��o XXX 
    Du = k_\Dp_;
    
    % Incremento na Velocidade, obtido com a equa��o XXX
    Dv = (gama/(beta*Dt(2)))*Du + (1-gama/(2*beta))*Dt(2)*A(:,2) ...
         -(gama/beta)*V(:,2);
     
    % Deslocamento e velocidade no final do passo, equa��es XXX e XXX
    D(:,3) = D(:,2) + Du;
    V(:,3) = V(:,2) + Dv;
    
    % Acelera��o no final do passo, equa��o XXX
    A(:,3) = M\( p(:,3) - C*V(:,3) - K*D(:,3));
    
    % Atualiza��o do passo de tempo - algoritmo de Hulbert & Jang
    Da = A(:,3) - A(:,2);             % Incremento na Acelera��o
    e(:,3) = (Dt(2)^2)*(beta-1/6)*Da; % Erro local, Eq. XXX
    RL(3) = norm(e(:,3))/sclfac(3); % Erro local normalizado, Eq. XXX              
end

if lb*tol<=RL(3) && RL(3)<=tol % Verifica��o da condi��o XXX
    Dt(3) = Dt(2);
    count = 0;
elseif RL(3)<lb*tol
    Dt(3) = Dt(2);
    count = count + 1;
end


