
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//

/*
PlayerSetAmmo
Call this whenever the players weapon changes or fires
to update the bullets in clip and ammo pool
*/
void PlayerSetAmmo()
{
	self.total_ammo = WeaponsGetTotalAmmoPool();
	self.current_ammo = WeaponGetCurrentAmmo();
};


/*
PlayerJump
Invokes the jump action for the player.
*/
void PlayerJump()
{
	// make sure we are on the ground
	if (!(self.flags & FL_ONGROUND))
		return;

	// make sure we have already released jumping
	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	
	sound(self, CHAN_AUTO, "sound/player/player_jump.ogg", 0.2, ATTN_NORM);
	self.weaponframe = 0;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = 0;
};


/*
CheckImpulses
Checks the player's impulses and executes actions based on them.
*/
void CheckImpulses() 
{
	switch (self.impulse)
	{
		case VIEWMODEL_NONE:
			ChangeWeapon(WEAPON_NONE);
		break;

		case 1: // KEY #1
			ChangeWeapon(WEAPON_PISTOL);
		break;

		case 2: // KEY #2
			ChangeWeapon(WEAPON_PUMP);
		break;

		case 3: // KEY #3
			ChangeWeapon(WEAPON_REVOLVER);
		break;

		case 4: // KEY #4
			ChangeWeapon(WEAPON_SMG);
		break;

	default: break;
	}
	self.impulse = 0;
};


/*
GetSpawnPoint
Returns the spawn point for the player.
*/
vector GetSpawnPoint()
{
	entity spawnpoint = world;
	spawnpoint = find(spawnpoint, classname, "info_player_start");
	return spawnpoint.origin + '0 0 1';
};


/*
Player_HandleJump
Handles the player's jump action based on button input.
*/
void Player_HandleJump() 
{
	if(self.button2) PlayerJump();
	else self.flags = self.flags | FL_JUMPRELEASED;
}


/*
Reload
Call to immediately invoke reloading on the players weapon
*/
void Reload()
{
    if (self.state != FREE) return;

    // Access weapon directly from self
    if (self.weapons[self.current_weapon].clip_size <= 0)
        return;

    int ammo_type = self.weapons[self.current_weapon].ammo_type;

    // Find matching ammo pool
    int pool_index = -1;
    for (int i = 0; i < 36; i++)
    {
        if (self.ammo_pools[i].ammo_type == ammo_type)
        {
            pool_index = i;
            break;
        }
    }
    if (pool_index == -1) return;

    int needed = self.weapons[self.current_weapon].clip_size -
                 self.weapons[self.current_weapon].ammo_count;
    if (needed <= 0) return;

    int to_load = needed;
    if (self.ammo_pools[pool_index].amount < needed)
        to_load = self.ammo_pools[pool_index].amount;

    if (to_load <= 0) return;

    self.state = RELOADING;
    self.sv_reloading = true;
    self.weapons[self.current_weapon].timer = self.weapons[self.current_weapon].reload_time;
    self.SendFlags |= SENDFLAGS_RELOAD;
}


/*
HandleReload
Handles the player's reloading action based on button input.
*/
void HandleReload()
{
	if (self.sv_shooting) return;
	if (self.sv_reloading) return;

	int reload_pressed_now = self.button4;

	if (!self.sv_reloading && reload_pressed_now && !self.reload_pressed_last)
        Reload();

    self.reload_pressed_last = reload_pressed_now;
}


/*
ReloadCooldown
Called after reloading to compensate for the reload
animation duration of the model
*/
void ReloadCooldown()
{
	if (self.sv_reloading == false) return;

	self.weapons[self.current_weapon].timer -= frametime;
	if (self.weapons[self.current_weapon].timer <= 0.1) 
	{
		int ammo_type = self.weapons[self.current_weapon].ammo_type;

		// Find matching ammo pool
		int pool_index = -1;
		for (int i = 0; i < 36; i++)
		{
			if (self.ammo_pools[i].ammo_type == ammo_type)
			{
				pool_index = i;
				break;
			}
		}
		if (pool_index == -1) return;

		int needed = self.weapons[self.current_weapon].clip_size -
					self.weapons[self.current_weapon].ammo_count;
		if (needed <= 0) return;

		int to_load = needed;
		if (self.ammo_pools[pool_index].amount < needed)
			to_load = self.ammo_pools[pool_index].amount;

		if (to_load <= 0) return;
		self.sv_reloading = false;
    	self.weapons[self.current_weapon].ammo_count += to_load;
    	self.ammo_pools[pool_index].amount -= to_load;
		PlayerSetAmmo();

		self.state = FREE;
		self.SendFlags |= SENDFLAGS_CURRENTWEAPON;
	}
}


/*
Raycast
Creates a traceline into the world from player pos
Returns true/false if traceline intersects with an ENTITY
Target is: trace_ent
shooter is: self
*/
int Raycast()
{ 
	int raycast_dist = 10000;
	makevectors(self.angles);
	traceline(self.origin, self.origin + v_forward * raycast_dist, 0, self);

	if (trace_ent) return true;
	return false;
}


/*
Shoot
Immediately invokes using the players current weapon
*/
void Shoot()
{
	if (self.state != FREE) return;	

	if (self.weapons[self.current_weapon].ammo_count <= 0)
	{
		Reload();
		return;
	}

	self.state = SHOOTING;
	self.weapons[self.current_weapon].ammo_count -= 1;
	self.sv_shooting = true;
	self.weapons[self.current_weapon].timer = self.weapons[self.current_weapon].fire_rate;
	self.SendFlags |= SENDFLAGS_SHOOT;
	PlayerSetAmmo();

	if (Raycast()) {
		trace_ent.health -= 10;
		if (trace_ent.health < 1) trace_ent.health = -1; // if they are -1 health on Server they will lay sideways on the floor like they got FLATENED out

		trace_ent.SendFlags |= SENDFLAGS_HIT;
	}
}


