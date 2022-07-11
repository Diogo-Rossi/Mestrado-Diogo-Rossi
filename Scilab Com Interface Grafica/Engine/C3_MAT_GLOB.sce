// MATRIZ DE RIGIDEZ E DE MASSA GLOBAIS NUMÉRICAS

Ex = evstr(MaterialData(1).string)
ro = evstr(MaterialData(2).string)

Ax = evstr(SectionData(1).string)
Ix = evstr(SectionData(2).string)

// Massa por unidade de comprimento das barras
px = ro*Ax;

// Inicialização da matrizes globais com zeros
K = zeros(3*nj,3*nj);
M = zeros(3*nj,3*nj);

winH = waitbar("Contruindo Matrizes de Rigidez e de Massa . . .")
tot = 6*6*m
for i=1:m
    
    // Cálculo dos comprimentos das barras e cossenos e senos dos angulos de 
    // inclinação, com base nas coordenadas dos nós inicial e final
    Lx(i) = sqrt(  ( CX(np,i)-CX(1,i) )^2 + ( CY(np,i)-CY(1,i) )^2  );
    c(i) = ( CX(np,i)-CX(1,i) )/Lx(i);
    s(i) = ( CY(np,i)-CY(1,i) )/Lx(i);
    
    // Matriz numérica de mudança de base para um vetor de três componentes
    R = [c(i) s(i) 0;                   // Exibida na equação XXX
        -s(i) c(i) 0;
          0    0   1];
    
    // Matriz numérica de mudança de base dos deslocamentos do elemento i  
    Rt(:,:,i) = [    R       zeros(3,3);  // Exibida na equação XXX
                 zeros(3,3)      R    ];

    // Matrizes de rigidez e de massa do elemento i         
    [ke,me]=MatKeMe(Lx(i),Ex,Ax,Ix,px);

    // Matrizes de rigidez e de massa locais (rotacionadas), do elemento i
    kl(:,:,i) = Rt(:,:,i)'*ke*Rt(:,:,i);       // Exibidas na equação XXX
    ml(:,:,i) = Rt(:,:,i)'*me*Rt(:,:,i);    
    
    // Matrizes de rigidez e de massa globais das estrutura
    for j=1:6
        for k=1:6
            // Soma-se as propriedades correspondentes a cada deslocamento
            // nodal que seja comum a um ou mais elementos da estrutura
            K(Des(i,j),Des(i,k)) = K(Des(i,j),Des(i,k)) + kl(j,k,i);
            M(Des(i,j),Des(i,k)) = M(Des(i,j),Des(i,k)) + ml(j,k,i);
            waitbar((6*6*(i-1)+6*(j-1)+k)/tot,winH);            
        end
    end

end
close(winH);
