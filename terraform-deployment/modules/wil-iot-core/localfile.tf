// - Climate Sensor Arrays -
resource "local_file" "device_certificate_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  filename = "${path.root}/ARDUINO/CLIMATE_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-device-certificate.pem"
  content  = aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].certificate_pem
}
resource "local_file" "private_key_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  filename = "${path.root}/ARDUINO/CLIMATE_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-private-key.pem.key"
  content  = aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].private_key
}
resource "local_file" "public_key_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  filename = "${path.root}/ARDUINO/CLIMATE_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-public-key.pem.key"
  content  = aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].public_key
}

// - Flow Sensor Arrays -
resource "local_file" "device_certificate_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  filename = "${path.root}/ARDUINO/FLOW_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-device-certificate.pem"
  content  = aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].certificate_pem
}
resource "local_file" "private_key_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  filename = "${path.root}/ARDUINO/FLOW_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-private-key.pem.key"
  content  = aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].private_key
}
resource "local_file" "public_key_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  filename = "${path.root}/ARDUINO/FLOW_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/certs/${each.value.name}-public-key.pem.key"
  content  = aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].public_key
}


// Climate Sensor Arrays - secrets.h file
resource "local_file" "dynamic_secrets_h_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  filename = "${path.root}/ARDUINO/CLIMATE_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/Secrets-${each.value.name}.h"
  content  = <<-EOF
    #include <pgmspace.h>

    #define SECRET

    #define THINGNAME "${each.value.name}"
    #define DEVICE_ID "${each.value.name}_${each.value.short_name}"

    int8_t TIME_ZONE = +1; //(GMT+1): Abuja, Nigeria

    #define AWS_IOT_ENDPOINT        "${data.aws_iot_endpoint.current.endpoint_address}"

    #define AWS_IOT_PUBLISH_TOPIC        "device/${each.value.name}_${each.value.short_name}/data"
    #define AWS_IOT_SUBSCRIBE_TOPIC        "device/${each.value.name}_${each.value.short_name}/data"


    #define WIFI_SSID        "${var.wifi_ssid}"
    #define WIFI_PASSWORD    "${var.wifi_password}"

    // Insert AWS Root CA1 contents below
    static const char AWS_CERT_CA[] PROGMEM = R"EOF(
    -----BEGIN CERTIFICATE-----
    MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF
    ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6
    b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL
    MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv
    b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj
    ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM
    9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw
    IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6
    VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L
    93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm
    jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
    AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA
    A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI
    U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs
    N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv
    o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU
    5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy
    rqXRfboQnoZsG4q5WTP468SQvvG5
    -----END CERTIFICATE-----

    )EOF";


    // Copy contents from XXXXXXXX-certificate.pem.crt here ▼
    // device certificate
    static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
    ${aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].certificate_pem}
    )KEY";


    // Copy contents from  XXXXXXXX-private.pem.key here ▼
    // device private key
    static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
    ${aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].private_key}
    )KEY";

  EOF

}

