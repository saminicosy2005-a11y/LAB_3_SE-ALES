% Configurar el puerto serie donde conecté mi ESP32 
puerto = "COM3";
baudrate = 115200;

% Definir frecuencia de muestreo a 100Hz y preparar el código para tomar 1000 muestras
Fs = 100;              % Frecuencia de muestreo [Hz]
N = 1000;              % Número de muestras

%% CONEXIÓN CON ESP32

% Inicializar la comunicación con el microcontrolador y configurar el salto de línea
esp = serialport(puerto, baudrate);
configureTerminator(esp, "LF");

% Limpiar el buffer por si quedó basura de alguna ejecución anterior
flush(esp);

%% ESTABILIZACIÓN

disp("Estabilizando el sensor durante 30 segundos...");
% 30 segundos al MPU6050 para que se estabilice y la lectura no tenga tanto offset
pause(30);

% Limpiar el buffer de nuevp para borrar todos los datos que llegaron mientras esperaba
flush(esp);

disp("Estabilización terminada.");

%% ADQUISICIÓN DE DATOS

disp("Adquiriendo datos...");

% Vector de ceros para que el bucle for sea más rápido
data = zeros(N,1);

% Bucle para leer línea por línea y convertir los datos a numéricos
for k = 1:N
    data(k) = str2double(readline(esp));
end

disp("Adquisición terminada.");

%% VECTOR DE TIEMPO

% Vector de tiempo basado en la frecuencia de muestreo que definims arriba
t = (0:N-1)/Fs;

%% CONVOLUCIÓN

% Filtro de promedio móvil de 5 muestras para limpiar el ruido del sensor
h = ones(1,5)/5;

% Aplicar convolución manteniendo el mismo tamaño de mi vector original ("same")
y = conv(data, h, "same");

%% ELIMINAR EFECTOS DE BORDE PARA LAS GRÁFICAS

% Cálculo de margen para recortar los extremos y que mi gráfica no muestre la caída del filtro
margen = floor(length(h)/2);

indices = margen+1 : N-margen;

t_graf = t(indices);
data_graf = data(indices);
y_graf = y(indices);

%% 1. SEÑAL ORIGINAL SIN BORDES

figure;

% Graficar laseñal cruda que leimos del acelerómetro en el eje Z
plot(t_graf, data_graf);

title('Aceleración Az - Señal Original');
xlabel('Tiempo [s]');
ylabel('Aceleración [m/s^2]');
grid on;

%% 2. SEÑAL ORIGINAL VS CONVOLUCIONADA

figure;

plot(t_graf, data_graf, 'DisplayName', 'Señal original');
hold on;

% Superponer la señal filtrada para ver visualmente cuánto ruido limpiamos
plot(t_graf, y_graf, 'DisplayName', 'Señal convolucionada');

title('Aceleración Az - Convolución');
xlabel('Tiempo [s]');
ylabel('Aceleración [m/s^2]');
legend;
grid on;

%% 3. SEÑAL CONVOLUCIONADA SIN BORDES

figure;

plot(t_graf, y_graf);

title('Señal convolucionada');
xlabel('Tiempo [s]');
ylabel('Aceleración [m/s^2]');
grid on;