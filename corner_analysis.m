clear all, close all
path = './Corner Analysis Results/';
ca_files = {dir([path '*.mat']).name};
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

T1o = zeros(length(aS), length(gS));
T1c = zeros(length(aS), length(gS));
T2o = zeros(length(aS), length(gS));
T2c = zeros(length(aS), length(gS));
er1 = zeros(length(aS), length(gS));
er2 = zeros(length(aS), length(gS));

for n = 1:length(ca_files)
    file = ca_files{n};
    load([path file]);
    gi = str2double(file(4));
    ai = str2double(file(5));
    
    wl = c./squeeze(T1.f);
    T1o(ai,gi) = interp1(wl, squeeze(T1.T), 1310e-9, 'spline');
    T1c(ai,gi) = interp1(wl, squeeze(T1.T), 1550e-9, 'spline');
    T2o(ai,gi) = interp1(wl, squeeze(T2.T), 1310e-9, 'spline');
    T2c(ai,gi) = interp1(wl, squeeze(T2.T), 1550e-9, 'spline');
    er1(ai,gi) = 10*log10(T1c(ai,gi)/T1o(ai,gi));
    er2(ai,gi) = 10*log10(T2o(ai,gi)/T2c(ai,gi));
%     plot(wl, [squeeze(T1.T) squeeze(T2.T)]), hold on
end

%% Contour Plots
[X, Y] = meshgrid(g_sweep*1e9, a_sweep*1e9);
figure(1);
subplot 211
[C,h] = contour(X,Y,er1,'ShowText','on');
clabel(C,h,'interpreter','latex')
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$er_1$');

subplot 212
[C,h] = contour(X,Y,er2,'ShowText','on');
clabel(C,h,'interpreter','latex')
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$er_2$');

figure(2);
subplot 221
[C,h] = contour(X, Y, T1o, 4, 'showtext', 'on', 'LabelSpacing', 1000);
clabel(C,h,'interpreter','latex', 'labelspacing', 1000);
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$T_1$ @ 1310 nm');

subplot 222
[C,h] = contour(X, Y, T1c, 4, 'showtext', 'on', 'LabelSpacing', 1000);
clabel(C,h,'interpreter','latex', 'labelspacing', 1000);
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$T_1$ @ 1550 nm');

subplot 223
[C,h] = contour(X, Y, T2o, 4, 'showtext', 'on', 'LabelSpacing', 1000);
clabel(C,h,'interpreter','latex');
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$T_2$ @ 1310 nm');

subplot 224
[C,h] = contour(X, Y, T2c, 4, 'showtext', 'on', 'LabelSpacing', 1000);
clabel(C,h,'interpreter','latex');
xlabel('$g$ [nm]'); ylabel('$a$ [nm]');
title('$T_2$ @ 1550 nm');

%% Waterfall Plots

T1a = zeros(length(a_sweep), length(wl));
T2a = zeros(length(a_sweep), length(wl));
for n = aS
    file = ['CA_3' num2str(n) '.mat'];
    load([path file]);
    T1a(n, :) = T1.T;
    T2a(n, :) = T2.T;
end

[X, Y] = meshgrid(wl*1e9, a_sweep*1e9);
figure(3);
subplot 221
waterfall(X, Y, T1a)
xlabel('$\lambda$ [nm]'); ylabel('$a$ [nm]'); zlabel('$T_1$');
subplot 222
waterfall(X, Y, T2a)
xlabel('$\lambda$ [nm]'); ylabel('$a$ [nm]'); zlabel('$T_2$');

T1g = zeros(length(a_sweep), length(wl));
T2g = zeros(length(a_sweep), length(wl));
for n = gS
    file = ['CA_' num2str(n) '3.mat'];
    load([path file]);
    T1g(n, :) = T1.T;
    T2g(n, :) = T2.T;
end
subplot 223
waterfall(X, Y, T1g)
xlabel('$\lambda$ [nm]'); ylabel('$g$ [nm]'); zlabel('$T_1$');
subplot 224
waterfall(X, Y, T2g)
xlabel('$\lambda$ [nm]'); ylabel('$g$ [nm]'); zlabel('$T_2$');