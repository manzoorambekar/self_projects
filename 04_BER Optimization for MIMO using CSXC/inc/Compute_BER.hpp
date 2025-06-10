#ifndef 	__COMP_BER_H_
#define 	__COMP_BER_H_

#include "../inc/Data_Collector.hpp"

using namespace cxsc;

/* Class to provides interfaces to calculate System BER */
class Compute_BER
{
    public: real f()
    {
		real denominator = 0;
		for(uint layer_count = ZERO; layer_count < active_layers_count; layer_count++)
			denominator += log2(M[layer_count]);
			
        return (2.0/denominator);
    }

    public: interval g(real Ml, real lambda, real sigma, real ps, interval pi)
    {
		interval temp1  = ((lambda*pi)/(2.0*sigma));
		real temp2  = sqrt((3.0*ps) / (3.0*(Ml-1.0)));
		
		return  temp1 * temp2; 
    }

    public: interval get_System_BER(Data_Collector dataC_of_Snr)
    {
        interval 	ber = interval(0);

        for(uint layer_count = ZERO; layer_count < active_layers_count; layer_count++)
        {
            interval 	gx = g(M[layer_count], dataC_of_Snr.lambda[layer_count], dataC_of_Snr.sigma, dataC_of_Snr.ps, dataC_of_Snr.pi[layer_count]);
            
			real temp1 = (1.0-(1.0/sqrt(M[layer_count])));
            ber +=  temp1 * erfc(gx);
        }
        
        interval total_ber = f() * ber;
        
        return total_ber;
    }
};

#endif
