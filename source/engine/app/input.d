module engine.app.input;

import std.conv;
import std.process;
import std.stdio;
import core.stdc.stdlib;



class Input
{
    struct Event{
        enum KeyCode {
            W, S, A, D, ESC, LMB, RMB, MMB
        }
        enum Device{
            Keyboard,
            Mouse
        }
        
        KeyCode code;
    }

    private this()
    {
        // Constructor code
    }

    static Input instance = null;

    private static Input Instance(){
        if (instance is null){
            version (Windows){
                instance = new WindowsInput();
            } else version (Posix){
                instance = new PosixInput();
            }
        }
        return instance;
    }

    static Event handle(){
        Input.Instance().last  = Input.Instance.pool_events();
        return Input.Instance.last;
    }

    protected abstract Event pool_events();

    private Event last;

    static Event last_event(){
        return Input.Instance().last;
    }
}
version (Posix) {
	import core.sys.posix.fcntl;
	import core.sys.posix.unistd;
	import core.sys.posix.sys.time;
	import core.sys.posix.sys.time;

	class PosixInput : Input {
	    enum CMD = "grep -E 'Handlers|EV' /proc/bus/input/devices |"
	               "grep -B1 120013 |"
	               "grep -Eo event[0-9]+ |"
	               "tr '\\n' '\\0'";
	    string kb_file;

	    struct input_event {
	        timeval time;
	        uint16_t type;
	        uint16_t code;
	        int32_t value;
	    };

	    this(){

	        kb_file = getKeyboardDeviceFileName();
	        int kb_fd = open(kb_file.ptr, O_RDONLY);
	        writeln("KBFD: ", kb_fd);
	        close(kb_fd);
	        //exit(1);
	    }

	    ~this() {
	        
	    }

	    static int count;
	    override Event pool_events() {
	        count++;
	        Event e;
	        if (count < 10){
	            e.code = Event.KeyCode.D;
	        } else {
	            e.code = Event.KeyCode.ESC;
	        }
	        return e;
	    }

	private:
	    string getKeyboardDeviceFileName(){
	        auto file = executeShell(CMD);
	        return "/dev/input/" ~ file.output;
	    }
	}
} else version (Windows) {
	class WindowsInput : Input {
		this () {
		}

		static int count;
		override Event pool_events() {
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
