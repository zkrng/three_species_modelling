function run_param(plotIt, num_start)
%% Parameter ranges
xp_range=linspace(0.071,0.225,5);
xc_range=linspace(0.1, 0.9, 9);
yc_range=[1.2, 2.01, 5];
yp_range=[5, 12, 19]; % 1.2, 2.01 seems not work with the chosen value of other parameters
R0_range=linspace(0.1, 0.9, 9);
C0_range=linspace(0.1, 0.9, 9);
orbit_freq=NaN(6,9);
RCP_amp=NaN(6,9,6);
equil_point=NaN(6,9,6,3);
%% Choose parameters
for k = 1:6
    %% Original value of parameters
    cfg = [];
    cfg.R0 = 0.161;
    cfg.C0 = 0.5;
    cfg.xc = 0.4;
    cfg.yc = 2.01;
    cfg.xp = 0.2;
    cfg.yp = 5;
    %% Other inputs
    cfg.plotIt = plotIt; % plot the results with each value 
    cfg.num_start = num_start; % number of start points/ use 2 if you'd like to plot
    cfg.win_size = [0, 0, 900, 900]; % figure size
    cfg.win_size1 = [0, 0, 900, 450]; % figure size

    cfg.c1=[0, 0.4470, 0.7410]; % color
    cfg.c2=[0.8500, 0.3250, 0.0980]; % color
    cfg.c3=[0.9290, 0.6940, 0.1250]; % color
    %% choose the examined parameter
    switch k
        case 1
            param='xp';
            param_range=xp_range;           
        case 2
            param='xc';
            param_range=xc_range;            
        case 3
            param='yc';
            param_range=yc_range;
        case 4
            param='yp';
            param_range=yp_range;          
        case 5
            param='R0';
            param_range=R0_range;
        case 6
            param='C0';
            param_range=C0_range;           
        otherwise
            disp('k is not 1 to 6')
    end
    %% Main
    for m = 1:length(param_range)
        cfg.(param) = param_range(m);
        [of, amp, ep, ept]=main_RCP(cfg, param);
        orbit_freq(k,m)=of;
        RCP_amp(k,m,:)=amp;
        equil_point(k,m,:,:)=ep(:,1:3);
        fn=[param num2str(m)];
        ep_type.(fn)=ept;
    end
    %% Plot the results of varying parameters' value
    if cfg.num_start > 2
        % the plot of amp and freq requires higher number of samples
        % remember to put cfg.plotIt = 0 to not plot too many figures
        plotting(param, param_range, orbit_freq(k,:),...
            squeeze(RCP_amp(k,:,:)), squeeze(equil_point(k,:,:,:)), cfg)
    end
end
close all;

