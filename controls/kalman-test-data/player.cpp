#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>
#include <cassert>
#include <gtkmm.h>
#include <glibmm.h>

using namespace std;

// argv[0] = exe name
// argv[1] = options
// argv[2] = format
// argv[3] = file name

typedef int DATA_TYPE;

typedef vector< pair <vector <string>, vector <string> > > FORMAT;

struct TickData {
	string tick_time;
	vector<double> ball;
	vector<double> friendly;
	vector<double> enemy;
	vector<string> debug;
};

struct GameState{
	int friendly_score;
	int enemy_score;
	char ref_box;
};

GameState cur_game_state;

vector<TickData>* ticks;

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
		//cout << str << '\t';
		string istr(str); // istr is raw data in string
		//cout << istr.size() << '\t';
		string ostr; // ostr is output data
		string cform( form[i] ); // cform is format
		//cout << cform.size() << '\t';
		unsigned int y_index = cform.find('Y');
		//cout << y_index << '\t';	
		int end_index = istr.size() - cform.size();
		//cout << end_index << '\t';
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
			//cout << oostr << '\n';
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
		//cout << str << '\t';
		string istr(str); // istr is raw data in string
		//cout << istr.size() << '\t';
		string ostr; // ostr is output data
		string cform( form[i] ); // cform is format
		//cout << cform.size() << '\t';
		unsigned int y_index = cform.find('Y');
		//cout << y_index << '\t';	
		int end_index = istr.size() - cform.size();
		//cout << end_index << '\t';
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
			//cout << oostr << '\n';
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
		//cout << output ;
	}
}

