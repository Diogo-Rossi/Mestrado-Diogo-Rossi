// CONFIGURAR GRID

// Limites atuais do eixo
BoundX = string(eixoEstr.data_bounds(2))
BoundY = string(eixoEstr.data_bounds(4))

// Passos atuais do Grid do eixo
PassoX = string(GridEstrutura.data(2,1)-GridEstrutura.data(1,1))
PassoY = string(max(diff(GridEstrutura.data(:,2))))

// Coleta entrada do usuário para passos e limites
Rotulos = ['Passo em X';'Passo em Y';'Máximo em X';'Máximo em Y'];
DadosGrid = x_mdialog('Configurar Grid',Rotulos,[PassoX;PassoY;BoundX;BoundY])


if DadosGrid~=[] then
    
    // Coleta numericamente entradas do usuário
    PassoX = evstr(DadosGrid(1));
    PassoY = evstr(DadosGrid(2));
    BoundX = evstr(DadosGrid(3));
    BoundY = evstr(DadosGrid(4));
    
    // Cria numericamente subsivisões dos eixos
    EixoX = [0:PassoX:BoundX]
    EixoY = [0:PassoY:BoundY]
    
    // Cria pontos em X
    PontosX = repmat(EixoX,1,size(EixoY,2))
    
    // Cria pontos em Y
    PontosY=[]
    for i=EixoY
        PontosY = [PontosY repmat(i,1,size(EixoX,2))]
    end
    
    // Atualiza Grid da estrutura e limites dos eixos
    GridEstrutura.data = [PontosX;PontosY]'
    eixoEstr.data_bounds =[0 BoundX 0 BoundY]
end
