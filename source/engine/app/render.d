module engine.app.render;
import std.stdio;
import std.format;

interface Drawaible {
    void draw(uint x, uint y, Render render);
}

class Color {
    private uint data;

    this(uint argb) {
        data = argb;
    }

    this(ubyte r, ubyte g, ubyte b, ubyte a = 0xFF){
        data = 0;
        this.a = a;        
        this.r = r;
        this.g = g;
        this.b = b;
    }

    @property uint a() { return (data >> 24) & 0xFF ; };
    @property void a(uint value) { data = (data & 0x00FFFFFF) | ((value & 0xFF) << 24); };    

    @property uint r() { return (data >> 16) & 0xFF ; };
    @property void r(uint value) { data = (data & 0xFF00FFFF) | ((value & 0xFF) << 16); };    
    
    @property uint g() { return (data >> 8) & 0xFF ; };
    @property void g(uint value) { data = (data & 0xFFFF00FF) | ((value & 0xFF) << 8); };    
    
    @property uint b() { return (data >> 0) & 0xFF ; };
    @property void b(uint value) { data = (data & 0xFFFFFF00) | ((value & 0xFF) << 0); };    

    @property uint argb() { return data; };
    @property void argb(uint value) { data = value; };        
}

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
        m_buffer_w = buffer_w;
        m_buffer_h = buffer_h;
    }

    void draw(uint xx, uint yy, uint id) {
        /*foreach (ref row; buffer()) {
            foreach (ref point; row) {
                point = 0x0000ffff;
            }
        }*/

        Color color = new Color(0xFF, 0, 0xFF);

        uint a = color.a;
        uint r = color.r;
        uint g = color.g;
        uint b = color.b;
        uint argb = color.argb;
    }

    void draw_point(uint x, uint y, uint argb) {
        if (x >= 0 && y >= 0 && x < m_buffer_w && y < m_buffer_h) {
            buffer()[y][x] = argb;
        }       
        
    }

    void draw_sprite(uint position_x, uint position_y, uint[][] sprite) {
        for (uint y; y < sprite.length; y++) {
            for (uint x; x < sprite[y].length; x++) {
                draw_point(position_x + x, position_y + y, sprite[y][x]);
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

