%% ����ȷ��YALMIP�������CPLEX��ȷ��װ,MATLAB�����Ӧ�ļ��������޷����г��򣡣�
% https://yalmip.github.io/allcommands  ʹ�ð����ļ�

%% ��ʼ��
clc;
clear all;close all;
yalmip;
Cplex;
%% ����������������
%------------------------��������-----------------------%
Pw=sdpvar(1,24,'full'); %�������
Ppv=sdpvar(1,24,'full');%�������
Pbat=sdpvar(1,24,'full');%���س���
% Pde=sdpvar(1,24,'full');%���ͻ������
Pnet=sdpvar(1,24,'full');%��������
Pbuy=sdpvar(1,24,'full');%�ӵ����������
Psell=sdpvar(1,24,'full');%������۵����
Temp_net=binvar(1,24,'full'); % ��|�۵��־
Temp_cha=binvar(1,24,'full'); %����־
Temp_dis=binvar(1,24,'full'); %�ŵ��־
Temp_static=binvar(1,24,'full'); %��ؾ��ñ�־
% Temp_de=binvar(1,24,'full'); %���ͻ������־
Pcha=sdpvar(1,24);
Pdis=sdpvar(1,24);
Constraints = [];
%-------------------------��������-----------------------%
Load=[88.24 	83.01 	80.15 	79.01 	76.07 	78.39 	89.95 	128.85 	155.45 	176.35 	193.71 	182.57 	179.64 	166.31 	164.61 	164.61 	174.48 	203.93 	218.99 	238.11 	216.14 	173.87 	131.07 	94.04];
%���Ԥ�����
Pw=[66.9	68.2	71.9	72	78.8	94.8	114.3	145.1	155.5	142.1	115.9	127.1	141.8	145.6...
    145.3	150	206.9	225.5	236.1	210.8	198.6	177.9	147.2	58.7];
%���Ԥ�����
Ppv=[0	0	0	0	0.06	6.54	20.19	39.61	49.64	88.62	101.59	66.78	110.46	67.41	31.53...
    50.76	20.6	22.08	2.07	0	0	0	0	0];
%��ʱ���
C_buy=[0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.53	0.53	0.53	0.82	0.82...
    0.82	0.82	0.82	0.53	0.53	0.53	0.82	0.82	0.82	0.53	0.53	0.53];
C_sell=[0.22	0.22	0.22	0.22	0.22	0.22	0.22	0.42	0.42	0.42	0.65	0.65...
    0.65	0.65	0.65	0.42	0.42	0.42	0.65	0.65	0.65	0.42	0.42	0.42];
%���ܵ�ز�������
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
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('����(kw)','FontSize',16);
hold on; 

plot(Pw        ,'-gd',...
                'Color',[0,0,1],...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
axis([1 24 0 240]) ;
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('����(kw)','FontSize',16);
hold on; 

plot(Ppv       ,'-mo',...
                'Color',[0,1,0],...
                'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 0 1],...
                'MarkerSize',5);
axis([1 24 0 240]) ;
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:40:240));
ylabel('����(kw)','FontSize',16);

legend('�縺��','���Ԥ�����','���Ԥ�����',2);
%% Լ��
for k = 1:24
  Constraints = [Constraints, -POWER<=Pnet(1,k)<=POWER,0<=Pbuy(1,k)<=POWER, -POWER<=Psell(1,k)<=0]; %�������ʽ���Լ����������160kW
  Constraints = [Constraints,Pnet(1,k)+Pw(1,k)+Ppv(1,k)==Load(1,k)+Pbat(1,k)];              %����ƽ��Լ��   ������+���+��� = ���� + ��س��
  Constraints = [Constraints, implies(Temp_net(1,k),[Pnet(1,k)>=0,Pbuy(1,k)==Pnet(1,k),Psell(1,k)==0])]; %�������Լ��   Pnet>0�ǹ��磬Pnet<0���۵�磬
  Constraints = [Constraints, implies(1-Temp_net(1,k),[Pnet(1,k)<=0,Psell(1,k)==Pnet(1,k),Pbuy(1,k)==0])]; %�۵����Լ��
%----------------------����Լ��--------------------%
% sum_bat=zeros(1,24);
  Constraints = [Constraints, -Pcs<=Pbat(1,k)<=Pcs,0<=Pcha(1,k)<=Pcs,-Pcs<=Pdis(1,k)<=0];%��س�ŵ�Լ��,PCS������40kW
  Constraints = [Constraints, implies(Temp_cha(1,k),[Pbat(1,k)>=0,Pcha(1,k)==Pbat(1,k),Pdis(1,k)==0])];%������Լ��
  Constraints = [Constraints, implies(Temp_dis(1,k),[Pbat(1,k)<=0,Pdis(1,k)==Pbat(1,k),Pcha(1,k)==0])];%�ŵ����Լ��
  Constraints = [Constraints, implies(Temp_static(1,k),[Pbat(1,k)==0,Pdis(1,k)==0,Pcha(1,k)==0])];%�������Լ��
  Constraints = [Constraints,Temp_cha(1,k)+Temp_dis(1,k)+Temp_static(1,k)==1];
%    sum_bat(1,k+1)=sum_bat(1,k)+Pcha(1,k)+Pdis(1,k);%����SOC
  Constraints=[Constraints,Ebattery*(socmin - soc0)<=sum(Pdis(1,1:k)+Pcha(1,1:k))<=Ebattery*(socmax - soc0)] ;%SOCԼ�����������300kwh����ʼS0CΪ0.4��0.3<=SOC<=0.95
end
  Constraints=[Constraints,sum(Pdis+Pcha)==0] ;%ST=S0��ʼĩSOC���Լ��
%% Ŀ�꺯��
 F=0;
%------------------�ܷ���--------------------%
for k = 1:24
  F = F + 0.52*Pw(:,k)+0.72*Ppv(:,k)+C_buy(:,k)*Pbuy(:,k)+C_sell(:,k)*Psell(1,k)+0.2*Pdis(1,k);
end
ops=sdpsettings('solver', 'cplex');%����ָ��������cplex�����
optimize(Constraints,F,ops);
disp(['�ܷ���=']);value(F) 

%% ��ͼ
x=1:24;
PP=[Pbuy;-Pdis;Pw;Ppv];
PP_neg=[Psell;-Pcha];
figure
bar(PP','stack');hold on;
h=legend('������������','���س�繦��','�������','�������',2);
set(h,'Orientation','horizon');
bar(PP_neg','stack');hold on;
plot(x,value(Load),'r','linewidth',2);
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0:50:300));
ylabel('����(kw)','FontSize',16);
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
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(-120:20:60));
ylabel('����(kw)','FontSize',16);
h=legend('�������۵繦�� >0�ǹ��� <0���۵�','���س�ŵ繦�� >0�ǳ�� <0�Ƿŵ�',3);

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
xlabel('ʱ��(h)','FontSize',16);
set(gca,'xTick',(1:2:24),'yTick',(0.2:0.1:1));
ylabel('socֵ','FontSize',16);
title('����SOC״̬');