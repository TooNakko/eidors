
function mat = convert_256 (A, meas_select)
  mat = zeros(256,1)
  j = 1;
  for i = 1:16
    x = (i-1)*16 + 1;
    y = (i)*16;
    j = 1+i;
    n = 0;
    for l = x:y
      if meas_select(l) == 1
        m = (i-1)*13 + 1;
        n = n + 1;
        mat(l) = A(m+mod(j,13));
        j = j + 1;
      else
         n = n +1;
         mat(l)= 0;
      end
    end
  end
endfunction
