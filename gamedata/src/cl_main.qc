void CSQC_Ent_Remove()
{
	remove(self);
};

void CSQC_Shutdown()
{
};

noref void CSQC_Init(float apiver, string enginename, float enginever)
{
	PrecacheEverything();
};

noref void CSQC_WorldLoaded() =
{
	CPlayerSpawn();

};

float new_x;
float new_y;
float new_z;

int timer;
noref void CSQC_Ent_Update(float isnew)
{
	float enttype = readbyte();
	float flags;
	switch (enttype)
	{
	case 5:
		flags = readbyte();
		if (flags & SENDFLAGS_ORIGIN)
		{
				new_x = readcoord();
				new_y = readcoord();
				new_z = readcoord();
		}
		if (flags & SENDFLAGS_CURRENTWEAPON)
		{
			viewmodel.current_viewmodel = readbyte();
			viewmodel.ChangeViewModel(viewmodel.current_viewmodel);
		}

		if (flags & SENDFLAGS_RELOAD)
			viewmodel.SetFrame(viewmodels[viewmodel.current_viewmodel].anim_reload); 

		if (flags & SENDFLAGS_SHOOT)
			viewmodel.SetFrame(viewmodels[viewmodel.current_viewmodel].anim_shoot);
	break;
	default:
		error("Unknown entity type! oh noes! panic!");
	};
};

// CALLED EVERY CLIENT RENDER FRAME
void CSQC_UpdateView(float width, float height, float menushown)
{
	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;

	//animate the view model
	viewmodel.Animate(frametime);
	
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

	self.origin_x = lerp(self.origin_x, new_x, NET_LERP);
	self.origin_y = lerp(self.origin_y, new_y, NET_LERP);
	self.origin_z = lerp(self.origin_z, new_z, NET_LERP);
	setorigin(self, self.origin);
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
			viewmodel.angles[0] -= 1;
			break;
			case K_RIGHTARROW:
			viewmodel.angles[0] += 1;
			break;
			case K_UPARROW:
			viewmodel.angles[1] -= 1;
			break;
			case K_DOWNARROW:
			viewmodel.angles[1] += 1;
			break;
			case K_DEL:
			viewmodel.angles[2] -= 1;
			break;
			case K_END:
			viewmodel.angles[2] += 1;
			break;

			case K_MWHEELDOWN:
				viewmodel.origin[2] -= 1;
			break;
			case K_MWHEELUP:
				viewmodel.origin[2] += 1;
			break;
			case K_PGDN:
				viewmodel.origin[0] -= 1;
			break;
			case K_PGUP:
				viewmodel.origin[0] += 1;
			break;
			case K_ENTER:
				viewmodel.origin[1] -= 1;
			break;
			case K_BACKSPACE:
				viewmodel.origin[1] += 1;
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
