//Various globals that are used in this FTEQW example are defined here, they are not used by the engine itself

//#pragma warning disable Q302
vector cursor_pos; /* Current mouse cursor position, updated in csqc_inputevent */
float g_width, g_height; /* Globals for screen width and height */

//Menu stuff
float in_menu; //what menu are we in
float time_in_menu;
float previous_buttons;

// for keybinding
float active_bind_index;
float menu_click_held;

const float MENU_NONE = 0;
const float MENU_MAIN = 1;
const float MENU_JOIN = 2;
const float MENU_SETTINGS = 4;
const float MENU_BUY = 8;
const float MENU_HOST = 16;
const float MENU_PREGAME = 32;
const float MENU_POSTGAME = 64;

float in_input_box;
float input_cursor;

// Custom Player Stats
.vector oldvelocity;
.vector oldangles;
.float bodyframe1time;
.float legsframe1time;
.float waist_yaw;
.PLAYER_LEG_STATE model_leg_state;
.PLAYER_BODY_STATE model_body_state;
.float new_x;
.float new_y;
.float new_z;
.int legs_anim_old_index;        // previous animation index (PLAYER_ANIM_IDLE / RUN)
.float legs_anim_old_frame;      // previous animation frame time
.float leg_anim_time_since_change;  // crossfade timer
.int body_anim_old_index;        // previous animation index (PLAYER_ANIM_IDLE / RUN)
.float body_anim_old_frame;      // previous animation frame time
.float body_anim_time_since_change;  // crossfade timer
.int body_anim;
.int anim_finished;
.int anim_time;

vector campos;
vector camang;

entity localplayer;

/* Player cl_Globals */
int cl_reloading;
int cl_viewmodel;
int total_ammo;
int ammo_count;
float health;
float max_health;
int armor;

const float VIEWHEIGHT_ELIMINATED = 3;

enum WEAPON_BASE_TYPE {
    WEAPON_BASE_TYPE_NONE,
    WEAPON_BASE_TYPE_PISTOL,
    WEAPON_BASE_TYPE_RIFLE,
    WEAPON_BASE_TYPE_KNIFE,
};

#define MAX_SKINS 8
typedef struct sViewModel {
    string model_path;
    int model_index;
    int anim_idle;
    int anim_shoot;
    int anim_reload;
    int anim_idle_length;
    int anim_shoot_length;
    int anim_reload_length;
    int anim_finished;
    int automatic;
    string sound_shoot;
    string sound_reload;
    Skin skin;
    vector origin;
    vector angles;
    vector scale;
} sViewModel;

entity(float entnums) num_for_ent = 
{
	entity finder = findfloat(world,entnum,entnums);
	while(finder)
	{
		if(finder.entnum == entnums)
		return finder;
		finder = finder.chain;
	}
	return finder;
}

// --- STATS ---
#define STAT_MAXHEALTH       32   // self.max_health
#define STAT_ARMORVALUE      33   // self.armorvalue
#define STAT_TOTALAMMO       34   // self.total_ammo
#define STAT_CURRENTAMMO     35   // self.current_ammo
#define STAT_CURRENTWEAPON   36   // self.current_weapon
