%% 请先确保YALMIP工具箱和CPLEX正确安装,MATLAB导入对应文件，否则无法运行程序！！
% https://yalmip.github.io/allcommands  使用帮组文件

%% 初始化
clc;
clear all;close all;
yalmip;
Cplex;
%% 各变量及常量定义
%------------------------变量定义-----------------------%
Pw=sdpvar(1,24,'full'); %风机出力
Ppv=sdpvar(1,24,'full');%光伏出力
Pbat=sdpvar(1,24,'full');%蓄电池出力
% Pde=sdpvar(1,24,'full');%柴油机组出力
Pnet=sdpvar(1,24,'full');%交换功率
Pbuy=sdpvar(1,24,'full');%从电网购电电量
Psell=sdpvar(1,24,'full');%向电网售电电量
Temp_net=binvar(1,24,'full'); % 购|售电标志
Temp_cha=binvar(1,24,'full'); %充电标志
Temp_dis=binvar(1,24,'full'); %放电标志
Temp_static=binvar(1,24,'full'); %电池静置标志
% Temp_de=binvar(1,24,'full'); %柴油机发电标志
Pcha=sdpvar(1,24);
Pdis=sdpvar(1,24);
Constraints = [];
%-------------------------常量定义-----------------------%
Load=[88.24 	83.01 	80.15 	79.01 	76.07 	78.39 	89.95 	128.85 	155.45 	176.35 	193.71 	182.57 	179.64 	166.31 	164.61 	164.61 	174.48 	203.93 	218.99 	238.11 	216.14 	173.87 	131.07 	94.04];
%风机预测出力
Pw=[66.9	68.2	71.9	72	78.8	94.8	114.3	145.1	155.5	142.1	115.9	127.1	141.8	145.6...
    145.3	150	206.9	225.5	236.1	210.8	198.6	177.9	147.2	58.7];
%光伏预测出力
Ppv=[0	0	0	0	0.06	6.54	20.19	39.61	49.64	88.62	101.59	66.78	110.46	67.41	31.53...
    50.76	20.6	22.08	2.07	0	0	0	0	0];
%分时电价
C_buy=[0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.53	0.53	0.53	0.82	0.82...
    0.82	0.82	0.82	0.53	0.53	0.53	0.82	0.82	0.82	0.53	0.53	0.53];
C_sell=[0.22	0.22	0.22	0.22	0.22	0.22	0.22	0.42	0.42	0.42	0.65	0.65...
    0.65	0.65	0.65	0.42	0.42	0.42	0.65	0.65	0.65	0.42	0.42	0.42];
%储能电池参数定义
Ebattery = 300;
soc0     = 0.5;
socmin   = 0.3;
socmax   = 0.95;
Pcs      = 40 ;
POWER    = 160 ;

