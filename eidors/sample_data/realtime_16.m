s1 = serialport("COM4", 115200)

set(s1, "parity", "N")                                                        
set(s1, "stopbits", 1)                                                      
flush(s1);

%==============Colect refference data
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('ref.txt','r');            %Doc du lieu reference
data_homg = fscanf(fileID,formatSpec,[208 100]);
data_homg = convert_new(data_homg);

%Initialize the forward and inversed model
imdl = mk_common_model('f2c2',16);
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 5);   
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

while(1)
  %=============Read data from the serial port
  flush(s1);
  fprintf(s1, '%s', 'f');
  %fprintf(s1, '%s', "f");

  
  f0 = zeros(208,1);
  f1 = [1 1 1 1];
  j = 0;
  while(1)
	  data = read(s1, 1, "string");
      fprintf(s1, '%s', 'f');
      disp("Seeking.");
      if data == 's'
          disp("New frame found!")
          break
      end
  end
	i = 1;
    j=0;    
    data = read(s1, 4*208 + 13 * 16 + 2 * 16 + 2 + 12,  "string");
    disp(strsplit(strip(data)))
    mod_data = str2double(strsplit(strip(data)))
    f0 = mod_data;

  tic
  EIT_data(1:208) = f0(1:208);

  data_objs = convert_new(EIT_data);
  disp(data_objs);
  figure(1);
  h1 = subplot(1,1,1);
  %Generate and display images
  img = inv_solve(imdl, data_homg, data_objs);  %!!!!!!
  show_slices(img); 
  eidors_colourbar(img);
  toc
end
fclose(s1);
pause(0.5);