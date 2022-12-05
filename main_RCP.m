function [orbit_freq, RCP_amp, equi_table, eqp_type]=main_RCP(cfg, param)
r = linspace(0,1,20);
c = linspace(0,1,20);
p = linspace(0,1,20);
%% Equilibrium points
[equi_table, eqp_type] = jcb_RCP2(cfg);
ep=find(equi_table(:,1)>=0 & equi_table(:,2)>=0 & equi_table(:,3)>=0);
%% Phase portrait
[R, C, P] = meshgrid(r, c, p);

uR = zeros(size(R));
uC = zeros(size(R));
uP = zeros(size(R));

t=0; % derivatives at each point at t=0
for i = 1:numel(R)
    dydt = YImodel2(t, [R(i); C(i); P(i)], cfg);
    uR(i) = dydt(1)/norm(dydt);
    uC(i) = dydt(2)/norm(dydt);
    uP(i) = dydt(2)/norm(dydt);
end
if cfg.plotIt
        figure('Position', cfg.win_size);
        quiver3(R, P, C, uR, uP, uC, 'k');
        hold on;
        plot3(equi_table(ep,1), equi_table(ep,3), equi_table(ep,2), 'rv', ...
            'MarkerFaceColor', 'r', 'MarkerSize', 10)
        axis equal tight
        xlabel('R'), ylabel('P'); zlabel('C')
        view([30,30])
        print(gcf,['figures\' param '\' param '_' num2str(cfg.(param), '%.3f') '_phasePortrait.png'], '-dpng', '-r300' )
end
%% Densities Samples
tspan=[0 1000];

N = cfg.num_start;
freq=NaN(N,3);
RCP_lim_mean=NaN(N,6);
kk=round(1 + (8000-1).*rand(N,1));
for k = 1:N
    %%
    %     k = 500;
    t=kk(k);
    start_point=[R(t), C(t), P(t)];
    for kkk=1:3
        if start_point(kkk)>0.9
            start_point(kkk)=0.9;
        elseif start_point(kkk)<0.1
            start_point(kkk)=0.1;
        end
    end
    RCP = ode45(@(t,y) YImodel2(t,y, cfg), tspan, start_point);
    RCPs = RCP.y;
    freq(k,:)=getFreq(RCPs,0); % frequency of population densities
    [RCP_limit, lim_mean]=getEnvelope(RCPs); % amplitude of population densities
    RCP_lim_mean(k,:)=lim_mean;
    if cfg.plotIt
        figure('Position', cfg.win_size1);
        subplot(121)
        quiver3(R, P, C, uR, uP, uC, 'color', [0.5, 0.5, 0.5]);
        axis equal tight
        xlabel('R'), ylabel('P'); zlabel('C')
        hold on;
        plot3(equi_table(ep,1), equi_table(ep,3), equi_table(ep,2), 'rv', ...
            'MarkerFaceColor', 'r', 'MarkerSize', 10)
        plot3(start_point(1), start_point(3), start_point(2),'ro') % starting point
        plot3(RCPs(1,:),RCPs(3,:),RCPs(2,:),'b', 'linewidth', 1.5);
        title([param '=' num2str(cfg.(param), '%.3f') ': R_s C_s P_s=' num2str(start_point,'%.3f  ')])
                view([30,30])

        subplot(122); hold on;
        plot(RCP.x, RCPs(1,:), '-', 'color', cfg.c1)
        plot(RCP.x, RCPs(2,:), '-.', 'color', cfg.c2)
        plot(RCP.x, RCPs(3,:), '--', 'color', cfg.c3)
%         plot(RCP.x, RCP_limit(1:2,:), '-', 'color', cfg.c1,'linewidth', 1.5)
%         plot(RCP.x, RCP_limit(3:4,:), '-.', 'color', cfg.c2,'linewidth', 1.5)
%         plot(RCP.x, RCP_limit(5:6,:), '--', 'color', cfg.c3,'linewidth', 1.5)

%         subplot(322); plot(RCP.x, RCPs(1,:), '-', 'color', cfg.c1); title('R')
%         subplot(324); plot(RCP.x, RCPs(2,:), '-', 'color', cfg.c2); title('C')
%         subplot(326); plot(RCP.x, RCPs(3,:), '-', 'color', cfg.c3); title('P')

        ylim([-0.02, 1.02])
        xlabel('Time (t)'), ylabel('Population density')
        legend('R', 'C', 'P')%, 'R range','', 'C range','', 'P range','')
        title(['Frequency of R C P=' num2str(freq(k,:),'%.3f ')])

        print(gcf,['figures\' param '\' param '_' num2str(cfg.(param), '%.3f') '_' num2str(k) '.png'], '-dpng', '-r300' )
    end
end
orbit_freq=median(freq(:), 'omitnan');
RCP_amp=median(RCP_lim_mean, 'omitnan');
%% System behavior at each equilibrium point
close all;
tspan=[0, 2000];
for k =1:length(ep)
    %%
    epv=equi_table(ep(k),1:3);
    epv_near=epv+0.001;
    for kkk=1:3
        if epv(kkk)==1
            epv_near(kkk)=epv(kkk)-0.001;
        end
    end
    
    RCP_eq = ode45(@(t,y) YImodel2(t,y, cfg), tspan, epv);
    RCPs_eq = RCP_eq.y;
    freq_eq =getFreq(RCPs_eq,0);
%     [RCP_limit_eq, lim_mean]=getEnvelope(RCPs_eq);
    
    RCP_eq_near = ode45(@(t,y) YImodel2(t,y, cfg), tspan, epv_near);
    RCPs_eq_near = RCP_eq_near.y;
    freq_eq_near =getFreq(RCPs_eq_near,0);
%     [RCP_limit_eq_near, lim_mean]=getEnvelope(RCPs_eq_near);
    
    if cfg.plotIt
        cr_ep=['Ep' num2str(ep(k))];
        figure('Position', cfg.win_size);
        
        subplot(221);
        quiver3(R, P, C, uR, uP, uC, 'color', [0.5, 0.5, 0.5]);
        axis equal tight
        xlabel('R'), ylabel('P'); zlabel('C')
        hold on;
        plot3(equi_table(ep,1), equi_table(ep,3), equi_table(ep,2), 'rv', ...
            'MarkerFaceColor', [1 .6 .6], 'MarkerSize', 5)
        plot3(equi_table(ep(k),1), equi_table(ep(k),3), equi_table(ep(k),2), 'rv', ...
            'MarkerFaceColor', 'r', 'MarkerSize', 8)
        plot3(RCPs_eq(1,:),RCPs_eq(3,:),RCPs_eq(2,:),'b');
        title([cr_ep '-' eqp_type.(cr_ep) ': R_s C_s P_s=' num2str(epv,'%.3f ')])
                view([30,30])

        subplot(222); hold on;
        plot(RCP_eq.x, RCPs_eq(1,:), '-', 'color', cfg.c1)
        plot(RCP_eq.x, RCPs_eq(2,:), '-.', 'color', cfg.c2)
        plot(RCP_eq.x, RCPs_eq(3,:), '--', 'color', cfg.c3)
%         plot(RCP_eq.x, RCP_limit_eq(1:2,:), '-', 'color', cfg.c1,'linewidth', 1.5)
%         plot(RCP_eq.x, RCP_limit_eq(3:4,:), '-.', 'color', cfg.c2,'linewidth', 1.5)
%         plot(RCP_eq.x, RCP_limit_eq(5:6,:), '--', 'color', cfg.c3,'linewidth', 1.5)
        ylim([-0.02, 1.02])
        xlabel('Time (t)'), ylabel('Population density')
        legend('R', 'C', 'P')
        title(['Frequency of R C P=' num2str(freq_eq,'%.3f ')])

        subplot(223)
        quiver3(R, P, C, uR, uP, uC, 'color', [0.5, 0.5, 0.5]);
        axis equal tight
        xlabel('R'), ylabel('P'); zlabel('C')
        hold on;
        plot3(equi_table(ep,1), equi_table(ep,3), equi_table(ep,2), 'rv', ...
            'MarkerFaceColor', [1 .6 .6], 'MarkerSize', 5)
        plot3(equi_table(ep(k),1), equi_table(ep(k),3), equi_table(ep(k),2), 'rv', ...
            'MarkerFaceColor', 'r', 'MarkerSize', 8)
        plot3(RCPs_eq_near(1,1),RCPs_eq_near(3,1),RCPs_eq_near(2,1),'ro') % starting point
        plot3(RCPs_eq_near(1,:),RCPs_eq_near(3,:),RCPs_eq_near(2,:),'b');
        title([cr_ep '+0.001: R_s C_s P_s=' num2str(epv_near,'%.3f ')])
                view([30,30])

        subplot(224); hold on;
        plot(RCP_eq_near.x, RCPs_eq_near(1,:), '-', 'color', cfg.c1)
        plot(RCP_eq_near.x, RCPs_eq_near(2,:), '-.', 'color', cfg.c2)
        plot(RCP_eq_near.x, RCPs_eq_near(3,:), '--', 'color', cfg.c3)
%         plot(RCP_eq_near.x, RCP_limit_eq_near(1:2,:), '-', 'color', cfg.c1,'linewidth', 1.5)
%         plot(RCP_eq_near.x, RCP_limit_eq_near(3:4,:), '-.', 'color', cfg.c2,'linewidth', 1.5)
%         plot(RCP_eq_near.x, RCP_limit_eq_near(5:6,:), '--', 'color', cfg.c3,'linewidth', 1.5)
        ylim([-0.02, 1.02])
        xlabel('Time (t)'), ylabel('Population density')
        legend('R', 'C', 'P')
        title(['Frequency of R C P=' num2str(freq_eq_near,'%.3f ')])
        
        eq_val=[num2str(epv(1), '%.3f') '_' num2str(epv(2), '%.3f') '_' num2str(epv(3), '%.3f')];
        print(gcf,['figures\' param '\' param  '_' num2str(cfg.(param), '%.3f') '_ep_' eq_val '_' ...
            eqp_type.(cr_ep) '.png'], '-dpng', '-r300' )
    end
end