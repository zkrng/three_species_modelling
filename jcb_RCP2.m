function [equi_table, eqp_type]=jcb_RCP2(cfg)
syms R C P R0 C0 xc yc xp yp
dR = R*(1-R)-xc*yc*C*R/(R+R0);
dC = xc*C*(-1+yc*R/(R+R0))-xp*yp*C*P/(C+C0);
dP = xp*P*(-1+yp*C/(C+C0));

f=[dR, dC, dP];
S = solve(f, [R, C, P]); % solve R, C, P for equilibrium point (dR = dC = dP = 0)
%%
% disp('>>>>>>>>>>>> R')
% pretty(S.R(1))
% disp('>>>>>>>>>>>> C')
% pretty(S.C(1))
% disp('>>>>>>>>>>>> P')
% pretty(S.P(1))

Rd=double(subs(S.R, [R0 C0 xc yc xp yp], [cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));
Cd=double(subs(S.C, [R0 C0 xc yc xp yp], [cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));
Pd=double(subs(S.P, [R0 C0 xc yc xp yp], [cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));

imaginary_sln = imag(Rd(:))~=0 |imag(Cd(:))~=0| imag(Pd(:))~=0;

equi_table = real([Rd, Cd, Pd]);
equi_table(imaginary_sln,:)=[];
%%
%%
df=jacobian(f,[R,C,P]);

% df_det = det(df); % product of eigenvalues
% df_trace = trace(df); % sum of eigenvalues

%%
% df_detd=zeros(size(R));
% df_traced=zeros(size(R));
% ddf=zeros(size(R),3);
eqp_type=struct;

for k =1 : size(equi_table,1)
%     df_detd(k)=double(subs(df_det, [R C P R0 C0 xc yc xp yp], ...
%         [Rd(k) Cd(k) Pd(k) cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));
%     df_traced(k)=double(subs(df_trace, [R C P R0 C0 xc yc xp yp], ...
%         [Rd(k) Cd(k) Pd(k) cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));

    ddf=double(subs(df, [R C P R0 C0 xc yc xp yp], ...
        [equi_table(k,:) cfg.R0 cfg.C0 cfg.xc cfg.yc cfg.xp cfg.yp]));
    df_eig=eig(ddf);
    fn=['Ep' num2str(k)];
    if all(real(df_eig)) % if all eigenvalues have non-zero real part
        if isreal(df_eig) & all(real(df_eig)<0)
            eqp_type.(fn)='stbNode';
        elseif isreal(df_eig) & all(real(df_eig)>0)
            eqp_type.(fn)='unstbNode';
        elseif isreal(df_eig) & sum(real(df_eig)>0) >=1 & sum(real(df_eig)<0) >=1
            eqp_type.(fn)='saddle';
        elseif any(imag(df_eig)==0) & all(real(df_eig)<0)
            eqp_type.(fn)='stbFocus';
        elseif any(imag(df_eig)==0) & all(real(df_eig)>0)
            eqp_type.(fn)='unstbFocus';
        elseif any(imag(df_eig)==0) & real(df_eig(imag(df_eig)==0))*real(df_eig(find(imag(df_eig)~=0,1)))<0
            eqp_type.(fn)='saddleFocus';
        else
            eqp_type.(fn)='unknown';
        end
    else
        eqp_type.(fn)='nonHypo';
    end
end
