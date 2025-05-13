
// this function was used by the original 1996 QuakeC compiler to create the
// Quake PAK files. it was never called by the engine and is effectively dead
// code. it is only kept here for completeness.
void main()
{

}

// this function is called by the engine at the start of each server frame,
// before physics is ran on each entity. you can use this function to check for
// world state changes like skill updates or whatever.
void StartFrame()
{

}

// this function is called by the engine at the end of each server frame, after
// physics is ran on each entity.
void EndFrame()
{

}

// equivalent to StartFrame, but called once for each connected player before
// the physics has been ran on that player.
void PlayerPreThink()
{

}

// equivalent to EndFrame, but called once for each connected player after the
// physics has been ran on that player.
void PlayerPostThink()
{

}

// called when a player is killed
void ClientKill()
{

}

// called by the engine just before PutClientInServer() is called, thus making
// it somewhat useless. you could use it to display a server message that a
// new player is incoming. in a singleplayer game this is not useful.
void ClientConnect()
{

}

// the player spawn function. we look for an info_player_start to find a
// starting position, then setup the default player values. after that, we
// decode the changelevel parms to bring over any data from the previous level
// (if applicable).
void PutClientInServer()
{
	entity spot = find(world, classname, "info_player_start");

	if (spot)
	{
		setorigin(self, spot.origin);
		self.angles = spot.angles;
	}
	else
	{
		setorigin(self, [0, 0, 0]);
		self.angles = [0, 0, 0];
	}

	// setup default player values
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.fixangle = TRUE;
	setsize(self, [-16, -16, -24], [16, 16, 32]);
	self.flags |= FL_CLIENT;
	self.view_ofs = [0, 0, 22];
	self.classname = "player";

	// decode changelevel parms
	self.health = parm1;
}

// called by the engine when a player disconnects. "self" is the player entity
// that is disconnecting.
void ClientDisconnect()
{

}

// called by the engine before spawning the player, if they didn't transition
// from a previous level. use this to set default values for things that are
// carried across changelevels. here we are using "parm1" to hold the player's
// default health value.
void SetNewParms()
{
	parm1 = 100;
}

// called by the engine when a player is exiting the level to go to another
// level. use this function to save values between level changes.
void SetChangeParms()
{
	parm1 = self.health;
}

// called when a spectator connects.
void SpectatorConnect()
{

}

// called when a spectator disconnects.
void SpectatorDisconnect()
{

}

// called once for each connected spectator during each server frame.
void SpectatorThink()
{

}

// parse console-entered commands by the client.
void SV_ParseClientCommand(string cmd)
{
	clientcommand(self, cmd);
}

// called for each frame where the server is paused.
void SV_PausedTic(float paused_time)
{

}

// return TRUE if the server should be allowed to pause.
float SV_ShouldPause(float new_status)
{
	return TRUE;
}

// the player physics frame function. we call the standard Quake player physics
// builtin, because writing your own player physics is a lot of work.
void SV_RunClientCommand()
{
	runstandardplayerphysics(self);
}
