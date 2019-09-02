#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>
#include <cassert>

using namespace std;

// argv[0] = exe name
// argv[1] = options
// argv[2] = format
// argv[3] = file name

typedef int DATA_TYPE;

typedef vector< pair <vector <string>, vector <string> > > FORMAT;

vector<string> tokenize_option( const char* material, char delim ){
	string s(material);
	vector<unsigned int> slash;	
	vector<string> phrases;
	bool in_quote(0);
	// bool close_quote(0);
	// find all the slashes, ignore the ones in quotation mark
	// need a universal way to ignore dashes in quotes
	for( unsigned int i = 0; i < s.size(); i++ ){
		if( s[i] == '-' ){
			if( !in_quote ){
				slash.push_back(i);
			} else {
				in_quote = 0;
			}
		}
		if( s[i] == '\"' ){
			//cout << "found quote\n";
			slash[slash.size()-1] += 1;
			in_quote = 1;
		}
	}
	//cout << "number of slashes: " << slash.size() << endl;
	for( unsigned int i = 0; i < slash.size(); i++ ){
		if( i != 0 && s[slash[i]-1] == '-' ){
			slash.erase(slash.begin() + i-1 );
			//cout << "found a double dash\n";
		}
	}
	//cout << "number of valid slashes: " << slash.size() << endl;
	for( unsigned int i = 0; i < slash.size(); i++ ){
		if( i < slash.size()-1 && slash[i+1] < s.size() ){
			string item( &s[slash[i]]+1, slash[i+1] - slash[i] -1 );
			phrases.push_back( item );
		} else if ( i == slash.size()-1 ){	
			string item( &s[slash[i]]+1 );
			phrases.push_back( item );
		}
	}
	//cout << "number of phrases: " << phrases.size() << endl;
	for( unsigned int i = 0; i < phrases.size(); i++ ){
		cout << phrases[i] << endl;
	}
	return phrases;
}

vector<string> tokenize_format( const char* material, char delim ){
	string s(material);
	vector<unsigned int> slash;	
	vector<string> phrases;
	for( unsigned int i = 0; i < s.size(); i++ ){
		if( s[i] == '-' ){
			slash.push_back(i);
		}
	}
	//cout << "number of slashes: " << slash.size() << endl;
	for( unsigned int i = 0; i < slash.size(); i++ ){
		if( i < slash.size()-1 && slash[i+1] < s.size() && s[slash[i]+1] != '-' ){
			string item( &s[slash[i]]+1, slash[i+1] - slash[i] -1 );
			phrases.push_back( item );
		} else if ( i == slash.size()-1 ){	
			string item( &s[slash[i]]+1 );
			phrases.push_back( item );
		}
	}
	//cout << "number of phrases: " << phrases.size() << endl;
	for( unsigned int i = 0; i < phrases.size(); i++ ){
		cout << phrases[i] << endl;
	}
	return phrases;
}

void tokenize_and_add( FORMAT* format, const char* material, char delim ){
	// ie --0={--"SSL-Vision-Ball-0}{--N-N-(Y-Y)}
	pair< vector<string>, vector<string> > return_value;
	string s(material);
	size_t size = s.size();
	size_t p1 = s.find_first_of("{");
	size_t p2 = s.find_last_of("{");
	assert( p1 != string::npos );
	assert( p2 != string::npos );
	string s1( material + p1 + 1, p2 - p1 - 2 );
	string s2( material + p2 + 1, size - p2 - 2 );
	cout << s1 << "\t" << s2 << "\n";
	if( s[0] == '-' && s[1] == '-' && s[3] == '=' ){ // then is valid
		return_value.first = tokenize_option( s1.c_str(), delim );
		return_value.second = tokenize_format( s2.c_str(), delim );
		format->push_back(return_value);
	} else {
		cout << "bad format \n";
	}
	return;
}

string remove_char( string target, char unwanted ){
	unsigned int size = target.size();
	unsigned int offset = 0;
	char result_char[size];
	for( unsigned int i = 0; i < size; i++ ){
		if( target[i] == unwanted ){
			offset++;
			continue;
		}
		result_char[i-offset] = target[i];
	}
	result_char[size-offset] = '\0';
	return string(result_char);
}


string extract_values( stringstream *current_line, vector<string> form ){
	// when I have time I will clean up the code
	stringstream extracted_values;
	char str[1000]; // should avoid this
	for( unsigned int i = 0; i < form.size(); i++ ){ // only parse up to the specified forrmat, ignore up to the end of the same line
		(*current_line) >> str; // str is raw data in char array
		cout << str << '\t';
		string istr(str); // istr is raw data in string
		cout << istr.size() << '\t';
		string ostr; // ostr is output data
		string cform( form[i] ); // cform is format
		cout << cform.size() << '\t';
		unsigned int y_index = cform.find('Y');
		cout << y_index << '\t';	
		int end_index = istr.size() - cform.size();
		cout << end_index << '\t';
		if( y_index == string::npos ){
			continue;
		} else if( y_index == 0 && cform.size() == 1 ) {
			//cout << "ding!" << str << endl;	
			ostr = string(str);	
		} else if( y_index == 0 && cform.size() != 1 ){
			ostr = string(str, size_t(end_index + 1) );
		} else if( y_index != 0 && cform.size() != 1 ){
			ostr = string(str + y_index, size_t(end_index+1) );
		}
		if( ostr.size() != 0 ){
			string oostr = remove_char( ostr, ',' );
			extracted_values << oostr << '\t' ;
			cout << oostr << '\n';
		}
	}
	return string( extracted_values.str() );
}

