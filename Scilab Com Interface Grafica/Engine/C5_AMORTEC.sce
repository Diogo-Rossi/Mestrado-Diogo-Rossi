// FREQUENCIAS NATURAIS E MATRIZ DE AMORTECIMENTO

DampingData(find(evstr(DampingData.string)>n)).string = string(n)

modo1 = evstr(DampingData(1).string)
modo2 = evstr(DampingData(2).string)

csi(1,1) = evstr(DampingData(3).string)
csi(2,1) = evstr(DampingData(4).string)

// Vetor de frequências naturais da estrutura
// Raiz quadrada dos autovalores do problema generalizado da equação XXX 
w = sqrt(spec(K,M)); w = real(w); // Esse último comando força que 'w' seja real

// Ordena as frequências em ordem crescente dentro do vetor w
w = gsort(w,"g","i");

// Calcula o período de vibração natual mais curto, associado à maior freq.
Tj = 2*%pi/max(w);   // Equação XXX

// Matriz dos coeficientes do sistema linear composto por duas equações de
// duas incógnitas, iguais à expressão XXX
Q = [ 1/(2*w(modo1)) w(modo1)/2 ;
      1/(2*w(modo2)) w(modo2)/2 ];

// Solução do sistema linear de duas equações e duas incógnitas
a = Q\csi; // Também exibida na equação XXX

// Taxas de amortecimento modais, encontradas com a equação XXX
csi = zeros(n,1);
for i=1:n
    csi(i) = (1/(2*w(i)))*a(1) + (w(i)/2)*a(2);
end

// Matriz de amortecimento proporcional, dada pela equação XXX
C = a(1)*M + a(2)*K;
