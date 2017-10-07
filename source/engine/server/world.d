module engine.server.world;


struct ChunkConfig {
    this(uint size, uint seed){
        this.size = size;
        this.seed = seed;
    }
    uint size;
    uint seed;    
}

interface Event{
    uint type();
}

interface Tile {
    int mesh();
    bool event(Event event);   
    string name();
}

interface Terrain {
    Tile get(int x, int y);
}


interface Generator {
    Terrain generate(int x, int y);
    ChunkConfig chunkConfig();
}



class World {

    
    
    void initialize(Generator generator) {
        this.generator = generator;
    }

    void generate(int width, int height){
        terrain.length = width;

        for(int x = 0 ; x < width; x++) {
            Terrain[] t = terrain[x];
            t.length = height;
            
            for(int y = 0; y < height; y++) {            
                t[y] = generator.generate(x, y);

            }
        }
    }

    private Generator generator;
    private Terrain[][] terrain;
    
}
