function freq=getFreq(s, roi)
[D,N]=size(s);
if roi == 0
    roi=round(N/2):N;
end
X=s(:,roi);
freq=zeros(1,D);
for k = 1:D
    if sum(X(k,:))<1e-3
        freq(k)=NaN;
        continue;
    end
    zc_list=find_zc(X(k,:), mean(X(k,:)),0);
    half_cycle=mean(diff(zc_list));
    freq(k)=2/half_cycle;
end