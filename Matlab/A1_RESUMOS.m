% PROGRAMA PRINCIPAL

% Subrotinas iniciais comuns a todos os programas
C0_INIC
C1_BARRAS
C2_MAT_LOC
C3_MAT_GLOB
C4_REST_APOIO
C5_AMORTEC
C6_CARGAS

graf = 55;



% Subrotinas finais para algoritmo A
C7a_NEWMARK_CTS
C8_RESULTADOS
fid=fopen('t.txt','w'); fprintf(fid,'%1.30f\r\n',t');          fclose(fid);
fid=fopen('D.txt','w'); fprintf(fid,'%1.30f\r\n',DJ(graf,:)'); fclose(fid);
fid=fopen('Dt.txt','w');fprintf(fid,'%1.30f\r\n',Dt');         fclose(fid);
fid=fopen('N1.txt','w');fprintf(fid,'%d\n',N1);                fclose(fid);

% Subrotinas finais para algoritmo B
C7b_NEWMARK_ATS_BERGAN
C8_RESULTADOS
plot(t,Dt,t,lambda*T)
fid=fopen('t_BERGAN.txt','w'); fprintf(fid,'%1.30f\r\n',t');          fclose(fid);
fid=fopen('D_BERGAN.txt','w'); fprintf(fid,'%1.30f\r\n',DJ(graf,:)'); fclose(fid);
fid=fopen('Dt_BERGAN.txt','w');fprintf(fid,'%1.30f\r\n',Dt');         fclose(fid);
fid=fopen('N1_BERGAN.txt','w');fprintf(fid,'%d\n',N1);                fclose(fid);
fid=fopen('T.txt','w');        fprintf(fid,'%1.30f\r\n',T');          fclose(fid);
fid=fopen('Dt_lambda.txt','w');fprintf(fid,'%d\n',(Dt')/lambda);      fclose(fid);

% Subrotinas finais para algoritmo C
C7c_NEWMARK_ATS_HULBERT
C8_RESULTADOS
plot(t,sqrt(dot(e,e,1)))
fid=fopen('t_HULBERT.txt','w'); fprintf(fid,'%1.30f\r\n',t');          fclose(fid);
fid=fopen('D_HULBERT.txt','w'); fprintf(fid,'%1.30f\r\n',DJ(graf,:)'); fclose(fid);
fid=fopen('Dt_HULBERT.txt','w');fprintf(fid,'%1.30f\r\n',Dt');         fclose(fid);
fid=fopen('N1_HULBERT.txt','w');fprintf(fid,'%d\n',N1);                fclose(fid);
fid=fopen('RL.txt','w');        fprintf(fid,'%1.30f\r\n',RL');         fclose(fid);
fid=fopen('e.txt','w');fprintf(fid,'%d\n',sqrt(dot(e,e,1))');          fclose(fid);

% Subrotinas finais para algoritmo D
C7d_NEWMARK_ATS_CINTRA
C8_RESULTADOS
plot(t,kapa,t,kapaReg)
fid=fopen('t_CINTRA.txt','w'); fprintf(fid,'%1.30f\r\n',t');          fclose(fid);
fid=fopen('D_CINTRA.txt','w'); fprintf(fid,'%1.30f\r\n',DJ(graf,:)'); fclose(fid);
fid=fopen('Dt_CINTRA.txt','w');fprintf(fid,'%1.30f\r\n',Dt');         fclose(fid);
fid=fopen('N1_CINTRA.txt','w');fprintf(fid,'%d\n',N1);                fclose(fid);
fid=fopen('kapa.txt','w');        fprintf(fid,'%1.30f\r\n',kapa');    fclose(fid);
fid=fopen('kapaReg.txt','w');fprintf(fid,'%d\n',kapaReg');            fclose(fid);
