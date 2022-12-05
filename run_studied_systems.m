%% Plant - Crayfish - CatFish
clear; close all;
cfg = [];
cfg.R0 = 0.2;
cfg.C0 = 0.5;
cfg.xc = 0.6;
cfg.yc = 1.5;
cfg.xp = 0.05;
cfg.yp = 5;

cfg.S1= 1; % choose the folder S1
cfg.plotIt = 1; % to plot the results
cfg.num_start = 2; % number of start points
cfg.win_size = [0, 0, 900, 900];
cfg.win_size1 = [0, 0, 900, 450];

cfg.c1=[0, 0.4470, 0.7410];  % color
cfg.c2=[0.8500, 0.3250, 0.0980];  % color
cfg.c3=[0.9290, 0.6940, 0.1250]; % color

[of1, amp1, ep1, eqp_type1]=main_RCP(cfg, 'S1');
%% Task 3: chaotic solutions
clear; close all;
cfg = [];
cfg.R0 = 0.161;
cfg.C0 = 0.5;
cfg.xc = 0.4;
cfg.yc = 2.01;
cfg.xp = 0.148;
cfg.yp = 5;

cfg.S2= 1; % choose the folder S2
cfg.plotIt = 1; 
cfg.num_start = 2;
cfg.win_size = [0, 0, 900, 900];
cfg.win_size1 = [0, 0, 900, 450];

cfg.c1=[0, 0.4470, 0.7410];
cfg.c2=[0.8500, 0.3250, 0.0980];
cfg.c3=[0.9290, 0.6940, 0.1250];

[of2, amp2, ep2, eqp_type2]=main_RCP(cfg, 'S2');
close all;