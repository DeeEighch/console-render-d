module engine.client.client;

import std.exception;
import std.typecons;
import engine.app.render;
import engine.app.input;
import std.stdio;

import std.string : split;
import std.conv;
import std.process;


class Client {



	Render m_render; 

    Drawable td = new TestDrawable(3);

    void run(string[] args) {

        enforce(platformInit(), "Platform specific initialization failed!");

        foreach(arg;args) {
            writeln(arg);
        }

		uint[2] term_size = get_terminal_size();

		enforce(term_size.length == 2 && term_size[0] > 0 && term_size[1] > 0, "Terminal windows size detection failed!");

		m_render = new ConsoleRender(term_size[1], term_size[0] - 1 /* , ConsoleRender.Mode.SYMBOL*/);

        Input.Event event;
        for (int i; (event = Input.handle()).code != Input.KeyCode.Q; i = ++i % m_render.buffer_w()) {
            static int x = 20;
            static int y = 12;
            m_render.clear(Color.YELLOW);
            switch (event.code) {
                case Input.KeyCode.D:
                    x++;
                    break;
                case Input.KeyCode.A:
                    x--;
                    break;
                case Input.KeyCode.W:
                    y--;
                    break;
                case Input.KeyCode.S:
                    y++;
                    break;
                default:
                    break;
            }

            td.draw(x ,y, m_render);
            m_render.flush();
        }
        writeln("EXIT");
    }

    private bool platformInit() {
        version (Windows) {
            import core.runtime;
            import core.sys.windows.windows;

            enum ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;

            HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
        
            if (hOut == INVALID_HANDLE_VALUE)
            {
                return false;
            }

            DWORD dwMode = 0;
            if (!GetConsoleMode(hOut, &dwMode))
            {
                return false;
            }

            dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
            if (!SetConsoleMode(hOut, dwMode))
            {
                return false;
            }

            return true;
        } else {
            return true;
        }
    }

	private uint[] get_terminal_size(){
		auto cmd = executeShell("stty size");
		auto numbers = to!(uint[])(split(cmd.output));
		writefln("stty size: %s\nrows: %s\ncols: %s", cmd.output, numbers[0], numbers[1]);
		return numbers;
	}
}
