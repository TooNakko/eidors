x = linspace(2,18,1000);

y = -(x > 11.5 & x < 17.5) * 250;


plot(x,y, 'LineWidth',2);
xlim([0 20])
ylim([-300 50])