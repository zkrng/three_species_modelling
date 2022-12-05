%%
list_figures = {'R0', 'C0', 'xc', 'xp', 'yc', 'yp', 'S1', 'S2'};
for f = 1:length(list_figures)
    if ~exist(['.\figures\' list_figures{f}], 'dir')
        mkdir(['.\figures\' list_figures{f}])
    end
end

%% Run two studied systems
run_studied_systems;
%% Examining the varying parameters in Yodzis-Innes 3-species model 
close all; clear;
run_param(1, 2); % plot single case
run_param(0, 20); % plot parameter varying results