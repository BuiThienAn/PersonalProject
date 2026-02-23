time_mp = out.n_cl_mp.Time;
n_cl_mp= out.n_cl_mp.Data;
n_cl_tn= out.n_cl_tn.Data;
n_bx_mp=out.n_bx_mp.Data;
n_bx_tn=out.n_bx_tn.Data;
T_b=out.T_b.Data;

subplot(3,1,1);
plot(time_mp,T_b,'r-', 'LineWidth', 2);
title('Momen phanh', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Momen phanh (Nm)', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;

subplot(3,1,2);
plot(time_mp,n_bx_mp,'r-', 'LineWidth', 2);hold on;
plot(time_mp, n_bx_tn,'b-', 'LineWidth', 2);
title('So sánh tốc độ bánh xe giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ bánh xe (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;

subplot(3,1,3);
plot(time_mp,n_cl_mp,'r-', 'LineWidth', 2);hold on;
plot(time_mp, n_cl_tn,'b-', 'LineWidth', 2);
title('So sánh tốc độ con lăn giữa mô phỏng và thực nghiệm', 'FontSize', 25, 'FontWeight', 'bold');
xlabel('Thời gian (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Tốc độ con lăn (RPM)', 'FontSize', 16, 'FontWeight', 'bold');
legend('Mô phỏng 1 ắc quy', 'Thực nghiệm 1 ắc quy', ...
       'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'FontWeight', 'bold');  % Làm đậm chữ số trên trục x, y
grid on;