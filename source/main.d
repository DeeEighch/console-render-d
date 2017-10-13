#!/usr/bin/rdmd
import engine;
import std.stdio;

void main(string[] args)
{

    auto client = new Client();
    
    client.run(args);

}
