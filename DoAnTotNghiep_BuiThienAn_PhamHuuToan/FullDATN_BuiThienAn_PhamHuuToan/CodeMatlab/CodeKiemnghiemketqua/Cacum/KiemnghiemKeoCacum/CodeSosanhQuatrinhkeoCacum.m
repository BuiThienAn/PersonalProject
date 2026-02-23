%1 ắc quy
a01 = 0.2657;
b01 = 6.7129;
a11 = 0.060773449736866;
b11= 1.576434187120628;
a02 = 0.0601;
b02 = 8.2494;
a12 = 0.007150245075987;
b12 = 0.153671177646358;
J_bx = 0.2412;
J_cl = 1.2576;
r_bx = 0.245;
r_cl = 0.1; 
Trr = 0.334273249247759;
Rm=0.059792307934437;
Lm=2.247926023878100e-05;
ke_m=0.0413;
kt_m=0.0362;
K = 1;


data = xlsread('C:\Users\Legion\Downloads\Data DATN 26-5\Cacum\TangapCoastdownCacum1AQ_full.xlsx');
time_raw = data(:,1);
n_bx_tn_raw = data(:,5);
n_cl_tn_raw = data(:,4);
% w_tn = data(:,1);
% initial_w_bx = data(1,2)*2*pi()/60;

% Thông số lấy mẫu
step = 0.02;
time_max = 400;
epsilon = 1e-6;

% Chọn các chỉ số tại bước 0.2s trong khoảng từ 0 đến 20s
idx = find(abs(mod(time_raw, step)) < epsilon & time_raw <= time_max);

% Lọc dữ liệu
time = time_raw(idx);
n_bx_tn = n_bx_tn_raw(idx);
n_cl_tn = n_cl_tn_raw(idx);
startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('TangapCaCum1Acquy', 'StartTime', startTime, 'StopTime', stopTime);

sim('TangapCaCum1Acquy');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
n_bx_mp=ans.n_bx.Data;

% Lấy mỗi 80 giá trị một lần từ n_bx_mp
n_bx_mp_sampled = n_bx_mp(1:100:end);
n_bx_mp_sampled2 = n_bx_mp_sampled(20:end);
n_bx_tn2 = n_bx_tn(20:end);
n_cl_mp_sampled = n_cl_mp(1:100:end);
n_cl_mp_sampled2 = n_cl_mp_sampled(23:end);
n_cl_tn2 = n_cl_tn(23:end);
time_mp_sampled = time_mp(1:100:end);  % nếu bạn cần thời gian tương ứng


% Tính R^2
avr_bx = abs((n_bx_tn2 - n_bx_mp_sampled2) ./ n_bx_tn2) * 100;
err_bx =mean(abs((n_bx_tn2 - n_bx_mp_sampled2) ./ n_bx_tn2)) * 100;

avr_cl = abs((n_cl_tn2 - n_cl_mp_sampled2) ./ n_cl_tn2) * 100;
err_cl =mean(abs((n_cl_tn2 - n_cl_mp_sampled2) ./ n_cl_tn2)) * 100;
% Hiển thị R^2 trên Command Window
fprintf('Sai số bx 1 aq = %.4f\n', err_bx);
fprintf('Sai số cl 1 aq = %.4f\n', err_cl);

subplot(2,1,1);
plot(time_mp,n_bx_mp,'r-', 'LineWidth', 2);hold on;
plot(time, n_bx_tn,'b-', 'LineWidth', 2);
title('So sánh tốc độ bánh xe giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy','Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold', 'Location', 'southeast');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;
subplot(2,1,2);
plot(time_mp,n_cl_mp,'r-', 'LineWidth', 2);hold on;
plot(time, n_cl_tn,'b-', 'LineWidth', 2);
title('So sánh tốc độ con lăn giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy','Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold', 'Location', 'southeast');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;

%2 ắc quy
a01 = 0.2657;
b01 = 6.7129;
a11 =0.060931880707401;
b11=1.820843001248018;
a02 = 0.0601;
b02 = 8.2494;
a12=0.007408672590184;
b12=0.270086806664839;
J_bx = 0.2412;
J_cl = 1.2576;
r_bx = 0.245;
r_cl = 0.1; 
Trr=0.374661159089003;
Rm=0.059792307934437;
Lm=2.247926023878100e-05;
ke_m=0.0413;
kt_m=0.0362;
K = 1;


data = xlsread('C:\Users\Legion\Downloads\Data DATN 26-5\Cacum\TangapCoastdownCacum2AQ_full.xlsx');
time_raw = data(:,1);
n_bx_tn_raw = data(:,5);
n_cl_tn_raw = data(:,4);
% w_tn = data(:,1);
% initial_w_bx = data(1,2)*2*pi()/60;

% Thông số lấy mẫu
step = 0.02;
time_max = 400;
epsilon = 1e-6;

% Chọn các chỉ số tại bước 0.2s trong khoảng từ 0 đến 20s
idx = find(abs(mod(time_raw, step)) < epsilon & time_raw <= time_max);

% Lọc dữ liệu
time = time_raw(idx);
n_bx_tn = n_bx_tn_raw(idx);
n_cl_tn = n_cl_tn_raw(idx);
startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('TangapCaCum2Acquy', 'StartTime', startTime, 'StopTime', stopTime);

sim('TangapCaCum2Acquy');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
n_bx_mp=ans.n_bx.Data;

% Lấy mỗi 80 giá trị một lần từ n_bx_mp
n_bx_mp_sampled = n_bx_mp(1:100:end);
n_bx_mp_sampled2 = n_bx_mp_sampled(23:end);
n_bx_tn2 = n_bx_tn(23:end);
n_cl_mp_sampled = n_cl_mp(1:100:end);
n_cl_mp_sampled2 = n_cl_mp_sampled(20:end);
n_cl_tn2 = n_cl_tn(20:end);
time_mp_sampled = time_mp(1:100:end);  % nếu bạn cần thời gian tương ứng


% Tính R^2
avr_bx = abs((n_bx_tn2 - n_bx_mp_sampled2) ./ n_bx_tn2) * 100;
err_bx =mean(abs((n_bx_tn2 - n_bx_mp_sampled2) ./ n_bx_tn2)) * 100;

avr_cl = abs((n_cl_tn2 - n_cl_mp_sampled2) ./ n_cl_tn2) * 100;
err_cl =mean(abs((n_cl_tn2 - n_cl_mp_sampled2) ./ n_cl_tn2)) * 100;
% Hiển thị R^2 trên Command Window
fprintf('Sai số bx 2 aq = %.4f\n', err_bx);
fprintf('Sai số cl 2 aq = %.4f\n', err_cl);

subplot(2,1,1);
plot(time_mp,n_bx_mp,'m-', 'LineWidth', 2);hold on;
plot(time, n_bx_tn,'g-', 'LineWidth', 2);
title('So sánh tốc độ bánh xe giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy','Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold', 'Location', 'southeast');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;
subplot(2,1,2);
plot(time_mp,n_cl_mp,'m-', 'LineWidth', 2);hold on;
plot(time, n_cl_tn,'g-', 'LineWidth', 2);
title('So sánh tốc độ con lăn giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy','Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold', 'Location', 'southeast');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;
