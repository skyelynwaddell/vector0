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
	if ( !(self.flags & FL_ONGROUND) )
		return;

	// make sure we have already released jumping
	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	
	pointsound(self.origin, "sound/player/player_jump.ogg", 0.2, ATTN_NORM);
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
		case VIEWMODEL_NONE: // KEY #0 || case 10, which corresponds to KEY 0, because key 10 doesnt exist and self.impulse=0 actually means NOTHING is pressed, and NOT key 0... idfk anymore dude.
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
};


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
	pointsound(self.origin, self.weapons[self.current_weapon].sound_reload, 0.2, ATTN_NORM);
};


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
};


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
};


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
};


/*
Shoot
Immediately invokes using the players current weapon
*/
void Shoot()
{
	if (self.state != FREE) return;	
	if (self.health < 1) return;

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
	pointsound(self.origin, self.weapons[self.current_weapon].sound_shoot, 0.2, ATTN_NORM);

	PlayerSetAmmo();

	if (Raycast()) 
	{
		// trace_ent = the dude that just got shot
		trace_ent.health -= 10;
		if (trace_ent.health < 1) 
		{
			trace_ent.health = -1; // if they are -1 health on Server they will lay sideways on the floor like they got FLATENED out
			return;
		}

		trace_ent.SendFlags |= SENDFLAGS_HIT;

		// tell the player WHO did the shot - that it succeeeded
		if (self != trace_ent) self.SendFlags |= SENDFLAGS_TARGETSHOT;
	}
};


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
};


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
};


/*
PlayerCrouch
When invoked will immediately toggle the stance of the player
*/
void PlayerCrouch()
{
	self.crouching = !self.crouching;
	float viewheight = self.crouching ? VIEWHEIGHT_CROUCH : VIEWHEIGHT_DEFAULT;
	self.view_ofs_lerp = [0,0,viewheight];

	if (self.crouching == true)
		setsize(self, SCALE_MIN, SCALE_CROUCH);
	else
		setsize(self, SCALE_MIN, SCALE_DEFAULT);
};


/*
PlayerHandleCrouch
Called every game tick to determine if the player IS crouching or not...
*/
void PlayerHandleCrouch()
{
	if (self.button5 && self.crouch_was_pressed == false)
	{
		PlayerCrouch();
		self.crouch_was_pressed = true;
	}

	if (self.button5 == false) self.crouch_was_pressed = false;
	self.view_ofs = lerp_vec(self.view_ofs, self.view_ofs_lerp, 0.1);
};


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

	PlayerHandleCrouch();
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

	string _flags = ftos(changedflags);
	WriteString(MSG_ENTITY, _flags);

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

	self.view_ofs_lerp = [0, 0, VIEWHEIGHT_DEFAULT];
	self.view_ofs = [0, 0, VIEWHEIGHT_DEFAULT];
	
	precache_model("models/pump/pump.glb");
	precache_model("models/monster_shotgunner/monster_shotgunner_nowep.glb");
	setmodel(self, "models/monster_shotgunner/monster_shotgunner_nowep.glb");
	setorigin(self, GetSpawnPoint());
	setsize(self, SCALE_MIN, SCALE_DEFAULT);

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


/*
SV_ParseClientCommand
You can define custom SV console commands here
in the switch statement based on their string
**** These must be prefixed with `cmd` to work!! (ie. cmd mp)
*/
void SV_ParseClientCommand(string command_string) 
{
	tokenize(command_string);
	string cmd = argv(0);

	switch (cmd)
	{
		// Example command : `cmd foo` prints `bar`
		case "foo":
			print("bar");
		break;

		// Deathmatch
		case "gamemode_deathmatch":
			gamemode = GAMEMODE_DEATHMATCH;
			print("Mode: Deathmatch");
		break;

		// Free for All
		case "gamemode_ffa":
			gamemode = GAMEMODE_FFA;
			print("Mode: Free for All");
		break;

		// Dual - 1 vs 1
		case "gamemode_dual":
			gamemode = GAMEMODE_DUAL;
			print("Mode: Dual");
		break;

		default: break;
	}
};


/*
SV_RunClientCommand
i guess you run client commands from server here idk
*/
void SV_RunClientCommand()
{
	runstandardplayerphysics(self);
};


// Other stuffs not yet implemented / used
void SetNewParms(){};
void SetChangeParms(){};
void info_player_start(){};
void SV_PausedTic(float elapsedtime)
{
	// if (elapsedtime > 2) setpause(0);
};
