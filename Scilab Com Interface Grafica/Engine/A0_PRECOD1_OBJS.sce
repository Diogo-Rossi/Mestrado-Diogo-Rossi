// CRIAR FUNÇÕES DE OBJETO

// Função que cria um objeto do tipo "FuncName", i.e., figure, uicontrol, etc...
// com campos de propriedade definidos na estrutura "PropStruc", cujo nomes
// dos campos devem ser os mesmos nomes das propriedades do objeto
function obj = CriarObjeto(FuncName,PropStruc)
    PropNam = """" + fieldnames(PropStruc) + """"
    PropVal = "PropStruc."+fieldnames(PropStruc)
    PropStr = strcat(PropNam + "," + PropVal,",")
    if isempty(PropStr) then
        PropStr = ""
    end
    obj = evstr(FuncName + "(" + PropStr + ");");
endfunction

// Função que cria uicontrol do estilo 'ControlName' e propriedades de PropStruc
// Usando a função acima
function controle = CriarUicontrol(ControlName,PropStruc)
    PropStruc.style = ControlName                        
    controle = CriarObjeto("uicontrol",PropStruc)        
endfunction  
