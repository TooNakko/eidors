formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('obj.txt','r');            %Doc du lieu object tu file obj.txt
C = fscanf(fileID,formatSpec,[208 100]);

fileID1 = fopen('ref.txt','r');           %Doc du lieu reference tu file ref.txt
B = fscanf(fileID1,formatSpec); 


##%%Chuyen doi tu dang 208 sang 256
##A = zeros(256,size(C)(2));
##for i = 1: size(C)(2)
##  A(:,i)= convert_new(C(:,i));
##end
####A(:,2)= convert_new(C(:,2));
##B = convert_new(B);

fileID2 = fopen('simdata.txt','w');

fprintf(fileID2,'magnitudes : ');
formatSpec2 = '%f,';
fprintf(fileID2,formatSpec2,B);
fprintf(fileID2,'\nmagnitudes : ');
fprintf(fileID2,formatSpec2,C);
fclose(fileID2);


##A = zeros(208,1);
##fileID2 = fopen('simdata.txt','w');
##for i = 1: size(B)(2)
##    A = B(:,i);
##  
##  fprintf(fileID2,'\nmagnitudes : ');
##  formatSpec2 = '%f,';
##  fprintf(fileID2,formatSpec2,A);
##end
##fclose(fileID2);