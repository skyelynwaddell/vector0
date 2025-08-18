#define STAT_CURRENTWEAPON 33
/* Player sv_Globals */
.float last_time;
.int sv_reloading;
.int sv_shooting;
.int reload_pressed_last;
.int shoot_pressed_last;

enum PLAYER_STATE {
	FREE,
	SHOOTING,
	RELOADING,
};
.PLAYER_STATE state;

float delta(){ 
    if (self.last_time == 0) return;
    float dt = time - self.last_time;
    self.last_time = time;
    // On first call last_time=0 so dt will be large, so clamp it:
    if (dt > 0.1) dt = 0.16; // clamp to ~1 frame (16ms) to avoid big jumps
    if (dt < 0) dt = 0.16;  // clamp negatives too
    return dt;
};