function cp = bisec_cp(f,a,b)
A = a;
B = b;
C = 1;

  while(~(f(C) < 0.00000001 && f(C) > -0.00000001))
    C = (A + B)/2;
    if(f(C) > 0)
      A = C;
    elseif(f(C) < 0)
      B = C
    end
  end 
  
  cp = C;
end
