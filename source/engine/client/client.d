module engine.client.client;

import engine.app.render;
import std.stdio;

class Client {

    Render m_render = new ConsoleRender(80,24);

    Drawable td = new TestDrawable(2);

    void run(string[] args) {

        foreach(arg;args) {
            writeln(arg);
        }
        
        for (int i; true; i = ++i % 80) {
            m_render.clear(0x00ffff00);
            td.draw(i ,12, m_render);
            m_render.flush();
        }
        
    }



}
