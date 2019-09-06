#include <iostream>
#include <vector>
#include <fstream>
#include <gtkmm.h>

using namespace std;

class ReplayWindow : public Gtk::Window {
public: 
        ReplayWindow(vector<vector<double> >& data);
        virtual ~ReplayWindow();
	
	vector<vector<double> >& coords;

	class Frame : public Gtk::DrawingArea {
	public:
		Frame();
		virtual ~Frame();
		double x,y;
	protected:
		virtual bool on_expose_event(GdkEventExpose* event);
		static const double f_width = 3200.0;
		static const double f_height = 2400.0;
	};

protected:
        // signals
        void on_button_quit();
        void on_adjustment_changed();
               
        // child widgets
        Gtk::VBox m_VBox_Top, m_VBox_HScale;
	
	Frame f;	
                       
        Gtk::Adjustment m_adjustment;
                        
        Gtk::HScrollbar m_Scrollbar;
        Gtk::Button m_Button_Quit;
};    

ReplayWindow::Frame::Frame():
	x(0.0), y(0.0){
	signal_expose_event().connect(sigc::mem_fun(*this, &Frame::on_expose_event),false);
}

ReplayWindow::Frame::~Frame(){
}

bool ReplayWindow::Frame::on_expose_event(GdkEventExpose* event){
	Glib::RefPtr<Gdk::Window> window = get_window();
	if(window){
		Gtk::Allocation allocation = get_allocation();
		const int width = allocation.get_width();
		const int height = allocation.get_width();
		Cairo::RefPtr<Cairo::Context> cr = window->create_cairo_context();
		/*if(event){
			cr->rectangle(event->area.x, event->area.y, event->area.width, event->area.height);
			cr->clip();
		}*/
		cr->scale(width/f_width,height/f_height);
		cr->translate(f_width/2,f_height/2);
		cr->set_line_width(4);
		cr->save();
		cr->set_source_rgba(0.337,0.612,0.117,0.9);
		cr->paint();
		cr->restore();
		cr->arc(x,y,100,0,2*M_PI);
		cr->set_source_rgba(0.0,0.0,0.0,1.0);
		cr->fill();
		cr->save();
		
	}
	return true;
}

ReplayWindow::~ReplayWindow(){
}

ReplayWindow::ReplayWindow( vector<vector<double> >& data ):
	coords(data),
        m_adjustment(0.0, 0.0, double(int(data.size()-1)), 1.0, 10.0, 1.0),
        m_Scrollbar(m_adjustment),
        m_Button_Quit("quit")
{
        set_title("Replay Log Data");

        add(m_VBox_Top);
	f.set_size_request( 200,200 );
	m_VBox_Top.pack_start(f);
        m_VBox_Top.pack_start(m_VBox_HScale);
        m_VBox_Top.pack_start(m_Button_Quit, Gtk::PACK_SHRINK);
	m_Scrollbar.set_update_policy( Gtk::UPDATE_CONTINUOUS );
	m_Scrollbar.set_size_request( 200,30 );
        m_VBox_HScale.pack_start(m_Scrollbar);

        m_adjustment.signal_value_changed().connect(sigc::mem_fun(*this, &ReplayWindow::on_adjustment_changed));

        m_Button_Quit.set_can_default();
        m_Button_Quit.grab_default();
        m_Button_Quit.signal_clicked().connect(sigc::mem_fun(*this, &ReplayWindow::on_button_quit));
        m_Button_Quit.set_border_width(10);

        show_all_children();
}


void ReplayWindow::on_button_quit(){
        hide();
}

void ReplayWindow::on_adjustment_changed(){
        const double val = m_adjustment.get_value();
	const int index = int(val);
	double x = coords[index][0];
	double y = coords[index][1];
        cout << val << "/" << index << " (" << x << ", " << y << ")" << endl;
	f.x = x;
	f.y = y;
	f.queue_draw();
}


int main (int argc, char ** argv){
	if ( argc == 2 ){ // assuming the second argument is the file name
		ifstream ifile(argv[1]);
		vector< vector<double> > coords;
		while( !ifile.eof() ){
			vector<double> * temp = new vector<double>;
			double x;
			double y;
			ifile >> x >> y;
			temp->push_back(x);
			temp->push_back(y);
			coords.push_back(*temp);
		}
		for( unsigned int i=0; i < coords.size(); i++ ){
			for( unsigned int j = 0; j < coords[i].size(); j++ ){
				cout << coords[i][j] << ' ' ;
			}
			cout << endl;
		}
		cout << coords.size() << endl;
		Gtk::Main kit(argc, argv);
		
		ReplayWindow window(coords);
		Gtk::Main::run(window);
	} else {// print help menu
		string so;
		so += "Help Menu \n";
		so += "./parser AVG1 \n";
		so += "AVG1 \t data file in 'x y' format \n";
		cout << so;
	}
	return 0;
}
