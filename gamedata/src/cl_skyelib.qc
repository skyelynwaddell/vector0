#define STAT_CURRENTWEAPON 33

/* Inputs */
int previous_buttons;
int btn(int BUTTON) { return (input_buttons & BUTTON); };
int btnp(int BUTTON) 
{ 
    int pressed_now = input_buttons & BUTTON;
    int pressed_before = (previous_buttons & BUTTON);
    return (pressed_now && !pressed_before); 
};

/* Player cl_Globals */
int cl_reloading;
int total_ammo;
int ammo_count;
int health;
int max_health;
int armor;
int cl_viewmodel;

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
    string material_name;
    string texture;
    vector origin;
    vector angles;
    vector scale;
    string skins[MAX_SKINS];
} sViewModel;

