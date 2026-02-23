clear all;
clc;
% Đọc dữ liệu từ file
data = readtable('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\NopDVD\CodeMatlab\CodeTinhJ\NapMatlabBanhxe.xlsx', 'VariableNamingRule', 'preserve');
w_tn = data(:,2);
Kt = 0.0362;
a = 0.0601;
b = 8.2494;
Tst = 2;

% Tính toán các cột cơ bản
time = data{:,1};
w_bx = data{:,2} * 2 * pi / 60;
T_f = Kt*(a*w_bx+ b)*Tst;
P_f = w_bx .* T_f;
w_bx_first = w_bx(1);
initial = w_bx_first;
w_bx_last = w_bx(end);

% Tính W_f (tích phân số)
W_f = zeros(size(P_f));
for i = 1:(length(P_f)-1)
    W_f(i) = 0.5 * (P_f(i) + P_f(i+1)) * 0.02;
end

% ========== PHẦN XỬ LÝ DỮ LIỆU ĐẦY ĐỦ ==========
% Tính sum_W_f đầy đủ (tích lũy toàn bộ)
sum_Wf_full = cumsum(W_f);

% Tạo bảng đầy đủ
full_result = table(time, w_bx, T_f, P_f, W_f, sum_Wf_full, ...
    'VariableNames', {'Time', 'w_bx_rad_s', 'T_f', 'P_f', 'W_f', 'Sum_Wf_Full'});

% Tính sum_W_f CHỈ TRÊN DỮ LIỆU
sum_Wf = cumsum(W_f);

% Tính J_bx TỪ DỮ LIỆU
denominator = 0.5*(w_bx_first^2 - w_bx_last^2);

if abs(denominator) > 1e-10
    J = sum_Wf(end) / denominator;
else
    J = NaN;
    warning('Mẫu số gần bằng 0 - Không thể tính J');
end

% J = 3.277;
% ========== XUẤT KẾT QUẢ ==========
% Hiển thị trong Command Window
disp('Kết quả đầy đủ (5 hàng đầu):');
disp(head(full_result,5));
disp(['J tính từ dữ liệu lọc: ', num2str(J)]);

% Lưu vào workspace (GIỮ NGUYÊN NHƯ CŨ)
assignin('base', 'full_calculated_data', full_result);
assignin('base', 'J', J);

% Xuất ra Excel (GIỮ NGUYÊN NHƯ CŨ)
writetable(full_result, 'full_results.xlsx');

% Ghi thêm J_bx vào file
xlswrite('full_results.xlsx', {'J:', J}, 1, 'H1');

sim('D:\PHTOAN\Bach Khoa\HCMUT Automotive Engineering\FourthYear\HK242\DATN\NopDVD\CodeMatlab\CodeTinhJ\MoHinhCoastDownChung.slx',time);
w_mp=ans.n_coastdown.Data;
plot(time,w_mp,'r-');hold on;
plot(time, w_tn{:,1}, 'b-');  % Lấy cột đầu tiên dưới dạng mảng số
ylim([0 1000]);
xlabel('Thời gian (s)');
ylabel('Tốc độ con lăn (RPM)');
title('Đồ thị Coastdown cả cụm tải 2 ắc-quy');
legend('Mô phỏng', 'Thực tế');  % Thêm chú thích cho hai đường
