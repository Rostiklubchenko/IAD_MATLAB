% Дані студентів
students.S1.Hours = 15;
students.S1.Attempts = 2;
students.S1.Satisfaction = 'Позитивний';

students.S2.Hours = 8;
students.S2.Attempts = 4;
students.S2.Satisfaction = 'Негативний';

students.S3.Hours = 12;
students.S3.Attempts = 3;
students.S3.Satisfaction = 'Позитивний';

students.S4.Hours = 5;
students.S4.Attempts = 7;
students.S4.Satisfaction = 'Негативний';

students.S5.Hours = 10;
students.S5.Attempts = 5;
students.S5.Satisfaction = []; % Невідоме 

% Функція для розрахунку відстані між S5 та іншим студентом
function distance = calculate_distance(S5, Sk)
    distance = sqrt((S5.Hours - Sk.Hours)^2 + (S5.Attempts - Sk.Attempts)^2);
end

% Візуалізація сусідів
function visualize_neighbors(students, distances)
    num_students = length(distances); % Кількість студентів, окрім S5

    % Преалокація для масивів
    x = zeros(1, num_students); 
    y = zeros(1, num_students); 
    sizes = zeros(1, num_students); 

    % Збір даних для візуалізації
    fields = fieldnames(students);
    index = 1;
    for i = 1:length(fields)
        if ~strcmp(fields{i}, 'S5')
            x(index) = students.(fields{i}).Hours;
            y(index) = students.(fields{i}).Attempts;
            index = index + 1;
        end
    end
    
    % Розмір точок
    for i = 1:num_students
        sizes(i) = 1 / (distances{i, 2} + 1) * 200;
    end

    % Візуалізація
    figure;
    scatter(x, y, sizes, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerFaceAlpha', 0.7);
    hold on;
    
    % Точка для S5
    scatter(students.S5.Hours, students.S5.Attempts, 200, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'Marker', 'p'); 

    % Додавання підписів
    for i = 1:num_students
        text(students.(distances{i, 1}).Hours, students.(distances{i, 1}).Attempts, ...
             sprintf('%s\n%.2f', distances{i, 1}, distances{i, 2}), 'FontSize', 8, ...
             'HorizontalAlignment', 'right', 'Interpreter', 'none');
    end
    
    xlabel('Hours');
    ylabel('Attempts');
    title('Students and Distances to S5');
    axis equal;
    legend('Other students', 'S5');
    hold off;
end

% Функція для прогнозування задоволення для S5
function students = predict_satisfaction(students)
    % Виділяємо студента S5
    unknown_student = students.S5;
    
    % Ініціалізація змінних для мінімальної відстані та задоволення
    min_distance = inf;
    min_satisfaction = 'Невідомо'; 
    
    fields = fieldnames(students);
    num_students = length(fields) - 1; 
    
    % Преалокація масиву для збереження відстаней
    distances = cell(num_students, 2);  
    index = 1;  
    
    % Обчислюємо відстані до всіх студентів, окрім S5
    for i = 1:length(fields)
        if ~strcmp(fields{i}, 'S5')
            % Обчислюємо відстань
            distance = calculate_distance(unknown_student, students.(fields{i}));
            
            % Записуємо відстань та ім'я студента в масив
            distances{index, 1} = fields{i}; 
            distances{index, 2} = distance;   
            
            % Перевірка мінімальної відстані
            if distance < min_distance
                min_distance = distance;
                min_satisfaction = students.(fields{i}).Satisfaction;
            end
            
            index = index + 1;
        end
    end
    
    % Присвоюємо прогнозоване задоволення для S5
    students.S5.Satisfaction = min_satisfaction;
    students.S5.Distance = min_distance;
    
    % Виведення таблиці з відстанями
    disp('Таблиця з відстанями:');
    disp(distances);
    
    % Виведення прогнозованого задоволення для S5
    fprintf('Прогнозоване задоволення для S5: %s\n', students.S5.Satisfaction);
    
    % Виклик функції для візуалізації
    visualize_neighbors(students, distances);

    fields = fieldnames(students);
    fprintf('Таблиця студентів:\n');
    for i = 1:length(fields)
        student = students.(fields{i});
        satisfaction = student.Satisfaction;
        
        fprintf('%s: Hours=%d, Attempts=%d, Satisfaction=%s\n', ...
                fields{i}, student.Hours, student.Attempts, satisfaction);
    end
end

% Прогноз для S5
predict_satisfaction(students);
