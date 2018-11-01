[num,txt,raw] = xlsread('results.csv');
p0=num(18:end,3:8);t0=num(18:end,10:11);
p1=num(1:17,3:8);t1=num(1:17,10:11);
p=p0';t=t0';pl=p1';tl=t1';
[pn,inputStr] = mapminmax(p);
[tn,outputStr] = mapminmax(t);
net = newff(pn,tn,[4], {'tansig', 'purelin'},'traingdm');%������������4��12ȡֵ
net.trainParam.show = 10;%ÿ���10����ʾһ��ѵ�����
net.trainParam.epochs = 10000;%�������ѵ������5000��
net.trainParam.lr = 0.01;%ѧϰ���ʶ���traingdm�Ⱥ���������BP���磬ѧϰ����һ��ȡ0.01-0.1֮�䡣һ��û���ض���ʲô���ɣ�������ľ���ģ�ͣ������ı��������Ч�� 
net.trainParam.goal = 0.08;%ѵ��Ŀ��Ҫ�ﵽ�����ֵ��һ����1e-3net.divideFcn = '';
net.divideFcn = '';%��������������6�ε�����û�仯����matlab��Ĭ����ֹѵ����Ϊ���ó���������У�������ȡ����������
[net,tr] = train(net, pn, tn);%[net,tr]=train(net,P,T)net=init(net);��ʼ��������
A = sim(net,pn);
a = mapminmax('reverse', A, outputStr);
figure(1);
subplot(2, 1, 1); plot(1:length(t),a(1,:),':og',1:length(t), t(1,:), '-*');
legend('�����������Ľ��', 'ʵ�ʵĽ��');
xlabel('��������'); ylabel('�ڶ����ǵ���');
title('����������뼰ʵ�ʶԱ�ͼ');
grid on;
subplot(2, 1, 2);plot(1:length(t),a(2,:),':og',1:length(t), t(2,:), '-*');
legend('�����������Ľ��', 'ʵ�ʵĽ��');
xlabel('��������'); ylabel('�ڶ������̼�');
title('����������뼰ʵ�ʶԱ�ͼ');

plotperf(tr);%����ÿ��ѵ���������������ͼ

newinput = p1';
newinput = mapminmax('apply', newinput, inputStr);
newoutput = sim(net, newinput);
newoutput = mapminmax('reverse',newoutput, outputStr);
figure(2);
subplot(2, 1, 1);
plot(1:length(t1),newoutput(1,:),'g+',1:length(t1),tl(1,:),'b*');
legend('����Ԥ������Ľ��', 'ʵ�ʵĽ��');
xlabel('��������'); ylabel('�ڶ����ǵ���');
title('������Ԥ���뼰ʵ�ʶԱ�ͼ');
grid on;
subplot(2, 1, 2);plot(1:length(t1),newoutput(2,:),'-g+',1:length(t1), tl(2,:), '-b*');
legend('����Ԥ������Ľ��', 'ʵ�ʵĽ��');xlabel('��������'); ylabel('�ڶ������̼�');title('������Ԥ���뼰ʵ�ʶԱ�ͼ');

E=tl-newoutput;
E1=tl(1,:)-newoutput(1,:);
E2=tl(2,:)-newoutput(2,:);
MSE1=mse(E1)%������������Ϊ���ԵĲο�ָ��
MSE2=mse(E2)
MSE=mse(E)
