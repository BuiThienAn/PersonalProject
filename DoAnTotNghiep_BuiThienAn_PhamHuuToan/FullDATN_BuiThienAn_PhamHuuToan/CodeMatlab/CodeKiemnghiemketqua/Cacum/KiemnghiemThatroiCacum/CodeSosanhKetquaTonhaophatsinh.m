% Bộ thông số 1 (bảng đầu)
a11_1 = 0.060773449736866;
b11_1 = 1.576434187120628;
a12_1 = 0.007150245075987;
b12_1 = 0.153671177646358;
Trr_1 = 0.334273249247759;

% Bộ thông số 2 (bảng mới)
a11_2 = 0.060931880707401;
b11_2 = 1.820843001248018;
a12_2 = 0.007408672590184;
b12_2 = 0.270086806664839;
Trr_2 = 0.374661159089003;

% Vector trục hoành
w_bx = linspace(0, 100, 1000);
w_cl = linspace(0, 100, 1000);

% Tính giá trị các hàm
y_bx_1 = a11_1 * w_bx + b11_1;
y_bx_2 = a11_2 * w_bx + b11_2;

y_cl_1 = a12_1 * w_cl + b12_1;
y_cl_2 = a12_2 * w_cl + b12_2;

Trr_line_1 = Trr_1 * ones(size(w_bx));
Trr_line_2 = Trr_2 * ones(size(w_bx));

% Vẽ đồ thị
figure;

% --- Đồ thị 1: y = a11 * w_bx + b11 ---
subplot(3,1,1);
plot(w_bx, y_bx_1, 'r', 'LineWidth', 2); hold on;
plot(w_bx, y_bx_2, 'b', 'LineWidth', 2);
xlabel('Tốc độ bánh xe (rad/s)', 'FontWeight', 'bold');
ylabel('Momen phát sinh cụm động lực (Nm)', 'FontWeight', 'bold');
ylim([0 5]);
legend('1 ắc quy', '2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
title('Momen phát sinh cụm động lực a_{11}w_{bx} + b_{11}', 'FontSize', 16, 'FontWeight', 'bold');
grid on;

% --- Đồ thị 2: y = a12 * w_cl + b12 ---
subplot(3,1,2);
plot(w_cl, y_cl_1, 'r', 'LineWidth', 2); hold on;
plot(w_cl, y_cl_2, 'b', 'LineWidth', 2);
xlabel('Tốc độ con lăn (rad/s)', 'FontWeight', 'bold');
ylabel('Momen phát sinh cụm tạo tải (Nm)', 'FontWeight', 'bold');
ylim([0 5]);
legend('1 ắc quy', '2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
title('Momen phát sinh cụm tạo tải a_{12}w_{cl} + b_{12}', 'FontSize', 16, 'FontWeight', 'bold');
grid on;

% --- Đồ thị 3: Trr ---
subplot(3,1,3);
plot(w_bx, Trr_line_1, 'r--', 'LineWidth', 2); hold on;
plot(w_bx, Trr_line_2, 'b--', 'LineWidth', 2);
xlabel('Tốc độ (rad/s)', 'FontWeight', 'bold');
ylabel('Momen cản lăn (Nm)', 'FontWeight', 'bold');
ylim([0 1]);
legend('1 ắc quy', '2 ắc quy', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
title('Momen cản lăn T_{rr}', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
