import matplotlib.pyplot as plt
import numpy as np
import csv

snr = np.zeros(11)
ber = np.zeros(11)
ber_PA = np.zeros(11)
with open('data/data_task1.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count != 0:
            snr[line_count-1] = row[0]
            ber[line_count-1] = row[1]
            ber_PA[line_count-1] = row[2]
        line_count += 1

plt.figure(0)
plt.subplot(2,1,1)
plt.plot(snr, ber, marker='o')
plt.plot(snr, ber_PA, marker='o')
plt.xlim([10, 20])
plt.grid(1)
plt.title("M1 = 64, M2 = 2, M3 = 2")
plt.xlabel("SNR in dB")
plt.ylabel("BER")
plt.legend(('BER without PA','BER With PA'))

snr = np.zeros(11)
ber = np.zeros(11)
ber_PA = np.zeros(11)
with open('data/data_task2.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count != 0:
            snr[line_count-1] = row[0]
            ber[line_count-1] = row[1]
            ber_PA[line_count-1] = row[2]
        line_count += 1

plt.subplot(2,1,2)
plt.plot(snr, ber, marker='o')
plt.plot(snr, ber_PA, marker='o')
plt.xlim([10, 20])
plt.grid(1)
plt.title("M1 = 32, M2 = 4, M3 = 2")
plt.xlabel("SNR in dB")
plt.ylabel("BER")
plt.legend(('BER without PA','BER With PA'))
