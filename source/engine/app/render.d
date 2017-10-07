module engine.app.render;



interface Render {

    void clear(uint argb) ;

    void draw(uint x, uint y, uint id);

    void flush();

}

