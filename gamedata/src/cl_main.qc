/*
CSQC_Init
Client Side Quake C Init Func
*/
noref void CSQC_Init(float apiver, string enginename, float enginever)
{
	PrecacheEverything();
	WS_Connect();
	SkinsInit();
};


/*
CSQC_Ent_Remove
Called when a Client Side Entity is
removed from the world
*/
void CSQC_Ent_Remove()
{
	remove(self);
};


/*
CSQC_Shutdown
Called when ClientSide QC Shutsdown
Cleanup
*/
void CSQC_Shutdown()
{
};


/*
CSQC_WorldLoaded
Called once world has loaded and
entities have spawned
*/
noref void CSQC_WorldLoaded() =
{

};

/*
PlayerPredraw
Called before Update event
Put Server Side Updates in here...
*/
float PlayerPredraw()
{
	if (!self || self == world) return true;
	if (self == 0) return true;

	int isme = self.entnum == player_localentnum;

	self.oldorigin = self.origin;
	self.oldvelocity = self.velocity;

	self.origin_x = lerp(self.origin_x, self.new_x, NET_LERP);
	self.origin_y = lerp(self.origin_y, self.new_y, NET_LERP);
	self.origin_z = lerp(self.origin_z, self.new_z, NET_LERP);
	setorigin(self, self.origin);

	health = getstatf(STAT_HEALTH);
	health = clampf(health, 0, 255);
	max_health = getstatf(STAT_MAXHEALTH);
	armor = getstatf(STAT_ARMORVALUE);
	total_ammo = getstati(STAT_TOTALAMMO);
	ammo_count = getstati(STAT_CURRENTAMMO);

	// This is me
	if (isme)
	{
		// We have a viewmodel , we are probably a player
		if (self.viewmodel)
		{
			// We are alive
			if (health >= 1)
			{
				self.viewmodel.Animate(frametime);
			}
			// We are dead
			else
			{
				if (self.viewmodel.modelindex != VIEWMODEL_NONE)
				{
					self.viewmodel.ChangeViewModel(VIEWMODEL_NONE);
				}
			}
		}
		// We have NO viewmodel , we are probably a spectator
		else
		{
			return true;
		}
	} 

	// This is another player
	else 
	{
		PlayerStateMachine();
		addentity(self.weapon_ent);
	}
	return true;
};

