function [x] = palindrome()
  num = 0;
  out = 0;
  bound = 100;
  i = 999;
  count = 0;
  while i > bound
    for j = 999:-1:i
    count++;
      if (i * j) == str2num(fliplr(num2str(i * j)))
         num = (i * j);
         if num > out
            out = num;
            bound = out/999;
         end
      end
    end
    i = (i - 1);
  end
  x = out;
end