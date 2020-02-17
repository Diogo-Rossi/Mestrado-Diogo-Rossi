% INTRODU��O DAS BARRAS
% A execu��o deste programa assume que o seguinte j� foi executado:
% C0_INIC

fprintf('\n1 - GEOMETRIA =============================================\n');
nj = input('N�mero de n�s = ');
m  = input('N�mero de barras = ');

fprintf('\n1.1 - Barras.................................................');
for i=1:m
    fprintf('\nN�s da Barra %d:\n',i);
    Nos(i,1) = input('N� inicial = ');
    Nos(i,2) = input('N� final   = ');
    for j=1:2
        Des(i,3*j-2) = 3*Nos(i,j) - 2;  % N�mero dos deslocamentos dos n�s 
        Des(i,3*j-1) = 3*Nos(i,j) - 1;  % 1 e 2 do membro i, obtidos com as
        Des(i,3*j) = 3*Nos(i,j);        % equa��es XXX
    end
end

fprintf('\n1.2 - N�s....................................................');
for i=1:nj
    fprintf('\nCoordenadas do n� %d:\n',i);
    coord(i,1) = input('x = ');
    coord(i,2) = input('y = ');
end

% Valor padr�o fixado para np. Pode ser alterado.
np = 3;

% Calcula as coordenadas x e y dos np pontos tomados ao longo das barras
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

% Desenha a estrutura indeformada
close
set(figure(1),'units','normalized')
set(figure(1),'position',[0.55 0.55 0.44 0.42]);
plot([CX(1,:);CX(np,:)],[CY(1,:);CY(np,:)],'b-x')
axis equal
xmin = min(min(CX))-1 ; xmax = max(max(CX))+1;
ymin = min(min(CY))-1 ; ymax = max(max(CY))+1;
axis([xmin xmax ymin ymax])