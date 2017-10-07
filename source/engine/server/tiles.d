module engine.server.tiles;
import engine.server;
import std.format;



class BaseTile : Tile {
    private string m_name;
    private int m_mesh;

    this(string name, int mesh){
        m_name = name;
        m_mesh = mesh;
    }
    
    override int mesh() {
        return mesh;
    }

    override bool event(Event event) {
        return false;
    }

    override string name() {
        return name;
    }

    override string toString() {
        return format("Tile{ name: %s, mesh: %d }", name(), mesh());
    }    
}

class EndTile : BaseTile {
    this(){
        super("EndTile", -1);
    }
}


