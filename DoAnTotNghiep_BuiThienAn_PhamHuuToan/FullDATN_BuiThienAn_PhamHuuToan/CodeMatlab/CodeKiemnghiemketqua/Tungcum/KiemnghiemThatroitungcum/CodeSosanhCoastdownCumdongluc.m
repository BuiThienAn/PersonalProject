%Cụm động lực 7V
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Data DTAN 14-5\CumDongLucTST15\CoastdownCumDongLuc_7V.xlsx');
w_tn = data(:,4);
initial = data(1,4)*2*pi()/60;
Tst = 15;
time=0:0.02:(29*0.02);
a = 0.2657;
b = 6.7129;
J = 0.2412;
sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Test\MoHinhCoastDownChung.slx',time);
w_mp = ans.n_coastdown.Data;
w_mp2 = w_mp(1:30);
w_tn2 = w_tn(1:30);

% Tính err
err = abs((w_tn2 - w_mp2) ./ w_tn2) .* 100;
avg_err = mean(err);

% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', avg_err);

plot(time, w_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, w_tn, 'b-', 'LineWidth', 2);
ylim([0 350]);

xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
title('Đồ thị kiểm nghiệm tổn hao ban đầu và quán tính cụm động lực', 'FontSize', 25, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y

% Chèn chữ "19V" tại thời điểm t = 1s
t_chu = 20;  % thời gian muốn đặt chữ
idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
text(time(idx), w_mp(idx) + 20, '7V', 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold');

%Cụm động lực 19V
data = xlsread('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Data DTAN 14-5\CumDongLucTST15\CoastdownCumDongLuc_19V.xlsx');
w_tn = data(:,4);
initial = data(1,4)*2*pi()/60;
Tst = 15;
time=0:0.02:(71*0.02);
a = 0.2657;
b = 6.7129;
J = 0.2412;
sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\Test\MoHinhCoastDownChung.slx',time);
w_mp = ans.n_coastdown.Data;
w_mp2 = w_mp(1:30);
w_tn2 = w_tn(1:30);

% Tính err
err = abs((w_tn2 - w_mp2) ./ w_tn2) .* 100;
avg_err = mean(err);

% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', avg_err);

plot(time, w_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, w_tn, 'b-', 'LineWidth', 2);
ylim([0 350]);

xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
title('Đồ thị kiểm nghiệm tổn hao ban đầu và quán tính cụm động lực', 'FontSize', 25, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;
% Chèn chữ "19V" tại thời điểm t = 1s
t_chu = 20;  % thời gian muốn đặt chữ
idx = find(time >= t_chu, 1); % tìm chỉ số gần nhất
text(time(idx), w_mp(idx) + 20, '19V', 'Color', 'k', 'FontSize', 16, 'FontWeight', 'bold');


