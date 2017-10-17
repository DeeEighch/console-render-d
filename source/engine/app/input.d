module engine.app.input;

import std.conv;
import std.process;
import std.stdio;



class Input
{
    struct Event{
        enum KeyCode {
            EMPTY,
            W = 'w',
            S = 's',
            A = 'a',
            D = 'd',
            Q = 'q',
            ESC = '\x1b',
            LMB,
            RMB,
            MMB,

        }
        enum Device{
            Keyboard,
            Mouse
        }
        
        char code = cast(char)EOF;
    }

    private this()
    {
        // Constructor code
    }
    private static bool instantiated_;
    private __gshared Input instance_;

    private static Input Instance(){
        if (!instantiated_){
            synchronized(Input.classinfo){
                if (!instance_){
                    version (Windows){
                        instance_ = new WindowsInput();
                    } else version (Posix){
                        instance_ = new PosixInput();
                    }
                    instantiated_ = true;
                }
            }
        }
        return instance_;
    }

    static Event handle(){
        Event e;
        bool result = Input.Instance.pool_event(e.code);
        Input.Instance().last = e;
        return e;
    }

    protected abstract bool pool_event(ref char code);

    private Event last;

    static Event last_event(){
        return Input.Instance().last;
    }
}
version (Posix) {
	import core.sys.posix.fcntl;
	import core.sys.posix.unistd;
	import core.sys.posix.termios;
	import core.sys.posix.sys.time;
    import core.thread;
    import std.container.dlist;


    class InputThread : Thread {
        this(){
            super(&run);
            initerm();

        }
        ~this(){
            finterm();
        }

        public void stop(){
            running = false;
        }

        public bool poll_event(ref char key){
            int ch = EOF;
            if ((ch= getchar()) == EOF){
                return false;
            }

            key = cast(char)ch;
            return true;
        }

    private:
        bool running;
        //DList input_q;

        void run(){
            while (running){
                //Thread.sleep(dur!("msecs")(100));
            }
        }
    private:
        termios old_term;
        int oldf;

        void initerm(){
            termios newt_term;
            tcgetattr(0, &old_term);
            newt_term = old_term;
            newt_term.c_lflag &= ~(ICANON | ECHO);
            tcsetattr(0, TCSANOW, &newt_term);
            oldf = fcntl(0, F_GETFL, 0);
            fcntl(0, F_SETFL, oldf | O_NONBLOCK);
        }

        void finterm(){
            tcsetattr(0, TCSANOW, &old_term);
            fcntl(0, F_SETFL, oldf);
        }
    }

	class PosixInput : Input {
	    enum CMD = "grep -E 'Handlers|EV' /proc/bus/input/devices |"
	               "grep -B1 120013 |"
	               "grep -Eo event[0-9]+ |"
	               "tr '\\n' '\\0'";
	    string kb_file;

	    this(){

	        /*kb_file = getKeyboardDeviceFileName();
	        int kb_fd = open(kb_file.ptr, O_RDONLY);
	        writeln("KBFD: ", kb_fd);
	        close(kb_fd);*/
	        //exit(1);
            initerm();
            writeln(__FUNCTION__);
	    }

	    ~this() {
            finterm();
            writeln(__FUNCTION__);
	    }

	    static int count;
	    override bool pool_event(ref char code) {
            int ch = EOF;
            if ((ch = getchar()) == EOF){
                return false;
            }

            code = cast(char)ch;

            return true;
	    }

	private:
	    string getKeyboardDeviceFileName(){
	        auto file = executeShell(CMD);
	        return "/dev/input/" ~ file.output;
	    }

    private:
        termios old_term;
        int oldf;
        
        void initerm(){
            termios newt_term;
            tcgetattr(STDIN_FILENO, &old_term);
            newt_term = old_term;
            newt_term.c_lflag &= ~(ICANON | ECHO);
            //newt_term.c_cc[VMIN] = 1;
            tcsetattr(STDIN_FILENO, TCSANOW, &newt_term);
            oldf = fcntl(0, F_GETFL, 0);
            fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
        }
        
        void finterm(){
            tcsetattr(STDIN_FILENO, TCSANOW, &old_term);
            fcntl(0, F_SETFL, oldf);
        }
	}
} else version (Windows) {
	class WindowsInput : Input {
		this () {
		}

		static int count;
		override Event pool_event() {
			count++;
			Event e;
			if (count < 1000){
				e.code = Event.KeyCode.D;
			} else {
				e.code = Event.KeyCode.ESC;
			}
			return e;
		}

	}
}
