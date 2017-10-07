#!/usr/bin/rdmd
import std.stdio;
import std.getopt;
import engine;
import engine.server;
import derelict.lua.lua;
import std.exception;


enum RunConfig {
    server,
    client
};

RunConfig runConfig = RunConfig.client; 



void main(string[] args)
{
    auto helpInformation = getopt(
        args,
        config.caseInsensitive,
        "run|r", "[ client | server ]", &runConfig);

    if(helpInformation.helpWanted){
        defaultGetoptPrinter("Tanks v0.1", helpInformation.options);
    }    

    
    
                

    if(false && runConfig == RunConfig.client) {
        auto client = new Client();
        client.run(args);
    } else {

        DerelictLua.load("/usr/lib/x86_64-linux-gnu/liblua5.3.so");
        enforce(DerelictLua.isLoaded(), "Can't load Lua libraires");

        
        auto world = new World;
        world.initialize(new RandomGenerator(0));
        world.generate(16, 16);

        
        
        writeln("not implemented!");
    }

            

}
