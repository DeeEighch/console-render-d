module engine.app.render;
import std.stdio;


interface Render {

    void clear(uint argb);

    void draw(uint x, uint y, uint id);

    void flush();

}

class ConsoleRender : Render {
    
    uint m_buffer_w = 0;
    uint m_buffer_h = 0;
    uint current_buffer = 1;
    char [][] m_buffer1;
    char [][] m_buffer2;
    this(uint buffer_w, uint buffer_h) {
        
            m_buffer1.length = buffer_h;
            foreach (ref row; m_buffer1){
                row.length = buffer_w;
            }
            m_buffer2.length = buffer_h;
            foreach (ref row; m_buffer2){
                row.length = buffer_w;
            }
        m_buffer_w = buffer_h;
        m_buffer_h = buffer_w;
    }

    void draw (uint xx, uint xy, uint id){
        foreach(ref row; buffer()){
            foreach(ref point; row){
                point = '*';
            }
        }
    }
    
    void clear (uint argb) {
        foreach (ref row; buffer()){
            foreach (ref point; row){
                point = ' ';
            }
        }
    }

    void flush(){
        writeln("\n");
        if (current_buffer == 1){
            current_buffer = 2;
            render_buffer(m_buffer1);
        } else {
            current_buffer = 1;
            render_buffer(m_buffer2);
        }
        
    }

    ref char [][] buffer() {
        if (current_buffer == 1){
            return m_buffer1;
        } else {
            return m_buffer2;
        }
    }

    void render_buffer(char [][] buffer){
        int r = 0;
        foreach (ref row; buffer){
            r++;
            foreach (ref point; row){
                write(point);
                
            }
            if (r != buffer.length){
                write('\n');
            }
        }
    }
}

