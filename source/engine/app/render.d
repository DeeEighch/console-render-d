module engine.app.render;
import std.exception;
import std.stdio;
import std.format;
import std.array;



interface Drawable {
    void draw(uint x, uint y, Render render);
}

struct Color {
    enum RED        = 0x00ff0000;
    enum GREEN      = 0x0000ff00;
    enum BLUE       = 0x000000ff;
    enum YELLOW     = 0x00ffff00;
    enum LIGTH_BLUE = 0x0000ffff;
    enum MAGENTA    = 0x00ff00ff;

    private uint data;
    this(uint argb) {
        data = argb;
    }

    this(ubyte r, ubyte g, ubyte b, ubyte a = 0xFF) {
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
    void clear(Color color);

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

    uint[][][] m_sprites;

    void initSprites(){
        auto add_sprite = appender(&m_sprites);
        
        add_sprite.put([[0x00000000u, 0xffffffffu, 0x00000000u],
                        [0xffffffffu, 0xffffffffu, 0x00000000u],
                        [0x00000000u, 0x00000000u, 0x00000000u]]);
                        
        add_sprite.put([[0xffffffffu, 0x00000000u, 0xffffffffu],
                        [0x00000000u, 0x00000000u, 0xffffffffu],
                        [0xffffffffu, 0xffffffffu, 0xffffffffu]]);

        add_sprite.put([[0x00000000u, 0x00000000u, 0x00000000u],
                        [0x00000000u, 0xffffffffu, 0x00000000u],
                        [0x00000000u, 0x00000000u, 0x00000000u]]);

        add_sprite.put([[0x00000000u]]);
    }
    
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
        initSprites();
    }

    void draw(uint xx, uint yy, uint id) {

        Color color = Color(0xFF, 0, 0xFF);
        
        uint a = color.a;
        uint r = color.r;
        uint g = color.g;
        uint b = color.b;
        uint argb = color.argb;
        
        if (id < m_sprites.length) {
            draw_sprite(xx, yy, m_sprites[id]);
        }
    }

    void draw_point(uint x, uint y, uint argb) {
        if (x >= 0 && y >= 0 && x < m_buffer_w && y < m_buffer_h) {
            buffer()[y][x] = argb;
        }
        
    }

    void draw_sprite(uint position_x, uint position_y,ref uint[][] sprite) {
        for (uint y; y < sprite.length; y++) {
            for (uint x; x < sprite[y].length; x++) {
                draw_point(position_x + x, position_y + y, sprite[y][x]);
            }
        }
    }

    void clear(Color color){
        clear(color.argb);
    }

    void clear(uint argb) {
        foreach (ref row; buffer()) {
            foreach (ref point; row) {
                point = argb;
            }
        }
    }

    void flush() {
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
        //auto str_appender = appender!string();
        string s;
        //str_appender.put("\x1b[1J");
        //s ~= "\x1b[1J";
        write("\x1b[1J");
        foreach (ref row; m_buffer[index]) {
            r++;

            foreach (ref point; row) {
                //str_appender.put(bufferPointToConsoleEscape(point));
                //s ~= bufferPointToConsoleEscape(point);
                write(bufferPointToConsoleEscape(point));
            }
            
            if (r != m_buffer[index].length) {
                //str_appender.put('\n');
                //s ~= '\n';
                write('\n');
            }
        }

        //writeln(str_appender.data);
//        writeln(s);
    }


    string bufferPointToConsoleEscape(uint argb) {
        Color color = Color(argb);
        string console_escape = format("\x1b[48;2;%s;%s;%sm \x1b[0m", color.r, color.g, color.b);
        return console_escape;
    }
}



class TestDrawable : Drawable {

    uint m_id;
    
    this(uint sprite_id = 0) {
        m_id = sprite_id;
    }

    override void draw(uint x, uint y, Render render) {
        render.draw(x, y, m_id);
    }
}

