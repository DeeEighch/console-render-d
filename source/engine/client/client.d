module engine.client.client;

import std.exception;
import std.typecons;
import engine.app.render;
import engine.app.input;
import std.stdio;

class Client {

    Render m_render = new ConsoleRender(80,23);

    Drawable td = new TestDrawable(3);

    void run(string[] args) {

        enforce(platformInit(), "Platform specific initialization failed!");

        foreach(arg;args) {
            writeln(arg);
        }

        for (int i; Input.handle().code !is Input.Event.KeyCode.ESC; i = ++i % 80) {
            static int x = 2;
            static int y = 12;
            m_render.clear(Color(255,255,0));
            if (Input.last_event.code is Input.Event.KeyCode.D){
                x++;
            }
            td.draw(x ,y, m_render);
            m_render.flush();
        }
        
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
