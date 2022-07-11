// INTRODUÇÃO DAS BARRAS

// Coordenadas dos nós das barras inseridas
[dummy order] = unique(Barras.data,"r")     // Elimina nós coincidentes
coord = Barras.data(gsort(order,"g","i"),:) // Extrai nós não coincidentes

nj = size(coord,1) // Número de nós
m = size(Barras,1) // Número de barras

// Constrói a matriz de incidência dos nós e matriz de n° dos deslocmamentos
Nos = [];
Des = [];
for i=1:m
    Nos(i,1) = vectorfind(coord,Barras(i).data(1,:),"r") // Nó inicial e final
    Nos(i,2) = vectorfind(coord,Barras(i).data(2,:),"r") // do membro i
    for j=1:2
        Des(i,3*j-2) = 3*Nos(i,j) - 2;  // Número dos deslocamentos dos nós 
        Des(i,3*j-1) = 3*Nos(i,j) - 1;  // 1 e 2 do membro i, obtidos com as
        Des(i,3*j) = 3*Nos(i,j);        // equações XXX
    end    
end

// Valor padrão fixado para np. Pode ser alterado.
np = 10;

// Calcula as coordenadas x e y dos np pontos tomados ao longo das barras
CX = zeros(np,m);
CY = zeros(np,m);
for i=1:m
    CX(1,i) = coord(Nos(i,1),1);
    CX(np,i) = coord(Nos(i,2),1);
    CY(1,i) = coord(Nos(i,1),2);
    CY(np,i) = coord(Nos(i,2),2);
    Dx = (CX(np,i)-CX(1,i))/(np-1);
    Dy = (CY(np,i)-CY(1,i))/(np-1);
    for j=2:np-1
        CX(j,i) = CX(j-1,i) + Dx;
        CY(j,i) = CY(j-1,i) + Dy;
    end
end
