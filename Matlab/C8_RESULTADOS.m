% RESULTADOS
% A execução deste programa assume que os seguintes já foram executados:
% C0_INIC | C1_BARRAS | C2_MAT_LOC | C3_MAT_GLOB | C4_REST_APOIO
% C5_AMORTEC  | C6_CARGAS | 
% Assim como um dos quatro programas seguintes:
% C7a_NEWMARK_CTS         | C7b_NEWMARK_ATS_BERGAN
% C7c_NEWMARK_ATS_HULBERT | C7d_NEWMARK_ATS_CINTRA

% Na primeira vez que entra nessa interface assume-se que a deformada 
% dinâmica não foi calculada, definindo as seguintes variáveis
nao_calculado = 1;   
op = 1;            

while intersect(op,[1 2 3 4 5 6 7 8 9])    
    clc
    fprintf('\n7 - RESULTADOS ============================================\n');
    fprintf('\nNúmero total de pontos calculados no histórico de resposta:');
    fprintf('\nN1 = %d\n',N1);
    fprintf('\nEscolha o resultado a ser exibido:');
    fprintf('\n(1)-Frequências naturais e taxas de amortecimento');
    fprintf('\n(2)-Resposta para todos os Graus de Liberdade');
    fprintf('\n(3)-Resposta para um Grau de Liberdade específico');
    fprintf('\n(4)-Histórico de carga para todas as cargas nodais');
    fprintf('\n(5)-Histórico de carga para uma carga nodal específica');
    fprintf('\n(6)-Histórico da variação do incremento de tempo');
    fprintf('\n(7)-Gráfico da Função de controle de Bergan e Mollestad');
    fprintf('\n(8)-Deformada dinâmica da estrutura (OBS: Demorado!)');
    fprintf('\n(9)-Deformada estática da estrutura (com carregamento estático');
    fprintf('\n    igual aos valores máximos declarados para as cargas nodais)');
    fprintf('\n\n (Digite ENTER para sair)');

    op = input('\n\n Opção = ');
    if isempty(op); op = 10; end
    fprintf('\n ==========================================================\n');

    close
    switch op
        case 1 % Exibe frequências naturais e taxas de amortecimento            
            fprintf('\nFrequencias naturais (rad/s):')
            fprintf('\nw   = '); fprintf('%12.3f',w); fprintf('\n\n');
            fprintf('\nFrequencias naturais (Hz):')
            fprintf('\nf   = '); fprintf('%12.3f',w/(2*pi)); fprintf('\n\n');
            fprintf('\nTaxas de amortecimento (%%):');
            fprintf('\ncsi   = '); fprintf('%12.3f',100*csi);fprintf('\n');
            fprintf('\n ==========================================================\n')
            fprintf('\nAperte ENTER');
            pause
        case 2 % Plota a resposta para todos graus de liberdade
            legenda = {};
            for i=1:n
                legenda = [legenda; strcat('D',int2str(GL(i)))];
            end
            fprintf('Plotar histórico da variação do incremento de tempo?')
            op2 = input('\n(1)-SIM | (2)-NÃO | Opção = ');            
            switch op2
                case 1 % Plota a resposta junto com histórico de time-steps
                    set(figure(1),'units','normalized')
                    set(figure(1),'position',[0 0 1 1]);                     
                    subplot(2,1,1);
                    plot(t,D);
                    xlim([0 T1])
                    legend(legenda);
                    grid on
                    subplot(2,1,2);
                    plot(t,Dt);
                    xlim([0 T1])
                case 2 % Plota somente a resposta
                    set(figure(1),'units','normalized')
                    set(figure(1),'position',[0.55 0.55 0.44 0.42]);                    
                    plot(t,D);
                    xlim([0 T1])
                    legend(legenda);
                    grid on
            end
        case 3 % Plota a resposta para um grau de liberdade específico
            des = GLR(1);
            while intersect(des,GLR)
                noh = input('Nº do nó = ');
                fprintf('Deslocamento a ser plotado:\n');
                fprintf('(1)-X | (2)-Y -> Translações | (3)-Z -> Rotação');                
                des = input('\n\nOpção = ');
                switch des,case 1,tipo=' DESLOCX';case 2,tipo=' DESLOCY';case 3,tipo=' ROTZ';end;
                des = 3*noh - (3-des);
                if intersect(des,GLR)
                    fprintf('\nDeslocamento Restringido, escolha outro\n\n');
                else
                    legenda = ['D',int2str(des),'- Nó ',int2str(noh),tipo];
                    fprintf('\nPlotar histórico de variação do incremento de tempo?')
                    op2 = input('\n(1)-SIM | (2)-NÃO | Opção = ');
                    switch op2                       
                        case 1
                        %Plota a resposta junto com histórico de time-steps
                            set(figure(1),'units','normalized')
                            set(figure(1),'position',[0 0 1 1]);
                            subplot(2,1,1);
                            plot(t,DJ(des,:));
                            xlim([0 T1])
                            legend(legenda);
                            grid on
                            subplot(2,1,2);
                            plot(t,Dt);
                            xlim([0 T1])                       
                        case 2
                        %Plota somente a resposta    
                            set(figure(1),'units','normalized')
                            set(figure(1),'position',[0.55 0.55 0.44 0.42]);                    
                            plot(t,DJ(des,:));
                            xlim([0 T1])
                            legend(legenda);
                            grid on
                    end
                end
            end
        case 4 % Plota o histórico de todas as cargas nodais
            legenda = {};
            GLF = [];
            for i=1:n
                if F(i)~=0
                    legenda = [legenda; strcat('P',int2str(GL(i)))];
                    GLF = [GLF ; i];
                end                   
            end
            fprintf('Plotar histórico de variação do incremento de tempo?')
            op2 = input('\n(1)-SIM | (2)-NÃO | Opção = ');
            switch op2
                case 1 % Plota as cargas junto com histórico de time-steps
                    set(figure(1),'units','normalized')
                    set(figure(1),'position',[0 0 1 1]);                     
                    subplot(2,1,1);
                    plot(t,p(GLF,:));
                    legend(legenda);
            
                    MIN = min(min(p(GLF,:)))    ; MAX = max(max(p(GLF,:)));
                    ymin = MIN - abs(MAX-MIN)/10; ymax = MAX + abs(MAX-MIN)/10;
                    axis([0 T1 ymin ymax])            
                    grid on
                    
                    subplot(2,1,2);
                    plot(t,Dt);
                    xlim([0 T1])
                case 2 % Plota as cargas somente
                    set(figure(1),'units','normalized')
                    set(figure(1),'position',[0.55 0.55 0.44 0.42]);            
                    plot(t,p(GLF,:));
                    legend(legenda);
            
                    MIN = min(min(p(GLF,:)))    ; MAX = max(max(p(GLF,:)));
                    ymin = MIN - abs(MAX-MIN)/10; ymax = MAX + abs(MAX-MIN)/10;
                    axis([0 T1 ymin ymax])            
                    grid on
            end
        case 5 % Plota o histórico de uma carga nodal específica
            des = GLR(1);
            while ~isempty(intersect(des,GLR)) || F(GL==des)==0
                noh = input('Nº do nó = ');
                fprintf('Direção correspondente da carga a ser plotada:');
                fprintf('\n(1)-X | (2)-Y -> Forças  |  (3)-Z -> Momento');
                des = input('\n\nOpção = ');
                switch des,case 1,tipo=' FX';case 2,tipo=' FY';case 3,tipo=' MZ';end;                
                des = 3*noh - (3-des);
                if intersect(des,GLR)
                    fprintf('\nDeslocamento Restringido, escolha outro\n\n');
                elseif F(GL==des)==0
                    fprintf('\nCarga Nula, escolha outra\n\n');
                else
                    legenda = ['P',int2str(des),'- Nó ',int2str(noh),tipo];
                    fprintf('\nPlotar histórico de variação do incremento de tempo?')
                    op2 = input('\n(1)-SIM | (2)-NÃO | Opção = '); 
                    switch op2                        
                        case 1
                        % Plota a carga junto com histórico de time-steps
                            set(figure(1),'units','normalized')
                            set(figure(1),'position',[0 0 1 1]);
                            subplot(2,1,1);
                            plot(t,p(GL==des,:));
                            legend(legenda);
                    
                            MIN = min(p(GL==des,:)) ; MAX = max(p(GL==des,:));
                            ymin = MIN-abs(MAX-MIN)/10; ymax = MAX+abs(MAX-MIN)/10;
                            axis([0 T1 ymin ymax])                    
                            grid on
                            
                            subplot(2,1,2);
                            plot(t,Dt);
                            xlim([0 T1])                        
                        case 2         
                        % Plota a carga somente
                            set(figure(1),'units','normalized')
                            set(figure(1),'position',[0.55 0.55 0.44 0.42]);                    
                            plot(t,p(GL==des,:));
                            legend(legenda);
                    
                            MIN = min(p(GL==des,:)) ; MAX = max(p(GL==des,:));
                            ymin = MIN-abs(MAX-MIN)/10; ymax = MAX+abs(MAX-MIN)/10;
                            axis([0 T1 ymin ymax])                    
                            grid on
                    end
                end
            end
        case 6 % Plota histórico de time-steps
            set(figure(1),'units','normalized')
            set(figure(1),'position',[0.55 0.55 0.44 0.42]);            
            plot(t,Dt);
            xlim([0 T1])
        case 7 % Plota gráfico da função de controle de Bergan e Mollestad
               % Só funciona se tiver sido usado o algoritmo de Bergan
            xx = 0:0.001:CSIm+0.5;
            for i=1:length(xx)
                yy(i) = f(xx(i),CSIp,CSIm);
            end
            set(figure(1),'units','normalized')
            set(figure(1),'position',[0.55 0.55 0.44 0.42]);             
            plot(xx,yy);
            axis([0 CSIm+0.5 0 CSIm+0.5]);
            grid on
        case 8 % Exibe um vídeo da deformada dinâmica do pórtico          
            if nao_calculado
            % A deformada é calculada somente no caso em que já não tenha 
            % sido, pois esse processo (esse loop) é muito demorado
                set(figure(2),'WindowStyle','docked')            
                loading = barh(m*N1/40,0,m*N1/20); 
                axis equal;
                axis([0 m*N1 0 m*N1/20]);
                title('LOADING'); 
                
                DX = zeros(np,m,N1);
                DY = zeros(np,m,N1);
                CDX = zeros(np,m,N1);
                CDY = zeros(np,m,N1);
                d = zeros(6,1);                          
            
                for i=1:m
                    N_ = subs(MN,L,Lx(i));  
                    R2 = [c(i) -s(i);
                          s(i)  c(i)];                                        
                    DxL = Lx(i)/(np-1);              
                    for k=1:N1                
                        for j=1:6
                            d(j) = DJ(Des(i,j),k);
                        end
                   % O vetor 'd' é colocado em coordenadas nos eixos
                   % locais, usando a equação XXX
                        d = Rt(:,:,i)*d;
                   % O campo de deslocamentos em eixos locais é obtido
                   % usando a equação XXX                                            
                        fi = N_*d;
                   % A deformada é obtida para np pontos ao longo da barra   
                        xL = 0; 
                        for j=1:np
                            des = subs(fi,x,xL);
                            xL = xL + DxL;
                            % Mudança de base executada com a equação XXX
                            des = R2*des;
                            DX(j,i,k) = des(1);
                            DY(j,i,k) = des(2);
                        end                    
                        set(loading,'YData',(i-1)*N1+k)
                        drawnow                     
                    end               
                end                
            end

            % Informa que a deformada dinâmica já foi calculada ao menos
            % uma vez e delcara o fator de escala da deformada
            nao_calculado = 0;
            fs = input('Fator de escala = ');
            
            % Calcula as coordenadas da deformada para todos os instantes
            for k=1:N1
                CDX(:,:,k) = CX + fs*DX(:,:,k);
                CDY(:,:,k) = CY + fs*DY(:,:,k);
            end
            
            tempo = T1; % Tempo que se pretende rolar o filme
            set(figure(1),'units','normalized')
            set(figure(1),'position',[0.55 0.55 0.44 0.42]);            
            figure(1)
            deform = plot(CX(:,:),CY(:,:),'b',CDX(:,:,1),CDY(:,:,1),'r');
            axis equal
            xmin = min(min(min(CDX)))-1 ; xmax = max(max(max(CDX)))+1;
            ymin = min(min(min(CDY)))-1 ; ymax = max(max(max(CDY)))+1;
            axis([xmin xmax ymin ymax])            
            for k=1:N1
                for i=1:m
                    set(deform(m+i),'XData',CDX(:,i,k),'YData',CDY(:,i,k));
                end    
                drawnow
                pause(tempo/N1);
            end                     
        case 9
        % Exibe a deformada estática da estrutura considerando F (valores 
        % máximos para as cargas nodais) como carregamento estático  
            DJE = zeros(3*nj,1);  
            DE = K\F;      % Solução estática para os graus de liberdade      
            DJE(GL) = DE;  % Deslocamentos globais     

            DEX = zeros(np,m);
            DEY = zeros(np,m);
            d = zeros(6,1);
            for i=1:m
                N_ = subs(MN,L,Lx(i));
                R2 = [c(i) -s(i);
                      s(i)  c(i)];
                DxL = Lx(i)/(np-1);                
                for j=1:6
                    d(j) = DJE(Des(i,j));
                end
              % O vetor 'd' é colocado em coordenadas nos eixos locais,
              % usando a equação XXX                
                d = Rt(:,:,i)*d;
              % O campo de deslocamentos em eixos locais é obtido
              % usando a equação XXX 
                fi = N_*d;
              % A deformada é obtida para np pontos ao longo da barra                
                xL = 0;
                for j=1:np
                    des = subs(fi,x,xL);
                    xL = xL + DxL;
                    % Mudança de base executada com a equação XXX
                    des = R2*des;
                    DEX(j,i) = des(1);
                    DEY(j,i) = des(2);
                end
            end
            
            % Delcara o fator de escala da deformada
            fs = input('Fator de escala = ');
            
            % Calcula as coordenadas da deformada
            CDEX = CX + fs*DEX;
            CDEY = CY + fs*DEY;

            set(figure(1),'units','normalized')
            set(figure(1),'position',[0.55 0.55 0.44 0.42]);            
            plot(CX(:,:),CY(:,:),'b',CDEX(:,:),CDEY(:,:),'r')
            axis equal
            xmin = min(min(CDEX))-1 ; xmax = max(max(CDEX))+1;
            ymin = min(min(CDEY))-1 ; ymax = max(max(CDEY))+1;
            axis([xmin xmax ymin ymax])           
    end       
end
fprintf('FIM DO PROGRAMA\n\n');