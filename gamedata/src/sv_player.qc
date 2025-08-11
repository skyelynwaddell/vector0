
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//
.int reload_pressed_last;
.int shoot_pressed_last;

enum PLAYER_STATE {
	FREE,
	SHOOTING,
	RELOADING,
};
.PLAYER_STATE state;

/*
PlayerJump
Invokes the jump action for the player.
*/
void PlayerJump()
{
	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	
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
		case 10:
			ChangeWeapon(WEAPON_NONE);
		break;

		case 1:
			ChangeWeapon(WEAPON_PISTOL);
		break;

	default: break;
	}
	self.impulse = 0;
};


/*
get_spawn_point
Returns the spawn point for the player.
*/
vector get_spawn_point()
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
	if(self.button2)
		PlayerJump();
	else
		self.flags = self.flags | FL_JUMPRELEASED;
}

void Reload()
{
	if (self.state != FREE) return;
	self.state = RELOADING;
	self.sv_reloading = true;
	self.weapons[self.current_weapon].timer = self.weapons[self.current_weapon].reload_time;
	self.SendFlags |= SENDFLAGS_RELOAD;
}

void HandleReload()
{
	if (self.sv_shooting) return;
	if (self.sv_reloading) return;

	int reload_pressed_now = self.button4;

	if (!self.sv_reloading && reload_pressed_now && !self.reload_pressed_last)
        Reload();

    self.reload_pressed_last = reload_pressed_now;
}

void ReloadCooldown()
{
	if (self.sv_reloading == false) return;

	self.weapons[self.current_weapon].timer -= frametime;
	if (self.weapons[self.current_weapon].timer <= 0.1) 
	{
		self.sv_reloading = false;
		self.state = FREE;
	}
}

void Shoot()
{
	if (self.state != FREE) return;	
	self.state = RELOADING;

	self.sv_shooting = true;
	self.weapons[self.current_weapon].timer = self.weapons[self.current_weapon].fire_rate;
	self.SendFlags |= SENDFLAGS_SHOOT;
}

void HandleShoot()
{
	if (self.sv_shooting) return;
	if (self.sv_reloading) return;

	int shoot_pressed_now = self.button0;

	if (!self.sv_shooting && shoot_pressed_now && !self.shoot_pressed_last)
        Shoot();

    self.shoot_pressed_last = shoot_pressed_now;
}

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
	if (VectorLength(self.velocity) > 0.1)
		self.SendFlags |= SENDFLAGS_ORIGIN;
	
	self.SendFlags |= SENDFLAGS_ANGLES;

	CheckImpulses();
	makevectors(self.v_angle);

	HandleShoot();
	HandleReload();

	ShootCooldown();
	ReloadCooldown();
};


/*
PlayerPostThink
Post-Update function for the player.
*/
void PlayerPostThink()
{
	if(self.flags & FL_ONGROUND)
    self.velocity *= 0.9;
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
	print("Client connect\n");
	self.last_time = 0;
	self.sv_shooting = 0;
	self.sv_reloading = 0;
	self.reload_pressed_last = 0;
	self.shoot_pressed_last = 0;
};


float MySendEntity(entity playerent, float changedflags)
{
	WriteByte(MSG_ENTITY, ENTITY_PLAYER);
	WriteByte(MSG_ENTITY, changedflags);

	if (changedflags & SENDFLAGS_ANGLES)
	{
		WriteCoord(MSG_ENTITY, self.angles_x);
		WriteCoord(MSG_ENTITY, self.angles_y);
		WriteCoord(MSG_ENTITY, self.angles_z);
	}

	if (changedflags & SENDFLAGS_ORIGIN)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}

	if (changedflags & SENDFLAGS_CURRENTWEAPON)
		WriteByte(MSG_ENTITY, self.current_weapon);

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
	self.classname = "player";
	self.solid = SOLID_SLIDEBOX;
	self.health = 100;
	precache_model("models/testplayer.iqm");
	setmodel(self, "models/testplayer.iqm");
	self.movetype = MOVETYPE_WALK;
	setorigin(self, get_spawn_point());
	//self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [16, 16, 56]);
	self.view_ofs = [0, 0, 48];
	self.SendEntity = MySendEntity;
	WeaponsInit();


	self.SendFlags = SENDFLAGS_ORIGIN | SENDFLAGS_MODELINDEX;
};

void PutClientInServer()
{
	player_chain_add(self);
	PlayerSpawn();
};

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
		// case "reload":
		// 	print("foooooo");
		// break;
		default: break;
	}
};


void SV_RunClientCommand()
{
	runstandardplayerphysics(self);
};

