#ifndef 	__LAGRANGE_H_
#define 	__LAGRANGE_H_

#include "../inc/Data_Collector.hpp"
#include "../inc/Compute_BER.hpp"

/* Object of Data_Collector, containing information regrading MIMO system for single SNR */
Data_Collector dataC_of_Snr;

/* Provides Lagrangian to nlinsys class */
GTvector f ( const GTvector& p )
{
	uint n = p.Dim();
	GTvector res(4);

	real temp1 = (2.0/(log2(M[0]) + log2(M[1]) + log2(M[2])));
	for(uint i = 1 ; i <= n-1U ; i++)
	{
		real temp2 = (1.0-(1.0/sqrt(M[i-1])))*(2.0/sqrt(Pi_real));

		real temp3 = ((dataC_of_Snr.lambda[i])/(2.0*dataC_of_Snr.sigma)) * (sqrt(( 3.0*dataC_of_Snr.ps) / (3.0*(M[i-1]-1.0))));

		GradType temp4 = (-exp(-sqr(p[i]*temp3)));
		
		GradType temp5 = 2.0*p[i]*p[4];
		
		res[i] = temp1 * temp2 * temp3 * temp4 + temp5;
	}

	res[n]=sqr(p[1])+sqr(p[2])+sqr(p[3]) - 3.0;
	return res;
}

/* Class to provides interfaces to calculate Lagrange Multiplier */
class Lagrange
{
	/* Computes Lagrange Multiplier and updates the candidated in Data_Collector class */
	public: void computeLSE(Data_Collector& dataC_itr)
	{
		dataC_of_Snr = dataC_itr;
		ivector   SearchInterval(active_layers_count+1);
		imatrix   Solu = imatrix(0);
		intvector Unique;
		int       NumberOfSolus=0, Error;
		interval onlyXi(0);

		//SearchInterval[1]=interval(0.0,2.0);SearchInterval[2]=interval(0.0,2.0);SearchInterval[3]=interval(0.0,2.0);SearchInterval[4]=interval(0.0,2.0);
		real tolerance=10e-5;

		for(uint i = 1 ; i <= active_layers_count+1 ; i++)
		{
			SearchInterval[i] = interval(0.0, 2.0);
		}
	   
		AllNLSS(f, SearchInterval, tolerance, Solu, Unique, NumberOfSolus, Error);

		std::cout << SetPrecision(23,15) << Scientific;   // Output format
		
		cout << "             Candidate: 1" << endl;
		
		/* Considering only the first locally enclosed zero */
		for(uint i = 1 ; i <= active_layers_count ; i++)
		{
			dataC_itr.pi[i-1] = Solu[1][i];
			cout << "             pi"<<i<<"      = " << Solu[1][i] << endl;
		}
		cout << "             meu      = " << Solu[1][active_layers_count+1] << endl << endl;
		
		if (Error)
			cout << endl << AllNLSSErrMsg(Error) << endl;
		else if ( (NumberOfSolus == 1) && Unique[1] )
			cout << endl << "We have validated that there is a globally unique zero!"
				<< endl;
	}
};

#endif