figure;
plot(Load      ,'-r^',...
                'Color',[1,0,0],...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
axis([1 24 0 240]) ;
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('功率(kw)','FontSize',16);
hold on; 

plot(Pw        ,'-gd',...
                'Color',[0,0,1],...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
axis([1 24 0 240]) ;
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('功率(kw)','FontSize',16);
hold on; 

plot(Ppv       ,'-mo',...
                'Color',[0,1,0],...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
axis([1 24 0 240]) ;
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('功率(kw)','FontSize',16);

legend('电负荷','风机预测出力','光伏预测出力',2);
%% 约束
for k = 1:24
  Constraints = [Constraints, -POWER<=Pnet(1,k)<=POWER,0<=Pbuy(1,k)<=POWER, -POWER<=Psell(1,k)<=0]; %主网功率交换约束，不大于160kW
  Constraints = [Constraints,Pnet(1,k)+Pw(1,k)+Ppv(1,k)==Load(1,k)+Pbat(1,k)];              %功率平衡约束   ，电网+风电+光伏 = 负载 + 电池充电
  Constraints = [Constraints, implies(Temp_net(1,k),[Pnet(1,k)>=0,Pbuy(1,k)==Pnet(1,k),Psell(1,k)==0])]; %购电情况约束   Pnet>0是购电，Pnet<0是售电电，
  Constraints = [Constraints, implies(1-Temp_net(1,k),[Pnet(1,k)<=0,Psell(1,k)==Pnet(1,k),Pbuy(1,k)==0])]; %售电情况约束
%----------------------蓄电池约束--------------------%
% sum_bat=zeros(1,24);
  Constraints = [Constraints, -Pcs<=Pbat(1,k)<=Pcs,0<=Pcha(1,k)<=Pcs,-Pcs<=Pdis(1,k)<=0];%电池充放电约束,PCS功率是40kW
  Constraints = [Constraints, implies(Temp_cha(1,k),[Pbat(1,k)>=0,Pcha(1,k)==Pbat(1,k),Pdis(1,k)==0])];%充电情况约束
  Constraints = [Constraints, implies(Temp_dis(1,k),[Pbat(1,k)<=0,Pdis(1,k)==Pbat(1,k),Pcha(1,k)==0])];%放电情况约束
  Constraints = [Constraints, implies(Temp_static(1,k),[Pbat(1,k)==0,Pdis(1,k)==0,Pcha(1,k)==0])];%静置情况约束
  Constraints = [Constraints,Temp_cha(1,k)+Temp_dis(1,k)+Temp_static(1,k)==1];
%    sum_bat(1,k+1)=sum_bat(1,k)+Pcha(1,k)+Pdis(1,k);%计算SOC
  Constraints=[Constraints,Ebattery*(socmin - soc0)<=sum(Pdis(1,1:k)+Pcha(1,1:k))<=Ebattery*(socmax - soc0)] ;%SOC约束，电池容量300kwh，初始S0C为0.4，0.3<=SOC<=0.95
end
  Constraints=[Constraints,sum(Pdis+Pcha)==0] ;%ST=S0，始末SOC相等约束
%% 目标函数
 F=0;
%------------------总费用--------------------%
for k = 1:24
  F = F + 0.52*Pw(:,k)+0.72*Ppv(:,k)+C_buy(:,k)*Pbuy(:,k)+C_sell(:,k)*Psell(1,k)+0.2*Pdis(1,k);
end
ops=sdpsettings('solver', 'cplex');%参数指定程序用cplex求解器
optimize(Constraints,F,ops);
disp(['总费用=']);value(F) 

%% 画图
x=1:24;
PP=[Pbuy;-Pdis;Pw;Ppv];
PP_neg=[Psell;-Pcha];
figure
bar(PP','stack');hold on;
h=legend('电网交换功率','蓄电池充电功率','风机出力','光伏出力',2);
set(h,'Orientation','horizon');
bar(PP_neg','stack');hold on;
plot(x,value(Load),'r','linewidth',2);
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:50:300));
ylabel('功率(kw)','FontSize',16);
hold off;

figure
plot(x,value(Pbuy+Psell),'-ro',...
                'Color',[1,0,0],...
                'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
hold on;
plot(x,value(Pdis+Pcha),'-gd',...
                'Color',[1,0,1],...
                'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
hold off;
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(-120:20:60));
ylabel('功率(kw)','FontSize',16);
h=legend('电网购售电功率 >0是购电 <0是售电','蓄电池充放电功率 >0是充电 <0是放电',3);

soc = zeros(1,25);
s = zeros(1,25);
soc(1)=soc0;
for k=1:24
    s(k)=value(sum(Pdis(1,1:k)+Pcha(1,1:k)))/Ebattery+soc0;
    soc(k+1)=s(k);
end
soc(1)=soc0;
xx=0:24;
figure
plot(xx,soc      ,'-ro',...
                'Color',[1,0,0],...
                'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
xlabel('时间(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0.2:0.1:1));
ylabel('soc值','FontSize',16);
title('蓄电池SOC状态');