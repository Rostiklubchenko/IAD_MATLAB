% 1. Привести виробничу функцію Кобба-Дугласа до лінійного виду:
% ln(y) = ln(A) + α * ln(K) + β * ln(L)

% Функція для обчислення lnY
function result = lnY(lnA, alpha, lnK, beta, lnL)
    result = lnA + alpha * lnK + beta * lnL;
end

% 2. Генерація вхідних K і L, і вихідних Y даних зі зростанням

% Розмір вибірки
N = 20;

% Генерація вхідних даних
K = sort(randi([1, N], 1, N));
L = sort(randi([1, N], 1, N));

% Генерація вихідних даних
Y = sort(normrnd(N, 0.05, [1, N]));

disp('K:');
disp(K);
disp('L:');
disp(L);
disp('Y:');
disp(Y);

% 3. Побудова 3D графіку
figure;
scatter3(K, L, Y, 'filled');
xlabel('K');
ylabel('L');
zlabel('Y');
grid on;
title('3D scatter plot for K, L, Y');

% 4. Побудова матриці H і перевірка її рангу

% Генерація векторів з логарифмованих значень K, L, Y
Y_log = log(Y);
K_log = log(K);
L_log = log(L);

disp('Вектор Y_log:');
disp(Y_log);
disp('Вектор K_log:');
disp(K_log);
disp('Вектор L_log:');
disp(L_log);

% Побудова матриці H з стовпця одиниць, W та U
H = [ones(N, 1), K_log', L_log'];

disp('Матриця H:');
disp(H);

% Перевірка рангу матриці H
rank_H = rank(H);
minSize = min(size(H));

disp(['Ранг матриці H: ', num2str(rank_H)]);

if rank_H ~= minSize
    disp('Матриця H неповнорангова. Переробіть вектори K і L.');
end

% 5. Знайти оцінки невідомих параметрів

% Знаходження X
X = inv(H' * H) * H' * Y_log';

X_lnA = X(1);
X_alpha = X(2);
X_beta = X(3);

% Отримання оцінки A з X_lnA
X_A = exp(X_lnA);

disp(['A = ', num2str(X_A)]);
disp(['alpha = ', num2str(X_alpha)]);
disp(['beta = ', num2str(X_beta)]);

% 6. Перевірити критерій значущості коефіцієнтів регресії і визначити довірчі границі

% Знаходження Yalt на основі отриманих параметрів
Yalt = arrayfun(@(i) lnY(X_lnA, X_alpha, K_log(i), X_beta, L_log(i)), 1:N);

disp('Вектор Yalt:');
disp(Yalt);

% Знаходження вибіркової дисперсії
sample_variance = sum((Y_log - Yalt) .^ 2) / (N - length(X));

disp(['Вибіркова дисперсія = ', num2str(sample_variance)]);

% Знаходження квадратів дисперсій
HTH = inv(H' * H);
c = diag(HTH);

disp('Елементи головної діагоналі:');
disp(c');

variance = sample_variance * c;

disp('Квадрати дисперсій:');
disp(variance');

% Обчислення параметра t
t_values = X ./ sqrt(variance);

disp('t:');
disp(t_values');

% Знаходження табличного значення t_alpha
t_alpha = tinv(0.975, N - length(X)); % 95% довірчий інтервал

disp(['t_alpha = ', num2str(t_alpha)]);

% Обчислення довірчих границь
T = t_alpha * sqrt(variance);

for i = 1:length(T)
    disp(['T', num2str(i), ' = ', num2str(X(i)), ' +- ', num2str(T(i))]);
end

% 7. Визначити коефіцієнт множинної детермінації (R^2)

% Знаходимо lnY_upper
lnY_upper = sum(Y_log) / N;

R2 = sum((Yalt - lnY_upper) .^ 2) / sum((Y_log - lnY_upper) .^ 2);

disp(['R^2 = ', num2str(R2)]);

% 8. Здійснити зворотне перетворення шляхом потенціювання

Y_potentiated = exp(Y_log);

disp('Початкове значення Y:');
disp(Y);
disp('Потенційоване значення Y:');
disp(Y_potentiated);