/*
CSQC_Ent_Update
Called everytime a PACKET is received (NOT every tick!)
Handles the incoming packets/messages from the SVQC code
*/
noref void CSQC_Ent_Update(float isnew)
{
	if (self == world) return;

	float enttype = readbyte();
	int isme = readbyte();
	float flags;
	switch (enttype)
	{
	
	/*=================================
	PLAYER
	//=================================*/
	case ENTITY_PLAYER:
		flags = readbyte();

		self.oldangles.x = readcoord();
		self.oldangles.y = readcoord();
		self.oldangles.z = readcoord();
		self.predraw = PlayerPredraw;

		// Create Event [Player Spawned]
		if (self && self.entnum != 0 && isnew) 
		{
			setmodel(self, "models/monster_shotgunner/monster_shotgunner_nowep.glb");
			self.frame = PLAYER_ANIM_IDLE;
			
			if (isme) CPlayerSpawn();
			else WeaponEntitySpawn();
		}

		// Origin
		if (flags & SENDFLAGS_ORIGIN)
		{
			self.new_x = readcoord();
			self.new_y = readcoord();
			self.new_z = readcoord();
		}

		// Current Weapon
		if (flags & SENDFLAGS_CURRENTWEAPON)
		{
			int viewmodel_index = readbyte();
			if (isme)
			{
				if (viewmodel_index == 0) viewmodel_index = VIEWMODEL_NONE;
				self.viewmodel.current_viewmodel = viewmodel_index;
				self.viewmodel.ChangeViewModel(viewmodel_index);
				cl_viewmodel = viewmodel_index;
			}
			else
			{
				self.weapon_ent.ChangeWeapon(viewmodel_index);
    			PlayerChangeAnim(PLAYER_TOP_ANIM_IDLE);
			}
		}

		// Reload
		if (flags & SENDFLAGS_RELOAD)
		{
			if (isme)
			{
				if (!isnew) 
				{
					self.viewmodel.SetFrame(viewmodels[self.viewmodel.current_viewmodel].anim_reload); 
					localsound(viewmodels[self.viewmodel.current_viewmodel].sound_reload, CHAN_AUTO, 0.2);
				}
			}
			else
			{
				if (self.body_anim != PLAYER_TOP_ANIM_RELOAD)
				{
					PlayerChangeAnim(PLAYER_TOP_ANIM_RELOAD);
					sound(self, CHAN_AUTO, viewmodels[self.viewmodel.current_viewmodel].sound_shoot, 0.2, ATTN_NORM);
				}
			}
		}

		// Jump
		if (flags & SENDFLAGS_JUMP)
		{
			// if (isme)
			// 	localsound("sound/player/player_jump.ogg", CHAN_AUTO, 1);
			// else
			print("WHAT THE FUCK?!");
			localsound("sound/player/player_jump.ogg", CHAN_AUTO, 1);
		}

		// Hit
		if (flags & SENDFLAGS_HIT)
		{
			int istarget = readbyte();
			if (istarget == true)
			{
				print("I was shot");
			}
		}

		// Shoot
		if (flags & SENDFLAGS_SHOOT)
		{
			if (isme)
			{
				if (!isnew) 
				{
					self.viewmodel.SetFrame(viewmodels[self.viewmodel.current_viewmodel].anim_shoot);
					localsound(viewmodels[self.viewmodel.current_viewmodel].sound_shoot, CHAN_AUTO, 0.2);
				}
			}
			else
			{
				if (self.body_anim != PLAYER_TOP_ANIM_SHOOT)
				{
					PlayerChangeAnim(PLAYER_TOP_ANIM_SHOOT);
					sound(self, CHAN_AUTO, viewmodels[self.viewmodel.current_viewmodel].sound_shoot, 0.2, ATTN_NORM);
				}
			}
			
		}

		// Model Index (Current Model's Animation)
		if (flags & SENDFLAGS_MODELINDEX)
		{
			int i = readshort();
			setmodelindex(self, i);
			self.drawmask = 1;
		}
	break;
	/*=================================
	PLAYER END
	//=================================*/
	default: error("ERROR in CSQC_Ent_Update: Misaligned bytes or unknown Entity type. Make sure you are reading all bytes you sent from the server in the correct order. Try running csqcdebug 1");
	}
};


/*
CSQC_UpdateView
Client Side QC Update Event
Called EVERY game TICK!
*/
void CSQC_UpdateView(float width, float height, float menushown)
{
	if (!self || self == world) return;
	
	WS_Update(); // Call to receive messages from websocket server

	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;
	
	// disable default crosshair and hud
	setproperty(VF_DRAWENGINESBAR, 0);	
	setproperty(VF_DRAWCROSSHAIR, 1);

	// basically offsets camera so were not stuck in the floor
	// and does the viewbob thing
	campos = getproperty(VF_ORIGIN);
	camang = getproperty(VF_ANGLES);

	entity csqcplayer = findfloat(world, entnum, player_localentnum);
	if (csqcplayer && csqcplayer != world)
	{
		vector view_ofs = {0};
		view_ofs.z = health > 0 ? getstatf(STAT_VIEWHEIGHT) : VIEWHEIGHT_ELIMINATED;
		setviewprop(VF_ORIGIN, csqcplayer.origin + view_ofs);
	
		if (csqcplayer.viewmodel && csqcplayer.viewmodel.debug_mode == false)
			csqcplayer.viewmodel.UpdateBobbing(csqcplayer, frametime);
	
		//autoadd entities received from servers for drawing	
		addentities(MASK_ENGINE | MASK_VIEWMODEL);
	}

	renderscene();
	draw_gui();
};


