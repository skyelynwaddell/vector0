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

.Weapon weapons[36];
.int current_weapon;

int ANIM_FPS = 24;

void ChangeWeapon(WEAPON_TYPE new_weapon)
{ 
    self.current_weapon = new_weapon; 
    self.SendFlags |= SENDFLAGS_CURRENTWEAPON;
};

void WeaponsInit()
{
	self.sv_reloading = false;
    self.sv_shooting  = false;

    // None / Arms or whatever
    self.weapons[WEAPON_NONE].name           = "No Weapon";
    self.weapons[WEAPON_NONE].ammo_type      = AMMO_NONE;
    self.weapons[WEAPON_NONE].clip_size      = 0;            
    self.weapons[WEAPON_NONE].ammo_count     = 0;            
    self.weapons[WEAPON_NONE].damage         = 0;            
    self.weapons[WEAPON_NONE].fire_rate      = 0;            
    self.weapons[WEAPON_NONE].reload_time    = 0;        
    self.weapons[WEAPON_NONE].automatic      = false;    

    // Pistol
    self.weapons[WEAPON_PISTOL].name         = "Pistol";
    self.weapons[WEAPON_PISTOL].ammo_type    = AMMO_9MM;
    self.weapons[WEAPON_PISTOL].clip_size    = 12; 
    self.weapons[WEAPON_PISTOL].ammo_count   = 12; 
    self.weapons[WEAPON_PISTOL].damage       = 10; 
    self.weapons[WEAPON_PISTOL].fire_rate    = 6 / ANIM_FPS;
    self.weapons[WEAPON_PISTOL].reload_time  = 26 / ANIM_FPS;
    self.weapons[WEAPON_PISTOL].automatic    = false;

    ChangeWeapon(WEAPON_PISTOL);

};

