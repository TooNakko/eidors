
function mat = convert_928 (A)
  mat = zeros(1024,1);
  disp("A cuối:\n");
  disp(A(end));
  count = 0 + 1 
  A_idx = 0 + 1
  i = 0 + 1
  for i = 2 + 1:31
    mat(i) = A(A_idx);
    A_idx = A_idx + 1;
  end
  i = i + 5;
  while true
      if count <= 30
        mat(i) = A(A_idx);
        A_idx = A_idx + 1;
        count = count + 1;
        i = i + 1;
      else
        count = 0 + 1;
        i = i + 3;
      end
      if i == 32*31 +1
        break;
      end
  end
  disp("A_idx = ");
  disp(A_idx);
  for i = (32*31 + 2):(32*32-2)
    mat(i) = A(A_idx);
    A_idx = A_idx + 1;
  end
  
end
