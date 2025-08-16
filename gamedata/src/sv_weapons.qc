// properties a weapon could have
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

// all the diffrent ammo types a weapon can use
enum AMMO_TYPE {
    AMMO_NONE,
    AMMO_9MM,
    AMMO_365,
    AMMO_SHOTGUN_SHELLS,
};

// ammo pool type/struct
struct AMMO_POOL {
    int ammo_type;
    int amount;
};

// everyone has 36 weaponslots, 36 ammo pools (that those weapons can reload from)
// and a current weapon index
.Weapon weapons[36];
.AMMO_POOL ammo_pools[36];
.int current_weapon;

int ANIM_FPS = 24; // animation speed (should match blender)

/*
WeaponsGetTotalAmmoPool
Returns the current weapons ammo pool amount
ie. if you have SMG equipped, it will return the total ammo of 9mm bullets
*/
int WeaponsGetTotalAmmoPool()
{
    for (int i=0; i<36; i++)
    {
        if (self.ammo_pools[i].ammo_type == self.weapons[self.current_weapon].ammo_type)
        {
            return self.ammo_pools[i].amount;
            break;
        }
    }
}


/*
ChangeWeapon
Changes the current weapon to the new index
by WEAPON_TYPE
*/
void ChangeWeapon(WEAPON_TYPE new_weapon)
{ 
    if (self.current_weapon == new_weapon) return;
    self.state = 0;
    self.sv_reloading = false;
    self.weapons[self.current_weapon].timer = 0;
    self.current_weapon = new_weapon; 
    self.SendFlags |= SENDFLAGS_CURRENTWEAPON;
};


/*
WeaponsInit
Called once at game start -- Initializes the weapons array
*/
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
    self.ammo_pools[WEAPON_NONE].ammo_type   = AMMO_NONE;
    self.ammo_pools[WEAPON_NONE].amount      = 0;

    // Pistol
    self.weapons[WEAPON_PISTOL].name         = "Pistol";
    self.weapons[WEAPON_PISTOL].ammo_type    = AMMO_9MM;
    self.weapons[WEAPON_PISTOL].clip_size    = 12; 
    self.weapons[WEAPON_PISTOL].ammo_count   = 12; 
    self.weapons[WEAPON_PISTOL].damage       = 10; 
    self.weapons[WEAPON_PISTOL].fire_rate    = 6 / ANIM_FPS;
    self.weapons[WEAPON_PISTOL].reload_time  = 26 / ANIM_FPS;
    self.weapons[WEAPON_PISTOL].automatic    = false;
    self.ammo_pools[WEAPON_PISTOL].ammo_type = AMMO_9MM;
    self.ammo_pools[WEAPON_PISTOL].amount    = 30;

    // Pump
    self.weapons[WEAPON_PUMP].name         = "Shotgun";
    self.weapons[WEAPON_PUMP].ammo_type    = AMMO_SHOTGUN_SHELLS;
    self.weapons[WEAPON_PUMP].clip_size    = 12; 
    self.weapons[WEAPON_PUMP].ammo_count   = 12; 
    self.weapons[WEAPON_PUMP].damage       = 10; 
    self.weapons[WEAPON_PUMP].fire_rate    = 15 / ANIM_FPS;
    self.weapons[WEAPON_PUMP].reload_time  = 35 / ANIM_FPS;
    self.weapons[WEAPON_PUMP].automatic    = true;
    self.ammo_pools[WEAPON_PUMP].ammo_type = AMMO_SHOTGUN_SHELLS;
    self.ammo_pools[WEAPON_PUMP].amount    = 30;

    // Revolver
    self.weapons[WEAPON_REVOLVER].name         = "Revolver";
    self.weapons[WEAPON_REVOLVER].ammo_type    = AMMO_365;
    self.weapons[WEAPON_REVOLVER].clip_size    = 12; 
    self.weapons[WEAPON_REVOLVER].ammo_count   = 12; 
    self.weapons[WEAPON_REVOLVER].damage       = 10; 
    self.weapons[WEAPON_REVOLVER].fire_rate    = 9 / ANIM_FPS;
    self.weapons[WEAPON_REVOLVER].reload_time  = 57 / ANIM_FPS;
    self.weapons[WEAPON_REVOLVER].automatic    = false;
    self.ammo_pools[WEAPON_REVOLVER].ammo_type = AMMO_365;
    self.ammo_pools[WEAPON_REVOLVER].amount    = 30;

    // SMG
    self.weapons[WEAPON_SMG].name         = "SMG";
    self.weapons[WEAPON_SMG].ammo_type    = AMMO_9MM;
    self.weapons[WEAPON_SMG].clip_size    = 12; 
    self.weapons[WEAPON_SMG].ammo_count   = 12; 
    self.weapons[WEAPON_SMG].damage       = 10; 
    self.weapons[WEAPON_SMG].fire_rate    = 5 / ANIM_FPS;
    self.weapons[WEAPON_SMG].reload_time  = 40 / ANIM_FPS;
    self.weapons[WEAPON_SMG].automatic    = true;
    self.ammo_pools[WEAPON_SMG].ammo_type = AMMO_9MM;
    self.ammo_pools[WEAPON_SMG].amount    = 30;

    ChangeWeapon(WEAPON_PISTOL);

};

