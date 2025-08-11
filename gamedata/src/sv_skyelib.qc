#define STAT_CURRENTWEAPON 33

float last_time;

float delta(){ 
    if (last_time == 0) return;
    float dt = time - last_time;
    last_time = time;
    // On first call last_time=0 so dt will be large, so clamp it:
    if (dt > 0.1) dt = 0.16; // clamp to ~1 frame (16ms) to avoid big jumps
    if (dt < 0) dt = 0.16;  // clamp negatives too
    return dt;
}

/* Player sv_Globals */
int sv_reloading;
int sv_shooting;