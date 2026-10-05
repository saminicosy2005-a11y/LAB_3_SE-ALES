%% PARTE A: CONVOLUCIÓN EN MATLAB

% Definir las dos secuencias discretas de entrada para la prueba
x = [1 2 1];
h = [1 1 1];

% Aplicar la función nativa de MATLAB para calcular la convolución entre x y h
y = conv(x, h);

% Imprimir el resultado en la command window para verificar que los valores tengan sentido
disp('Resultado de la convolución:');
disp(y);

% Armar los vectores de índices (n) para poder graficar correctamente cada señal desde cero
n_x = 0:length(x)-1;
n_h = 0:length(h)-1;
n_y = 0:length(y)-1;

% Configurar una figura con 3 subplots para comparar gráficamente mis señales para el reporte
figure;

subplot(3,1,1);
stem(n_x, x, 'filled');
title('Señal x[n]');
xlabel('n');
ylabel('Amplitud');
grid on;

subplot(3,1,2);
stem(n_h, h, 'filled');
title('Señal h[n]');
xlabel('n');
ylabel('Amplitud');
grid on;

subplot(3,1,3);
stem(n_y, y, 'filled');
title('Convolución y[n] = x[n] * h[n]');
xlabel('n');
ylabel('Amplitud');
grid on;
