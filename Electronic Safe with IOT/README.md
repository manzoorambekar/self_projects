# 🔐 Electronic Safe with IoT

A technologically advanced, remotely accessible electronic safe integrating Arduino, Raspberry Pi, sensors, and IoT automation to ensure secure, real-time monitoring and control.

## 📌 Motivation

- Enhanced security through real-time monitoring and alerts
- SOS signal for theft or emergencies
- Remote monitoring via IoT
- Audit trails and environmental condition logs
- Easy to use and extend
- Straightforward upgrade path for future features

---

## 🧩 System Overview

The project combines hardware and software to create a smart electronic safe with:

- **Arduino** and **Raspberry Pi** as the primary controllers
- **DHT11 Sensor** for temperature monitoring
- **Motion sensor**, **buzzer**, **keypad**, **servo motor**, and **LEDs**
- **IFTTT integration** for real-time notifications and automation

This secure system enhances traditional safes with smart, user-friendly control and continuous monitoring.

---

## 🔄 System Workflow

1. **User Authentication**: Password input via keypad
2. **Sensor Monitoring**: Motion and temperature sensors active
3. **Servo Locking Mechanism**: Unlocks safe upon valid entry
4. **Real-time Alerts**: Uses IFTTT webhook to notify users
5. **Environmental Logs**: DHT11 data is monitored and optionally logged
6. **Raspberry Pi** handles automation, logic coordination, and cloud connectivity

---

## 📚 Libraries Used

| Library           | Purpose                           |
|------------------|-----------------------------------|
| `Adafruit_DHT`   | Reads DHT11 temperature sensor    |
| `Time`           | Time tracking                     |
| `PyFirmata`      | Arduino communication via Firmata |
| `chestnut.arduino` | Flashing Firmata to Arduino     |
| `RPi.GPIO`       | Raspberry Pi GPIO pin control     |
| `gpiozero`       | Servo motor and peripheral control|
| `ifttt_webhook`  | Triggers IFTTT applets            |

---

## 🌐 IoT Integration

- **IFTTT Webhooks** send real-time alerts on:
  - Unauthorized access attempts
  - Environmental anomalies (e.g., temperature rise)
- Future integration planned with home automation systems and SMS gateways

---

## 🔮 Future Scope

- Biometric or facial recognition authentication
- Two-factor authentication
- Smart card access
- Touch screen UI
- SMS notifications and call alerts
- Energy-efficient components
- More rugged locking mechanisms

---

## ✅ Conclusion

Testing demonstrated that:

- The safe reliably detects motion and temperature anomalies
- Provides secure access through password authentication
- Sends real-time alerts via IFTTT to notify users

This project successfully illustrates the potential for modern technology to transform traditional safekeeping methods, enhancing security, usability, and remote oversight.

---

---

## Authors
- **Manzoor Ambekar**
- **Sneha Potadar**

**Guided by:**  
- Prof. Dr.-Ing. habil. Olaf Simanski  
- Dipl.-Ing. Uwe Starke  

---
> 📅 **Date Presented:** March 8, 2023  
> 🏛 **Department:** Information and Electrical Engineering, Hochschule Wismar


