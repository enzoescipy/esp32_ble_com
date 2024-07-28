#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer *pServer = NULL;
BLECharacteristic *pNotifyCharacteristic = NULL;
BLECharacteristic *pWriteCharacteristic = NULL;

bool deviceConnected = false;
bool oldDeviceConnected = false;
char value[] = "hello, world!";

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_NOTIFY_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_WRITE_UUID "118c877b-59b9-4610-827c-d5173aed4c27"

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *pServer)
    {
        delay(1000);
        deviceConnected = true;
    };

    void onDisconnect(BLEServer *pServer)
    {
        delay(1000);
        deviceConnected = false;
    }
};

void setup()
{
    Serial.begin(115200);

    // Create the BLE Device
    BLEDevice::init("ESP32");

    // Create the BLE Server
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    // Create the BLE Service
    BLEService *pService = pServer->createService(SERVICE_UUID);

    // Create a BLE Characteristic
    pNotifyCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_NOTIFY_UUID,
        BLECharacteristic::PROPERTY_NOTIFY);
    // Creates BLE Descriptor 0x2902: Client Characteristic Configuration Descriptor (CCCD)
    pNotifyCharacteristic->addDescriptor(new BLE2902());

    // Create a BLE Characteristic
    pWriteCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_WRITE_UUID,
        BLECharacteristic::PROPERTY_WRITE);

    // Creates BLE Descriptor 0x2902: Client Characteristic Configuration Descriptor (CCCD)
    pWriteCharacteristic->addDescriptor(new BLE2902());

    // Start the service
    pService->start();

    // Start advertising
    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->setScanResponse(false);
    pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
    BLEDevice::startAdvertising();
    Serial.println("Waiting a client connection to notify...");
}

void loop()
{
    // notify changed value
    if (deviceConnected) {
        pNotifyCharacteristic->setValue((uint8_t *)&value, 11);
        pNotifyCharacteristic->notify();

        std::string value = pWriteCharacteristic->getValue();
        if (value.length() > 0) {
            pWriteCharacteristic->setValue((uint8_t *) "",0);
            Serial.println(value.c_str());
        }
        delay(1500);
    }

    // disconnecting
    if (!deviceConnected && oldDeviceConnected)
    {
        delay(500);                  // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("start advertising");
        oldDeviceConnected = deviceConnected;
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected)
    {
        Serial.println("connection lost.");
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }
}