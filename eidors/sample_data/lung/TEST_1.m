

K1=2;           % file extension length
K2='lung';    % official data analysis directory
K3=13;          % Default Viasys frame rate (issue warning)
filename = ['lung','/','1001_b.get']; 

lengthK2 = length(K2);
if strncmp(K2,filename,lengthK2) == 1
    idstring = filename(lengthK2+1:end);
    [studycode,idrem1] = strtok(idstring,'/');
    origin = GetSubjectType(studycode);
    [subjectid,idrem2] = strtok(idrem1(2:end),'/');
    [casedate,idrem3] = strtok(idrem2(2:end),'/');
    file = fliplr(strtok(fliplr(idrem3),'/'));
end

device = 'Viasys';
vdtemp = eidors_readdata('1001_b.get');
[vd,s] = FormatViasysData(vdtemp);
fr = 13;

eitdata = struct('structure','eitdata',...
    'subject_id',subjectid,...
    'subject_type',origin,...
    'case_date',casedate,...
    'file_name',file,...
    'eit_device',device,...
    'number_of_frames',size(vd,2),...
    'frame_rate',fr,... % Will require an ASCII file header reader
    'voltage_data',vd);
    
        
maneuver='increment'; PEEP=14; dP=5;

eitdata.maneuver = maneuver;
eitdata.peep = PEEP;
eitdata.deltap = dP;
range = [];
##range = [1,size(eitdata.voltage_data,2)];
if isempty(range)
   range = [1,size(eitdata.voltage_data,2)];
end
   
##[eitdata,s]=EITFilterData(eitdata,'bandpass',range);
[eitimages,s]=EITReconstructImages(eitdata);
[eitdata,eitimages,s]=EITCalcTidalImages(eitdata,eitimages,range);

   
% Temp line for counting breaths
eitdata.tidalindices = eitdata.tidalindices;
[eitimages,p,s]=EITCalcLungRoi(eitimages);
[eitimages,s]=EITCalcComplianceImage(eitimages);

