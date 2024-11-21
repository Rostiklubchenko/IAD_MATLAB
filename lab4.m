clc;
clear;

% Кількість точок у кожній множині (генеруємо окремо)
num_points = randi([5, 10], 3, 1);

% Математичні середні для множин (утворюють трикутник)
mean1 = [0, 0];
mean2 = [2, 0];
mean3 = [1, 2];

% Дисперсія
variance = 1.5;

% Генеруємо випадкові точки для кожної множини
set1 = [normrnd(mean1(1), variance, [num_points(1), 1]), ...
        normrnd(mean1(2), variance, [num_points(1), 1])];

set2 = [normrnd(mean2(1), variance, [num_points(2), 1]), ...
        normrnd(mean2(2), variance, [num_points(2), 1])];

set3 = [normrnd(mean3(1), variance, [num_points(3), 1]), ...
        normrnd(mean3(2), variance, [num_points(3), 1])];

% Об'єднуємо всі точки
all_points = [set1; set2; set3];

% Відображення початкових точок
figure;
hold on;
scatter(set1(:,1), set1(:,2), 'r', 'DisplayName', 'Set 1');
scatter(set2(:,1), set2(:,2), 'g', 'DisplayName', 'Set 2');
scatter(set3(:,1), set3(:,2), 'b', 'DisplayName', 'Set 3');
plot([mean1(1), mean2(1)], [mean1(2), mean2(2)], 'k');
plot([mean2(1), mean3(1)], [mean2(2), mean3(2)], 'k');
plot([mean3(1), mean1(1)], [mean3(2), mean1(2)], 'k');
legend;
title('Random Points and Triangular Means');
hold off;

% Початкові центри кластерів
initial_centers = [mean1; mean2; mean3];

% Реалізація алгоритму k-means
function [labels, centers, steps] = k_means_clustering(data, k, initial_centers, max_iterations)
    if nargin < 4
        max_iterations = 100;
    end
    [n_points, ~] = size(data);
    centers = initial_centers;
    labels = zeros(n_points, 1);
    for step = 1:max_iterations
        % Оцінка відстаней до центрів
        distances = zeros(n_points, k);
        for i = 1:k
            distances(:, i) = sum((data - centers(i, :)).^2, 2);
        end
        % Призначення точок до кластерів
        [~, labels] = min(distances, [], 2);
        
        % Перерахунок центрів
        new_centers = zeros(k, size(data, 2));
        for i = 1:k
            cluster_points = data(labels == i, :);
            if ~isempty(cluster_points)
                new_centers(i, :) = mean(cluster_points, 1);
            else
                new_centers(i, :) = centers(i, :); % Якщо кластер пустий
            end
        end
        
        % Перевірка на збіжність
        if all(abs(new_centers - centers) < 1e-4, 'all')
            break;
        end
        centers = new_centers;
    end
    steps = step;
end

% Початкова кластеризація
k = 3;
[cluster_labels, final_centers, steps] = k_means_clustering(all_points, k, initial_centers);

% Відображення кластерів
figure;
hold on;
colors = 'rgb';
for i = 1:k
    scatter(all_points(cluster_labels == i, 1), all_points(cluster_labels == i, 2), colors(i), 'DisplayName', sprintf('Cluster %d', i));
end
scatter(final_centers(:, 1), final_centers(:, 2), 'kx', 'LineWidth', 2, 'DisplayName', 'Final Centers');
legend;
title('k-means Clustering');
hold off;

% Розрахунок напрямків зміщення для трикутника
directions = [mean2 - mean1; mean3 - mean2; mean1 - mean3];
norm_directions = directions ./ vecnorm(directions, 2, 2); % Нормалізація напрямків

% Кластеризація зі зміщеними центрами
offset = 0.75 * variance;

% Віддалення
initial_centers_away = initial_centers + offset * norm_directions;
[~, ~, steps_away] = k_means_clustering(all_points, k, initial_centers_away);

% Наближення
initial_centers_towards = initial_centers - offset * norm_directions;
[~, ~, steps_towards] = k_means_clustering(all_points, k, initial_centers_towards);

% Таблиця результатів
results_table = table(["Initial"; "Away"; "Towards"], [steps; steps_away; steps_towards], ...
    'VariableNames', {'Case', 'Steps'});

disp('Кількість кроків для кожного випадку:');
disp(results_table);

% Відображення кластерів для віддалених центрів
figure;
hold on;
for i = 1:k
    scatter(all_points(cluster_labels == i, 1), all_points(cluster_labels == i, 2), colors(i), 'DisplayName', sprintf('Cluster %d', i));
end
scatter(initial_centers_away(:, 1), initial_centers_away(:, 2), 'kx', 'LineWidth', 2, 'DisplayName', 'Away Centers');
legend;
title('k-means Clustering (Centers Moved Away)');
hold off;

% Відображення кластерів для наближених центрів
figure;
hold on;
for i = 1:k
    scatter(all_points(cluster_labels == i, 1), all_points(cluster_labels == i, 2), colors(i), 'DisplayName', sprintf('Cluster %d', i));
end
scatter(initial_centers_towards(:, 1), initial_centers_towards(:, 2), 'kx', 'LineWidth', 2, 'DisplayName', 'Towards Centers');
legend;
title('k-means Clustering (Centers Moved Towards)');
hold off;
