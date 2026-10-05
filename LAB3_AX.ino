#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;

void setup() {
  // Inicializar la comunicación serial como configuramos en el script de MATLAB
  Serial.begin(115200);

  // Configurar los pines I2C de ESP32 (SDA en 21, SCL en 22)
  Wire.begin(21, 22);

  // Ver que MPU6050 está bien conectado
  if (!mpu.begin()) {
    while (1) {
      delay(10);
    }
  }

  // Seteo el rango en ±2 g (más que suficiente) 
  mpu.setAccelerometerRange(MPU6050_RANGE_2_G);
}

void loop() {
  sensors_event_t aceleracion, giro, temperatura;

  // Leer todos los datos del sensor y guardarlos en variables de evento
  mpu.getEvent(&aceleracion, &giro, &temperatura);

  // Mandar por serial solo la aceleración en el eje Z para procesarla con filtro en MATLAB
  Serial.println(aceleracion.acceleration.z);

  // Delay de 10ms para clavar frecuencia de muestreo en los 100 Hz que necesitamos
  delay(10);
}
