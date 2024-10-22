clc;

% Встановлюємо параметри
N = 30;

function printArray(N)
    for i = 1:length(N)
        fprintf('%6.0f ', N(i));
    end
    fprintf('\n');
end

% Генеруємо першу випадкову послідовність з чисел в діапазоні від 0 до 99
x_prob = randi([0, 99], 1, N);
y_prob = randi([0, 99], 1, N);

fprintf("\n");
disp('Перша випадкова послідовність:');
printArray(x_prob);
disp('Друга випадкова послідовність:');
printArray(y_prob);

% Функція для генерації детермінованої послідовності
function seq = generateSequence(N, a0, d)
    seq = a0 + d * (0:(N-1));
end

% Генеруємо детерміновані послідовності
Xdetup = generateSequence(N, randi([-N, N]), randi([1, N]));
Ydetup = generateSequence(N, randi([-N, N]), randi([1, N]));

Xdetdown = generateSequence(N, randi([-N, N]), randi([-N, -1]));
Ydetdown = generateSequence(N, randi([-N, N]), randi([-N, -1]));

fprintf("\n");
disp('Послідовності за законом арифметичної прогресії');
disp('Xdetup = ');
printArray(Xdetup);
disp('Ydetup = ');
printArray(Ydetup);
disp('Xdetdown = ');
printArray(Xdetdown);
disp('Ydetdown = ');
printArray(Ydetdown);

% Генеруємо стохастичні послідовності
x_stoch1 = x_prob + Xdetup;
x_stoch2 = x_prob + Xdetdown;

y_stoch1 = y_prob + Ydetup;
y_stoch2 = y_prob - Ydetdown;

fprintf("\n");
disp('Стохастичні послідовності');
disp('x_stoch1 = ');
printArray(x_stoch1);
disp('x_stoch2 = ');
printArray(x_stoch2);
disp('y_stoch1 = ');
printArray(y_stoch1);
disp('y_stoch2 = ');
printArray(y_stoch2);

% Побудова графіків
figure;
plot(x_prob, y_prob, 'go');
xlabel('x\_prob');
ylabel('y\_prob');
title('Випадкові значення');

figure;
plot(x_stoch1, y_stoch1, 'bo');
xlabel('x\_stoch1');
ylabel('y\_stoch1');
title('Графік 1');

figure;
plot(x_stoch2, y_stoch2, 'ro');
xlabel('x\_stoch2');
ylabel('y\_stoch2');
title('Графік 2');

% Функція для розрахунків
function result = calc(X, Y, N)
    X_v = sum(X) / N;
    Y_v = sum(Y) / N;

    M_XY = sum((X - X_v) .* (Y - Y_v)) / N;

    D_X = sum((X - X_v).^2) / N;
    D_Y = sum((Y - Y_v).^2) / N;

    R_XY = M_XY / sqrt(D_X * D_Y);

    result.X_v = X_v;
    result.Y_v = Y_v;
    result.M_XY = M_XY;
    result.D_X = D_X;
    result.D_Y = D_Y;
    result.R_XY = R_XY;
end

% Розрахунок результатів
results = [
    calc(x_prob, y_prob, N); 
    calc(x_stoch1, y_stoch1, N); 
    calc(x_stoch2, y_stoch2, N)
];

% Виведення результатів
fprintf("\n");
disp('Таблиця оцінок');
fprintf('%10s%10s%10s%10s%10s\n', 'X_v', 'Y_v', 'M_xy', 'D_x', 'D_y')
for i = 1:length(results)
    fprintf('%d. %7.4f %10.4f %10.4f %10.4f %10.4f\n', i, results(i).X_v, results(i).Y_v, results(i).M_XY, results(i).D_X, results(i).D_X);
end

fprintf("\n");
disp("Результати");
for i = 1:length(results)
    fprintf('%d. R_XY = %.2f\n', i, results(i).R_XY);
end