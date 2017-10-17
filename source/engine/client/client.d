module engine.client.client;

import std.exception;
import std.typecons;
import engine.app.render;
import engine.app.input;
import std.stdio;

class Client {

    Render m_render = new ConsoleRender(80,23/*, ConsoleRender.Mode.SYMBOL*/);

    Drawable td = new TestDrawable(2);

    void run(string[] args) {

        enforce(platformInit(), "Platform specific initialization failed!");

        foreach(arg;args) {
            writeln(arg);
        }

        Input.Event event;
        for (int i; (event = Input.handle()).code != Input.KeyCode.Q; i = ++i % 80) {
            static int x = 2;
            static int y = 12;
            m_render.clear(Color.GREEN);
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
}