vector<TickData> stateful_parser( fstream *log_data, fstream *out_data, FORMAT form ){
	// used to append dection information before ssl-vision output
	vector<string> memory( form.size() - 1 );
	vector<TickData> all_ticks;
	all_ticks.push_back( TickData() );
	cout << all_ticks.size() << endl;
	TickData* one_tick = new TickData();
	//vector<TickData> all_ticks;
	while( !log_data->eof() ){
		char new_line[1000];
		log_data->getline(new_line, 1000);
		unsigned int total_types = form.size();
		bool quit = false;
		
		for( unsigned int i = 0; !quit && i < total_types; i++ ){
			vector<string> data_name = form[i].first;
			stringstream new_line_ss(new_line);
			if( wanted_line( &new_line_ss, data_name ) ){
				string extracted =  extract_values( &new_line_ss, form[i].second );
				cout << i << '\t' << extracted << endl;
				//memory[i-1].clear();
				//memory[i-1].append( extracted );
				cout << "doing write to memory \n" ;
				stringstream ss(extracted);
				double buf[4];
				string str_buf;
				switch( i ){
				case 0:
					//cout << "doing end of tick \n" ;
					one_tick->tick_time = extracted;
					//cout << all_ticks[all_ticks.size()-1].tick_time << endl;
					//all_ticks[all_ticks.size()-1].tick_time = extracted;
					break;
				case 1:
					ss >> buf[0] >> buf[1];
					//cout << buf[0] << '\t' << buf[1] << '\t';
					one_tick->ball.push_back(buf[0]);
					one_tick->ball.push_back(buf[1]);
					//all_ticks[all_ticks.size()-1].ball.push_back(buf[0]);
					//all_ticks[all_ticks.size()-1].ball.push_back(buf[1]);
					break;
				case 2:
					ss >> buf[0] >> buf[1] >> buf[2] >> buf[3];
					//cout << buf[0] << '\t' << buf[1] << '\t' << buf[2] << '\t' << buf[3] << endl;
					one_tick->friendly.push_back(buf[0]);
					one_tick->friendly.push_back(buf[1]);
					one_tick->friendly.push_back(buf[2]);
					one_tick->friendly.push_back(buf[3]);
					//all_ticks[all_ticks.size()-1].friendly.push_back(buf[0]);
					//all_ticks[all_ticks.size()-1].friendly.push_back(buf[1]);
					//all_ticks[all_ticks.size()-1].friendly.push_back(buf[2]);
					//all_ticks[all_ticks.size()-1].friendly.push_back(buf[3]);
					break;
				case 3:
					ss >> buf[0] >> buf[1] >> buf[2] >> buf[3];
					//cout << buf[0] << '\t' << buf[1] << '\t' << buf[2] << '\t' << buf[3] << endl;
					one_tick->enemy.push_back(buf[0]);
					one_tick->enemy.push_back(buf[1]);
					one_tick->enemy.push_back(buf[2]);
					one_tick->enemy.push_back(buf[3]);
					break;
				case 4:
					str_buf = new_line_ss.str();
					cout << str_buf << '\t';
					one_tick->debug.push_back( str_buf );
					cout << one_tick->debug.size() << endl ;
					break;
				default :
					break;
				}
				quit = true;

				ss.str();
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
			//all_ticks.push_back(TickData());
			all_ticks.push_back(*one_tick);
			one_tick = new TickData();
			//one_tick = &all_ticks.end();
		}
	
	}
	cout << all_ticks[100].tick_time << endl;
	return all_ticks;
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

Gtk::HScrollbar *hsb_progress;
Gtk::DrawingArea *field;
Glib::RefPtr<Gtk::TextBuffer> glib_text_buf;
Glib::RefPtr<Gtk::TextBuffer> txb_score;
Glib::RefPtr<Gtk::TextBuffer> txb_ref_box;
Glib::RefPtr<Gtk::TextBuffer> txb_debug_msg;

void update_client(){
	const vector<TickData> &all_ticks = *ticks;
	int i = hsb_progress->get_value();
	//cout << "before data \n";
	cout << all_ticks[i].tick_time << endl;
	cout << i << '\t' << all_ticks.size() << '\t' << all_ticks[i].ball.size() << '\t' << all_ticks[i].friendly.size() << '\t' << all_ticks[i].debug.size() << '\t';
	if( all_ticks[i].ball.size() !=0 ){
		cout << all_ticks[i].ball[0] << '\t' << all_ticks[i].ball[1] << '\t'; 
	}
	for( int j = 0; j < all_ticks[i].friendly.size(); j++ ){
		cout << all_ticks[i].friendly[j] << '\t' ;
	}
	for( int j = 0; j < all_ticks[i].debug.size(); j++ ){
		cout << all_ticks[i].debug[j] << endl;
	}
	cout << endl;
	glib_text_buf->set_text(all_ticks[i].tick_time);
	//index = i;	
	const Glib::RefPtr<Gdk::Window> win(field->get_window());
	if(win){
		win->invalidate(false);
	}
}

bool draw(GdkEventExpose *){
	cout << "redrawing" << endl;
	vector<TickData> all_ticks = *ticks;
	Cairo::RefPtr<Cairo::Context> ctx = field->get_window()->create_cairo_context();
	int width, height;
	int index = hsb_progress->get_value();
	field->get_window()->get_size(width, height);
	ctx->set_source_rgb(0.0,0.33,0.0);
	ctx->move_to(0.0, 0.0);
	ctx->line_to(width, 0.0);
	ctx->line_to(width,height);
	ctx->line_to(0.0, height);
	ctx->fill();

	ctx->translate(width/2, height/2);
	ctx->scale(width/(3.5*2), -width/(3.5*2));
	ctx->set_line_width(0.01);

	ctx->set_source_rgb(0.0,0.0,0.0);
	ctx->begin_new_path();
	ctx->move_to(0.0, width/(3.5*2));
	ctx->line_to(0.0, -width/(3.5*2));

	if(all_ticks[index].ball.size() != 0 ){
		ctx->set_source_rgb(1.0,0.5,0.0);
		ctx->begin_new_path();
		ctx->arc(all_ticks[index].ball[0], all_ticks[index].ball[1], 0.03, 0, 2*3.1415926 );
		ctx->fill();
	}

	cout << all_ticks[index].friendly.size() << endl;
	for( int i = 0; i < all_ticks[index].friendly.size(); i+=4 ){
		ctx->set_source_rgb(0.0, 0.0, 1.0);
		ctx->begin_new_path();
		ctx->arc(all_ticks[index].friendly[i+1],all_ticks[index].friendly[i+2], 0.12, all_ticks[index].friendly[i+3]+0.2*3.1415926, all_ticks[index].friendly[i+3]-0.2*3.1415926);
		ctx->fill();
		// text
		ctx->move_to(all_ticks[index].friendly[i+1],all_ticks[index].friendly[i+2]);
		stringstream num;
		num << i;
		ctx->set_source_rgb(0.0,0.0,0.0);
		ctx->set_font_size(0.1);
		ctx->show_text(num.str());
	}

	cout << all_ticks[index].enemy.size() << endl;
	for( int i = 0; i < all_ticks[index].enemy.size(); i+=4 ){
		ctx->set_source_rgb(1.0, 0.0, 0.0);
		ctx->begin_new_path();
		ctx->arc(all_ticks[index].enemy[i+1],all_ticks[index].enemy[i+2], 0.12, all_ticks[index].enemy[i+3]+0.2*3.1415926, all_ticks[index].enemy[i+3]-0.2*3.1415926);
		ctx->fill();
		// text
		ctx->move_to(all_ticks[index].enemy[i+1],all_ticks[index].enemy[i+2]);
		stringstream num;
		num << i;
		ctx->set_source_rgb(0.0,0.0,0.0);
		ctx->set_font_size(0.1);
		ctx->show_text(num.str());
	}
	
	txb_score->set_text("not available");
	txb_ref_box->set_text("not available");
	string str_debug_msg;
	for( int i = 0; i < all_ticks[index].debug.size(); i++ ){
		str_debug_msg += all_ticks[index].debug[i];
		str_debug_msg += "\n";
	}
	txb_debug_msg->set_text( Glib::ustring(str_debug_msg ));
	
	return true;
}

int main (int argc, char *argv[]){
	if ( argc == 2 ) { // S for stateful
		FORMAT format;
		fstream log_data( argv[argc-1], fstream::in );
		vector<string> tags;
		// tag hacks
		tags.push_back("--0={--End-of-Tick}{--N-N-Y}");
		tags.push_back("--1={--Ball-Data}{--Y-Y}");
		tags.push_back("--2={--Friendly-Robot-Data}{--Y-Y-Y-Y}");
		tags.push_back("--3={--Enemy-Robot-Data}{--Y-Y-Y-Y}");
		tags.push_back("--4={--Debug-Message}{--L}");
		//tags.push_back("--5={--Score}{--}");
		//tags.push_back("--6={--RefBox}{--}");

		for( int i = 0; i <  tags.size(); i++ ){
			tokenize_and_add( &format, tags[i].c_str(), '-');
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
		
		vector<TickData> all_ticks = stateful_parser( &log_data, &out_data, format );
		ticks = &all_ticks;
	
		log_data.close();
		out_data.close();

		cout << all_ticks.size() << endl;
		cout << all_ticks[100].ball.size()  << endl;
		cout << all_ticks[100].tick_time << endl;
		
		Gtk::Main kit(argc, argv);
		//index = -1;
		Gtk::Window vis;
		Gtk::HBox h_box;
		Gtk::VBox v_box;
		Gtk::VBox msg_box;
		Gtk::Adjustment adj_progress(0.0, 0.0, all_ticks.size(), 1.0, 10.0);
		hsb_progress = new Gtk::HScrollbar(adj_progress);
		//Gtk::HScrollbar hsb_progress( adj_progress );
		adj_progress.signal_value_changed().connect( &update_client );
		v_box.add(*hsb_progress);

		field = new Gtk::DrawingArea();
		field->set_size_request(600,600);
		field->signal_expose_event().connect( &draw );
		v_box.pack_start(*field);

		Gtk::TextView* text_view = new Gtk::TextView();
		Gtk::TextView txv_score;
		Gtk::TextView txv_ref_box;
		Gtk::TextView txv_debug_msg;
		txb_score = Gtk::TextBuffer::create();
		txb_ref_box = Gtk::TextBuffer::create();
		txb_debug_msg = Gtk::TextBuffer::create();
		txv_score.set_size_request(300,100);
		txv_score.set_buffer(txb_score);
		txv_ref_box.set_size_request(300,100);
		txv_ref_box.set_buffer(txb_ref_box);
		txv_debug_msg.set_size_request(300,400);
		txv_debug_msg.set_buffer(txb_debug_msg);
		txv_debug_msg.set_wrap_mode( Gtk::WRAP_WORD );
		glib_text_buf = Gtk::TextBuffer::create();
		text_view->set_buffer(glib_text_buf);
		//msg_box.add(*text_view);
		msg_box.add(txv_score);
		msg_box.add(txv_ref_box);
		msg_box.add(txv_debug_msg);
		h_box.add(v_box);
		h_box.add(msg_box);
		vis.add(h_box);
		vis.show_all();
		
	//	draw();
		Gtk::Main::run(vis);

	}
	return 0;
}


