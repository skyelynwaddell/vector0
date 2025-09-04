// the goats
#define true 1
#define false 0

#define NET_LERP 0.25

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
	SENDFLAGS_ORIGIN         = 1,
	SENDFLAGS_CURRENTWEAPON  = 2,
    SENDFLAGS_SHOOT          = 4,
    SENDFLAGS_RELOAD         = 8,
    SENDFLAGS_MODELINDEX     = 16,
    SENDFLAGS_ANGLES         = 32,
    SENDFLAGS_STATS          = 64,
    SENDFLAGS_HIT            = 128,
};


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