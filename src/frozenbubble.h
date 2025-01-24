#ifndef FROZENBUBBLE_H
#define FROZENBUBBLE_H

#include <SDL2/SDL.h>
#include <stdint.h>
#include <string>
#include <iostream>

#include "gamesettings.h"
#include "audiomixer.h"

#include "mainmenu.h"
#include "bubblegame.h"

enum GameState {
    TitleScreen = 0,
    MainGame = 1,
    LevelEditor = 2,
    Netplay = 3
};

class FrozenBubble
{
public:
    int startTime = 0, totalBubbles = 0;
    void CallGameQuit() { IsGameQuit = true; };

    uint8_t RunForEver();
    GameState currentState = MainGame;

    FrozenBubble(const FrozenBubble& obj) = delete;
    static FrozenBubble* Instance();
private:
    int addictedTime = 0;
    bool IsGameQuit;
    SDL_Window *window;
    SDL_Renderer *renderer;

    GameSettings *gameOptions;
    AudioMixer *audMixer;

    MainMenu *mainMenu;
    BubbleGame *mainGame;

    void HandleInput(SDL_Event *e);

    static FrozenBubble* ptrInstance;
    FrozenBubble();
    ~FrozenBubble();
};

#endif // FROZENBUBBLE_H
