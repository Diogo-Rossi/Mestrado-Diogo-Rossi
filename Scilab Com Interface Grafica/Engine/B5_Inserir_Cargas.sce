frame_left_estr.enable ="off"

// Escolha dos nós da estrutura
nos = SelectNodesInMat(coord)

// Escolha das direções das cargas
CarDir =[]
if ~isempty(nos) then
    Labels = ["Força em X"; "Força em Y"; "Momento em Z"];
    CarDir = evstr(x_mdialog("Direções das cargas",Labels,["%F";"%F";"%F"]))
end

if ~isempty(CarDir) & or(CarDir) then

    // Apaga as cargas nos nós selecionados eventualmente já carregados
    if ~isempty(Cargas) then
        PosJahCarregada = []
        for i=1:size(nos,"*")
            Carreg = vectorfind(Cargas.user_data(:,1:2),coord(nos(i),:),"r")
            PosJahCarregada = [PosJahCarregada Carreg]
        end
        DirJahCarregada = []
        for i=PosJahCarregada
            if or(Cargas(i).user_data(:,3)==find(CarDir)) then
            DirJahCarregada = [DirJahCarregada i]
        end
    end
    Cargas = DeleteItemInArrayStructure(DirJahCarregada,Cargas)
    HistCargas = DeleteItemInArrayStructure(DirJahCarregada,HistCargas)
end

// Escolha da função de carga
Entradas = ["(1)-Carga impulsiva constante."    ;
            "(2)-Carga triangular decrescente." ;
            "(3)-Carga triangular simetrica."   ;
            "(4)-Carga senoidal."               ;
            "(5)-Rampa até carga constante"     ]
opC = x_choose(Entradas,["Função do historico de carga:"])

if opC~=0 then
    
    // Alimentação dos parâmetros da função de carga
    Labels = ["Instante de inicio da carga (t0)"             ;
              "Intervalo de duracao da carga impulsiva (t1)" ;
              "Frequencia do carregamento senoidal (w)"      ;
              "Valor Maximo da carga (F)"                    ]
    if opC==4 then; Labels=Labels([1 3 4]); else; Labels=Labels([1 2 4]);end

        DadosCargas=evstr(x_mdialog("Dados das cargas",Labels,["0";"0.05";"2000"]))
        t0=DadosCargas(1);t1=DadosCargas(2);w1=DadosCargas(2);F=DadosCargas(3);

        if ~isempty(DadosCargas) then       
            for i=1:size(nos,"*")
                exec("ObjetoCargas.sce",-1)
            end
        end
    end
end

frame_left_estr.enable ="on"
BotoesAnalise(2:3).enable = "off"; nao_calculado = 1;
