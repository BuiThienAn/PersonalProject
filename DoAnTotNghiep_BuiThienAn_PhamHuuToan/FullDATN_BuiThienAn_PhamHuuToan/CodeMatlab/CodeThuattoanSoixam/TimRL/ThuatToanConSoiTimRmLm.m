clc; clear all;
%--------------------------Doc du lieu dap ung toc do------------------
data = xlsread('D:\MATLAB_23_5\MATLAB\Tangapcumdongluc567V.xlsx');
time_raw = data(:,1);
v_raw = data(:,2);
i_raw = data(:,3);
n_bx_raw = data(:,4);

% Thông số lấy mẫu
step = 0.02;
time_max = 20;
epsilon = 1e-6;

% Chọn các chỉ số tại bước 0.2s trong khoảng từ 0 đến 20s
idx = find(abs(mod(time_raw, step)) < epsilon & time_raw <= time_max);

% Lọc dữ liệu
time = time_raw(idx);
v_tn = v_raw(idx);
i_tn = i_raw(idx);
n_bx_tn = n_bx_raw(idx);

%khoi tao bay soi
N = 100; %12 con soi
n_par = 2; %số ẩn
max_iteration = 20;
minLm = 10^(-5);
maxLm = 10^(-3);
minRm = 0.01;
maxRm = 0.2;
% mina12 = 0.00;
% maxa12 = 0.1;
% minb12 = 0;
% maxb12 = 5;


p(:,1) = minLm*ones(N,1)+(maxLm-minLm)*rand(N,1);
p(:,2)= minRm*ones(N,1)+(maxRm-minRm)*rand(N,1);
% p(:,3) = mina12*ones(N,1)+(maxa12-mina12)*rand(N,1);
% p(:,4) = minb12*ones(N,1)+(maxb12-minb12)*rand(N,1);

alpha=[minLm,minRm];
alpha_score=inf;
beta=[minLm,minRm];
beta_score=inf;
delta=[minLm,minRm];
delta_score=inf;

% 
% alpha=[alpha(1,1), alpha(1,2)];
% alpha_score=alpha_score;
% beta=[beta(1,1), beta(1,2)];
% beta_score=beta_score;
% delta=[delta(1,1), delta(1,2)];
% delta_score=delta_score;

alpha_score_history=zeros(max_iteration,1);
d_sum=zeros(max_iteration,1);
%}

startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('TangapCumdongluc', 'StartTime', startTime, 'StopTime', stopTime);

for iter=1:1:max_iteration
    
    for i=1:1:N

        if(p(i,1)>maxLm || p(i,1)<minLm)
            p(i,1)=minLm+(maxLm-minLm)*rand();
        end

        if(p(i,2)>maxRm || p(i,2)<minRm)
            p(i,2)=minRm+(maxRm-minRm)*rand();
        end
        % 
        % if(p(i,3)>maxa12 || p(i,3)<mina12)
        %     p(i,3)=mina12+(maxa12-mina12)*rand();
        % end
        % 
        % if(p(i,4)>maxb12 || p(i,4)<minb12)
        %     p(i,4)=minb12+(maxb12-minb12)*rand();
        % end
     
        Lm=p(i,1);
        Rm=p(i,2);
        % b11=p(i,2);
        % a12=p(i,3);
        % b12=p(i,4);

        

        %-------------------Tinh sai so theo dap ung toc------------
        %-----------------------------------------------------------
        sim('TangapCumdongluc');
        n_bx_full = ans.n_bx;
        n_bx_mp = interp1(n_bx_full.Time, n_bx_full.Data, time, 'linear');
        i
        err=sum((n_bx_tn-n_bx_mp).^2)/length(time);
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
        % dz=p(k,3)-alpha(1,3);
        % dt=p(k,4)-alpha(1,4);
        dis=sqrt(dx^2+dy^2);
        d_sum(iter)=d_sum(iter)+dis;
    end
    d_sum(iter)=d_sum(iter)/N;
    iter
    % save('BCS_DulieuRmLm.mat');
    
end

Lm=alpha(1,1);
Rm=alpha(1,2);

sim('TangapCumdongluc');
time_mp = ans.n_bx.Time;
n_bx_mp = ans.n_bx.Data;

plot(time_mp, n_bx_mp, 'r-'); hold on;
plot(time, n_bx_tn, 'b-');

title('So sánh tốc độ bánh xe giữa mô phỏng và thực nghiệm');
xlabel('Thời gian (s)');
ylabel('Tốc độ bánh xe (RPM)');
legend('Mô phỏng', 'Thực nghiệm');
grid on;