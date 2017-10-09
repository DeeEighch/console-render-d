module engine.client.client;

import engine.app.render;
import std.stdio;

class Client {

    Render m_render = new ConsoleRender(80,24);

    void run(string[] args) {

        foreach(arg;args) {
            //writeln(arg);
        }
        //writeln("ulong: ", ulong.sizeof, " bytes");
        //writeln("uint: ", uint.sizeof, " bytes");
        
        for (int i; i < 10; i++) {
            m_render.clear(0x0000ffff);
            m_render.draw(i,10,0);
            m_render.flush();
        }
        
    }



}
