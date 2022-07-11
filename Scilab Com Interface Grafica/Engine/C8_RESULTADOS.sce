// RESULTADOS
// A execução deste programa assume que os seguintes já foram executados:
// C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO
// C5_AMORTEC  | C6_CARGAS | 
// Assim como um dos quatro programas seguintes:
// C7a_NEWMARK_CTS         | C7b_NEWMARK_ATS_BERGAN
// C7c_NEWMARK_ATS_HULBERT | C7d_NEWMARK_ATS_CINTRA

// Na primeira vez que entra nessa interface assume-se que a deformada 
// dinâmica não foi calculada, definindo as seguintes variáveis
nao_calculado = 1;   
op = 1;            

while intersect(op,[1 2 3 4 5 6 7 8 9])    
    clc
    mprintf('\n7 - RESULTADOS ============================================\n');
    mprintf('\nNumero total de pontos calculados no historico de resposta:');
    mprintf('\nN1 = %d\n',N1);
    mprintf('\nEscolha o resultado a ser exibido:');
    mprintf('\n(1)-Frequencias naturais e taxas de amortecimento');
    mprintf('\n(2)-Resposta para todos os Graus de Liberdade');
    mprintf('\n(3)-Resposta para um Grau de Liberdade especifico');
    mprintf('\n(4)-Historico de carga para todas as cargas nodais');
    mprintf('\n(5)-Historico de carga para uma carga nodal especifica');
    mprintf('\n(6)-Historico da variacao do incremento de tempo');
    mprintf('\n(7)-Grafico da Funcao de controle de Bergan e Mollestad');
    mprintf('\n(8)-Deformada dinamica da estrutura (OBS: Talvez demorado)');
    mprintf('\n(9)-Deformada estatica da estrutura (com carregamento estatico');
    mprintf('\n    igual aos valores maximos declarados para as cargas nodais)');
    mprintf('\n\n (Digite ENTER para sair)');

    op = input('Opcao = ');
    if isempty(op); op = 10; end
    mprintf('\n ==========================================================\n');

    close
    switch op
        case 1 // Exibe frequências naturais e taxas de amortecimento            
            mprintf('\nFrequencias naturais (rad/s):')
            mprintf('\nw   = '); mprintf('%12.3f',w); mprintf('\n\n');
            mprintf('\nFrequencias naturais (Hz):')
            mprintf('\nf   = '); mprintf('%12.3f',w/(2*%pi)); mprintf('\n\n');
            mprintf('\nTaxas de amortecimento (%%):',0);
            mprintf('\ncsi   = '); mprintf('%12.3f',100*csi);mprintf('\n');
            mprintf('\n ==========================================================\n')
            halt('Aperte ENTER');            
        case 2 // Plota a resposta para todos graus de liberdade
            legenda = [];
            for i=1:n
                legenda = [legenda ; 'D' + string(GL(i))];
            end
            mprintf('Plotar historico da variacao do incremento de tempo?')
            op2 = input('(1)-SIM | (2)-NAO | Opcao = ');           
            switch op2
                case 1 // Plota a resposta junto com histórico de time-steps
                    subplot(2,1,1);
                    plot(t,D);
                    gca().data_bounds([1 2])=[0 T1]
                    legend(legenda);
                    subplot(2,1,2);
                    plot(t,Dt);
                    gca().data_bounds([1 2])=[0 T1]
                case 2 // Plota somente a resposta
                    plot(t,D);
                    gca().data_bounds([1 2])=[0 T1]
                    legend(legenda);
            end
        case 3 // Plota a resposta para um grau de liberdade específico
            des = GLR(1);
            while intersect(des,GLR)
                noh = input('Numero do noh = ');
                mprintf('Deslocamento a ser plotado:\n');
                mprintf('(1)-X | (2)-Y -> Translacoes | (3)-Z -> Rotacao');                
                des = input('Opcao = ');
                switch des,case 1,tipo=' DESLOCX';case 2,tipo=' DESLOCY';case 3,tipo=' ROTZ';end;
                des = 3*noh - (3-des);
                if intersect(des,GLR)
                    mprintf('\nDeslocamento Restringido, escolha outro\n\n');
                else
                    legenda = strcat(['D',string(des),'- Noh ',string(noh),tipo]);
                    mprintf('\nPlotar historico de variacao do incremento de tempo?')
                    op2 = input('(1)-SIM | (2)-NAO | Opcao = ');
                    switch op2                       
                        case 1
                        //Plota a resposta junto com histórico de time-steps
                            subplot(2,1,1);
                            plot(t,DJ(des,:));
                            gca().data_bounds([1 2])=[0 T1]
                            legend(legenda);
                            subplot(2,1,2);
                            plot(t,Dt);
                            gca().data_bounds([1 2])=[0 T1]
                        case 2
                        //Plota somente a resposta                        
                            plot(t,DJ(des,:));
                            gca().data_bounds([1 2])=[0 T1]
                            legend(legenda);
                    end
                end
            end
        case 4 // Plota o histórico de todas as cargas nodais
            legenda = [];
            GLF = [];
            for i=1:n
                if F(i)~=0
                    legenda = [legenda; strcat(['P',string(GL(i))])];
                    GLF = [GLF ; i];
                end                   
            end
            mprintf('Plotar historico de variacao do incremento de tempo?')
            op2 = input('(1)-SIM | (2)-NAO | Opcao = ');
            switch op2
                case 1 // Plota as cargas junto com histórico de time-steps
                    subplot(2,1,1);
                    plot(t,p(GLF,:));
                    legend(legenda);
            
                    MIN = min(min(p(GLF,:)))    ; MAX = max(max(p(GLF,:)));
                    ymin = MIN - abs(MAX-MIN)/10; ymax = MAX + abs(MAX-MIN)/10;
                    gca().data_bounds = [0 T1 ymin ymax]
                    
                    subplot(2,1,2);
                    plot(t,Dt);
                    gca().data_bounds([1 2])=[0 T1]
                case 2 // Plota as cargas somente          
                    plot(t,p(GLF,:));
                    legend(legenda);
            
                    MIN = min(min(p(GLF,:)))    ; MAX = max(max(p(GLF,:)));
                    ymin = MIN - abs(MAX-MIN)/10; ymax = MAX + abs(MAX-MIN)/10;
                    gca().data_bounds = [0 T1 ymin ymax]            
            end
        case 5 // Plota o histórico de uma carga nodal específica
            des = GLR(1);
            while ~isempty(intersect(des,GLR)) || F(GL==des)==0
                noh = input('Numero do noh = ');
                mprintf('Direcao correspondente da carga a ser plotada:');
                mprintf('\n(1)-X | (2)-Y -> Forcas  |  (3)-Z -> Momento');
                des = input('Opcao = ');
                switch des,case 1,tipo=' FX';case 2,tipo=' FY';case 3,tipo=' MZ';end;                
                des = 3*noh - (3-des);
                if intersect(des,GLR)
                    mprintf('\nDeslocamento Restringido, escolha outro\n\n');
                elseif F(GL==des)==0
                    mprintf('\nCarga Nula, escolha outra\n\n');
                else
                    legenda = strcat(['P',string(des),'- Noh ',string(noh),tipo]);
                    mprintf('\nPlotar historico de variacao do incremento de tempo?')
                    op2 = input('(1)-SIM | (2)-NAO | Opcao = '); 
                    switch op2                        
                        case 1
                        // Plota a carga junto com histórico de time-steps
                            subplot(2,1,1);
                            plot(t,p(GL==des,:));
                            legend(legenda);
                    
                            MIN = min(p(GL==des,:)) ; MAX = max(p(GL==des,:));
                            ymin = MIN-abs(MAX-MIN)/10; ymax = MAX+abs(MAX-MIN)/10;
                            gca().data_bounds = [0 T1 ymin ymax]
                            
                            subplot(2,1,2);
                            plot(t,Dt);

                            gca().data_bounds([1 2]) = [0 T1]
                        case 2         
                        // Plota a carga somente                   
                            plot(t,p(GL==des,:));
                            legend(legenda);
                    
                            MIN = min(p(GL==des,:)) ; MAX = max(p(GL==des,:));
                            ymin = MIN-abs(MAX-MIN)/10; ymax = MAX+abs(MAX-MIN)/10;
                            gca().data_bounds = [0 T1 ymin ymax]                    
                    end
                end
            end
        case 6 // Plota histórico de time-steps           
            plot(t,Dt);
            gca().data_bounds = [0 T1 0 2*max(Dt)]
        case 7 // Plota gráfico da função de controle de Bergan e Mollestad
               // Só funciona se tiver sido usado o algoritmo de Bergan
            xx = 0:0.001:CSIm+0.5;
            for i=1:length(xx)
                yy(i) = f(xx(i),CSIp,CSIm);
            end         
            plot(xx,yy);
            gca().data_bounds = [0 CSIm+0.5 0 CSIm+0.5];
        case 8 // Exibe um vídeo da deformada dinâmica do pórtico          
            if nao_calculado
            // A deformada é calculada somente no caso em que já não tenha 
            // sido, pois esse processo (esse loop) é muito demorado                
                DX = zeros(np,m,N1);
                DY = zeros(np,m,N1);
                CDX = zeros(np,m,N1);
                CDY = zeros(np,m,N1);
                d = zeros(6,1);                          
            
                for i=1:m
                    N = MN(Lx(i));  
                    R2 = [c(i) -s(i);
                          s(i)  c(i)];                                        
                    DxL = Lx(i)/(np-1);              
                    for k=1:N1                
                        for j=1:6
                            d(j) = DJ(Des(i,j),k);
                        end
                        // O vetor 'd' é colocado em coordenadas nos eixos
                        // locais, usando a equação XXX
                        d = Rt(:,:,i)*d;
                        // O campo de deslocamentos em eixos locais é obtido
                        // usando a equação XXX                                            
                        fi = N*d;
                        // A deformada é obtida para np pontos ao longo da barra   
                        xL = 0; 
                        for j=1:np
                            des = horner(fi,xL);
                            xL = xL + DxL;
                            // Mudança de base executada com a equação XXX
                            des = R2*des;
                            DX(j,i,k) = des(1);
                            DY(j,i,k) = des(2);
                        end                                        
                    end               
                end                
            end

            // Informa que a deformada dinâmica já foi calculada ao menos
            // uma vez e delcara o fator de escala da deformada
            nao_calculado = 0;
            fs = input('Fator de escala = ');
            
            // Calcula as coordenadas da deformada para todos os instantes
            for k=1:N1
                CDX(:,:,k) = CX + fs*DX(:,:,k);
                CDY(:,:,k) = CY + fs*DY(:,:,k);
            end
            
            tempo = input('Tempo do filme (segundos) = '); // Tempo que se pretende rolar
            plot(CX(:,:),CY(:,:),'b',CDX(:,:,1),CDY(:,:,1),'r');
            deform = gce().children
            isoview on
            xmin = min(min(min(CDX)))-1 ; xmax = max(max(max(CDX)))+1;
            ymin = min(min(min(CDY)))-1 ; ymax = max(max(max(CDY)))+1;
            gca().data_bounds = [xmin xmax ymin ymax]
            for k=1:N1
                for i=1:m
                    deform(m+i).data = [CDX(:,i,k),CDY(:,i,k)];
                end    
                sleep(tempo/N1,"s");
            end                     
        case 9// Exibe a deformada estática da estrutura considerando F (valores 
              // máximos para as cargas nodais) como carregamento estático  
            DJE = zeros(3*nj,1);  
            DE = K\F;      // Solução estática para os graus de liberdade      
            DJE(GL) = DE;  // Deslocamentos globais     

            DEX = zeros(np,m);
            DEY = zeros(np,m);
            d = zeros(6,1);
            for i=1:m
                N = MN(Lx(i));
                R2 = [c(i) -s(i);
                      s(i)  c(i)];
                DxL = Lx(i)/(np-1);                
                for j=1:6
                    d(j) = DJE(Des(i,j));
                end
                // O vetor 'd' é colocado em coordenadas nos eixos locais,
                // usando a equação XXX                
                d = Rt(:,:,i)*d;
                // O campo de deslocamentos em eixos locais é obtido
                // usando a equação XXX 
                fi = N*d;
                // A deformada é obtida para np pontos ao longo da barra                
                xL = 0;
                for j=1:np
                    des = horner(fi,xL);
                    xL = xL + DxL;
                    // Mudança de base executada com a equação XXX
                    des = R2*des;
                    DEX(j,i) = des(1);
                    DEY(j,i) = des(2);
                end
            end
            
            // Delcara o fator de escala da deformada
            fs = input('Fator de escala = ');
            
            // Calcula as coordenadas da deformada
            CDEX = CX + fs*DEX;
            CDEY = CY + fs*DEY;

            plot(CX(:,:),CY(:,:),'b',CDEX(:,:),CDEY(:,:),'r')
            isoview on;
            xmin = min(min(CDEX))-1 ; xmax = max(max(CDEX))+1;
            ymin = min(min(CDEY))-1 ; ymax = max(max(CDEY))+1;
            gca().data_bounds = [xmin xmax ymin ymax]
    end       
end
mprintf('FIM DO PROGRAMA\n\n');
respFinal = input("Deseja fechar o Scilab? (1)-Sim, (2)-Nao, Resposta = ");
if respFinal==1; exit; end
