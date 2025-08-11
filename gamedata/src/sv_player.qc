
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//
int is_busy;
int reload_pressed_last;
int shoot_pressed_last;

enum PLAYER_STATE {
	FREE,
	SHOOTING,
	RELOADING,
};

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
			self.SendFlags |= SENDFLAGS_CURRENTWEAPON;
		break;

		case 1:
			ChangeWeapon(WEAPON_PISTOL);
			self.SendFlags |= SENDFLAGS_CURRENTWEAPON;
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
	if (is_busy != FREE) return;
	is_busy = RELOADING;
	sv_reloading = true;
	weapons[current_weapon].timer = weapons[current_weapon].reload_time;
	self.SendFlags |= SENDFLAGS_RELOAD;
}

void HandleReload()
{
	if (sv_shooting) return;
	if (sv_reloading) return;

	int reload_pressed_now = self.button4;

	if (!sv_reloading && reload_pressed_now && !reload_pressed_last)
        Reload();

    reload_pressed_last = reload_pressed_now;
}

void ReloadCooldown()
{
	if (sv_reloading == false) return;

	weapons[current_weapon].timer -= frametime;
	if (weapons[current_weapon].timer <= 0.1) 
	{
		sv_reloading = false;
		is_busy = FREE;
	}
}

void Shoot()
{
	if (is_busy != FREE) return;	
	is_busy = RELOADING;

	sv_shooting = true;
	weapons[current_weapon].timer = weapons[current_weapon].fire_rate;
	self.SendFlags |= SENDFLAGS_SHOOT;
}

void HandleShoot()
{
	if (sv_shooting) return;
	if (sv_reloading) return;

	int shoot_pressed_now = self.button0;

	if (!sv_shooting && shoot_pressed_now && !shoot_pressed_last)
        Shoot();

    shoot_pressed_last = shoot_pressed_now;
}

void ShootCooldown()
{
	if (sv_shooting == false) return;

	weapons[current_weapon].timer -= frametime;
	if (weapons[current_weapon].timer <= 0.1) 
	{
		sv_shooting = false;
		is_busy = FREE;
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

	CheckImpulses();
	makevectors(self.v_angle);
	
	HandleShoot();
	ShootCooldown();

	HandleReload();
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
	last_time = 0;
	sv_shooting = 0;
	sv_reloading = 0;
	reload_pressed_last = 0;
	shoot_pressed_last = 0;
};


float MySendEntity(entity playerent, float changedflags)
{
	WriteByte(MSG_ENTITY, 5);
	WriteByte(MSG_ENTITY, changedflags);

	if (changedflags & SENDFLAGS_ORIGIN)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}

	if (changedflags & SENDFLAGS_CURRENTWEAPON)
		WriteByte(MSG_ENTITY, current_weapon);

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
	setmodel(self, "models/testplayer.iqm");
	self.movetype = MOVETYPE_WALK;
	self.health = 100;
	setorigin(self, get_spawn_point());
	self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [16, 16, 56]);
	self.view_ofs = [0, 0, 48];
	self.SendEntity = MySendEntity;
	self.SendFlags = SENDFLAGS_ORIGIN | SENDFLAGS_CURRENTWEAPON;
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

	print("Parsed command: ", cmd, "\n");

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

