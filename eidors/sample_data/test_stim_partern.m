options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options,1);
mat = zeros(16,16);
for i = 1:16
  x = (i-1)*16 + 1;
  y = (i)*16;
  mat(i,:)= A(x:y);
end
mat

##mat = zeros(16,16);
##
##k = 1;
##
##for i = 1:16
##  for j = 1: 16
##    mat(i,j) = k;
##    k = k+1;
##  endfor
##  endfor
##mat