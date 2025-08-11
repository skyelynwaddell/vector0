#define printf(x, ...) print(sprintf(x, __VA_ARGS__))

void PrecacheEverything()
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testplayer.iqm");
	precache_model("models/test.glb");
	drawfont = loadfont("", "gfx/Russo_One.ttf", "56", -1, 0, 0);
	//drawfont = loadfont("", "gfx/1Dortmund-ExtraBold.otf", "64", -1, 0, 0);

};