/*
HandleShoot
Handles the player's shooting action based on button input.
*/
void HandleShoot()
{
    int is_auto = self.weapons[self.current_weapon].automatic;
    if (self.sv_shooting) return;
    if (self.sv_reloading) return;

    int shoot_pressed_now = self.button0;

    if (is_auto) {
        // Auto weapons fire whenever the button is held
        if (shoot_pressed_now)
            Shoot();
    } else {
        // Semi-auto weapons fire only on each press
        if (shoot_pressed_now && !self.shoot_pressed_last)
            Shoot();
    }

    self.shoot_pressed_last = shoot_pressed_now;
}


/*
ShootCooldown
Called after shooting a bullet to provide some
cooldown time inbetween shots according to the 
shooting animation of the weapon
*/
void ShootCooldown()
{
	if (self.sv_shooting == false) return;

	self.weapons[self.current_weapon].timer -= frametime;
	if (self.weapons[self.current_weapon].timer <= 0.1) 
	{
		self.sv_shooting = false;
		self.state = FREE;
	}
}


/*
PlayerPreThink
Pre-Update function for the player.
*/
void PlayerPreThink()
{	
	if (IsMoving(self)) 
		self.SendFlags |= SENDFLAGS_ORIGIN; 

	self.SendFlags |= SENDFLAGS_ANGLES;

	CheckImpulses();
	makevectors(self.v_angle);

	HandleShoot();
	HandleReload();

	ShootCooldown();
	ReloadCooldown();
	
	Player_HandleJump();
};


/*
PlayerPostThink
Post-Update function for the player.
*/
void PlayerPostThink()
{
	if(self.flags & FL_ONGROUND)
	{
    	self.velocity *= 0.9;
	}
};


/*
ClientKill
Called when a client is disconnected from server
*/
void ClientKill()
{
};


/*
ClientConnect
Called when a client connects to the server
*/
void ClientConnect()
{
	self.last_time = 0;
	self.sv_shooting = 0;
	self.sv_reloading = 0;
	self.reload_pressed_last = 0;
	self.shoot_pressed_last = 0;
	self.button0 = 0;
};


/*
Called every TICK 
Sends player data from SERVER to CLIENT side QC
*/
float MySendEntity(entity playerent, float changedflags)
{
	int isme = self == playerent;
	int istarget = trace_ent && trace_ent == playerent;
	//if (self.isme == false) { changedflags &= ~SENDFLAGS_SHOOT; } // how to avoid a state

	// Header & Message Type
	WriteByte(MSG_ENTITY, ENTITY_PLAYER);
	WriteByte(MSG_ENTITY, isme);
	WriteByte(MSG_ENTITY, changedflags);

	// Angles
	WriteCoord(MSG_ENTITY, self.angles_x);
	WriteCoord(MSG_ENTITY, self.angles_y);
	WriteCoord(MSG_ENTITY, self.angles_z);

	//Origin
	if (changedflags & SENDFLAGS_ORIGIN)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}

	// Current Weapon
	if (changedflags & SENDFLAGS_CURRENTWEAPON) 
		WriteByte(MSG_ENTITY, self.current_weapon);
		
	// Hit
	if (changedflags & SENDFLAGS_HIT) 
		WriteByte(MSG_ENTITY, istarget);

	// Model Index (Current Model's Animation)
	if (changedflags & SENDFLAGS_MODELINDEX)
		WriteShort(MSG_ENTITY, self.modelindex);

	return true;
};


/*
PlayerSpawn
Spawns the player entity with default parameters.
*/
void PlayerSpawn()
{
	self.classname = "Player";
	self.netname = "Player Name";
	self.solid = SOLID_SLIDEBOX;
	self.health = 100;
	self.armorvalue = 0;
	self.movetype = MOVETYPE_WALK;
	self.fixangle = TRUE;
	self.view_ofs = [0, 0, 64];
	
	precache_model("models/pump/pump.glb");
	precache_model("models/monster_shotgunner/monster_shotgunner_nowep.glb");
	setmodel(self, "models/monster_shotgunner/monster_shotgunner_nowep.glb");
	setorigin(self, GetSpawnPoint());
	setsize(self, [-14, -14, 0], [14, 14, 72]);
	WeaponsInit();
	PlayerSetAmmo();

	self.SendEntity = MySendEntity;
	self.SendFlags = SENDFLAGS_ORIGIN | SENDFLAGS_MODELINDEX;
};


/*
PutClientInServer
Called when a client connects to the server
*/
void PutClientInServer()
{
	player_chain_add(self);
	PlayerSpawn();
};


/*
ClientDisconnect
Called when a client leaves the server
*/
void ClientDisconnect()
{
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has left the game.\n");
};


void SetNewParms()
{
};

void SetChangeParms()
{
};

void info_player_start()
{
};

void SV_PausedTic(float elapsedtime)
{
	// if (elapsedtime > 2) setpause(0);
};

void SV_ParseClientCommand(string command_string) 
{
	tokenize(command_string);
	string cmd = argv(0);

	switch (cmd)
	{
		case "mp":
			print("foo");
		break;
		default: break;
	}
};


void SV_RunClientCommand()
{
	runstandardplayerphysics(self);
};

