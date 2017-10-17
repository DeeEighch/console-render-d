module engine.app.input;

import std.conv;
import std.process;
import std.stdio;



class Input
{
	enum KeyCode {
		EMPTY = EOF,
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

	struct Event{
		char code = cast(char)EOF;
	}
	
	private this() { /*Constructor code*/ }

	private static bool instantiated_;
	private __gshared Input instance_;

	private static Input Instance() {
		if (!instantiated_) {
			synchronized(Input.classinfo) {
				if (!instance_) {
					version (Windows){
						instance_ = new WindowsInput();
					} else version (Posix) {
						instance_ = new PosixInput();
					}
					instantiated_ = true;
				}
			}
		}
		return instance_;
	}

	static Event handle() {
		Event e;
		bool result = Input.Instance.pool_event(e.code);
		Input.Instance().last = e;
		return e;
	}
	
	protected abstract bool pool_event(ref char code);
	
	private Event last;
	
	static Event last_event() {
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

	class PosixInput : Input {
		string CMD = "grep -E 'Handlers|EV' /proc/bus/input/devices |"
			"grep -B1 120013 |"
				"grep -Eo event[0-9]+ |"
				"tr '\\n' '\\0'";
		string kb_file;
		
		this(){
			initerm();
			writeln(__FUNCTION__);
		}
		
		~this() {
			finterm();
			writeln(__FUNCTION__);
		}

		override bool pool_event(ref char code) {
			int ch = EOF;
			if ((ch = getchar()) == EOF){
				code = cast(char)ch;
				return false;
			}
			
			code = cast(char)ch;
			
			return true;
		}
		
	private:
		string getKeyboardDeviceFileName() {
			auto file = executeShell(CMD);
			return "/dev/input/" ~ file.output;
		}
		
	private:
		termios old_term;
		int oldf;

		void initerm() {
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
				e.code = Event.KeyCode.Q;
			}
			return e;
		}
		
	}
}
