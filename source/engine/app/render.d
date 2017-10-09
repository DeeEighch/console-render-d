module engine.app.render;
import std.stdio;
import std.format;

interface Render
{

    void clear(uint argb);

    void draw(uint x, uint y, uint id);

    void flush();

}

class ConsoleRender : Render
{

    uint m_buffer_w;
    uint m_buffer_h;
    uint current_buffer;
    uint [][][] m_buffer;
    
    this(uint buffer_w, uint buffer_h) {
        m_buffer.length = 2;
        foreach(ref buffer_slice; m_buffer) {
            buffer_slice.length = buffer_h;
            foreach(ref slice_row; buffer_slice) {
                slice_row.length = buffer_w;
            }
        }
    }

    void draw(uint xx, uint xy, uint id) {
        foreach (ref row; buffer()) {
            foreach (ref point; row) {
                point = 0x0000ffff;
            }
        }
    }

    void clear(uint argb) {
        foreach (ref row; buffer()) {
            foreach (ref point; row) {
                point = argb;
            }
        }
    }

    void flush() {
        writeln("\n");
        if (current_buffer == 0) {
            current_buffer = 1;
            render_buffer(0);
        } else {
            current_buffer = 0;
            render_buffer(1);
        }

    }

    ref uint[][] buffer() {
        return m_buffer[current_buffer];
    }

    void render_buffer(int index) {
        int r;
        foreach (ref row; m_buffer[index]) {
            r++;
            foreach (ref point; row) {
                write(bufferPointToConsoleEscape(point));
            }
            
            if (r != m_buffer[index].length) {
                write('\n');
            }
        }
    }

    string bufferPointToConsoleEscape(uint argb) {
        ubyte[] colors = (cast(ubyte*) &argb)[0 .. argb.sizeof];
        string console_escape = format("\x1b[48;2;%(%s;%)m \x1b[0m", [colors[0], colors[1], colors[2]]);
        return console_escape;
    }
}
