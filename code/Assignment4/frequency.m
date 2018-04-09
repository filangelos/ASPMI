function fi = frequency(n)
    
    if n <= 500
        fi = 100; 
    elseif n <= 1000
        fi = 100 + (n - 500) / 2;
    elseif n <= 1500
        fi = 100 + ((n - 1000) / 25)^2;
    else
        fi = 0;
    end

end