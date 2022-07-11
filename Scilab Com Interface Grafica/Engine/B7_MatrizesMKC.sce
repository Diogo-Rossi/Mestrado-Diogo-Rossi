
if max(size(M))>13 then
    editvar(["M" "K" "C"](Opcao));
    BotoesAnalise(2:3).enable = "off"
    BotoesMatrizes(3).enable = "off"
    for i=1:3; frequencias(i).string = ""; end;
else
    Rot = ["Matriz M" "Matriz K" "Matriz C"];
    Mat = list(M,K,C);
    Temp = x_mdialog(Rot(Opcao),string([1:n]),string([1:n]),string(Mat(Opcao)));
    if ~isempty(Temp) then
        select Opcao
            case 1
                M = evstr(Temp);
            case 2
                K = evstr(Temp);
            case 3
                C = evstr(Temp);
        end
        BotoesAnalise(2:3).enable = "off"
        BotoesMatrizes(3).enable = "off"
        for i=1:3; frequencias(i).string = ""; end;
    end
end

