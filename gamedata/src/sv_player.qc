
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//

/*
PlayerJump
Invokes the jump action for the player.
*/
void() PlayerJump =
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
void() CheckImpulses =
{
	switch (self.impulse)
	{
	default: break;
	}
	self.impulse = 0;
};


/*
get_spawn_point
Returns the spawn point for the player.
*/
vector() get_spawn_point =
{
	entity spawnpoint = world;
	spawnpoint = find(spawnpoint, classname, "info_player_start");

	return spawnpoint.origin + '0 0 1';
};


/*
Player_HandleJump
Handles the player's jump action based on button input.
*/
void() Player_HandleJump = 
{
	if(self.button2)
		PlayerJump();
	else
		self.flags = self.flags | FL_JUMPRELEASED;
}


/*
PlayerPreThink
Pre-Update function for the player.
*/
void() PlayerPreThink =
{	
	CheckImpulses();
	makevectors(self.v_angle);
	if(self.button0)
	{
		
	}
	
};


/*
PlayerPostThink
Post-Update function for the player.
*/
void() PlayerPostThink =
{
	if(self.flags & FL_ONGROUND)
    self.velocity *= 0.9;
};


/*
ClientKill
Called when a client is disconnected from server
*/
void() ClientKill =
{
};

/*
ClientConnect
Called when a client connects to the server
*/
void() ClientConnect =
{
	print("Client connect\n");
};


/*
PlayerSpawn
Spawns the player entity with default parameters.
*/
void() PlayerSpawn =
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

};

void() PutClientInServer =
{
	player_chain_add(self);
	PlayerSpawn();
};

void() ClientDisconnect =
{
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has left the game.\n");
};


void() SetNewParms =
{
};

void() SetChangeParms =
{
};

void() info_player_start =
{
};

void(float elapsedtime) SV_PausedTic =
{
	// if (elapsedtime > 2) setpause(0);
};

void(string command_string) SV_ParseClientCommand =
{
	tokenize(command_string);
	string cmd = argv(0);
	switch (cmd)
	{
	default: break;
	}
	clientcommand(self, command_string);
};


void() SV_RunClientCommand =
{
	runstandardplayerphysics(self);
};


