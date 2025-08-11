struct Weapon {
    string name;
    int ammo_type;
    int ammo_count;
    int clip_size;
    float damage;
    float fire_rate;
    float reload_time;
    int automatic;
    float timer;
};  

enum AMMO_TYPE {
    AMMO_NONE,
    AMMO_9MM,
};

Weapon weapons[36];
int current_weapon;

int ANIM_FPS = 24;

void WeaponsInit()
{
    // None / Arms or whatever
    weapons[WEAPON_NONE].name           = "No Weapon";
    weapons[WEAPON_NONE].ammo_type      = AMMO_NONE;
    weapons[WEAPON_NONE].clip_size      = 0;            
    weapons[WEAPON_NONE].ammo_count     = 0;            
    weapons[WEAPON_NONE].damage         = 0;            
    weapons[WEAPON_NONE].fire_rate      = 0;            
    weapons[WEAPON_NONE].reload_time    = 0;        
    weapons[WEAPON_NONE].automatic      = false;    

    // Pistol
    weapons[WEAPON_PISTOL].name         = "Pistol";
    weapons[WEAPON_PISTOL].ammo_type    = AMMO_9MM;
    weapons[WEAPON_PISTOL].clip_size    = 12; 
    weapons[WEAPON_PISTOL].ammo_count   = 12; 
    weapons[WEAPON_PISTOL].damage       = 10; 
    weapons[WEAPON_PISTOL].fire_rate    = 6 / ANIM_FPS;
    weapons[WEAPON_PISTOL].reload_time  = 26 / ANIM_FPS;
    weapons[WEAPON_PISTOL].automatic    = false;

    current_weapon = WEAPON_PISTOL;

};

void ChangeWeapon(WEAPON_TYPE new_weapon)
{ 
    current_weapon = new_weapon; 
    // send the current weapon INT to client
};