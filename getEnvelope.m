function [RCP_limit, RCP_lim_mean]=getEnvelope(RCPs)
RCP_limit=ones(6,size(RCPs,2));
for k=1:3
    [yupper,ylower] = envelope(RCPs(k,:), 30, 'peaks');
    RCP_limit((k-1)*2+1,:)=yupper;
    RCP_limit(k*2,:)=ylower;
end
RCP_lim_mean=mean(RCP_limit(:,round(length(RCPs)/2):end),2);
end