clearvars;
load('./wdm_coupler/SWG Neff Estimation/neff_sweep.mat');
widths = widths*1e9;

figure(2);
% subplot 121
plot(widths, neffs), hold on, box off, grid on
xlim([widths(1) 1500]);
ylim([1.4 max(neffs(:))]);
xlabel('width [nm]');
ylabel('$n_{eff}$');

% clearvars;
% load('TM_neff_sweep.mat');
% widths = widths*1e9;
% subplot 122
% plot(widths, neffs), hold on, box off, grid on
% xlim([widths(1) 1500]);
% ylim([1.4 max(neffs(:))]);
% xlabel('width [nm]');
% ylabel('$n_{eff}$');

nac = interp1(widths, neffs(1,:), 500);
w1 = interp1(neffs(2,:), widths, nac)