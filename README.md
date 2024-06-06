# Flutter application for Greenhouse monitoring, cooling and watering system  

The project uses Flutter to make a cross platform app to monitor and view different parameters for a plant in a greenhouse. The data is fetched from a backend server hosted on Heroku fed to by a ESP32 microcontroller connected to wifi. 

## Detailed Overview on the project
**• Temperature and Humidity Sensor:**
DHT-11 is a cost-effective sensor used for monitoring temperature and humidity of surrounding environment. The sensor provides real time values in digital format making it easily compatible with microcontrollers.

**•	Soil Moisture Sensor:** 
FC-28 sensor is used for soil moisture monitoring; it consists of two probes which are inserted into the soil and the change in resistance between these probes is used to measure the moisture content in soil. The sensor generates an analog output which is mapped with appropriate moisture percentage.

**•	Fans and Valves for water control:**
To maintain an optimal temperature and moisture level for efficient and automated irrigation a cooling and water supply system is controlled by the esp. This system comprises of a Fan and a Solenoid valve. The execution of these components is facilitated by a 12V relay, as the ESP controls their actions based on carefully calibrated threshold values.

**•	Connectivity and Cloud Server:**
We've integrated Node.js + Express.js API and a Heroku cloud server into our plant monitoring system. ESP32 devices, using ESPNow for wireless communication, collect real-time data from sensors in the greenhouse and sends them to the cloud for storing it into a database (MongoDB). This ensures efficient and seamless transfer of plant values to the cloud.



## Application design
![image](https://github.com/abdullah-ihsan/plant-iot-/assets/65601738/0d8e87b9-480b-41df-bf64-750bea3dd532)
![image](https://github.com/abdullah-ihsan/plant-iot-/assets/65601738/cfad0aea-df28-4a2f-9fe9-d5efff911a89)
