function zc_list=find_zc(amp,threshold,updown)
% Dao Nguyen, thi.dao.nguyen@uef.fi
% Find zero-crossing
% updown: 1: one sign, 0: both
zc_list=[];

for k=1:length(amp)-1
    if (amp(k)-threshold)*(amp(k+1)-threshold)<0
        zc_list(end+1)=k;
    end
end

if updown==0
    for k=1:length(amp)-1
        if (amp(k)+threshold)*(amp(k+1)+threshold)<0
            zc_list(end+1)=k;
        end
    end
end
zc_list=unique(zc_list);
end