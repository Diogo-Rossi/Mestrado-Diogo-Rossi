
Dt(2) = Dt(1);

for i=2:3
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
    
    // Algoritmo de Hulbert & Jang
    Da = A(:,i) - A(:,i-1);             // Incremento na Aceleração
    e(:,i) = (Dt(i-1)^2)*(Beta-1/6)*Da; // Erro local, Eq. XXX
    sclfac(i) = max(norm(Du),0.9*sclfac(i-1)); // Fator de escala, Eq. XXX  
    RL(i) = norm(e(:,i))/sclfac(i); // Erro local normalizado, Eq. XXX    
end

while RL(3)>tol
    // Algoritmo de Hulbert & Jang para redução do passo
    fdec = (tol/RL(3))^(1/pdec); // Fator de redução, eq. XXX
    Dt(2) = fdec*Dt(2);       // Redução do incremento, eq. XXX
    Dt(2) = max(Dt(2),Dtmin); // Dt limitado a um valor mínimo
    k_ = K + (1/(Beta*Dt(2)^2))*M + (Gama/(Beta*Dt(2)))*C;
         
    // Atualização do instante de tempo
    t(3) = t(2) + Dt(2);
       
    // Vetor de Carga efetiva incremental, dado pela equação XXX
    p(:,3) = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t(3));
    Dp = p(:,3) - p(:,2);
    Dp_ = Dp + ...
           + M*((1/(Beta*Dt(2)))*V(:,2)  +  (1/(2*Beta))*A(:,2) ) ...
           + C*((Gama/Beta)*V(:,2) + (Gama/(2*Beta)-1)*Dt(2)*A(:,2));
              
    // Incremento no deslocamento, encontrado ao resolver a equação XXX 
    Du = k_\Dp_;
    
    // Incremento na Velocidade, obtido com a equação XXX
    Dv = (Gama/(Beta*Dt(2)))*Du + (1-Gama/(2*Beta))*Dt(2)*A(:,2) ...
         -(Gama/Beta)*V(:,2);
     
    // Deslocamento e velocidade no final do passo, equações XXX e XXX
    D(:,3) = D(:,2) + Du;
    V(:,3) = V(:,2) + Dv;
    
    // Aceleração no final do passo, equação XXX
    A(:,3) = M\( p(:,3) - C*V(:,3) - K*D(:,3));
    
    // Atualização do passo de tempo - algoritmo de Hulbert & Jang
    Da = A(:,3) - A(:,2);             // Incremento na Aceleração
    e(:,3) = (Dt(2)^2)*(Beta-1/6)*Da; // Erro local, Eq. XXX
    RL(3) = norm(e(:,3))/sclfac(3); // Erro local normalizado, Eq. XXX              
end

if lb*tol<=RL(3) && RL(3)<=tol // Verificação da condição XXX
    Dt(3) = Dt(2);
    count = 0;
elseif RL(3)<lb*tol
    Dt(3) = Dt(2);
    count = count + 1;
end


