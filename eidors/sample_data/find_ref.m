pkg load instrument-control       %add package de doc tu cong COM
pkg load geometry                 % add package de ve line 
pkg load signal                   %add ham thu vien de xu li tin hieu

formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('obj.txt','r');            %Doc du lieu object tu file obj.txt
C = fscanf(fileID,formatSpec,[208 100]);

fileID1 = fopen('ref.txt','r');           %Doc du lieu reference tu file ref.txt
B = fscanf(fileID1,formatSpec); 


%%Chuyen doi tu dang 208 sang 256
A = zeros(256,size(C)(2));
for i = 1: size(C)(2)
  A(:,i)= convert_new(C(:,i));
end
##A(:,2)= convert_new(C(:,2));
B = convert_new(B);

figure(1);
h1 = subplot(1,1,1);

%========================hình tròn
%Khoi tao mô hình thuan, nguoc,tao mô hình kích thích
imdl = mk_common_model('c2c2',16);
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 10);     % Hàm mk_stim_patterns ?? tao mô hình kích thích, thay doi tham so cuoi ?? chinh dòng mA
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;



%========================Decrease Noise======================================
##fmdl = mdl_normalize(mk_library_model('neonate_16el'),1);
##fmdl = mdl_normalize(mk_library_model('adult_male_16el'),1);
##elec_pos = [16,1,.5]; elec_shape=[0.15,0.3,0.01,0,60]; maxsz=0.08; nfft=27;
##fmdl = mk_library_model({'neonate','boundary','left_lung','right_lung'}, ...
##      elec_pos, elec_shape, maxsz,nfft);
      
##fmdl = mdl_normalize(fmdl,1);
##fmdl = mdl_normalize(mk_library_model('cylinder_16x1el_coarse'),1);
##options = {'no_meas_current','no_rotate_meas'};
##[fmdl.stimulation,fmdl.meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 5);
##opt.imgsz = [64 64]; opt.noise_figure = 0.5;
##imdl = mk_GREIT_model(mk_image(fmdl,1), 0.20, [], opt);


%Thuc hien giai mô hình nguoc ?? tao anh
data_homg = B;
figure(1);

h1 = subplot(1,1,1);
tic
globe = zeros(1,size(A)(2));

for i = 1: size(A)(2)
##  tic

  data_objs = A(:,i); % from your file
  img = inv_solve(imdl, data_homg, data_objs);    %Hàm tao anh
  
  img.calc_colours.ref_level =  0; %  Set gia tri c?a ref
  img.calc_colours.clim      =  1; %  Dat gia tri dai do max
  
  globe(i) = sum(img.elem_data);
  

##  toc
  pause(0.1)
##  figure(2);
##  plot(A(:,i));
end
plot(globe)
DataInv = 1.01*max(globe) - globe;
##findpeaks(DataInv)
[Minima,MinIdx] = findpeaks(DataInv);

plot(globe)
hold on
plot(MinIdx,globe(MinIdx),'r*')
hold off