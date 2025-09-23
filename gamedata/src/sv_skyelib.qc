#define STAT_CURRENTWEAPON 33
/* Player sv_Globals */
.float last_time;
.int sv_reloading;
.int sv_shooting;
.int reload_pressed_last;
.int shoot_pressed_last;
.int total_ammo;
.int current_ammo;
.int current_weapon;

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


/*
IsMoving
Returns true if the entity provided is currently moving
*/
int IsMoving(entity ent_to_check_is_moving)
{
	return VectorLength(ent_to_check_is_moving.velocity) > 0.1;
}


// --- STATS ---
const float STAT_MAXHEALTH    = 32;   // self.max_health
const float STAT_ARMORVALUE   = 33;   // self.armorvalue
const float STAT_TOTALAMMO    = 34;   // self.total_ammo
const float STAT_CURRENTAMMO  = 35;   // self.current_ammo
void network_send_clientstats() 
{
    clientstat(STAT_MAXHEALTH,   EV_FLOAT,   max_health);
    clientstat(STAT_ARMORVALUE,  EV_FLOAT,   armorvalue);
    clientstat(STAT_TOTALAMMO,   EV_INTEGER, total_ammo);
    clientstat(STAT_CURRENTAMMO, EV_INTEGER, current_ammo);
};

