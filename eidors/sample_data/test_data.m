
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('obj.txt','r');
C = fscanf(fileID,formatSpec,[208 1]);

fileID1 = fopen('ref.txt','r');
B = fscanf(fileID1,formatSpec);

##show_slices(inv_solve(mk_common_model('d2c2',16),B,A)); 
imdl = mk_common_model('c2c2',16);
##n_rings = 12;
##n_electrodes = 16;
##three_d_layers = []; % no 3D
##fmdl = mk_circ_tank( n_rings , three_d_layers, n_electrodes);
% then assign the fields in fmdl to imdl.fwd_model
%%Convert to 256------------------------
A = zeros(256,1);
A(:,1)= convert_new(C(:,1));
##A(:,2)= convert_new(C(:,2));
B = convert_new(B);

figure(1)
h1 = subplot(2,2,1)

options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 5);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;
tic
data_homg = B;
data_objs = A; % from your file
img = inv_solve(imdl, data_homg, data_objs);
show_slices(img);
toc
##common_colourbar(h1,img);

##for j = 1:length(B)-1
##  if A(j,1) == 0
##    A(j,1) = A(j+1,1);
##  endif
##end
##for j = 1:length(B)-1
##  if A(j,2) == 0
##    A(j,2) = A(j+1,2);
##  endif
##end

##figure(2)
h2 = subplot(2,2,2)
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 10);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

data_homg = B;
data_objs = A; % from your file
img = inv_solve(imdl, data_homg, data_objs);
show_slices(img);
##common_colourbar(h2,img);
##figure(3)
h3 = subplot(2,2,3)
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 20);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

data_homg = B;
data_objs = A; % from your file
img = inv_solve(imdl, data_homg, data_objs);
show_slices(img);
##common_colourbar(h3,img);
##figure(4)




h4 = subplot(2,2,4)
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 30);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

data_homg = B;
data_objs = A; % from your file
img = inv_solve(imdl, data_homg, data_objs);
show_slices(img);
common_colourbar([h1,h2,h3,h4],img);
##
##figure(5)
##options = {'no_meas_current','no_rotate_meas'};
##[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 15);
##imdl.fwd_model.stimulation = stim;
##imdl.fwd_model.meas_select = meas_select;
##
##data_homg = B;
##data_objs = A; % from your file
##img = inv_solve(imdl, data_homg, data_objs);
##show_slices(img);
####for i = 1:4
##  figure(i);
##  data_homg = B;
##  data_objs = A(:,i); % from your file
##  img = inv_solve(imdl, data_homg, data_objs);
##  show_slices(img);
##end
##B(:) = 2;
##A(:) = 0.01;