# Climate Sensor Arrays .ino file
resource "local_file" "dynamic_ino_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  filename = "${path.root}/ARDUINO/CLIMATE_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/${each.value.name}.ino"
  # content  = aws_iot_certificate.cert.public_key
  content = <<-EOF
    /*
    BlackBox Series - ClimateSensor Array - DeviceId = ${each.value.name}_${each.value.short_name}
    Built for: WiL_Nigeria - Sustaining Water Project
    Managing Coders: Michael J. Watkins & Kevon Mayers
    www.BetterThingsLLC.com
    www.kevonmayers.com

    */

    //Libraries
    #include <ESP8266WiFi.h>
    #include <WiFiClientSecure.h>
    #include <PubSubClient.h>
    #include <ArduinoJson.h>
    #include <time.h>
    #include "Secrets-${each.value.name}.h"
    #include "DHT.h"
    #include <SPI.h>
    #include <Wire.h>
    #include <Adafruit_GFX.h>
    #include "UUID.h"

    UUID uuid;

    //Definitions
    #define TIME_ZONE +1 //(GMT+1)time for Abuja,Nigeria
    #define CS_PIN 15 //data pin D8 (GIO15)
    #define DHTPIN 4 //data pin D2 (GIO4)
    #define DHTTYPE DHT11 // sensor type
    //#define DEVICE_ID 1001 //WiL_IoT Device Catalog

    DHT dht(DHTPIN, DHTTYPE); //Object constructor to communicate as a sensor

    //Variables DHT11
    float h ;
    float tF;
    float t;
    unsigned long lastMillis = 0;
    unsigned long previousMillis = 0;
    const long interval = 5000;

    //Variables Capactive Resister
    const int AirValue = 705;   //you need to replace this value with Value_1
    const int WaterValue = 290;  //you need to replace this value with Value_2
    const int SensorPin = A0;
    int soilMoistureValue = 0;
    int soilmoisturepercent=0;
    int RelayControl1 = 5;
    int Valve = A0;

    //Variables Time
    time_t now;
    time_t nowish = 1510592825;

    //Variables SD Card
    File myFile;
    String fileName = "${each.value.name}_${each.value.short_name}.csv";
    unsigned temperatureF = 0; //added for SD card input
    unsigned temperatureC = 0; //added for SD card input
    unsigned flowRate = 0; //added for SD card input
    unsigned totalMilliLitres = 0; //added for SD card input

    //AWS_Certificate IDs
    WiFiClientSecure net;

    BearSSL::X509List cert(AWS_CERT_CA);
    BearSSL::X509List client_crt(AWS_CERT_CRT);
    BearSSL::PrivateKey key(AWS_CERT_PRIVATE);

    PubSubClient client(net);




    void NTPConnect(void)
    {
    Serial.print("Setting time using SNTP");
    configTime(TIME_ZONE * 3600, 0 * 3600, "pool.ntp.org", "time.nist.gov");
    now = time(nullptr);
    while (now < nowish)
    {
        delay(500);
        Serial.print(".");
        now = time(nullptr);
    }
    Serial.println("done!");
    struct tm timeinfo;
    gmtime_r(&now, &timeinfo);
    Serial.print("Current time: ");
    Serial.print(asctime(&timeinfo));
    }


    void messageReceived(char *topic, byte *payload, unsigned int length)
    {
    Serial.print("Received [");
    Serial.print(topic);
    Serial.print("]: ");
    for (int i = 0; i < length; i++)
    {
        Serial.print((char)payload[i]);
    }
    Serial.println();
    }


    void connectAWS()
    {
    delay(3000);
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    Serial.println(" ");
    Serial.println(String("Attempting to connect to SSID: ") + String(WIFI_SSID));

    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(1000);
    }

    NTPConnect();

    net.setTrustAnchors(&cert);
    net.setClientRSACert(&client_crt, &key);

    client.setServer(AWS_IOT_ENDPOINT, 8883);
    client.setCallback(messageReceived);


    Serial.println("Connecting to AWS IOT");

    while (!client.connect(THINGNAME))
    {
        Serial.print(".");
        delay(1000);
    }

    if (!client.connected()) {
        Serial.println("AWS IoT Timeout!");
        return;
    }

    { //Green LED ON indicates active data transfer to AWS
        digitalWrite(16, HIGH);
    }

    // Subscribe to a topic
    client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);

    Serial.println("AWS IoT Connected!");
    delay(1000);

    }


    void publishMessage() //Data sent to AWS
    {
    // Generate UUID. This value is used as the MessageId
    uuid.generate();

    StaticJsonDocument<200> doc;
    doc["MessageId"] = uuid;
    doc["DeviceId"] = DEVICE_ID;
    doc["Time"] = millis();
    doc["Humidity"] = h;
    doc["Flowrate_lpm"] = flowRate;
    doc["Flowrate_total"] = (totalMilliLitres);
    doc["Temperature_C"] = t;
    doc["Temperature_F"] = tF;
    doc["SoilMoistureValue"] = soilMoistureValue;
    doc["SoilMoisture"] = soilmoisturepercent;

    //_____ End Data sent to AWS

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer); // print to client
    client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
    }


    void setup()
    {
    Serial.begin(115200);
    connectAWS();
    dht.begin();
    pinMode(5, OUTPUT); // Relay
    pinMode(16, OUTPUT);// Initializes when Connected to AWS
    pinMode(A0, INPUT); // Moisture Sensor
    pinMode(RelayControl1, OUTPUT); // Water Valve Relay

    //SDCard_initialization
    initializeCard();

    /* //SDCard_File Delete_Overwrite
    if(SD.exists(fileName)) //check if the file already exists
    {
        SD.remove(fileName); //if it did, delete it
        Serial.print(fileName);
        Serial.println(" already exists.");
        Serial.println("It is being deleted and will be overwritten.");
    } */

    writeHeader();

    }

    //SDCard_Function initializeCard() to initialize the SD card ---------------
    void initializeCard()
    {
    //Serial.println("Beginning initialization of SD Card: ");

    if(!SD.begin(CS_PIN)) //of the SD card on pin GIO15 is not accessible
    {
        Serial.println("SD initialization failed");
        while (1); //infinite loop to force resetting the arduino
    }
    Serial.println("SD Initialized successfully"); //if you reach here it is setup successfully
    }

    //SDCard_writeHeader() function to write the header data to the data file ---------------
    void writeHeader()
    {
    myFile = SD.open(fileName, FILE_WRITE); // open file to edit (write)data to it

    if(myFile)
    {
        Serial.println("Writing to " + fileName + ": ");
        Serial.println("---------------\n");

        myFile.println("Now,deviceID,Time,Humidity,Temp_C,Temp_F,soilMoistureValue,soilMoisture%,FlowRate_LPM,Total Liters");

        myFile.close(); //close the file
    }

    else
    {
        Serial.println("error opening " + fileName);
    }
    }

    //SDCard_writeData() function to write the dataFields to the file ---------------
    void writeData()
    {
    myFile = SD.open(fileName, FILE_WRITE);

    if(myFile)
    {
        myFile.print(now); //print deviceID value
        myFile.print(","); //print comma
        myFile.print(DEVICE_ID); //print deviceID value
        myFile.print(","); //print comma
        myFile.print(millis()); //print time since ESP8266 last reset in milliseconds
        myFile.print(","); //print comma
        myFile.print(h); //print humidity value
        myFile.print(","); //print comma
        myFile.print(t); //print temp_C value
        myFile.print(","); //print comma
        myFile.print(tF); //print temp_F value
        myFile.print(","); //print comma
        myFile.print(soilMoistureValue); //print soilMoistureValue value
        myFile.print(","); //print comma
        myFile.print(soilmoisturepercent); //print soilmoisturepercent value
        myFile.print(","); //print comma
        myFile.print(flowRate); // FlowRate LPM
        myFile.print(","); //print comma
        myFile.println(totalMilliLitres); // Flowrate Total Liters

        myFile.close();
    }

    else
    {
        Serial.println("error opening " + fileName);
    }

    }

    void loop()
    {
    {
    //Serial.print("Current");
    configTime(TIME_ZONE * 3600, 0 * 3600, "pool.ntp.org", "time.nist.gov");
    now = time(nullptr);
    while (now < nowish)
    {
        delay(500);
        Serial.print(".");
        now = time(nullptr);
    }
    //Serial.println("done!");
    struct tm timeinfo;
    gmtime_r(&now, &timeinfo);
    //Serial.print("Time: ");
    Serial.print(asctime(&timeinfo));
    Serial.print(" ");
    //Serial.print(now);
    }

    {
    //Device_ID
        Serial.print("Device_ID: ");
        Serial.println(DEVICE_ID);
        Serial.print(" ");

    //DHT11
    h = dht.readHumidity();
    tF = ((dht.readTemperature()*1.8)+32); // Fahrenheit
    t = dht.readTemperature(); //Celcius
    /*
    if (isnan(h) || isnan(t) )  // Check if any reads failed and exit early (to try again).
    {
        Serial.println(F("Failed to read from DHT sensor!"));
        return;
    }
    */

    Serial.print(F("Humidity: "));
    Serial.print(h);
    Serial.print(F("%  Air Temperature: "));
    Serial.print(tF);
    Serial.print(F("°F / "));
    Serial.print(t);
    Serial.println(F("°C "));

    //Capactive Resister
    if (soilMoistureValue > 425)
    {
        digitalWrite(RelayControl1,HIGH);// NO1 and COM1 Connected (ValveOpen)
    }
    else
    {
        digitalWrite(RelayControl1,LOW);// NO1 and COM1 disconnected (ValveClosed)
    }

    soilMoistureValue = analogRead(SensorPin);  //put Sensor insert into soil

        Serial.print(" ");
        Serial.print("Capacitive Sensor Reading - ");
        Serial.println(soilMoistureValue);

        soilmoisturepercent = map(soilMoistureValue, AirValue, WaterValue, 0, 100);

    if(soilmoisturepercent >= 70)
    {
        Serial.print(" ");
        Serial.print(soilmoisturepercent);
        Serial.println("% - Valve Closed");
        Serial.println(" ");
    }
    else if(soilmoisturepercent <0)
    {
        Serial.print(" ");
        Serial.print(soilmoisturepercent);
        Serial.println("% Moisture - Valve Open");
        Serial.println(" ");
    }
    else if(soilmoisturepercent >=0 && soilmoisturepercent <= 73)
    {
        Serial.print(" ");
        Serial.print(soilmoisturepercent);
        Serial.println("% Moisture - Valve Open");
        Serial.println(" ");
    }

    writeData();

    delay(2000);
    }


    now = time(nullptr);

    if (!client.connected())
        {
        connectAWS();
        }
    else
        {
        client.loop();
        if (millis() - lastMillis > 5000)
        {
        lastMillis = millis();
        publishMessage();
        }
    }
    }


  EOF

}

