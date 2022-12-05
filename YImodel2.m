function dydt = YImodel2(t, RCP, cfg)
R0 = cfg.R0;
C0 = cfg.C0;
xc = cfg.xc;
yc = cfg.yc;
xp = cfg.xp;
yp = cfg.yp;

dydt = zeros(3,1);
dydt(1) = RCP(1)*(1-RCP(1))-xc*yc*RCP(2)*RCP(1)/(RCP(1)+R0);
dydt(2) = xc*RCP(2)*(-1+yc*RCP(1)/(RCP(1)+R0))-xp*yp*RCP(2)*RCP(3)/(RCP(2)+C0);
dydt(3) = xp*RCP(3)*(-1+yp*RCP(2)/(RCP(2)+C0));