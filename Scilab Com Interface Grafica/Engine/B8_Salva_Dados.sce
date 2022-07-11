Arquivo = uiputfile(["*.dinam","Arquivos de Análise Dinâmica"], ...
                    fileparts(pwd()),"Salvar dados da análise");
if ~isempty(Arquivo) then
    [Path,Name,Extension] = fileparts(Arquivo);
    Arquivo = Path + Name + ".dinam"
    
    EditBoxData = []
    
    Campos = {MaterialData SectionData DampingData NewmarkBeta DeltaT_CTS ATS_Bergan ATS_Hulbert ATS_Cintra}

    k=1
    for i=1:size(Campos,"*")
        for j=1:size(Campos{i},"*")
            EditBoxData(k) = Campos{i}(j).string
            k=k+1
        end
    end
    
    if ~isempty(EditBoxData); 
        save(Arquivo, "EditBoxData","-append")
    end

    if ~isempty(Barras); 
        BarrasData = Barras.data;
        save(Arquivo, "BarrasData","-append")
    end 
    
    if ~isempty(Barras); 
        BarrasData = Barras.data;
        save(Arquivo, "BarrasData","-append")
    end
    if ~isempty(Cargas);
        CargasData = Cargas.user_data;
        save(Arquivo, "CargasData","-append")
    end
    if ~isempty(Restricoes); 
        ApoiosData = {Restricoes.data Restricoes.user_data};
        save(Arquivo, "ApoiosData","-append")
    end 
end
