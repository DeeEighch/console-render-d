import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
import derelict.sdl2.net;

void main()
{
    SDL_Window* mainWindow;
    SDL_GLContext mainGLContext;

    try
    {
        //DerelictGL3.load();

        // Load the SDL 2 library.
        DerelictSDL2.load();
.
        DerelictSDL2Image.load();
        DerelictSDL2Mixer.load();
        DerelictSDL2ttf.load();
        DerelictSDL2Net.load();
    }
    catch(Exception e){}
    finally{}

    // Initialise SDL
    if( SDL_Init( SDL_INIT_EVERYTHING ) == -1 ) {
        throw new Exception("SDL initialization failed");
    }

    //SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION,3);
    //SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION,3);

    SDL_WindowFlags flags = SDL_WINDOW_SHOWN;
    int width = 1024;
    int height = 768;

    mainWindow = SDL_CreateWindow("SDL2 OpenGL Example", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, flags);
    //mainGLContext = SDL_GL_CreateContext(mainWindow);

    //DerelictGL3.reload();

    SDL_DestroyWindow(mainWindow);
    SDL_Quit();
}
