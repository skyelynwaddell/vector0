
void() CSQC_Ent_Remove =
{
	remove(self);
};

void() CSQC_Shutdown =
{
};

noref void(float apiver, string enginename, float enginever) CSQC_Init =
{
	drawfont = loadfont("", "Courier Prime Code", "12,16,24,32,64,72,128,256,512", -1, 0, 0);
	precache_everything();
};

noref void() CSQC_WorldLoaded =
{
	CPlayerSpawn();
};

noref void(float isnew) CSQC_Ent_Update =
{
	// printf("csqc ent update %f\n", isnew);
};

// CALLED EVERY CLIENT RENDER FRAME
void(float width, float height, float menushown) CSQC_UpdateView =
{
	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;

	//animate the view model
	viewmodel.Animate(frametime);
	
	// disable default crosshair and hud
	setproperty(VF_DRAWENGINESBAR, 0);	
	localcmd("crosshair 16\n");
	setproperty(VF_DRAWCROSSHAIR, 1);

	campos = getproperty(VF_ORIGIN);
	camang = getproperty(VF_ANGLES);

	//autoadd entities received from servers for drawing	
	addentities(MASK_ENGINE | MASK_VIEWMODEL);
	
	//does what you think it does
	renderscene();
	draw_gui();
};

float(string cmd) CSQC_ConsoleCommand =
{
	tokenize(cmd);
	switch(argv(0))
	{
		default:
			return FALSE;
	}
	return TRUE;
};

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
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


void() CSQC_Parse_Event =
{
	float first = readbyte();
	switch(first) {
		default:
			printf("No action for byte %f\n", first);
			break;
	}
};


float(string key, string val) find_player_id =
{
	for (int currentindex = 0; currentindex < maxclients; currentindex++)
	{
		if (getplayerkeyvalue(currentindex, key) == val) return currentindex;
	}
	return -1;
}

void(string printmsg, float printlvl) CSQC_Parse_Print =
{
	print(printmsg);
};