string extract_values( fstream *log_data, vector<string> form ){
	// when I have time I will clean up the code
	stringstream extracted_values;
	char str[1000]; // should avoid this
	for( unsigned int i = 0; i < form.size(); i++ ){ // only parse up to the specified forrmat, ignore up to the end of the same line
		(*log_data) >> str; // str is raw data in char array
		cout << str << '\t';
		string istr(str); // istr is raw data in string
		cout << istr.size() << '\t';
		string ostr; // ostr is output data
		string cform( form[i] ); // cform is format
		cout << cform.size() << '\t';
		unsigned int y_index = cform.find('Y');
		cout << y_index << '\t';	
		int end_index = istr.size() - cform.size();
		cout << end_index << '\t';
		if( y_index == string::npos ){
			continue;
		} else if( y_index == 0 && cform.size() == 1 ) {
			//cout << "ding!" << str << endl;	
			ostr = string(str);	
		} else if( y_index == 0 && cform.size() != 1 ){
			ostr = string(str, size_t(end_index + 1) );
		} else if( y_index != 0 && cform.size() != 1 ){
			ostr = string(str + y_index, size_t(end_index+1) );
		}
		if( ostr.size() != 0 ){
			string oostr = remove_char( ostr, ',' );
			extracted_values << oostr << '\t' ;
			cout << oostr << '\n';
		}
	}
	return string( extracted_values.str() );
}

bool wanted_line( stringstream *current_line, vector<string> token ){
	char str[1000];
	int i = 0;
	bool quit = false;
	for( i = 0; !quit && i < int(token.size()); i++ ){
		(* current_line) >> str;
		string s(str);
		if( s != string(token[i]) ){
			//cout << "want " << token[i] << ": " << s << endl;	
			//cout << "ignore line \n"
			i = -2; // mark index to toss the rest of the line.
			quit = true;
		}
	}
	if(quit){
		return false;
	} else {
		return true;
	}
}

bool wanted_line( fstream *log_data, vector<string> token ){
	char str[1000];
	int i = 0;
	bool quit = false;
	for( i = 0; !quit && i < int(token.size()); i++ ){
		(* log_data) >> str;
		string s(str);
		if( s != string(token[i]) ){
			//cout << "want " << token[i] << ": " << s << endl;	
			//cout << "ignore line \n"
			i = -2; // mark index to toss the rest of the line.
			quit = true;
		}
	}
	if(quit){
		return false;
	} else {
		return true;
	}
}

string parse_by_line( string new_line, FORMAT form ){
	unsigned int total_types = form.size();
	DATA_TYPE new_find = -1; 
	bool quit = false;
	string data;
	
	for( unsigned int i = 0; !quit && i < total_types; i++ ){
		vector<string> data_name = form[i].first;
		stringstream new_line_ss(new_line);
		if( wanted_line( &new_line_ss, data_name ) ){
			new_find = i;
			data = extract_values( &new_line_ss, form[i].second );
			quit = true;
		}
	}

	// FORMAT[0] denote where the line breaks
	if( new_find == 0 ){
		data += "\n";
	}

	return data;

}

void multi_task_parser( fstream *log_data, fstream *out_data, FORMAT form ){
	while( !log_data->eof() ){
		char str[1000]; // a better way for this?
		log_data->getline(str, 1000);
		string output = parse_by_line( string(str), form );
		(*out_data) << output;
		cout << output ;
	}
}

void stateful_parser( fstream *log_data, fstream *out_data, FORMAT form ){
	// used to append dection information before ssl-vision output
	vector<string> memory( form.size() - 1 );
	while( !log_data->eof() ){
		char new_line[1000];
		log_data->getline(new_line, 1000);
		unsigned int total_types = form.size();
		bool quit = false;
		
		// scan from 1
		for( unsigned int i = 1; !quit && i < total_types; i++ ){
			vector<string> data_name = form[i].first;
			stringstream new_line_ss(new_line);
			if( wanted_line( &new_line_ss, data_name ) ){
				string extracted =  extract_values( &new_line_ss, form[i].second );
				memory[i-1].clear();
				memory[i-1].append( extracted );
				quit = true;
			}
		}

		stringstream new_line_ss( new_line );
		if( wanted_line( &new_line_ss, form[0].first ) ){
			// FORMAT[0] denote where the line breaks
			( *out_data ) << extract_values( &new_line_ss, form[0].second ) << "\t";
			for( unsigned int i = 0; i < memory.size(); i++ ){
				( *out_data ) << memory[i].c_str() << "\t";
				memory[i].clear();
			}
			(*out_data) << "\n";
		}
	
	}
}

