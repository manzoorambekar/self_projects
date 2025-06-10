# Software Defined Radio (SDR) Using ADALM-PLUTO

This project demonstrates the use of the ADALM-PLUTO SDR device to perform signal transmission and reception in a flexible and software-configurable way. Using GNU Radio and Pluto SDR, this project explores real-time radio frequency signal processing including modulation, transmission, reception, and analysis.

---

## 📡 Overview

Software Defined Radio (SDR) is a radio communication system where components typically implemented in hardware are instead implemented in software. This project uses the **ADALM-PLUTO** SDR by Analog Devices to experiment with:

- Real-time transmission and reception of signals
- Digital modulation and demodulation (e.g., QPSK, BPSK, FM)
- Spectrum visualization and analysis
- GNU Radio for building and running SDR flowgraphs

---

## 🧰 Tools and Hardware

- **ADALM-PLUTO SDR**: A portable SDR device capable of operating from 325 MHz to 3.8 GHz.
- **GNU Radio Companion**: A graphical tool for creating signal processing flowgraphs.
- **MATLAB / Simulink** *(optional)*: For advanced signal processing or model simulation.
- **Antenna**: For transmitting and receiving RF signals.
- **Linux/Windows OS**: Compatible with both for running SDR software.

---

## ⚙️ Features

- Transmit test signals such as sine waves, QPSK, or custom waveforms
- Receive live signals from the air and decode them
- Analyze spectrum, power levels, and SNR in real-time
- Adjustable parameters: frequency, gain, bandwidth, sampling rate

---

## 🧪 Sample Experiments

1. **FM Transmission and Reception**
2. **QPSK Modulation and Demodulation**
3. **Spectrum Analyzer**
4. **Loopback Communication**
5. **Signal Filtering and Noise Suppression**

Each experiment demonstrates a specific concept in SDR and is implemented using flowgraphs in GNU Radio.

---

## 📁 Project Structure

```
SDR Using Adalm-Pluto/
├── QAM_Receiver/             # Matlab source files for the receiver
├── QAM_Transmitter/          # Matlab source files for the transmitter
├── README.md                 # Project description
└── Docs/                     # Project documentations
```

---

## 🚀 Getting Started

1. Connect ADALM-PLUTO via USB.
2. Install required software:
   - [GNU Radio](https://wiki.gnuradio.org/index.php/InstallingGR)
   - PlutoSDR drivers
3. Load `.grc` files into GNU Radio Companion.
4. Configure frequency, gain, and run the flowgraph.

---

## 🔗 References

- [ADALM-PLUTO Wiki](https://wiki.analog.com/university/tools/pluto)
- [GNU Radio Docs](https://wiki.gnuradio.org/)
- [Pluto SDR MATLAB Support](https://www.mathworks.com/hardware-support/pluto-sdr.html)
- [SDR# for Windows](https://airspy.com/sdrsharp/)

---

## 👨‍💻 Author

**Manzoor Ambekar**

Feel free to contribute or raise issues to enhance this project!