// Flow Sensors - secrets.h file
resource "local_file" "dynamic_secrets_h_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  filename = "${path.root}/ARDUINO/FLOW_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/Secrets-${each.value.name}.h"
  content  = <<-EOF
    #include <pgmspace.h>

    #define SECRET

    #define THINGNAME "${each.value.name}"
    #define DEVICE_ID "${each.value.name}_${each.value.short_name}"

    int8_t TIME_ZONE = +1; //(GMT+1): Abuja, Nigeria

    #define AWS_IOT_ENDPOINT        "${data.aws_iot_endpoint.current.endpoint_address}"

    #define AWS_IOT_PUBLISH_TOPIC        "device/${each.value.name}_${each.value.short_name}/data"
    #define AWS_IOT_SUBSCRIBE_TOPIC        "device/${each.value.name}_${each.value.short_name}/data"


    #define WIFI_SSID        "${var.wifi_ssid}"
    #define WIFI_PASSWORD    "${var.wifi_password}"

    // Insert AWS Root CA1 contents below
    static const char AWS_CERT_CA[] PROGMEM = R"EOF(
    -----BEGIN CERTIFICATE-----
    MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF
    ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6
    b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL
    MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv
    b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj
    ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM
    9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw
    IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6
    VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L
    93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm
    jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
    AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA
    A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI
    U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs
    N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv
    o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU
    5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy
    rqXRfboQnoZsG4q5WTP468SQvvG5
    -----END CERTIFICATE-----

    )EOF";


    // Copy contents from XXXXXXXX-certificate.pem.crt here ▼
    // device certificate
    static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
    ${aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].certificate_pem}
    )KEY";


    // Copy contents from  XXXXXXXX-private.pem.key here ▼
    // device private key
    static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
    ${aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].private_key}
    )KEY";

  EOF

}

