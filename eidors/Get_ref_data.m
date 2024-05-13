
s1 = serialport("COM8", 115200)

set(s1, "parity", "N")                                                        
set(s1, "stopbits", 1)                                                      
flush(s1);

%==============Colect refference data
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen('ref.txt','w');            %Doc du lieu reference




while(1)
    fprintf(s1, '%s', "f");
  %=============Read data from the serial port
  flush(s1);

  while(true)
	  data = read(s1, 1, "uint8");
      if data == 's'
          disp("New frame found!")
          break
      end
  end
    data = read(s1, 4*208 + 13 * 16 + 2 * 16 + 12,  "string");
    disp(data)
    fprintf(fileID, '%s', data);
 break

end

fclose(fileID);
fclose(s1);
pause(0.5);