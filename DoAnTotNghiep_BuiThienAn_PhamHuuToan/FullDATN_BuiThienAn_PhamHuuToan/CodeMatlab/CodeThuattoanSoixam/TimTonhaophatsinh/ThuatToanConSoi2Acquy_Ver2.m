clc; clear all;
a01 = 0.2657;
b01 = 6.7129;
a02 = 0.0601;
b02 = 8.2494;
J_bx = 0.2412;
J_cl = 1.2576;
r_bx = 0.235146;
r_cl = 0.1; 

% time=0:0.02:(1250*0.02);
%--------------------------Doc du lieu dap ung toc do------------------
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\data26_05\Solieudaxuly\CoastdownCaCum2AQ_15V.xlsx');
time_raw = data(:,5);
n_bx_tn_raw = data(:,4);
n_cl_tn_raw = data(:,2);
% w_tn = data(:,1);
w_cl_initial = data(1,2)*2*pi()/60;

% Chọn các chỉ số tại bước 0.2s (mỗi 10 điểm nếu bước là 0.02s)
step = 0.2;
idx = find(mod(time_raw, step) == 0);   % chỉ lấy các thời điểm chia hết cho 0.2

% Lọc dữ liệu
time = time_raw(idx);
n_bx_tn = n_bx_tn_raw(idx);
n_cl_tn = n_cl_tn_raw(idx);

%khoi tao bay soi
N = 100; %12 con soi
n_par = 5;
max_iteration = 20;
mina11 = 0.060773449736866;
maxa11 = 0.1;
minb11 = 1.576434187120628;
maxb11 = 5;
mina12 = 0.007150245075987;
maxa12 = 0.1;
minb12 = 0.153671177646358;
maxb12 = 5;
minTrr = 0.334273249247759;
maxTrr = 5;

p(:,1) = mina11*ones(N,1)+(maxa11-mina11)*rand(N,1);
p(:,2)= minb11*ones(N,1)+(maxb11-minb11)*rand(N,1);
p(:,3) = mina12*ones(N,1)+(maxa12-mina12)*rand(N,1);
p(:,4) = minb12*ones(N,1)+(maxb12-minb12)*rand(N,1);
p(:,5) = minTrr*ones(N,1)+(maxTrr-minTrr)*rand(N,1);

alpha=[mina11,minb11,mina12,minb12,minTrr];
alpha_score=inf;
beta=[mina11,minb11,mina12,minb12,minTrr];
beta_score=inf;
delta=[mina11,minb11,mina12,minb12,minTrr];
delta_score=inf;

alpha_score_history=zeros(max_iteration,1);
d_sum=zeros(max_iteration,1);
%}

startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);

for iter=1:1:max_iteration
    
    for i=1:1:N

        if(p(i,1)>maxa11 || p(i,1)<mina11)
            p(i,1)=mina11+(maxa11-mina11)*rand();
        end

        if(p(i,2)>maxb11 || p(i,2)<minb11)
            p(i,2)=minb11+(maxb11-minb11)*rand();
        end

        if(p(i,3)>maxa12 || p(i,3)<mina12)
            p(i,3)=mina12+(maxa12-mina12)*rand();
        end

        if(p(i,4)>maxb12 || p(i,4)<minb12)
            p(i,4)=minb12+(maxb12-minb12)*rand();
        end
     
        if(p(i,5)>maxTrr || p(i,5)<minTrr)
            p(i,5)=minTrr+(maxTrr-minTrr)*rand();
        end

        a11=p(i,1);
        b11=p(i,2);
        a12=p(i,3);
        b12=p(i,4);
        Trr= p(i,5);

        

        %-------------------Tinh sai so theo dap ung toc------------
        %-----------------------------------------------------------
        sim('CoastdownCaCum1AQ_Ver2');
        n_cl_mp=ans.n_cl.Data;
        i
        err=sum((n_cl_tn-n_cl_mp).^2)/length(time);
        %-------------------------------------------------------------

        %--------------------------------------------------------------
        if(err<alpha_score)
            alpha=p(i,:);
            alpha_score=err;
        end

        if(err>alpha_score && err<beta_score)
            beta=p(i,:);
            beta_score=err;
        end

        if(err>beta_score && err<delta_score)
            delta=p(i,:);
            delta_score=err;
        end
    end
    
    a=2-iter*2/max_iteration;
    for i=1:1:N
        r1=rand(1,n_par);
        r2=rand(1,n_par);
        A1=2*a*r1-a;
        C1=2*r2;
        D_alpha=abs(C1.*alpha-p(i,:));
        X1=alpha-A1.*D_alpha;

        r1=rand(1,n_par);
        r2=rand(1,n_par);
        A2=2*a*r1-a;
        C2=2*r2;
        D_beta=abs(C2.*beta-p(i,:));
        X2=beta-A2.*D_beta;

        r1=rand(1,n_par);
        r2=rand(1,n_par);
        A3=2*a*r1-a;
        C3=2*r2;
        D_delta=abs(C3.*delta-p(i,:));
        X3=delta-A3.*D_delta;

        p(i,:)=(X1+X2+X3)/3;
    end

    alpha_score_history(iter,1)=alpha_score;
    
    for k=1:1:N
        dx=p(k,1)-alpha(1,1);
        dy=p(k,2)-alpha(1,2);
        dz=p(k,3)-alpha(1,3);
        dt=p(k,4)-alpha(1,4);
        dm=p(k,5)-alpha(1,5);
        dis=sqrt(dx^2+dy^2+dz^2+dt^2+dm^2);
        d_sum(iter)=d_sum(iter)+dis;
    end
    d_sum(iter)=d_sum(iter)/N;
    iter
    save('BCS_CoastdownCaCum2AQ_Ver2_lan2.mat');
    
end

a11=alpha(1,1);
b11=alpha(1,2);
a12=alpha(1,3);
b12=alpha(1,4);
Trr=alpha(1,5);

startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);

sim('CoastdownCaCum1AQ_Ver2');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
n_bx_mp=ans.n_bx.Data;
subplot(2,1,1);
plot(time_mp,n_bx_mp,'r-');hold on;
plot(time, n_bx_tn,'b-');
title('So sánh tốc độ bánh xe giữa mô phỏng và thực nghiệm');
xlabel('Thời gian (s)');
ylabel('Tốc độ bánh xe (RPM)');
legend('Mô phỏng', 'Thực nghiệm');
grid on;
subplot(2,1,2);
plot(time_mp,n_cl_mp,'r-');hold on;
plot(time, n_cl_tn,'b-');
title('So sánh tốc độ con lăn giữa mô phỏng và thực nghiệm');
xlabel('Thời gian (s)');
ylabel('Tốc độ con lăn (RPM)');
legend('Mô phỏng', 'Thực nghiệm');
grid on;