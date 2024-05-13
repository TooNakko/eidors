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


%Khoi tao mô hình thuan, nguoc,tao mô hình kích thích
##imdl = mk_common_model('c2c2',16);
##options = {'no_meas_current','no_rotate_meas'};
##[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 5);     % Hàm mk_stim_patterns ?? tao mô hình kích thích, thay doi tham so cuoi ?? chinh dòng mA
##imdl.fwd_model.stimulation = stim;
##imdl.fwd_model.meas_select = meas_select;


%===========================Draw lung=====================
% 2D Model
imdl= mk_common_model('c2t2',16);
% Make correct stimulation pattern
[st, els]= mk_stim_patterns(...
   16, ... % electrodes / ring
    1, ... % 1 ring of electrodes
   '{ad}','{ad}', ... % adj stim and measurement
   { 'no_meas_current', ... %  don't mesure on current electrodes
     'no_rotate_meas',  ... %  don't rotate meas with stimulation
     'do_redundant', ...    %  do redundant measurements
   }, 10 );  % stimulation current (mA)
imdl.fwd_model.stimulation= st;
imdl.fwd_model.meas_select= els;

% most EIT systems image best with normalized difference
imdl.fwd_model = mdl_normalize(imdl.fwd_model, 1);
imdl.RtR_prior= @prior_gaussian_HPF;
%===========================Draw lung=====================

%Thuc hien giai mô hình nguoc ?? tao anh
data_homg = B;
clf; axes('position',[0.05,0.5,0.25,0.45]);
img.calc_colours = struct('ref_level',0,'greylev',0.2,'backgnd',[1,1,1]);
data_objs = A(:,4);                               % Lua chon 1 anh chuan de ve len
img = inv_solve(imdl, data_homg, data_objs);    %Hàm tao anh
show_slices(img);               % Hien thi anh


yposns = [17]; xposns = [43]; %=======>>>Chinh toa do diem can ve tai day
ofs= [0];

% Show positions on image
hold on; for i = 1:length(xposns)
    plot(xposns(i),yposns(i),'s','LineWidth',10);
end; hold off;

% Show plots
imgs = calc_slices(inv_solve(imdl, data_homg, A));
axes('position',[0.32,0.6,0.63,0.25]);

taxis =  (0:size(imgs,3)-1)/5; % frame rate = 13
hold all
for i = 1:length(xposns);
    plot(taxis,ofs(i)+squeeze(imgs(yposns(i),xposns(i),:)),'LineWidth',2);
    squeeze(imgs(yposns(i),xposns(i),:))
end
hold off
set(gca,'yticklabel',[]); xlim([0 16]);