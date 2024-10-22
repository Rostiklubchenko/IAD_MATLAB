% Дані
customers.C1.Age = 25;
customers.C1.VisitedCountries = 4;
customers.C1.Purchase = 'Пляжний відпочинок';

customers.C2.Age = 49;
customers.C2.VisitedCountries = 10;
customers.C2.Purchase = 'Гастрономічний тур';

customers.C3.Age = 38;
customers.C3.VisitedCountries = 3;
customers.C3.Purchase = 'Гірський туризм';

customers.C4.Age = 36;
customers.C4.VisitedCountries = 5;
customers.C4.Purchase = 'Круїзи';

customers.C5.Age = 41;
customers.C5.VisitedCountries = 6;
customers.C5.Purchase = []; % Невідома категорія покупки

% Функція для розрахунку відстані між C5 та іншим клієнтом
function distance = calculate_distance(C5, Ck)
    distance = sqrt((C5.Age - Ck.Age)^2 + (C5.VisitedCountries - Ck.VisitedCountries)^2);
end

% Візуалізація сусідів
function visualize_neighbors(customers, distances)
    num_customers = length(distances); % Кількість клієнтів, окрім C5

    % Преалокація для масивів
    x = zeros(1, num_customers); 
    y = zeros(1, num_customers); 
    sizes = zeros(1, num_customers); 

    % Збір даних для візуалізації
    fields = fieldnames(customers);
    index = 1;
    for i = 1:length(fields)
        if ~strcmp(fields{i}, 'C5')
            x(index) = customers.(fields{i}).Age;
            y(index) = customers.(fields{i}).VisitedCountries;
            index = index + 1;
        end
    end
    
    % Розмір точок
    for i = 1:num_customers
        sizes(i) = 1 / (distances{i, 2} + 1) * 200; % Розмір точки відповідно до відстані
    end

    % Візуалізація
    figure;
    scatter(x, y, sizes, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerFaceAlpha', 0.7);
    hold on;
    
    % Точка для C5
    scatter(customers.C5.Age, customers.C5.VisitedCountries, 200, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'Marker', 'p'); 
    % Маркер 'p' - п'ятикутна зірка, 'r' - червоний колір

    % Додавання підписів
    for i = 1:num_customers
        text(customers.(distances{i, 1}).Age, customers.(distances{i, 1}).VisitedCountries, ...
             sprintf('%s\n%.2f', distances{i, 1}, distances{i, 2}), 'FontSize', 8, ...
             'HorizontalAlignment', 'right', 'Interpreter', 'none');
    end
    
    xlabel('Age');
    ylabel('Visited countries');
    title('Customers and Distances to C5');
    axis equal;
    legend('Other customers', 'C5');
    hold off;
end

% Функція для прогнозування категорії покупки для C5
function customers = predict_purchase(customers)
    % Виділяємо клієнта C5
    unknown_customer = customers.C5;
    
    % Ініціалізація змінних для мінімальної відстані та покупки
    min_distance = inf;
    min_purchase = 'Невідомо';  % Початкове значення
    
    fields = fieldnames(customers);
    num_customers = length(fields) - 1;  % Кількість клієнтів (без C5)
    
    % Преалокація масиву для збереження відстаней
    distances = cell(num_customers, 2);  
    index = 1;  % Лічильник для заповнення масиву distances
    
    % Обчислюємо відстані до всіх клієнтів, окрім C5
    for i = 1:length(fields)
        if ~strcmp(fields{i}, 'C5')
            % Обчислюємо відстань
            distance = calculate_distance(unknown_customer, customers.(fields{i}));
            
            % Записуємо відстань та ім'я клієнта в масив
            distances{index, 1} = fields{i};  % Ім'я клієнта
            distances{index, 2} = distance;   % Відстань
            
            % Перевірка мінімальної відстані
            if distance < min_distance
                min_distance = distance;
                min_purchase = customers.(fields{i}).Purchase;  % Найближча покупка
            end
            
            index = index + 1;  % Збільшуємо лічильник
        end
    end
    
    % Присвоюємо покупку та відстань для C5
    customers.C5.Purchase = min_purchase;
    customers.C5.Distance = min_distance;
    
    % Виведення таблиці з відстанями
    disp('Table with distances:');
    disp(distances);
    
    % Виведення прогнозованої покупки для C5
    fprintf('Predicted purchase for C5: %s\n', customers.C5.Purchase);
    
    % Виклик функції для візуалізації
    visualize_neighbors(customers, distances);

    fields = fieldnames(customers);
    fprintf('Customer Table:\n');
    for i = 1:length(fields)
        customer = customers.(fields{i});
        purchase = customer.Purchase;
        
        % % Перевіряємо, чи поле Purchase пусте або None
        % if isempty(purchase)
        %     purchase = 'Невідомо';  % Якщо Purchase не визначено, виводимо "Невідомо"
        % end
        
        fprintf('%s: Age=%d, Visited Countries=%d, Purchase=%s\n', ...
                fields{i}, customer.Age, customer.VisitedCountries, purchase);
    end
end

% Прогноз для C5
predict_purchase(customers);