module engine.client.client;

import std.exception;
import std.typecons;
import engine.app.render;
import engine.app.input;
import std.stdio;


class Client {

    Render m_render = new ConsoleRender(80,23);

    Drawable td = new TestDrawable(2);

    void run(string[] args) {

        enforce(platformInit(), "Platform specific initialization failed!");

        foreach(arg;args) {
            writeln(arg);
        }
        Input.Event event;
        for (int i; (event = Input.handle()).code != Input.Event.KeyCode.Q/*Input.Event.KeyCode.ESC*/; i = ++i % 80) {
            static int x = 2;
            static int y = 12;
            m_render.clear(Color(0,255,0));
            switch (event.code) {
                case Input.Event.KeyCode.D :
                    x++;
                    break;
                case Input.Event.KeyCode.A:
                    x--;
                    break;
                case Input.Event.KeyCode.W:
                    y--;
                    break;
                case Input.Event.KeyCode.S:
                    y++;
                    break;
                default:
                    break;
            }

            td.draw(x ,y, m_render);
            m_render.flush();
        }
        writeln("OUT");
        
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
}
