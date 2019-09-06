#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdlib.h>

using namespace std;

int main ( int argc, char** argv ){
	if( argc >= 2){
		string arg1(argv[1]);
		if( arg1 == "--help" || arg1 == "-h" || arg1 == "-help"){
			//print help menu

		} else if( argc >= 3 && (arg1[1] == 'r' || arg1[1] == 'R') ){
			string arg2( argv[2] );
			const char coln_char =	argv[1][2];
			int coln = atoi( &coln_char );
			int rown = 0;
			int row = 0, col = 0;
			vector< vector<double> > data;
			vector<double> average;
			vector<double> stdderiv;
			ifstream data_file( arg2.c_str(), ifstream::in );
			
			// read file to memory
			while( !data_file.eof() ){
				vector<double> new_row;
				rown++;
				for( int i = 0; i < coln; i++ ){
					double new_point;
					data_file >> new_point;
					new_row.push_back(new_point);
				}
				data.push_back(new_row);
				
			}

			// close file			
			data_file.close();
			
			// print to screen
			for( row = 0; row < rown ; row++ ){
				for( col = 0; col < coln; col++ ){
					cout << data[row][col] << ' ';
				}
				cout << endl;
			}

			// calculate average
			for( col = 0; col < coln; col++ ){
				double sum = 0;
				for( row = 0; row < rown; row++ ){
					sum += data[row][col]; 
				}
				average.push_back(sum/row);
			}

			// calculate standard derivative
			for( col = 0; col < coln; col++ ){
				double deriv_sum = 0;
				for( row = 0; row < rown; row++ ){
					deriv_sum += (data[row][col] - average[col]) * (data[row][col] - average[col]);
				}
				stdderiv.push_back( deriv_sum / (row-1) );
			}

			// print result
			for( col = 0; col < coln; col++ ){
				cout << col << "\t(" << average[col] <<"," << stdderiv[col] << ")" << endl;
			}
		}
	}
}
