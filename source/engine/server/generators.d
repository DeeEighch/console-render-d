module engine.server.generators;
import engine.server;
import derelict.lua.functions;



class RandomGenerator : Generator {
    private const ChunkConfig config;
    
    this(uint seed) {
        this.config = ChunkConfig(16, seed);
    }

    class TerrainImp : Terrain {
        Tile[][] tiles;

        override Tile get(int x, int y) {
            return tiles[x][y];
        }

        void generate(int gx, int gy, ChunkConfig conf) {
            tiles.length = conf.size;

            for(int x = 0; x < conf.size; x++) {
                Tile[] t = tiles[x];
                t.length = conf.size;
                for(int y = 0; y < conf.size; y++) {
                    t[y] = new EndTile();
                }
            }
        }
        
    }    

    override Terrain generate(int x, int y) {
        auto terrain = new TerrainImp();
        terrain.generate(x, y, config);
        return terrain;
    }

    override ChunkConfig chunkConfig() {
        return config;
    }
    
}


class LuaGenerator : Generator {
    private const ChunkConfig config;
    
    this(uint seed) {
        this.config = ChunkConfig(16, seed);
    }
    
    override Terrain generate(int x, int y) {
        auto terrain = new TerrainImp();
        terrain.generate(x, y, config);
        return terrain;
    }

    override ChunkConfig chunkConfig() {
        return config;
    }
}
