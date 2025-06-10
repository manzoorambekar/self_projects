# BER Optimization for MIMO using CSXC

This project presents a method for optimizing the Bit Error Rate (BER) in a MIMO (Multiple Input Multiple Output) communication system using a power allocation strategy powered by the C-XSC (C++ eXtension for Scientific Computing) library. The implementation considers a 3-layer MIMO system and leverages Lagrange multipliers to allocate power effectively among layers to reduce the BER.

---

## 📌 Overview

In a MIMO system where multiple transmitter and receiver antennas are used, interference among channels can lead to an increase in the Bit Error Rate (BER). This project:

- Uses **Singular Value Decomposition (SVD)** to enhance channel separation.
- Introduces a **power allocation algorithm** to further reduce BER.
- Applies **Lagrange multiplier optimization** to determine optimal power distribution across three active transmission layers.
- Simulates the system using the **C-XSC library** for high-precision interval arithmetic and mathematical computation.

---

## 📈 Problem Statement

The traditional MIMO system assumes equal power distribution across layers, which is not always optimal for minimizing BER. By selectively allocating more power to layers based on their channel conditions, we can minimize the overall BER of the system.

---

## 🔧 Methodology

1. **SVD-based Channel Decomposition**  
   Decomposes the MIMO channel using SVD to simplify power distribution and analysis.

2. **Lagrangian Optimization**  
   Uses a Lagrangian function to find optimal power allocation factors (π₁, π₂, π₃) that minimize the overall BER under the constraint that the total power remains constant.

3. **C-XSC Based Implementation**  
   Non-linear equations resulting from partial derivatives of the Lagrangian are numerically solved using the C-XSC library to obtain power allocation values.

---

## 📊 Results

The system was tested under two configurations:

1. **M1 = 64, M2 = 2, M3 = 2**
2. **M1 = 32, M2 = 4, M3 = 2**

For both configurations, BER was significantly reduced using power allocation across SNR values from 10 dB to 20 dB.

Example result:
```
SNR (dB): 15
BER without PA: 1.56E-02
BER with PA:    1.24E-03
```

Graphs and tabulated results clearly show that power allocation leads to substantial BER improvement.

---

## 🧩 System Design

- **Static Design**: Class diagrams define relationships between modules.
- **Dynamic Design**: Sequence diagrams explain execution flow and interactions between components.

---

## 🛠️ Technologies Used

- C++
- C-XSC Library (https://www2.math.uni-wuppertal.de/wrswt/xsc/cxsc/apidoc/html/index.html)
- Matplotlib (for plotting results)
- NumPy
- Sparx Systems Enterprise Architect (for UML diagrams)

---

## 📁 Folder Structure

```
BER Optimization for MIMO using CSXC/
├── src/                      # Source files for simulation
├── plots/                    # Graphs of SNR vs BER
├── report/                   # Project report PDF
├── README.md                 # Project description
└── data/                     # Output and tabulated data
```

---

## 📚 References

- [Lagrange Multipliers – Wikipedia](https://en.wikipedia.org/wiki/Lagrange_multiplier#Example_1)
- [C-XSC Library](http://www2.math.uni-wuppertal.de/wrswt/xsc/cxsc/apidoc/html/index.html)
- [3x3 MIMO Channel Model – ResearchGate](https://www.researchgate.net/figure/Representation-of-3X3-MIMO-channel_fig1_322070644)

---

## 👨‍🎓 Authors

- **Tilak Dal**  
- **Manzoor Ambekar**  
- **Mohit Singh Bhandari**  
- **Mayur Mankar**

Under the guidance of **Prof. Dr. rer.nat. habil Ekatrina Auer**, Hochschule Wismar.
