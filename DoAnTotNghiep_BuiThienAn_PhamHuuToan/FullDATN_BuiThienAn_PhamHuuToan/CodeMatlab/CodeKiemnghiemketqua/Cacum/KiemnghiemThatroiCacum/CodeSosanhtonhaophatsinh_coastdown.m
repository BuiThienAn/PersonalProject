%15V 1AQ
load('BCS_CoastdownCaCum1AQ_Ver2_lan2.mat');
a11=alpha(1,1);
b11=alpha(1,2);
a12=alpha(1,3);
b12=alpha(1,4);
Trr=alpha(1,5);

% data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\data26_05\Solieudaxuly\CoastdownCaCum1AQ15V.xlsx');
% time_raw = data(:,5);
% n_bx_tn_raw = data(:,4);
% n_cl_tn_raw = data(:,2);
% % w_tn = data(:,1);
% 
% 
% % Chọn các chỉ số tại bước 0.2s (mỗi 10 điểm nếu bước là 0.02s)
% step = 0.2;
% idx = find(mod(time_raw, step) == 0);   % chỉ lấy các thời điểm chia hết cho 0.2
% 
% % Lọc dữ liệu
% time = time_raw(idx);
% n_bx_tn = n_bx_tn_raw(idx);
% n_cl_tn = n_cl_tn_raw(idx);


startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);

sim('CoastdownCaCum1AQ_Ver2');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
n_bx_mp=ans.n_bx.Data;
n_cl_mp2 = n_cl_mp(1:end);
n_bx_mp2 = n_bx_mp(1:end);
n_cl_tn2 = n_cl_tn(1:end);
n_bx_tn2 = n_bx_tn(1:end);

% Tính err
err_cl = abs((n_cl_mp2 - n_cl_tn2) ./ n_cl_tn2) .* 100;
avg_err_cl = mean(err_cl);
% Tính err
err_bx = abs((n_bx_mp2 - n_bx_tn2) ./ n_bx_tn2) .* 100;
avg_err_bx = mean(err_bx);

% Hiển thị R^2 trên Command Window
fprintf('Sai số con lăn 1AQ= %.4f\n', avg_err_cl);
fprintf('Sai số bánh xe 1AQ= %.4f\n', avg_err_bx);

