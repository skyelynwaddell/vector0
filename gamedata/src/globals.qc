// the goats
#define true 1
#define false 0

#define NET_LERP 0.25
const float VIEWHEIGHT_DEFAULT    = 64; // View height default
const float VIEWHEIGHT_CROUCH     = 32; // View height while crouching
const float VIEWHEIGHT_ELIMINATED = 3;  // View hight when eliminated

// use these with setsize() for min / max parms
vector SCALE_MIN = [-14, -14, 0];       // player scale minimum
vector SCALE_DEFAULT = [14, 14, 72];    // player scale max when standing
vector SCALE_CROUCH = [14, 14, 32];     // player scale max when crouching

enum NET_ENTITY {
    ENTITY_PLAYER=1,
};

enum PLAYER_LEG_STATE {
    PLAYER_LEG_STATE_IDLE,
    PLAYER_LEG_STATE_WALK,
    PLAYER_LEG_STATE_RUN,
    PLAYER_LEG_STATE_CROUCH,
    PLAYER_LEG_STATE_CROUCH_WALK,
};

enum PLAYER_TOP_ANIM {
    PLAYER_TOP_ANIM_IDLE,
    PLAYER_TOP_ANIM_SHOOT,
    PLAYER_TOP_ANIM_RELOAD,
    PLAYER_TOP_ANIM_SWITCH_WEAPON,
};

enum PLAYER_BODY_STATE {
    PLAYER_BODY_STATE_IDLE_PISTOL,
    PLAYER_BODY_STATE_SHOOT_PISTOL,
    PLAYER_BODY_STATE_RELOAD_PISTOL,
    PLAYER_BODY_STATE_IDLE_RIFLE,
    PLAYER_BODY_STATE_SHOOT_RIFLE,
    PLAYER_BODY_STATE_RELOAD_RIFLE,
    PLAYER_BODY_STATE_IDLE,
};

enum PLAYER_ANIM {
    PLAYER_ANIM_PISTOL,
    PLAYER_ANIM_PISTOL_SHOOT,
    PLAYER_ANIM_RIFLE,
    PLAYER_ANIM_RIFLE_RELOAD,
    PLAYER_ANIM_RIFLE_SHOOT,
    PLAYER_ANIM_CROUCH,
    PLAYER_ANIM_DEATH1,
    PLAYER_ANIM_DEATH2,
    PLAYER_ANIM_DEATH3,
    PLAYER_ANIM_DEATH4,
    PLAYER_ANIM_HURT1,
    PLAYER_ANIM_HURT2,
    PLAYER_ANIM_IDLE,
    PLAYER_ANIM_PISTOL_RELOAD,
    PLAYER_ANIM_RUN,
    PLAYER_ANIM_SHOOT,
    PLAYER_ANIM_TPOSE,
    PLAYER_ANIM_WALK,
};

int VIEWMODEL_NONE = 10;
enum WEAPON_TYPE {
    WEAPON_NONE,
    WEAPON_PISTOL,
    WEAPON_SMG,
    WEAPON_PUMP,
    WEAPON_REVOLVER,
};

enum SENDFLAGS {
	SENDFLAGS_ORIGIN         = 1<<0,   // sends the current players origin / position
	SENDFLAGS_CURRENTWEAPON  = 1<<1,   // sends the current players weapon & ammo/pool
    SENDFLAGS_SHOOT          = 1<<2,   // alerts CL that the player has FIRED a shot
    SENDFLAGS_RELOAD         = 1<<3,   // sent when the player RELOADS
    SENDFLAGS_MODELINDEX     = 1<<4,  // Sets the PLAYER MODEL index (ie. model for the player ; NOT THE GUN / VIEWMODEL)
    SENDFLAGS_ANGLES         = 1<<5,  // sends the current players angles, like if they are looking up/down etc.
    SENDFLAGS_STATS          = 1<<9,  // sends player stats - just use stats... 
    SENDFLAGS_HIT            = 1<<7, // alerts that I have been shot
    SENDFLAGS_JUMP           = 1<<8, // called when player jumps
    SENDFLAGS_TARGETSHOT     = 1<<6, // Called when I have successfully SHOT someone ELSE.
};

// --- STATS ---
#define STAT_MAXHEALTH       32   // self.max_health
#define STAT_ARMORVALUE      33   // self.armorvalue
#define STAT_TOTALAMMO       34   // self.total_ammo
#define STAT_CURRENTAMMO     35   // self.current_ammo
#define STAT_CURRENTWEAPON   36   // self.current_weapon


float VectorLength(vector v){ return v_x*v_x + v_y*v_y + v_z*v_z; };
float lerp(float start, float end, float t){return start + (end - start) * t;};
vector lerp_vec(vector start, vector end, float t){return start + (end - start) * t;};

float clampf(float val, float min, float max)
{
    if (val < min) return min;
    if (val > max) return max;
    return val;
}

float absf(float val)
{
    if (val < 0) return -val;
    return val;
};



// float PlayerGet(){
//     return findfloat(world, entnum, player_localentnum);
// };