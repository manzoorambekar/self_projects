#include "../inc/Data_Collector.hpp"
#include "../inc/Compute_BER.hpp"
#include "../inc/Lagrange.hpp"

/* Define the extern global variables */
Lagrange		lagrange;
Compute_BER 	comp_BER;
Data_Collector 	dataC[50];

int main(void)
{
    /* Loop for each SNR */
    for(int index = ZERO; index < snr_count; index++)
    {
        /* ---------------------------- Compute BER without Power allocation ---------------------------- */
        
        /* Evaluate System BER without Power Allocation */
        dataC[index].ber_without_pa = comp_BER.get_System_BER(dataC[index]);

        cout << "________________________________________________________________________________________"<<endl;
        cout << Fixed << SetPrecision(0,0) << "SNR = " << dataC[index].snr_db << "dB" << endl;
		cout << SetPrecision(25,13) << Scientific;
        cout << "System BER without PA =    " << dataC[index].ber_without_pa << endl << endl;

        /* ---------------------------- Compute BER with Power allocation ---------------------------- */
        
        cout << "Power Allocation factors computed using Lagrange Multiplier Method are," << endl;
		
        /* Derive the values of Power Allocation factors using Lagrange Multiplier method */
		lagrange.computeLSE(dataC[index]);
		
        /* Evaluate System BER with Power Allocation */
		dataC[index].ber_with_pa = comp_BER.get_System_BER(dataC[index]);
		
		cout << "System BER with PA    =    " << dataC[index].ber_with_pa << endl;
    }
    
    /* Export the data in csv file */
    Data_Collector::create_csv(dataC);
    
    cout << "\nExecution finished successfully!" << endl;
    
    return 0;
}
