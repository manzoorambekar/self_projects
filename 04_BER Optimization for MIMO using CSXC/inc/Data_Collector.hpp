#ifndef 	__DATACOLLECTOR_H_
#define 	__DATACOLLECTOR_H_

#include <cstdio> 
#include <nlinsys.hpp> 
#include "interval.hpp"
#include <fstream>

using namespace cxsc;

#define 	LAYERS_COUNT 	4U

typedef unsigned int uint;

/* Static global variables required for every Data_Collector object */
static 	int 	snr_min = ZERO, snr_max = ZERO, obj_count = ZERO;
static 	int 	snr_count = ZERO;
static  uint	active_layers_count = ZERO; 

/* Number of bits per symbol for each layer */
static 	real 	M[LAYERS_COUNT];

/* Collection of the data for the parameters required in MIMO transmission */
class Data_Collector
{
    /* Singular values */
    public:  real 		lambda[LAYERS_COUNT] = {real(3.698971), real(2.107508), real(1.348946), real(0.366802)};
    
    /* Overall available transmit power */
    public:  real 		ps = 1.0;

	/* Noise Power */
    public:  real 		sigma;
    public:  real 		snr_db;
    
	/* Without Power Allocation default values of pi1, pi2, and p3 are kept as 1 */
    public:  interval 	pi[LAYERS_COUNT] = {interval(1), interval(1), interval(1), interval(1)};
    
    public:  interval 	ber_without_pa;
    public:  interval 	ber_with_pa;

	/* Evaluates sigma for SNR in db */
    private: real 		get_SnrVsSigma(real snr)
    {
        return 	 sqrt(1.0/(2.0*snr));
    }
    
	/* Constructor of the class Data_Collector */
    public: Data_Collector()
    {
		/* One time user interface */
		if(snr_min == ZERO)
		{
			cout << "Enter the SNR range in db: " << endl;
			cin  >> snr_min; cin >> snr_max;
			snr_count = snr_max+1-snr_min;
			
			//cout << "Enter the active layers count: " << endl;
			//cin  >> active_layers_count;
			/* Static assignment to the active_layers_count: can be modified for different use cases */
			active_layers_count = 3U;
			
			cout << "Enter the bits/Symbol for each layer: " << endl;
			for(uint i = ZERO ; i < active_layers_count ; i++)
				cin >> M[i];
		}
		
		/* Initialize SNR and sigma */
		snr_db 		= 	real(obj_count-1 + snr_min);
		sigma 		= 	get_SnrVsSigma(snr_db);
		
		obj_count++;
    }
    
    /* Function exports the required data into csv file for further processing */
    public: static void create_csv(Data_Collector* dataC)
	{
		fstream fout;
		
		char in_csv;
		string in_csv_name;
		cout << "\nDo you want to create the csv file for further use? (y/n)" << endl;
		cin >> in_csv;
		if(in_csv == 'y')
		{
			cout << "\nPlease enter the file name:" << endl;
			cin >> in_csv_name;
			/* opens an existing csv file or creates a new file. */
			fout.open("../data/"+ in_csv_name + ".csv", ios::out | ios::app);
			
			fout << "SNR (dB), BER without PA, BER with PA\n";
			
			for(int index = ZERO; index < snr_count; index++)
			{
				fout << Fixed << SetPrecision(0,0)
					 << dataC[index].snr_db << ", ";
				
				fout << Fixed << SetPrecision(13,13)
					 << mid(dataC[index].ber_without_pa) << ", "
					 << mid(dataC[index].ber_with_pa)
					 << "\n";
			}
		}
	}
};

#endif

