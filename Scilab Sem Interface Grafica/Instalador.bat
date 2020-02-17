:: MESTRADO ANALISE DINAMICA
:: VERSAO SEM INTERFACE GRAFICAS

:: Desabilita o ECHO dos comandos
@echo off

:: Formata tamanho do CMD
mode con: cols=200 lines=55

:: Define os nomes dos arquivos:
:: - Fonte da Subrotina principal
:: - De execucao do programa 
:: - Mascara do executavel do software
:: - Terminacao do executavel do software
set RotinaPrincipal=C0_INIC.sce
set ArquivoExecutor=Analise_Dinamica_Estruturas_Prompt.bat
set MascaraSoftware=C:\WScilex-cli.exe
set TerminacaoSoftware=scilab-6.0.2\bin\WScilex-cli.exe

:: Informa mensagens no prompt
echo Criando executavel do programa . . .
echo Isto pode demorar um pouco . . .
echo --------------------------------
echo Procurando arquivo do software . . .
echo[

:: Cria uma lista de enderecos de arquivos que tem a terminacao com a mascara
:: do executavel do software e grava essa lista no arquivo de texto "lista.txt"
:: OBS: /b usa formatação básica (sem informações de cabeçalho ou resumo).
::      /s exibe os arquivos no diretorio especificado e subdiretorios
:: Primeiro exibe na tela, depois grava no arquivo
dir %MascaraSoftware% /b /s
echo --------------------------------
dir %MascaraSoftware% /b /s > lista.txt

:: Executa um comando para cada arquivo no conjunto (lista.txt) (somente um)
:: O arquivo é aberto, lido e quebrado em linhas individuais de texto e analisado para os tokens
:: Por padrão, /F transfere o primeiro token separado por espaço de cada linha (ignora linhas em branco)
:: É possível substituir o comportamento padrão especificando "opções" opcionais: Esta é uma cadeia de
:: caracteres entre aspas que contém uma ou mais palavras-chave. A palavra chave "tokens" especifica
:: quais tokens serao usados na linha onde o asterisco pega o texto restante da linha (toda, no caso abaixo)
:: Em cada loop deste FOR, é executado o comando 'call :subrotina "%%i"' que chama o procedimento com rótulo
:: nomeado ':subrotina' e parametro "%%i"
for /F "tokens=*" %%i in (lista.txt) do call :subrotina "%%i"

:: Vai para o rotulo 'end'
goto end

:: --------------------------------------------------------------------------------------------------
:subrotina
:: Armazena o valor do primeiro parametro da subrotina (i.e. "%%i") na variavel %linha%
:: Este parametro é a linha atual do arquivo lido
set linha=%1

:: Caso os ultimos caracteres da variavel %linha% sejam iguais à terminacao do executavel
:: do software %TerminacaoSoftware%, armazena esta linha na variavel %ExecutavelSoftware%
:: OBS: o comando :~X pega os X primeiros caracteres da variavel, e :~-X pega os X ultimos
:: (https://stackoverflow.com/questions/636381/what-is-the-best-way-to-do-a-substring-in-a-batch-file)
:: Deve substituir o valor de X pelo comprimento da variavel %TerminacaoSoftware% + 1 (aspa final conta)
:: É necessario colocar aspas antes de %linha pois a aspa inicial original não entra depois do comando :~-X
:: É necessario colocar aspas em %TerminacaoSoftware% para fazer a comparacao (inicialmente nao há aspas)
if "%linha:~-33%=="%TerminacaoSoftware%" (set ExecutavelSoftware=%linha%)

:: Vai para o final deste arquivo, para fechar o loop sem executar os comandos mais abaixo
goto :eof
:: --------------------------------------------------------------------------------------------------

:end
::Customizado para o Scilab 6.0.0

:: Exclui o arquivo "lista.txt"
del lista.txt

:: Verifica se foi encontrao o arquivo do software
if not defined ExecutavelSoftware (
echo Nao foi encontrado o arquivo do software no local %TerminacaoSoftware%
echo[
echo Necessario ter instalado o %TerminacaoSoftware%
echo[
echo[
goto :pausafinal
)

:: Escreve no arquivo %ArquivoExecutor% a linha de comando abaixo, usando as variaveis do Executavel e da Rotina
:: Obs: este executa o programa com a janela maximizada. O de baixo executaria com a janela minimizada
echo @call start /max "" %ExecutavelSoftware% -e "chdir(\"Engine\");exec(\"%RotinaPrincipal%\",-1);" > %ArquivoExecutor%
::echo @call start /min "" %ExecutavelSoftware% -e "chdir(\"Engine\");exec(\"%RotinaPrincipal%\",-1);" > %ArquivoExecutor%

:: Escreve no arquivo "ImageToolBox.bat" a linha de comando abaixo, usando a variavel do Executavel
REM echo @call %ExecutavelSoftware% -nw -e "atomsInstall(\"IPCV\");quit;" > ImageToolBox.bat

:: Excuta o arquivo "ImageToolBox.bat" que tem a linha de comando acima
REM echo Instalando Modulo de Processamento de Imagens (IPCV) . . .
REM echo[
REM @call ImageToolBox.bat

:: Exclui o arquivo "ImageToolBox.bat"
REM del ImageToolBox.bat

:: Limpa a tela e Informa mensagens no prompt
echo --------------------------------
echo Concluido
echo Para usar o programa futuramente, basta abrir o arquivo "%ArquivoExecutor%"
echo.

:pausafinal
pause