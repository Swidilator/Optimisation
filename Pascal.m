function [x] = Pascal(n)
 Matrix = zeros(n,n);
  
 for i = 1:n
  for j = 1:n
    if(j == 1)
      Matrix(i,1) = 1;
    
    elseif i > 1
      Matrix(i,j) = Matrix(i -1,j) + Matrix(i -1, j - 1);   
    end
  end
 end

 x = Matrix;

 end