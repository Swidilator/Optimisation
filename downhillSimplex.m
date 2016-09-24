%f = @(a,b) (1 - a)^2 + 10*(b - a^2)^2
%xt = [-1.20, 1.00; -0.23, 1.26; -0.94, 1.97]


function x = downhillSimplex(f, m)
  A = 1;
  G = 2;
  B = 0.5;
  for z = 1:3
    Matrix = zeros(3,3);            %starter matrix_type
    Matrix(1,1:2) = m(z,1:2);          %populate with given matrix
    Matrix(2:3,1:2) = generateVertices(m,z);
    Matrix = sortMatrix(f, Matrix);  %evaluate and sort vertices
    k = 0;                          %maximum iterations
    lowPts = Matrix(1,1:3);
    %disp("Starting 'while' loop");
    while((stopCrit(Matrix) > 0.0000001) && (k < 10000))
      xRef = [0,0];                   %x', the reflection of x^h
      xRef = (((1 + A) * findCentroid(Matrix)) - A * Matrix(3,1:2)); %reflection
      xRefVal = f(xRef(1,1),xRef(1,2));
      if((Matrix(1,3) <= xRefVal) && (xRefVal <= Matrix(3,3)))
        %disp("Matrix after replacement with reflection");
        %Replace highest valued vertex with reflection
        Matrix(3,1:2) = xRef;
        Matrix = sortMatrix(f, Matrix);
      end
      
      if(xRefVal < Matrix(1,3))
        %disp("1");
        %Expand the simplex, find x''
        xExp = (G * xRef) + ((1 - G) * findCentroid(Matrix));
        xExpVal = f(xExp(1,1),xExp(1,2));
        
        if(xExpVal < Matrix(1,3))
          %disp("2");
          %Replace highest vertex with expansion
          Matrix(3,1:2) = xExp;
          Matrix = sortMatrix(f, Matrix);
        elseif(xExpVal >= Matrix(1,3))
          %disp("3");
          Matrix(3,1:2) = xRef;
          Matrix = sortMatrix(f, Matrix);
        end
        
      elseif(xRefVal > Matrix(2,3))
        %disp("4");
        %Contract Simplex by Contraction Factor
        %xCon = [0,0];
        %xConVal = 0;
        %Calculate the Contraction factor
        if(xRefVal < Matrix(3,3))
          xCon = (B * xRef) + ((1 - B) * findCentroid(Matrix));
          xConVal = f(xCon(1,1),xCon(1,2));
        elseif
          xCon = ((B * Matrix(3,1:2)) + ((1 - B) * findCentroid(Matrix)));
          xConVal = f(xCon(1,1),xCon(1,2));
        end
        
        if((xConVal < Matrix(3,3)) && (xConVal < xRefVal))
          Matrix(3,1:2) = xCon;
          Matrix = sortMatrix(f, Matrix);
        end
        
        %Shrink lengths of edges connected to lowest value
        if((xConVal >= Matrix(3,3)) && (xConVal >= xRefVal))
          for i = 2:3
            Matrix(i,1:2) = Matrix(1,1:2) + (0.5 * (Matrix(i,1:2) - Matrix(1,1:2)));
            Matrix = sortMatrix(f, FunctionMatrix);
          end
        end
      end
      lowPts = [lowPts;Matrix(1,1:3)];
      k = k + 1;
    end
    disp(" ");
    Matrix
    disp(z); disp(": coordinates of minimum: "); Matrix(1,1:2)
    disp(z); disp(": function value: "); Matrix(1,3)
    k
    
    %Plot surfacemap
    [X,Y] = meshgrid(-2:0.1:2, -2:0.1:2);
    Z = (1 - X).^2 + 10 * ((Y - X.^2).^2);
    figure
    hold on;
    surf(X,Y,Z);
    view(320,120);
    
    plot3(lowPts(:,1),lowPts(:,2),lowPts(:,3), '-r*','LineWidth',1, 'MarkerSize', 7);
  
    plot3(lowPts(end,1),lowPts(end,2),lowPts(end,3),'y','MarkerSize', 7 );
    hold off;
    
    %Plot contourmap
    figure
    [C,h] = contourf(X,Y,Z);
    clabel(C,h);
    view(0,90);
    
    hold on;
    plot3(lowPts(1:end-1,1),lowPts(1:end-1,2),lowPts(1:end-1,3), '-r*','LineWidth',1, 'MarkerSize', 7);
    plot3(lowPts(end,1),lowPts(end,2),lowPts(end,3),'v');
    hold off;
  end
  
end

%Works out the values of of the function 'f' at each vertex, and then sorts by
%function value in ascending order
function ans = sortMatrix(f, m)
  tempM = m;
  for i = 1:3
    tempM(i,3) = f(m(i,1),m(i,2));
  end
  ans = sortrows(tempM,3);
end

%This calculates the stopping critaria for the current set of vertices
function ans2 = stopCrit(m)
  meanVal = mean(m(:,3));
  totalVal = 0;
  for i = 1:3
    t = m(i,3) - meanVal;
    totalVal = totalVal + t.^2;
  end
  
  ans2 = sqrt((1/3)*totalVal);
end

%This, as the name says, finds the centroid of the other two points
function ans3 = findCentroid(m)
  x = [0,0];
  for i = 1:2
    x = x + m(i,1:2);
  end
  ans3 = (1/2)*x;
end

%This extrapolates the other two vertices using the selected vertex, then
%outputs a 2x2 matrix that can be simply bolted into Matrix
function ans4 = generateVertices(m, n)
  x = zeros(2);
  count = 1;
  for i = 1:3
    if(i ~= n)
      x1t = m(i,1) - m(n,1);
      y1t = m(i,2) - m(n,2);
      dist = sqrt(x1t.^2 + y1t.^2);
      x(count,1) = m(n,1) + ((0.1) * x1t/dist);
      x(count,2) = m(n,2) + ((0.1) * y1t/dist);
      count++;
    end
  end
  ans4 = x;
end














