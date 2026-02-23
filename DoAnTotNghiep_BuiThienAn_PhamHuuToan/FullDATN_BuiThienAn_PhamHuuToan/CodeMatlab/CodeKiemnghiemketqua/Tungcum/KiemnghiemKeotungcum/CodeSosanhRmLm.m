Lm=2.247926023878100e-05;
Rm=0.059792307934437;

data = xlsread('C:\Users\Legion\Downloads\MATLAB\Tangapcumdongluc567V_DaLoc.xlsx');
time_raw = data(:,1);
v_raw = data(:,2);
i_raw = data(:,3);
n_bx_raw = data(:,4);

% Thông số lấy mẫu
step = 0.02;
time_max = time_raw(end);
epsilon = 1e-6;

% Chọn các chỉ số tại bước 0.2s trong khoảng từ 0 đến 20s
idx = find(abs(mod(time_raw, step)) < epsilon & time_raw <= time_max);

% Lọc dữ liệu
time = time_raw(idx);
v_tn = v_raw(idx);
i_tn = i_raw(idx);
n_bx_tn = n_bx_raw(idx);
startTime = num2str(time(1));
stopTime = num2str(time(end));

set_param('TangapCumdongluc', 'StartTime', startTime, 'StopTime', stopTime);

sim('TangapCumdongluc');
time_mp = ans.n_bx.Time;
n_bx_mp = ans.n_bx.Data;

% Lấy mỗi 80 giá trị một lần từ n_bx_mp
n_bx_mp_sampled = n_bx_mp(1:80:end);
n_bx_mp_sampled2 = n_bx_mp_sampled(7:end);
n_bx_tn2 = n_bx_tn(7:end);
time_mp_sampled = time_mp(1:80:end);  % nếu bạn cần thời gian tương ứng

% Tính R^2
err =mean(abs((n_bx_tn2 - n_bx_mp_sampled2) ./ n_bx_tn2)) * 100;


% Hiển thị R^2 trên Command Window
fprintf('Sai số = %.4f\n', err);

plot(time_mp, n_bx_mp, 'r-', 'LineWidth', 2); hold on;
plot(time, n_bx_tn, 'b-', 'LineWidth', 2);

title('Đồ thị kiểm nghiệm thông số Motor của cụm động lực khi chưa đặt bánh xe xuống', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng', 'Thực tế', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;