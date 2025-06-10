
cd src
g++ -Wall -Wno-deprecated -I/home/mint/cxsc/include/ -L/home/mint/cxsc/lib/ -Wl,-R/home/mint/cxsc/lib/ Main.cpp -lcxsc -o out
./out
rm out