void legacy_parser( fstream *log_data, fstream *out_data, vector<string> data_name, vector<string> data_form ){
		while( !log_data->eof() ){	
			if( !(wanted_line( log_data, data_name )) ){
				log_data->ignore( 1000, '\n' );
				//cout << "0";
				continue;
			} //cout << "1";
			//cout << endl;
			(*out_data) << extract_values( log_data, data_form ) << endl;
			//cout << "!!!!!!!!!!!!!!!!!!!!!!!!!\n" ;
			log_data->ignore( 1000, '\n' );
		}
}


int main (int argc, char *argv[]){
	/*if(argc == 1){
		string ci;
		int index;
		char c;
		cin >> ci;
		//cout << ci << endl;
		cin >> index;
		if(ci[index] == '\"') //cout << "you've got it\n";
	}*/
	if( argc == 2 && argv[1][1] == 'h' ){
		/** prepare 
		*/
		string so("Help Menu  \n");
		so += "Example: ./parser AVG1 AVG2 filename \n";
		so += "\t\t AVG1: \t --1={--Friendly-Robot-Data}{--N-Y-Y-Y-Y-Y-Y} \n";
		so += "\t\t\t--2={--\"SSL-Vision-Ball-0}{--N-N\\(Y-Y\\)} \n";
		so += "use -L for legacy parser\n";
		/*string si(argv[1]);
		if( si == "-h" || si == "--help" || si == "-help" || si == "help" ){
			//cout << so;
		}*/
		cout << so;
	} else if(argc == 5 && argv[1][1] == 'L' ){ // L for legacy
		string option(argv[2]);
		string format(argv[3]);
		vector<string> data_name = tokenize_option(option.c_str(), '-');
		vector<string> data_form = tokenize_format(format.c_str(), '-');
		cout << data_form.size() << endl;
		fstream log_data( argv[4], fstream::in );
		size_t name_size = string( argv[4] ).size();
		string ofile( argv[4], name_size-4 );
		ofile += "-";
		if( argv[2][2] == '"' ){
			ofile += string( &argv[2][3] );
		} else {
			ofile += string( &argv[2][2] );
		}
		ofile += ".data";
		fstream out_data( ofile.c_str(), fstream::out );	
		legacy_parser( &log_data, &out_data, data_name, data_form );
		out_data.close();
		log_data.close();
	} else if ( argc >=5 && argv[1][1] == 'S' ) { // S for stateful
		FORMAT format;
		fstream log_data( argv[argc-1], fstream::in );

		// must start tockenizing from the 3rd arg
		for( int i = 2; i <  argc-1; i++ ){
			tokenize_and_add( &format, argv[i], '-');
		}

		// generate a properly named output
		unsigned int name_size = string( argv[argc-1] ).size();
		string ofile( argv[argc-1], name_size-4 );
		ofile += "-S";
		for( unsigned int i = 0; i < format.size(); i++ ){
			ofile += "-";
			for( unsigned int j = 0; j < format[i].first.size(); j++ ){
				ofile += "-";
				ofile += format[i].first[j];
			}
		}
		ofile += ".data";
		fstream out_data( ofile.c_str(), fstream::out ); 

		for( unsigned int i = 0; i < format.size(); i++ ){
			out_data << "% ";
			for( unsigned int j = 0; j < format[i].first.size(); j++ ){
				out_data << format[i].first[j] << "\t";
			}
			for( unsigned int j = 0; j < format[i].second.size(); j++ ){
					out_data << format[i].second[j] << "\t";
			}
			out_data << endl;
		}
		
		stateful_parser( &log_data, &out_data, format );
		log_data.close();
		out_data.close();

	} else if ( argc != 1 ){
		FORMAT format;
		fstream log_data( argv[argc-1], fstream::in );

		for( int i = 1; i <  argc-1; i++ ){
			tokenize_and_add( &format, argv[i], '-');
		}

		// generate a properly named output
		unsigned int name_size = string( argv[argc-1] ).size();
		string ofile( argv[argc-1], name_size-4 );
		for( unsigned int i = 0; i < format.size(); i++ ){
			ofile += "-";
			for( unsigned int j = 0; j < format[i].first.size(); j++ ){
				ofile += "-";
				ofile += format[i].first[j];
			}
		}
		ofile += ".data";
		fstream out_data( ofile.c_str(), fstream::out ); 

		for( unsigned int i = 0; i < format.size(); i++ ){
			out_data << "% ";
			for( unsigned int j = 0; j < format[i].first.size(); j++ ){
				out_data << format[i].first[j] << "\t";
			}
			for( unsigned int j = 0; j < format[i].second.size(); j++ ){
					out_data << format[i].second[j] << "\t";
			}
			out_data << endl;
		}
		
		multi_task_parser( &log_data, &out_data, format );
		log_data.close();
		out_data.close();
	}
	return 0;
}