subplot(2,1,1);
plot(time_mp,n_bx_mp,'r-', 'LineWidth', 2);hold on;
plot(time, n_bx_tn,'b-', 'LineWidth', 2);hold on;
title('Đồ thị so sánh tốc độ bánh xe', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', 'Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
% % Chèn chữ "19V" tại thời điểm t = 1s
% t_chu = 2;  % thời gian muốn đặt chữ
% idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% text(time(idx), n_bx_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');

subplot(2,1,2);
plot(time_mp,n_cl_mp,'r-', 'LineWidth', 2);hold on;
plot(time, n_cl_tn,'b-', 'LineWidth', 2); hold on;
title('Đồ thị so sánh tốc độ con lăn', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', 'Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
% Chèn chữ "19V" tại thời điểm t = 1s
% t_chu = 2;  % thời gian muốn đặt chữ
% idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% text(time(idx), n_cl_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');

%15V 2AQ
load('BCS_CoastdownCaCum2AQ_Ver2_lan2.mat');
a11=alpha(1,1);
b11=alpha(1,2);
a12=alpha(1,3);
b12=alpha(1,4);
Trr=alpha(1,5);

% data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\data26_05\Solieudaxuly\CoastdownCaCum1AQ15V.xlsx');
% time_raw = data(:,5);
% n_bx_tn_raw = data(:,4);
% n_cl_tn_raw = data(:,2);
% % w_tn = data(:,1);
% 
% 
% % Chọn các chỉ số tại bước 0.2s (mỗi 10 điểm nếu bước là 0.02s)
% step = 0.2;
% idx = find(mod(time_raw, step) == 0);   % chỉ lấy các thời điểm chia hết cho 0.2
% 
% % Lọc dữ liệu
% time = time_raw(idx);
% n_bx_tn = n_bx_tn_raw(idx);
% n_cl_tn = n_cl_tn_raw(idx);
w_cl_initial = n_cl_tn(1,1)*2*pi()/60;

startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);

sim('CoastdownCaCum1AQ_Ver2');
time_mp = ans.n_cl.Time;
n_cl_mp=ans.n_cl.Data;
n_bx_mp=ans.n_bx.Data;
n_cl_mp2 = n_cl_mp(1:end);
n_bx_mp2 = n_bx_mp(1:end);
n_cl_tn2 = n_cl_tn(1:end);
n_bx_tn2 = n_bx_tn(1:end);

% Tính err
err_cl = abs((n_cl_mp2 - n_cl_tn2) ./ n_cl_tn2) .* 100;
avg_err_cl = mean(err_cl);
% Tính err
err_bx = abs((n_bx_mp2 - n_bx_tn2) ./ n_bx_tn2) .* 100;
avg_err_bx = mean(err_bx);

% Hiển thị R^2 trên Command Window
fprintf('Sai số con lăn 2AQ= %.4f\n', avg_err_cl);
fprintf('Sai số bánh xe 2AQ= %.4f\n', avg_err_bx);

subplot(2,1,1);
plot(time_mp,n_bx_mp,'m-', 'LineWidth', 2);hold on;
plot(time, n_bx_tn,'g-', 'LineWidth', 2);
title('Đồ thị so sánh tốc độ bánh xe', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', 'Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;
% % Chèn chữ "19V" tại thời điểm t = 1s
% t_chu = 2;  % thời gian muốn đặt chữ
% idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% text(time(idx), n_bx_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');

subplot(2,1,2);
plot(time_mp,n_cl_mp,'m-', 'LineWidth', 2);hold on;
plot(time, n_cl_tn,'g-', 'LineWidth', 2);
title('Đồ thị so sánh tốc độ con lăn', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', 'Mô phỏng 2 ắc quy', 'Thực nghiệm 2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;

% %8V 1AQ
% load('BCS_CoastdownCaCum1AQ_Ver2_lan2.mat');
% a11=alpha(1,1);
% b11=alpha(1,2);
% a12=alpha(1,3);
% b12=alpha(1,4);
% Trr=alpha(1,5);
% 
% data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\data26_05\Solieudaxuly\CoastdownCacum1AQ_8V.xlsx');
% time_raw = data(:,5);
% n_bx_tn_raw = data(:,4);
% n_cl_tn_raw = data(:,2);
% % w_tn = data(:,1);
% 
% 
% % Chọn các chỉ số tại bước 0.2s (mỗi 10 điểm nếu bước là 0.02s)
% step = 0.2;
% idx = find(mod(time_raw, step) == 0);   % chỉ lấy các thời điểm chia hết cho 0.2
% 
% % Lọc dữ liệu
% time = time_raw(idx);
% n_bx_tn = n_bx_tn_raw(idx);
% n_cl_tn = n_cl_tn_raw(idx);
% w_cl_initial = n_cl_tn(1,1)*2*pi()/60;
% 
% startTime = num2str(time(1));
% stopTime = num2str(time(end));
% 
% set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);
% 
% sim('CoastdownCaCum1AQ_Ver2');
% time_mp = ans.n_cl.Time;
% n_cl_mp=ans.n_cl.Data;
% n_bx_mp=ans.n_bx.Data;
% n_cl_mp2 = n_cl_mp(1:end);
% n_bx_mp2 = n_bx_mp(1:end);
% n_cl_tn2 = n_cl_tn(1:end);
% n_bx_tn2 = n_bx_tn(1:end);
% 
% % Tính err
% err_cl = abs((n_cl_mp2 - n_cl_tn2) ./ n_cl_tn2) .* 100;
% avg_err_cl = mean(err_cl);
% % Tính err
% err_bx = abs((n_bx_mp2 - n_bx_tn2) ./ n_bx_tn2) .* 100;
% avg_err_bx = mean(err_bx);
% 
% % Hiển thị R^2 trên Command Window
% fprintf('Sai số con lăn 1AQ= %.4f\n', avg_err_cl);
% fprintf('Sai số bánh xe 1AQ= %.4f\n', avg_err_bx);
% 
% subplot(2,1,1);
% plot(time_mp,n_bx_mp,'r-', 'LineWidth', 2);hold on;
% plot(time, n_bx_tn,'b-', 'LineWidth', 2);hold on;
% title('Đồ thị so sánh tốc độ bánh xe', 'FontSize', 16);
% xlabel('Thời gian (s)', 'FontSize', 14);
% ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 14);
% legend('Mô phỏng trường hợp tải 1 ắc quy', 'Thực nghiệm trường hợp tải 1 ắc quy', 'Mô phỏng trường hợp tải 2 ắc quy', 'Thực nghiệm trường hợp tải 2 ắc quy', 'FontSize', 12);
% grid on;
% % % Chèn chữ "19V" tại thời điểm t = 1s
% % t_chu = 2;  % thời gian muốn đặt chữ
% % idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% % text(time(idx), n_bx_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
% 
% subplot(2,1,2);
% plot(time_mp,n_cl_mp,'r-', 'LineWidth', 2);hold on;
% plot(time, n_cl_tn,'b-', 'LineWidth', 2); hold on;
% title('Đồ thị so sánh tốc độ con lăn', 'FontSize', 16);
% xlabel('Thời gian (s)', 'FontSize', 14);
% ylabel('Tốc độ con lăn (RPM)', 'FontSize', 14);
% legend('Mô phỏng trường hợp tải 1 ắc quy', 'Thực nghiệm trường hợp tải 1 ắc quy', 'Mô phỏng trường hợp tải 2 ắc quy', 'Thực nghiệm trường hợp tải 2 ắc quy','FontSize', 12);
% grid on;
% % Chèn chữ "19V" tại thời điểm t = 1s
% t_chu = 2;  % thời gian muốn đặt chữ
% idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% text(time(idx), n_cl_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');

% %8V 2AQ
% load('BCS_CoastdownCaCum2AQ_Ver2_lan2.mat');
% a11=alpha(1,1);
% b11=alpha(1,2);
% a12=alpha(1,3);
% b12=alpha(1,4);
% Trr=alpha(1,5);
% 
% data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\data26_05\Solieudaxuly\CoastdownCacum2AQ_8V.xlsx');
% time_raw = data(:,5);
% n_bx_tn_raw = data(:,4);
% n_cl_tn_raw = data(:,2);
% % w_tn = data(:,1);
% 
% 
% % Chọn các chỉ số tại bước 0.2s (mỗi 10 điểm nếu bước là 0.02s)
% step = 0.2;
% idx = find(mod(time_raw, step) == 0);   % chỉ lấy các thời điểm chia hết cho 0.2
% 
% % Lọc dữ liệu
% time = time_raw(idx);
% n_bx_tn = n_bx_tn_raw(idx);
% n_cl_tn = n_cl_tn_raw(idx);
% w_cl_initial = n_cl_tn(1,1)*2*pi()/60;
% 
% startTime = num2str(time(1));
% stopTime = num2str(time(end));
% 
% set_param('CoastdownCaCum1AQ_Ver2', 'StartTime', startTime, 'StopTime', stopTime);
% 
% sim('CoastdownCaCum1AQ_Ver2');
% time_mp = ans.n_cl.Time;
% n_cl_mp=ans.n_cl.Data;
% n_bx_mp=ans.n_bx.Data;
% n_cl_mp2 = n_cl_mp(1:end);
% n_bx_mp2 = n_bx_mp(1:end);
% n_cl_tn2 = n_cl_tn(1:end);
% n_bx_tn2 = n_bx_tn(1:end);
% 
% % Tính err
% err_cl = abs((n_cl_mp2 - n_cl_tn2) ./ n_cl_tn2) .* 100;
% avg_err_cl = mean(err_cl);
% % Tính err
% err_bx = abs((n_bx_mp2 - n_bx_tn2) ./ n_bx_tn2) .* 100;
% avg_err_bx = mean(err_bx);
% 
% % Hiển thị R^2 trên Command Window
% fprintf('Sai số con lăn 2AQ= %.4f\n', avg_err_cl);
% fprintf('Sai số bánh xe 2AQ= %.4f\n', avg_err_bx);
% 
% subplot(2,1,1);
% plot(time_mp,n_bx_mp,'m-', 'LineWidth', 2);hold on;
% plot(time, n_bx_tn,'g-', 'LineWidth', 2);
% title('Đồ thị so sánh tốc độ bánh xe', 'FontSize', 16);
% xlabel('Thời gian (s)', 'FontSize', 14);
% ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 14);
% legend('Mô phỏng trường hợp tải 1 ắc quy', 'Thực nghiệm trường hợp tải 1 ắc quy', 'Mô phỏng trường hợp tải 2 ắc quy', 'Thực nghiệm trường hợp tải 2 ắc quy', 'FontSize', 12);
% grid on;
% % % Chèn chữ "19V" tại thời điểm t = 1s
% % t_chu = 2;  % thời gian muốn đặt chữ
% % idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
% % text(time(idx), n_bx_mp(idx) + 20, 'Trường hợp tải 1 ắc quy', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
% 
% subplot(2,1,2);
% plot(time_mp,n_cl_mp,'m-', 'LineWidth', 2);hold on;
% plot(time, n_cl_tn,'g-', 'LineWidth', 2);
% title('Đồ thị so sánh tốc độ con lăn', 'FontSize', 16);
% xlabel('Thời gian (s)', 'FontSize', 14);
% ylabel('Tốc độ con lăn (RPM)', 'FontSize', 14);
% legend('Mô phỏng trường hợp tải 1 ắc quy', 'Thực nghiệm trường hợp tải 1 ắc quy', 'Mô phỏng trường hợp tải 2 ắc quy', 'Thực nghiệm trường hợp tải 2 ắc quy','FontSize', 12);
% grid on;