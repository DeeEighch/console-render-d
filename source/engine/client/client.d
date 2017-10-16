module engine.client.client;

import engine.app.render;
import std.stdio;

class Client {

    Render m_render = new ConsoleRender(80,24);

    Drawable td = new TestDrawable(2);

    void run(string[] args) {

        if (!platformInit()){
            return;
        }

        foreach(arg;args) {
            writeln(arg);
        }

        for (int i; true; i = ++i % 80) {
            m_render.clear(0x00ffff00);
            td.draw(i ,12, m_render);
            m_render.flush();
        }
        
    }

    private bool platformInit(){
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
