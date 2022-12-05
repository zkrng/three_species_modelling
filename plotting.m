function plotting(param, param_range, freq, amp, ep, cfg)
figure('Position', [0 0 900 600]);

subplot(211); hold on;
for kk=1:length(param_range)
    cur_ep=squeeze(ep(kk,:,:));
%     for k=1:6
        plot3(cur_ep(:,1),cur_ep(:,3),cur_ep(:,2),'o');
        text(cur_ep(:,1),cur_ep(:,3),cur_ep(:,2), num2str((1:6)'))
%     end
end
legend(strcat([param '='],num2str(param_range', '%.3f')))
xlabel('R'), ylabel('P'); zlabel('C')
grid on; axis equal tight; view(3)

subplot(223);
plot(freq,'-o');
xticks(1:length(param_range))
xticklabels(num2str(param_range','%.3f'))
xtickangle(45)
ylabel('Orbit frequency')
xlabel(param)

subplot(224); hold on;
plot(amp(:,1:2), '-', 'color', cfg.c1)
plot(amp(:,3:4), '-.', 'color', cfg.c2)
plot(amp(:,5:6), '--', 'color', cfg.c3)
legend('R+', 'R-', 'C+','C-', 'P+', 'P-')
xticks(1:length(param_range))
xticklabels(num2str(param_range','%.3f'))
xtickangle(45)
ylabel('Population Density')
xlabel(param)

print(gcf,['figures\' param '\' param '_orbit_frequency.png'], '-dpng', '-r300')