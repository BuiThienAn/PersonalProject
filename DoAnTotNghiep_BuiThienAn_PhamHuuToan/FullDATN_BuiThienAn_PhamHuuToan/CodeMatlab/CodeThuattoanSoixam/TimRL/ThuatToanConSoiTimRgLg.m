clc; clear all;
%--------------------------Doc du lieu dap ung toc do------------------
data = xlsread('D:\MATLAB_23_5\MATLAB\DataTangApCumTaoTai.xlsx');
time_raw = data(:,1);
v_raw = data(:,2);
i_raw = data(:,3);
n_cl_raw = data(:,4);

% Thông số lấy mẫu
step = 0.2;
time_max = 150;
epsilon = 1e-6;

% Chọn các chỉ số tại bước 0.2s trong khoảng từ 0 đến 100s
idx = find(abs(mod(time_raw, step)) < epsilon & time_raw <= time_max);

% Lọc dữ liệu
time = time_raw(idx);
v_tn = v_raw(idx);
i_tn = i_raw(idx);
n_cl_tn = n_cl_raw(idx);

%khoi tao bay soi
N = 100; %số con soi
n_par = 2;
max_iteration = 20;
minLg = 10^(-5);
maxLg = 10^(-3);
minRg = 0.01;
maxRg = 0.2;
% mina12 = 0.00;
% maxa12 = 0.1;minb11
% minb12 = 0;
% maxb12 = 5;

p(:,1) = minLg*ones(N,1)+(maxLg-minLg)*rand(N,1);
p(:,2)= minRg*ones(N,1)+(maxRg-minRg)*rand(N,1);
% p(:,3) = mina12*ones(N,1)+(maxa12-mina12)*rand(N,1);
% p(:,4) = minb12*ones(N,1)+(maxb12-minb12)*rand(N,1);

alpha=[minLg, minRg];
alpha_score=inf;
beta=[minLg, minRg];
beta_score=inf;
delta=[minLg, minRg];
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

set_param('TangapCumTaoTai', 'StartTime', startTime, 'StopTime', stopTime);

for iter=1:1:max_iteration
    
    for i=1:1:N

        if(p(i,1)>maxLg || p(i,1)<minLg)
            p(i,1)=minLg+(maxLg-minLg)*rand();
        end

        if(p(i,2)>maxRg || p(i,2)<minRg)
            p(i,2)=minRg+(maxRg-minRg)*rand();
        end
        % 
        % if(p(i,3)>maxa12 || p(i,3)<mina12)
        %     p(i,3)=mina12+(maxa12-mina12)*rand();
        % end
        % 
        % if(p(i,4)>maxb12 || p(i,4)<minb12)
        %     p(i,4)=minb12+(maxb12-minb12)*rand();
        % end
     
        Lg=p(i,1);
        Rg=p(i,2);
        % a12=p(i,3);
        % b12=p(i,4);

        

        %-------------------Tinh sai so theo dap ung toc------------
        %-----------------------------------------------------------
        sim('TangapCumTaoTai');
        n_cl_full = ans.n_cl;
        n_cl_mp = interp1(n_cl_full.Time, n_cl_full.Data, time, 'linear');
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
        % dz=p(k,3)-alpha(1,3);
        % dt=p(k,4)-alpha(1,4);
        dis=sqrt(dx^2 + dy^2);
        d_sum(iter)=d_sum(iter)+dis;
    end
    d_sum(iter)=d_sum(iter)/N;
    iter
    % save('BCS_DulieuRgLg_attempt2.mat');
    
end

Lg=alpha(1,1);
Rg=alpha(1,2);

sim('TangapCumTaoTai');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
plot(time_mp,n_cl_mp,'r-');hold on;
plot(time, n_cl_tn,'b-');

title('So sánh tốc độ con lăn giữa mô phỏng và thực nghiệm');
xlabel('Thời gian (s)');
ylabel('Tốc độ con lăn (RPM)');
legend('Mô phỏng', 'Thực nghiệm');
grid on;