# Flow Array Sensors .ino file
resource "local_file" "dynamic_ino_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  filename = "${path.root}/ARDUINO/FLOW_SENSOR_ARRAYS_AWS_IOT/${each.value.name}/${each.value.name}.ino"
  # content  = aws_iot_certificate.cert.public_key
  content = <<-EOF
    /*
    BlackBox Series - ClimateSensor Array - DeviceId = ${each.value.name}/${each.value.name}
    Built for: WiL_Nigeria - Sustaining Water Project
    Managing Coders: Michael J. Watkins & Kevon Mayers
    www.BetterThingsLLC.com
    www.kevonmayers.com
    */

    //Libraries ---------------
    #include <ESP8266WiFi.h>
    #include <WiFiClientSecure.h>
    #include <PubSubClient.h>
    #include <LiquidCrystal_I2C.h>
    #include <ArduinoJson.h>
    #include <time.h>
    #include "Secrets-${each.value.name}.h"
    #include <SD.h>
    #include <SPI.h>
    #include <Wire.h>
    #include <Adafruit_GFX.h>
    #include <OneWire.h>
    #include <DallasTemperature.h>
    #include "UUID.h"

    UUID uuid;

    //Definitions ---------------
    #define TIME_ZONE +1 //(GMT+1)time for Abuja,Nigeria
    #define CS_PIN 15 //data pin D8 (GIO15)
    #define SENSOR  0 // sensor type

    // LCD number of columns and rows
    int lcdColumns = 16;
    int lcdRows = 2;
    LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows); // if you don't know your display address, run an I2C scanner sketch

    //DS18B20
    const int oneWireBus = 2; //data pin D4 (GIO2)
    OneWire oneWire(oneWireBus); //Setup a oneWire instance to communicate with any OneWire devices
    DallasTemperature sensors(&oneWire); //Pass our oneWire reference to DS18B20 sensor

    //WaterFlow Sensor Model GR-S403
    unsigned humidity = 0; //added for Timestream WiL_tbl input
    unsigned h = 0; //added for SD card input
    unsigned soilMoistureValue = 0; //added for Timestream WiL_tbl input
    unsigned soilmoisturepercent = 0;//added for Timestream WiL_tbl input
    unsigned long currentMillis = 0;
    unsigned long lastMillis = 0;
    unsigned long previousMillis = 0;
    int interval = 5000; //default code 1000
    boolean ledState = LOW;
    float calibrationFactor = 4.5;
    volatile byte pulseCount;
    byte pulse1Sec = 0;
    unsigned long flowMilliLitres;
    unsigned int totalMilliLitres;
    unsigned int totalLitres;
    float flowRate;
    float flowLitres;
    float temperatureC = sensors.getTempCByIndex(0);
    float temperatureF = sensors.getTempFByIndex(0);

    void IRAM_ATTR pulseCounter()
    {
    pulseCount++;
    }

    //Variables Time ---------------
    time_t now;
    time_t nowish = 1510592825;

    //Variables SD Card
    File myFile;
    String fileName = "${each.value.name}_${each.value.short_name}.csv";

    //AWS_Certificate IDs ---------------
    WiFiClientSecure net;

    BearSSL::X509List cert(AWS_CERT_CA);
    BearSSL::X509List client_crt(AWS_CERT_CRT);
    BearSSL::PrivateKey key(AWS_CERT_PRIVATE);

    PubSubClient client(net);


    //Function NTP Connection ---------------
    void NTPConnect(void)
    {
    Serial.print("Setting time using SNTP");
    configTime(TIME_ZONE * 3600, 0 * 3600, "pool.ntp.org", "time.nist.gov");
    now = time(nullptr);
    while (now < nowish)
    {
        delay(500);
        Serial.print(".");
        now = time(nullptr);
    }
    Serial.println("done!");
    struct tm timeinfo;
    gmtime_r(&now, &timeinfo);
    Serial.print("Current time: ");
    Serial.print(asctime(&timeinfo));

    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(asctime(&timeinfo));
    delay(3600);
    }

    //Function messageReceived Connection Verification ---------------
    void messageReceived(char *topic, byte *payload, unsigned int length)
    {
    Serial.print("Received [");
    Serial.print(topic);
    Serial.print("]: ");
    for (int i = 0; i < length; i++)
    {
        Serial.print((char)payload[i]);
    }
    Serial.println();
    }

    //Function AWS Connection ---------------
    void connectAWS()
    {
    //WIFI Connection Start
    delay(3000);
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    Serial.println(String("Connecting to ") + String(WIFI_SSID));
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connecting to...");
    lcd.setCursor(0, 1);
    lcd.print(WIFI_SSID);

    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(1000);
    }

    // Serial Print Dialog - WIFI Connected
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.print("Connected to ");
    Serial.println(WIFI_SSID);
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());

    // LCD Dialog - WIFI Connected
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connected!");
    lcd.setCursor(0, 1);
    lcd.print(WIFI_SSID);
    delay(3600);

    //LCD Dialog - IP Address
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Local IP");
    lcd.setCursor(0, 1);
    lcd.print(WiFi.localIP());
    delay(3600);

    NTPConnect();

    net.setTrustAnchors(&cert);
    net.setClientRSACert(&client_crt, &key);

    client.setServer(AWS_IOT_ENDPOINT, 8883);
    client.setCallback(messageReceived);


    Serial.println("Connecting to AWS IOT");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connecting...");
    lcd.setCursor(0, 1);
    lcd.print("AWS IOT");
    delay(3600);

    while (!client.connect(THINGNAME))
    {
        Serial.print(".");
        delay(1000);
    }

    if (!client.connected())
    {
        Serial.println("AWS IoT Timeout!");
        return;
    }

    // Subscribe to a topic
    client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);

    Serial.println("AWS IoT Connected!");
    Serial.println(" ");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connected!");
    lcd.setCursor(0, 1);
    lcd.print("AWS IOT");
    delay(3600);
    }

    //Function publishMessage ---------------
    void publishMessage() //Data sent to AWS
    {
    // Generate UUID. This value is used as the MessageId
    uuid.generate();

    StaticJsonDocument<200> doc;
    doc["MessageId"] = uuid;
    doc["DeviceId"] = DEVICE_ID;
    doc["Time"] = millis();
    doc["Humidity"] = humidity;
    doc["Flowrate_lpm"] = flowRate;
    doc["Flowrate_total"] = (totalMilliLitres);
    doc["Temperature_C"] = temperatureC;
    doc["Temperature_F"] = temperatureF;
    doc["SoilMoisturevValue"] = soilMoistureValue;
    doc["SoilMoisture"] = soilmoisturepercent;

    //_____ End Data sent to AWS

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer); // print to client
    client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
    }


    void setup()
    {
    Serial.begin(115200);

    while (!Serial){}; //wait for Serial Port to connect.

    // initialize LCD - turn on LCD backlight
    lcd.init();
    lcd.backlight();
    lcd.clear();
    delay(3600);

    //starting text
    Serial.println(" ");
    Serial.println(" ");
    Serial.println("System Start");
    lcd.print("System Start");
    delay(3600);
    lcd.clear();
    //turn-on power to FlowMeter notice
    lcd.setCursor(0, 0);
    lcd.println("FlowMeter Switch");
    delay(3600);
    Serial.println("Initializing the SD card");
    lcd.setCursor(0, 0);
    lcd.print("Init SD card");
    delay(3600);

    //SDCard_initialization
    initializeCard();

    /* //SDCard_File Delete_Overwrite
    if(SD.exists(fileName)) //check if the file already exists
    {
        SD.remove(fileName); //if it did, delete it
        Serial.print(fileName);
        Serial.println(" already exists.");
        Serial.println("It is being deleted and will be overwritten.");
    } */

    writeHeader();

    //process Notice
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connecting");
    lcd.setCursor(0, 1);
    lcd.print("WIFI & AWS");

    connectAWS(); //physical connection to AWS

    //FlowMeter pinMode(LED_BUILTIN, OUTPUT);
    pinMode(SENSOR, INPUT_PULLUP);

    pulseCount = 0;
    flowRate = 0.0;
    flowMilliLitres = 0;
    totalMilliLitres = 0;
    previousMillis = 0;

    attachInterrupt(digitalPinToInterrupt(SENSOR), pulseCounter, FALLING);

    //Start the DS18B20 sensor
    sensors.begin();
    }

    //SDCard_Function initializeCard() to initialize the SD card ---------------
    void initializeCard()
    {
    //Serial.println("Beginning initialization of SD Card: ");

    if(!SD.begin(CS_PIN)) //of the SD card on pin GIO15 is not accessible
    {
        Serial.println("SD initialization failed");
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("SD init Failed");
        while (1); //infinite loop to force resetting the arduino
    }
    Serial.println("SD Initialized successfully"); //if you reach here it is setup successfully
    //Serial.println("---------------\n");
    }

    //SDCard_writeHeader() function to write the header data to the data file ---------------
    void writeHeader()
    {
    myFile = SD.open(fileName, FILE_WRITE); // open file to edit (write)data to it

    lcd.setCursor(0, 1);
    lcd.print("Writing SD Card");
    delay(3600);
    lcd.clear();

    if(myFile)
    {
        Serial.println("Writing to " + fileName + ": ");
        Serial.println("---------------\n");

        myFile.println("Now,deviceID,Time,Humidity,Temp_C,Temp_F,soilMoistureValue,soilMoisture%,FlowRate_LPM,Total Liters");

        myFile.close(); //close the file
    }

    else
    {
        Serial.println("error opening " + fileName);
    }
    }

    //SDCard_writeData() function to write the dataFields to the file ---------------
    void writeData()
    {
    myFile = SD.open(fileName, FILE_WRITE);

    if(myFile)
    {
        myFile.print(now); //print DEVICE_ID value
        myFile.print(","); //print comma
        myFile.print(DEVICE_ID); //print DEVICE_ID value
        myFile.print(","); //print comma
        myFile.print(millis()); //print time since ESP8266 last reset in milliseconds
        myFile.print(","); //print comma
        myFile.print(h); //print humidity value
        myFile.print(","); //print comma
        myFile.print(temperatureC); //print temp_C value
        myFile.print(","); //print comma
        myFile.print(temperatureF); //print temp_F value
        myFile.print(","); //print comma
        myFile.print(soilMoistureValue); //print soilMoistureValue value
        myFile.print(","); //print comma
        myFile.print(soilmoisturepercent); //print soilmoisturepercent value
        myFile.print(","); //print comma
        myFile.print(flowRate); // FlowRate LPM
        myFile.print(","); //print comma
        myFile.println(totalMilliLitres); // Flowrate Total Liters

        myFile.close();
    }

    else
    {
        Serial.println("error opening " + fileName);
    }
    }


    void loop()
    {
    //Time Capture
    currentMillis = millis();
    if (currentMillis - previousMillis > interval)

    //Flow Meter & Temperature Calculations
    {
        pulse1Sec = pulseCount;
        pulseCount = 0;

        // Because this loop may not complete in exactly 1 second intervals we calculate
        // the number of milliseconds that have passed since the last execution and use
        // that to scale the output. We also apply the calibrationFactor to scale the output
        // based on the number of pulses per second per units of measure (litres/minute in
        // this case) coming from the sensor.
        flowRate = ((1000.0 / (millis() - previousMillis)) * pulse1Sec) / calibrationFactor;
        previousMillis = millis();

        // Divide the flow rate in litres/minute by 60 to determine how many litres have
        // passed through the sensor in this 1 second interval, then multiply by 1000 to
        // convert to millilitres.
        flowMilliLitres = (flowRate / 60) * 1000;
        //AccumTotalMilliLitres = flowMilliLitres / 1000;
        flowLitres = (flowRate / 60);

        // Add the millilitres passed in this second to the cumulative total
        totalMilliLitres += flowMilliLitres;
        totalLitres += flowLitres;

        //---------------

        //Print the flow rate for this second in litres / minute to Serial Monitor
        Serial.print("FlowRate: ");
        Serial.print(float(flowRate),1);  // Print the integer part of the variable
        Serial.print("LPM / ");
        //Serial.print("\t");       // Print tab space

        //Print the cumulative total of litres flowed since starting
        //Serial.print("Total Liters: ");
        // Serial.print(totalLitres);
        // Serial.print("L / ");
        Serial.print(totalMilliLitres);
        Serial.print("mL");
        Serial.println("\t");       // Print tab space

        //DallasTemp ---------------
        sensors.requestTemperatures();
        Serial.print("Temperature: ");
        Serial.print(temperatureC,1);
        Serial.print("˚C / ");
        Serial.print(temperatureF,1);
        Serial.println("˚F");
        Serial.println(" ");
        //Serial.print("\t");       // Print tab space

        //LCD Print the flow rate in litres / minute and cumulative total of litres flowed since starting
        //clears the display to print new message
        lcd.clear();

        lcd.setCursor(0, 0);
        lcd.print("Total: ");
        lcd.print(totalMilliLitres);
        lcd.print(" mL");
        lcd.setCursor(0, 1);
        lcd.print(temperatureF,1);
        lcd.print("\xDF F ");
        lcd.print(temperatureC,1);
        lcd.print("\xDF C");

    writeData();

    delay(6000);
    }

    now = time(nullptr);

    if (!client.connected())
        {
        connectAWS();
        }
    else
        {
        client.loop();
        if (millis() - lastMillis > 5000)
        {
        lastMillis = millis();
        publishMessage();
        }
    }
    }



  EOF

}
resource "local_file" "env" {
  count    = var.create_amplify_app ? 1 : 0
  filename = "${path.root}/../web-app/.env"
  content  = <<-EOF
  VITE_REGION=${data.aws_region.current.name}
  VITE_API_ID=${aws_appsync_graphql_api.appsync_graphql_api[0].id}
  VITE_GRAPHQL_URL=${aws_appsync_graphql_api.appsync_graphql_api[0].uris.GRAPHQL}
  VITE_IDENTITY_POOL_ID=${aws_cognito_identity_pool.identity_pool.id}
  VITE_USER_POOL_ID=${aws_cognito_user_pool.user_pool.id}
  VITE_APP_CLIENT_ID=${aws_cognito_user_pool_client.user_pool_client.id}
  VITE_IOT_ENDPOINT=${data.aws_iot_endpoint.current.endpoint_address}
  EOF


}



