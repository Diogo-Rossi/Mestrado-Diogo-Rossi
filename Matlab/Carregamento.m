function p = Carregamento(n,nc,opC,desC,t0,t1,w1,F,t)

p = zeros(n,1);

for i=1:nc
    switch opC(i)
        case 1            
            if t < t0(i)
                p(desC(i)) = 0;
            elseif t <= t0(i)+t1(i)
                p(desC(i)) = F(desC(i));
            else
                p(desC(i)) = 0; 
            end
        case 2
            slope = F(desC(i))/t1(i);
            if t < t0(i)           
                p(desC(i)) = 0; 
            elseif t <= t0(i)+t1(i)
                p(desC(i)) = F(desC(i)) - slope*(t-t0(i));           
            else
                p(desC(i)) = 0;                
            end
        case 3            
            slope = F(desC(i))/(t1(i)/2);
            if t < t0(i)           
                p(desC(i)) = 0; 
            elseif t <= t0(i)+t1(i)/2
                p(desC(i)) = slope*(t-t0(i));           
            elseif t <= t0(i)+t1(i)
                p(desC(i)) = F(desC(i)) - slope*(t-(t0(i)+t1(i)/2));
            else
                p(desC(i)) = 0;
            end           
        case 4
            p(desC(i)) = F(desC(i))*sin(w1(i)*t);             
    end
end

end