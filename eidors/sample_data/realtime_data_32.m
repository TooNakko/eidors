

s1 = serialport("COM8", 115200)

set(s1, "parity", "N")                                                        
set(s1, "stopbits", 1)                                                      
flush(s1);

%==============Colect refference data
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n';
fileID = fopen('ref_data.txt','r');            %Doc du lieu reference
data_homg = fscanf(fileID,formatSpec, [928 Inf]);

w_origin_file = fopen('F_origin.txt', 'w');
w_new_file = fopen('F_new.txt', 'w');

count = 0
for i = 1:numel(data_homg)
    if count == 29
        fprintf(w_origin_file, '\n');
        count = 0
    end
    fprintf(w_origin_file, '%.2f ', data_homg(i));
    count = count + 1;
end

data_homg = convert_new_32(data_homg);
%F = reshape(data_homg, [32,32]);
count = 0;
for i = 1:numel(data_homg)
    if count == 32
        fprintf(w_new_file, '\n');
        count = 0;
    end
    fprintf(w_new_file, '%.2f ', data_homg(i));
    count = count + 1;
end


%Initialize the forward and inversed model
imdl = mk_common_model('d2c2',32);
options = {'no_meas_current','no_rotate_meas'}; %Rotate_meas ?
[stim, meas_select] = mk_stim_patterns(32,1,'{ad}','{ad}',options, 5);  %Amp = ? 
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

while(1)
  flush(s1);
  %=============Read data from the serial port
  fprintf(s1, '%s', "f");
  
  %fwrite(s, "f");
  f0 = zeros(928,1);

  while(true)
	  data = read(s1, 1, "string");
      if data == 's'
          disp("New frame found!");
          break
      end
  end
	i = 1;
    data = read(s1,4732,  "string"); 
    disp(strsplit(strip(data)));
    mod_data = str2double(strsplit(strip(data)));
    f0 = mod_data;

  tic
  EIT_data(1:928) = f0(1:928);

  data_objs = convert_new_32(EIT_data);
  disp(data_objs);
  figure(1);
  h1 = subplot(1,1,1);
  %Generate and display images
  img = inv_solve(imdl, data_homg, data_objs);
  show_slices(img); 
  eidors_colourbar(img);
  
  toc
end
fclose(s1);
pause(0.5);