/*
CSQC_ConsoleCommand
You can define custom CS console commands here
in the switch statement based on their string
*/
float CSQC_ConsoleCommand(string cmd)
{
	tokenize(cmd);
	string command = argv(0);
	switch(command)
	{
		case "viewmodel_debug":
			entity csqcplayer = findfloat(world, entnum, player_localentnum);
			if (!csqcplayer || !csqcplayer.viewmodel)
			{
				print("Cannot toggle viewmodel debug: viewmodel is NULL\n");
				return TRUE;
			}
			if (csqcplayer.viewmodel.debug_mode == true)
			{
				csqcplayer.viewmodel.debug_mode = false;
				print("Viewmodel Debug Mode Disabled\n");
			}
			else
			{
				csqcplayer.viewmodel.debug_mode = true;
				print("Viewmodel Debug Mode Enabled\n");
			}
		break;


		default:
			return FALSE;
	}
	return TRUE;
};


/*
CSQC_InputEvent
Handles Client Side user inputs
for controlling menus etc.
*/
float CSQC_InputEvent(float evtype, float scanx, float chary, float devid)
{
	sui_input_event(evtype, scanx, chary, devid);
	switch(evtype)
	{
	case IE_KEYDOWN:
	
		if (!self || !self.viewmodel) return false;
		if (self.viewmodel.debug_mode == false) return false;

		switch (scanx)
		{
			case K_LEFTARROW:
				self.viewmodel.angles[0] -= 1;
			break;
			case K_RIGHTARROW:
				self.viewmodel.angles[0] += 1;
			break;
			case K_UPARROW:
				self.viewmodel.angles[1] -= 1;
			break;
			case K_DOWNARROW:
				self.viewmodel.angles[1] += 1;
			break;
			case K_DEL:
				self.viewmodel.angles[2] -= 1;
			break;
			case K_END:
				self.viewmodel.angles[2] += 1;
			break;
			case K_MWHEELDOWN:
				self.viewmodel.origin[2] -= 1;
			break;
			case K_SPACE:
				self.viewmodel.origin[2] += 1;
			break;
			case K_PGDN:
				self.viewmodel.origin[0] -= 1;
			break;
			case K_PGUP:
				self.viewmodel.origin[0] += 1;
			break;
			case K_ENTER:
				self.viewmodel.origin[1] -= 1;
			break;
			case K_BACKSPACE:
				self.viewmodel.origin[1] += 1;
			break;
			default:break;			
		}

		return FALSE;
	case IE_KEYUP:
		return FALSE;
	case IE_MOUSEDELTA:
		return FALSE;
	case IE_MOUSEABS:
		cursor_pos_x = scanx;
		cursor_pos_y = chary;
		return FALSE;
	}
	return FALSE;
};


/*
CSQC_Parse_Event
Not quite sure when to use this
over the other network message receiver
*/
void CSQC_Parse_Event()
{
	float first = readbyte();
	switch(first) {
		case 1: 
		break;
		default:
			printf("No action for byte %f\n", first);
			break;
	}
};


/*
find_player_id
Find ME in the world of all the entities
*/
float find_player_id(string key, string val)
{
	for (int currentindex = 0; currentindex < maxclients; currentindex++)
	{
		if (getplayerkeyvalue(currentindex, key) == val) return currentindex;
	}
	return -1;
}


/*
CSQC_Parse_Print
Prints a parsed message? idk
*/
void CSQC_Parse_Print(string printmsg, float printlvl)
{
	print(printmsg);
};


/*
CSQC_RendererRestarted
Called whenever the RENDERER restarts/starts
If you ForceShader or Overwrite a shader
IT MUST BE RE-APPLIED HERE. Or else when they fullscreen/change renderer the material/shader will be reset and not re-applied automatically.
*/
void CSQC_RendererRestarted(string rendererdescription)
{
	// for (self = world; (self = nextent(self)); ) 
	// {

	// }
}

// for (self = world; (self = nextent(self); ) {self.doshit();}
