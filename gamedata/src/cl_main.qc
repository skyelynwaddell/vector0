.float new_x;
.float new_y;
.float new_z;

noref void CSQC_Init(float apiver, string enginename, float enginever)
{
	PrecacheEverything();
};

void CSQC_Ent_Remove()
{
	remove(self);
};

void CSQC_Shutdown()
{
};

noref void CSQC_WorldLoaded() =
{

};

float PlayerPredraw()
{
	int isme = self.entnum == player_localentnum;

	self.origin_x = lerp(self.origin_x, self.new_x, NET_LERP);
	self.origin_y = lerp(self.origin_y, self.new_y, NET_LERP);
	self.origin_z = lerp(self.origin_z, self.new_z, NET_LERP);
	setorigin(self, self.origin);

	if (isme)
	{
		self.viewmodel.Animate(frametime);

	} else 
	{
		addentity(self);
	}
	return true;
};

noref void CSQC_Ent_Update(float isnew)
{
	int isme = self.entnum == player_localentnum;

	float enttype = readbyte();
	float flags;
	switch (enttype)
	{
	case ENTITY_PLAYER:
		flags = readbyte();

		self.predraw = PlayerPredraw;
		self.angles_x = readcoord();
		self.angles_y = readcoord();
		self.angles_z = readcoord();

		// Player Spawned
		if (self && self.entnum != 0 && isnew) // first time we see this entity INIT
		{
			if (isme) CPlayerSpawn();
			setmodel(self, "models/testplayer.iqm");
		}

		// Origin
		if (flags & SENDFLAGS_ORIGIN)
		{
			self.new_x = readcoord();
			self.new_y = readcoord();
			self.new_z = readcoord();
		}

		// Player Health & Armor
		if (flags & SENDFLAGS_STATS)
		{
			if (isme)
			{
				health = readbyte();
				max_health = readbyte();
				armor = readbyte();
			}
		}


		// Current Weapon
		if ((flags & SENDFLAGS_CURRENTWEAPON) && isme) 
		{
			int viewmodel_index = readbyte();
			if (viewmodel_index == 0) viewmodel_index = VIEWMODEL_NONE;
			self.viewmodel.current_viewmodel = viewmodel_index;
			self.viewmodel.ChangeViewModel(viewmodel_index);
			total_ammo = readbyte();
			ammo_count = readbyte();
			cl_viewmodel = viewmodel_index;
		}

		// Reload
		if (flags & SENDFLAGS_RELOAD && isme)
		{
			self.viewmodel.SetFrame(viewmodels[self.viewmodel.current_viewmodel].anim_reload); 
			total_ammo = readbyte();
			ammo_count = readbyte();
		}

		// Shoot
		if (flags & SENDFLAGS_SHOOT && isme)
		{
			self.viewmodel.SetFrame(viewmodels[self.viewmodel.current_viewmodel].anim_shoot);
			total_ammo = readbyte();
			ammo_count = readbyte();
		}

		// Model Index (Current Model's Animation)
		if (flags & SENDFLAGS_MODELINDEX)
		{
			int i = readshort();
			setmodelindex(self, i);
			self.drawmask = 1;
		}

	break;
	default: error("Unknown entity type! oh noes! panic!");
	}
};

// CALLED EVERY CLIENT RENDER FRAME
void CSQC_UpdateView(float width, float height, float menushown)
{
	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;
	
	// disable default crosshair and hud
	setproperty(VF_DRAWENGINESBAR, 0);	
	setproperty(VF_DRAWCROSSHAIR, 1);

	campos = getproperty(VF_ORIGIN);
	camang = getproperty(VF_ANGLES);

	entity csqcplayer = findfloat(world, entnum, player_localentnum);
	vector your_view_ofs = [0,0,getstatf(STAT_VIEWHEIGHT)];
	setviewprop(VF_ORIGIN, csqcplayer.origin + your_view_ofs);

	//autoadd entities received from servers for drawing	
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	//does what you think it does
	renderscene();
	draw_gui();
};

float CSQC_ConsoleCommand(string cmd)
{
	tokenize(cmd);
	string command = argv(0);
	switch(command)
	{
		default:
			return FALSE;
	}
	return TRUE;
};

float CSQC_InputEvent(float evtype, float scanx, float chary, float devid)
{
	sui_input_event(evtype, scanx, chary, devid);
	switch(evtype)
	{
	case IE_KEYDOWN:
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
			case K_MWHEELUP:
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


float find_player_id(string key, string val)
{
	for (int currentindex = 0; currentindex < maxclients; currentindex++)
	{
		if (getplayerkeyvalue(currentindex, key) == val) return currentindex;
	}
	return -1;
}

void CSQC_Parse_Print(string printmsg, float printlvl)
{
	print(printmsg);
};
