// MATRIZ DE RIGIDEZ E DE MASSA LOCAIS
// O scilab não trabalha com variáveis simbólicas como o matlab
// Para resolver esse problema fez-se uso de funções que utilizam polinomios
// Também se fez uso de uma função que integra os polinomios numa matriz

function MatrizN=MN(L)

    // Variável do polinômio
    x = poly(0,"x");
    
    // Vetor-linha de variáveis simbólicas dado na equação XXX
    X = [1 x x^2 x^3];
    
    // Matriz do sistema linear dado na equação XXX
    Q = [ horner(X         ,0) ;
          horner(derivat(X),0) ;
          horner(X         ,L) ;
          horner(derivat(X),L) ];
    
    // Vetores-coluna de termos independentes dados na equação XXX
    b(:,1) = [1; -1/L; 0; -1/L];
    b(:,2) = [0;  1/L; 1;  1/L];
    b(:,3) = [1; 0; 0; 0];
    b(:,4) = [0; 1; 0; 0];
    b(:,5) = [0; 0; 1; 0];
    b(:,6) = [0; 0; 0; 1];
    
    // Obtenção das 6 funções Ni pela equação XXX
    for i=1:6
        N(i) = X*(Q\b(:,i));
    end
    
    // Matriz das funções Ni, exibida na equação XXX
    MatrizN = [ N(1)  0    0   N(2)  0    0   ;
                 0   N(3) N(4)  0   N(5) N(6) ];
            
endfunction

function [ke,me]=MatKeMe(L,E,A,I,p)
    
    N = MN(L)
    
    // Matriz das derivadas das funções Ni, exibida na equação XXX
    B(1,:) = derivat(N(1,:));          // Linha 1
    B(2,:) = derivat(derivat(N(2,:))); // Linha 2
    
    // Matriz com propriedades da seção, exibida na equação XXX
    S = [ A 0 ; 0 I ];
    
    // Obtenção das matrizes de rigidez e de massa do elemento
    ke = E*IntPolyMat(B'*S*B,0,L);   // Expressão XXX
    me = p*IntPolyMat(N'*N,0,L);   // Expressão XXX

endfunction

function I=IntPolyMat(M,a,b)
    // Essa função calcula a integral em [a,b] de todos elementos de uma matriz
    // de polinomios 'M', retornando uma matriz real 'I'
    for i =1:size(M,1);
        for j=1:size(M,2)
            I(i,j) = integrate(pol2str(M(i,j)),"x",a,b);
        end
    end    
endfunction
