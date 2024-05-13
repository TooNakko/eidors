##fmdl = mdl_normalize(mk_library_model('neonate_16el'),1);
##[fmdl.stimulation,fmdl.meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}');
##opt.imgsz = [64 64]; opt.noise_figure = 0.5;
##imdl = mk_GREIT_model(mk_image(fmdl,1), 0.25, [], opt);

vv= eidors_readdata('1001_b.get'); 
vi=vv(:,46); vh=vv(:,61);
    
imdl = mk_common_model('c2c2',16);


options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options, 10);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

##fmdl = mdl_normalize(mk_library_model('neonate_16el'),1);
##[fmdl.stimulation,fmdl.meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}');
##opt.imgsz = [64 64]; opt.noise_figure = 0.5;
##imdl = mk_GREIT_model(mk_image(fmdl,1), 0.25, [], opt);

##vv= eidors_readdata('P04P-1016.get'); vi=vv(:,45); vh=vv(:,61);
imr = inv_solve(imdl,vh,vi);

clf; axes('position',[0.05,0.5,0.25,0.45]);
imr.calc_colours = struct('ref_level',0,'greylev',0.2,'backgnd',[1,1,1]);
show_slices(imr);

yposns = [20]; xposns = [20]; ofs= [40];

% Show positions on image
hold on; for i = 1:length(xposns)
    plot(xposns(i),yposns(i),'s','LineWidth',10);
end; hold off;

% Show plots
imgs = calc_slices(inv_solve(imdl, vh, vv));
axes('position',[0.32,0.6,0.63,0.25]);

taxis =  (0:size(imgs,3)-1)/13; % frame rate = 13
hold all
for i = 1:length(xposns);
    plot(taxis,ofs(i)+squeeze(imgs(yposns(i),xposns(i),:)),'LineWidth',2);
end
hold off
set(gca,'yticklabel',[]); xlim([0 16]);