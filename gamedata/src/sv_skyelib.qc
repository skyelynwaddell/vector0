// sv_skyelib.qc
// Skyel's Game Library - Server-side
// Mostly static functions, or generic variables reusable across fps games

/* Player sv_globals */
.float last_time;
.int sv_reloading;
.int sv_shooting;
.int reload_pressed_last;
.int shoot_pressed_last;
.int total_ammo;
.int current_ammo;
.int current_weapon;
.int was_jumping;
.int was_on_ground;
.int crouching;
.int crouch_toggle;
.int crouch_was_pressed;
.vector view_ofs_lerp;

enum GAMEMODE {
	GAMEMODE_DEATHMATCH,	// 5 v 5 Team Based Deathmatch
	GAMEMODE_FFA,			// Free For All
	GAMEMODE_DUAL,			// Dual - 1 vs 1
};
GAMEMODE gamemode;

enum PLAYER_STATE {
	FREE,
	SHOOTING,
	RELOADING,
};
.PLAYER_STATE state;

/*
delta
Returns the current delta time
*/
float delta(){ 
    if (self.last_time == 0) return 0.0;
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
};


/*
precache_everything
Called once on worldspawn load to precache 
any sv side imports such as sounds, etc.
*/
void precache_everything()
{
    //player sounds
    precache_sound("sound/player/player_jump.ogg");

    //pistol
	precache_sound("sound/weapons/pistol_shot.ogg");
	precache_sound("sound/weapons/pistol_reload.ogg");

	//shotgun
	precache_sound("sound/weapons/shotgun.ogg");
	precache_sound("sound/weapons/shotgun_reload.ogg");

	//revolver
	precache_sound("sound/weapons/revolver_shot.ogg");
	precache_sound("sound/weapons/revolver_reload.ogg");

	//mp
	precache_sound("sound/weapons/mp_shot.ogg");
	precache_sound("sound/weapons/mp_reload.ogg");
};


/*
network_send_clientstats
Sends the clientstats every server tick
these are variables SERVER side controls
that client side needs access to (ie. Health, Armor, etc.)
*/
void network_send_clientstats() 
{
    clientstat(STAT_MAXHEALTH,   EV_FLOAT,   max_health);
    clientstat(STAT_ARMORVALUE,  EV_FLOAT,   armorvalue);
    clientstat(STAT_TOTALAMMO,   EV_INTEGER, total_ammo);
    clientstat(STAT_CURRENTAMMO, EV_INTEGER, current_ammo);
};

