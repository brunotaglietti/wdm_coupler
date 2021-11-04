clear all, close all
ca_files = {dir('./Corner Analysis Results/*.mat').name};
c = physconst('lightspeed');
gS = 1:5;
aS = 1:5;

clrs = get(0, 'DefaultAxesColorOrder');
ppi = get(groot,'screenpixelsperinch');
ss = get(groot, 'screensize');
figsize = [16 12]*ppi/2.54;
set(groot,'defaultLineLineWidth',1.0,...
    'defaultAxesTickLabelInterpreter','latex',...
    'defaultLegendInterpreter','latex','defaultTextInterpreter','latex',...
    'defaultAxesFontSize',12,...
    'defaultfigureposition', [ss(3:4).*[0.1 0.1], figsize]);
clear ppi ss figsize

T1a = zeros(length(gS), length(aS));
T1b = zeros(length(gS), length(aS));
T2a = zeros(length(gS), length(aS));
T2b = zeros(length(gS), length(aS));
er1 = zeros(length(gS), length(aS));
er2 = zeros(length(gS), length(aS));

for n = 1:length(ca_files)
    file = ca_files{n};
    load(['./Corner Analysis Results/' file]);
    i = str2num(file(4));
    j = str2num(file(5));
    
    wl = c./squeeze(T1.f);
    T1a(i,j) = interp1(wl, squeeze(T1.T), 1310e-9, 'spline');
    T1b(i,j) = interp1(wl, squeeze(T1.T), 1550e-9, 'spline');
    T2a(i,j) = interp1(wl, squeeze(T2.T), 1310e-9, 'spline');
    T2b(i,j) = interp1(wl, squeeze(T2.T), 1550e-9, 'spline');
    er1(i,j) = 10*log10(T1b(i,j)/T1a(i,j));
    er2(i,j) = 10*log10(T2a(i,j)/T2b(i,j)); 
end
[X, Y] = meshgrid(g_sweep*1e9, a_sweep*1e9);
subplot 121
contour(X,Y,er1,'ShowText','on')
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$er_1$');

subplot 122
contour(X,Y,er2,'ShowText','on')
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$er_2$');
