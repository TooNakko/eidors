formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('middle_data.txt','r');            %Doc du lieu object tu file obj.txt
C = fscanf(fileID,formatSpec,[208 100]);

fileID1 = fopen('ref_data.txt','r');           %Doc du lieu reference tu file ref.txt
B = fscanf(fileID1,formatSpec); 

a = size(C);
A = zeros(256,a(2));
for i = 1: a(2)
  A(:,i)= convert_new(C(:,i));
end


% ##A(:,2)= convert_new(C(:,2));
B = convert_new(B);




 fmdl = mdl_normalize(mk_library_model('neonate_16el'),1);
 fmdl = mdl_normalize(mk_library_model('adult_male_16el'),1);
 elec_pos = [16,1,.5]; elec_shape=[0.15,0.3,0.01,0,60]; maxsz=0.08; nfft=27;
 fmdl = mk_library_model({'neonate','boundary','left_lung','right_lung'}, ...
       elec_pos, elec_shape, maxsz,nfft);
       
 fmdl = mdl_normalize(fmdl,1);
 fmdl = mdl_normalize(mk_library_model('cylinder_16x1el_coarse'),1);
 options = {'no_meas_current','no_rotate_meas'};
 [fmdl.stimulation,fmdl.meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 5);
 opt.imgsz = [64 64]; opt.noise_figure = 0.5;
 imdl = mk_GREIT_model(mk_image(fmdl,1), 0.20, [], opt);


%Thuc hien giai mô hình nguoc ?? tao anh
data_homg = B;


subplot(2,1,1);
tic
b = size(A)
globe = zeros(b(2));

for i = 1: b(2)
% ##  tic

  data_objs = A(:,i); % from your file
  img = inv_solve(imdl, data_homg, data_objs);    %Hàm tao anh
  
  img.calc_colours.ref_level =  0; %  Set gia tri c?a ref
  %img.calc_colours.clim      =  1; %  Dat gia tri dai do max

  cells_to_plot = img.elem_data(1551:1614);

  
  show_slices(img);               % Hien thi anh

  eidors_colourbar(img);
  

  pause(0.1)

end

mat = zeros(64,1);
for i = 1 : 49
  mat(i) = img.elem_data(28 + i*56);
end 
%plot(mat)
subplot(2,1,2)
x = linspace(0,17, 64)

plot(x,cells_to_plot)
xlim([0 17])
axis square
