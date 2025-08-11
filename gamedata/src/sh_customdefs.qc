//shared definitions

#define printf(x, ...) print(sprintf(x, __VA_ARGS__))


void PrecacheEverything()
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testplayer.iqm");
	drawfont = loadfont("", "gfx/Russo_One.ttf", "64", -1, 0, 0);

};