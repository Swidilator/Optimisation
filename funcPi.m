function [x] = funcPi()
  output = 0;
  denom = 1;
  flip = 1;
  count = 0;
  
  while count < 1000
    output = output + (flip/denom);
    output;
    denom = denom + 2;
    flip = flip*(-1);
    count = count + 1;
  end
  x = 4*output;
end