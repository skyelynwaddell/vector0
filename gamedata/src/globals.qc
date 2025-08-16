// the goats
#define true 1
#define false 0

#define NET_LERP 0.25

enum NET_ENTITY {
    ENTITY_PLAYER=1,
};

enum PLAYER_ANIM {
    PLAYER_ANIM_IDLE=7,
    PLAYER_ANIM_SHOOT=9,
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
};


float VectorLength(vector v){ return v_x*v_x + v_y*v_y + v_z*v_z; };
float lerp(float start, float end, float t){return start + (end - start) * t;};
vector lerp_vec(vector start, vector end, float t){return start + (end - start) * t;};

float absf(float val)
{
    if (val < 0) return -val;
    return val;
};

// float PlayerGet(){
//     return findfloat(world, entnum, player_localentnum);
// };