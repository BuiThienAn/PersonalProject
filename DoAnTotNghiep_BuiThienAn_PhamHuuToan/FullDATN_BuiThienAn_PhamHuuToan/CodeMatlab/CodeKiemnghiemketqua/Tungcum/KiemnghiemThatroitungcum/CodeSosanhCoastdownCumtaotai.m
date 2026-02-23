%Cụm tạo tải 7V
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Data DTAN 14-5\CumTaoTai\Coastdowncumtaotai_7V.xlsx');
w_tn = data(:,2);
initial = data(1,2)*2*pi()/60;
Tst = 2;
time=0:0.02:(5791*0.02);
a = 0.0601;
b = 8.2494;
J = 1.2576;
sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Test\MoHinhCoastDownChung.slx',time);
w_mp = ans.n_coastdown.Data;
w_mp2 = w_mp(1:3600);
w_tn2 = w_tn(1:3600);

% Tính err
err = abs((w_tn2 - w_mp2) ./ w_tn2) .* 100;
avg_err = mean(err);

% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', avg_err);

plot(time, w_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, w_tn, 'b-', 'LineWidth', 2);
ylim([0 1200]);

xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
title('Đồ thị kiểm nghiệm tổn hao ban đầu và quán tính cụm tạo tải', 'FontSize', 25, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y

% Chèn chữ "19V" tại thời điểm t = 1s
t_chu = 20;  % thời gian muốn đặt chữ
idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
text(time(idx), w_mp(idx) + 20, '7V', 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold');

%Cụm tạo tải 9V
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Data DTAN 14-5\CumTaoTai\Coastdowncumtaotai_9V.xlsx');
w_tn = data(:,2);
initial = data(1,2)*2*pi()/60;
Tst = 2;
time=0:0.02:(7804*0.02);
a = 0.0601;
b = 8.2494;
J = 1.2576;
sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Test\MoHinhCoastDownChung.slx',time);
w_mp = ans.n_coastdown.Data;
w_mp2 = w_mp(1:3600);
w_tn2 = w_tn(1:3600);

% Tính err
err = abs((w_tn2 - w_mp2) ./ w_tn2) .* 100;
avg_err = mean(err);

% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', avg_err);

plot(time, w_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, w_tn, 'b-', 'LineWidth', 2);
ylim([0 1200]);

xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
title('Đồ thị kiểm nghiệm tổn hao ban đầu và quán tính cụm tạo tải', 'FontSize', 25, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y

t_chu = 20;  % thời gian muốn đặt chữ
idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
text(time(idx), w_mp(idx) + 20, '9V', 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold');

%Cụm tạo tải 12V
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Data DTAN 14-5\CumTaoTai\Coastdowncumtaotai_12V.xlsx');
w_tn = data(:,2);
initial = data(1,2)*2*pi()/60;
Tst = 2;
time=0:0.02:(9196*0.02);
a = 0.0601;
b = 8.2494;
J = 1.2576;
sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Test\MoHinhCoastDownChung.slx',time);
w_mp = ans.n_coastdown.Data;
w_mp2 = w_mp(1:3600);
w_tn2 = w_tn(1:3600);

% Tính err
err = abs((w_tn2 - w_mp2) ./ w_tn2) .* 100;
avg_err = mean(err);

% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', avg_err);

plot(time, w_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, w_tn, 'b-', 'LineWidth', 2);
ylim([0 1200]);

xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
title('Đồ thị kiểm nghiệm tổn hao ban đầu và quán tính cụm tạo tải', 'FontSize', 25, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;

t_chu = 20;  % thời gian muốn đặt chữ
idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
text(time(idx), w_mp(idx) + 20, '12V', 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold');