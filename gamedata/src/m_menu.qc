vector MENU_BG            = '0.07 0.00 0.12';   // deep purple (still dark, but brighter than before)
vector MENU_BG_DARK       = '0.04 0.00 0.08';   // darker tone for contrast
vector MENU_BORDER        = '0.6 0.0 1.0';      // bright violet-magenta (matches your ring)
vector MENU_BUTTON        = '0.3 0.0 0.5';      // strong purple button color
vector MENU_BUTTON_BORDER = '0.75 0.0 1.0';     // vivid pink-purple border
vector MENU_TEXT_1        = '1 1 1';            // white text
vector MENU_TEXT_2        = '0.9 0.75 1.0';     // soft light purple/lavender
vector MENU_HIGHLIGHT     = '1 0.6 1';          // magenta glow effect for highlights
vector MENU_DARKEN        = '0.15 0.0 0.25';    // light purple-black overlay

vector MENU_TEXT_SMALL = '8 8 0';
vector MENU_TEXT_MEDIUM = '16 16 0';
vector MENU_TEXT_LARGE = '24 24 0';

float menu_in_game;

void() input_tester =
{
	float char = 0;
	float scan = 0;
	string printme = "";
	while (sui_get_input(char, scan))
	{
		printme = strcat(printme, chr2str(char));
	}
	if (printme != "") printf("INPUT: %s\n", printme); 
};

void(string id, vector pos, vector size, float maxlen, __inout string text, __inout float cursor) text_input_control =
{
	vector textsize = [size_y - 4, size_y - 4];
	sui_push_frame(pos, size);
	vector basecolor = sui_is_hovered(id) ? MENU_BG_DARK + MENU_HIGHLIGHT * 0.08 : MENU_BG_DARK; 
	sui_fill([0, 0], size, basecolor, 0.6, 0);
	
	sui_text_input(id, [0, 0], size, text, cursor);
	
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_CENTER]);
	float focused = sui_is_last_clicked(id);
	// Under focus
	focused ? sui_border_box([0, 0], size, 1, MENU_BORDER, 0.6, 0) : 0;	
	
	sui_push_frame([2, 0], [size_x - 4, size_y - 4]);
	
	float cursorx;
	if (stringwidth(text, 1, textsize) > size_x - 4)
	{
		sui_clip_to_frame();
		cursorx = 0;
		sui_set_align([SUI_ALIGN_END, SUI_ALIGN_CENTER]);
		sui_text([0, 0], textsize, text, MENU_TEXT_1, 1, 0);
	}
	else
	{
		cursorx = stringwidth(substring(text, 0, cursor), 1, textsize);
		sui_text([0, 0], textsize, text, MENU_TEXT_1, 1, 0);
	}
	if (focused) 
	{
		sui_fill([cursorx, 0], [2, textsize_y], MENU_TEXT_1, fabs(sin(time * 4)), 0);
	}
	sui_reset_clip();
	sui_pop_frame();
};

float(string id, vector pos, vector size, string text) my_button =
{
	sui_push_frame(pos, size);
	vector basecolor = sui_is_hovered(id) ? MENU_BUTTON + MENU_HIGHLIGHT * 0.25 : MENU_BUTTON; 
	basecolor = sui_is_held(id) ? MENU_BUTTON - MENU_DARKEN * 0.1 : basecolor;
	vector text_color = sui_is_hovered(id) ? MENU_TEXT_2 : MENU_TEXT_1;
	//sui_fill([0, 0], size, basecolor, 0.6, 0);
	//sui_border_box([0, 0], size, 1, MENU_BUTTON_BORDER, 0.4, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	sui_text([0, 0], MENU_TEXT_SMALL, text, text_color, 1, 0);	
	sui_action_element([0, 0], size, id, sui_noop);
	sui_pop_frame();
	
	return sui_is_clicked(id);
};


void(string id, vector pos, vector size, vector minmaxsteps, __inout float value) my_slider =
{
	sui_push_frame(pos, size);
	
	value = sui_slidercontrol(id, [0, 0], size, minmaxsteps, value, sui_slider_noop);
	float maxval = minmaxsteps[1];
	float sliderx = (value / maxval) * size_x;
	sui_fill([0, size_y * 0.25], [size_x, size_y * 0.5], MENU_BG_DARK, 1.0, 0);
	
	float is_active = sui_is_held(id) || (sui_is_hovered(id) && !sui_click_held());
	vector slider_ctrl_color = is_active ? MENU_BUTTON + MENU_HIGHLIGHT * 0.2 : MENU_BUTTON;
	sui_fill([sliderx - 2, 0], [4, size_y], slider_ctrl_color, 1.0, 0);
	
	sui_pop_frame();
};

void(vector pos, vector size, vector minmaxsteps, string cvar_s, string name, string format) cvar_slider =
{
	float current = cvar(cvar_s);
	float old = current;
	sui_push_frame(pos, [size_x, size_y * 0.5 - 4]);
	sui_text([0, 0], MENU_TEXT_SMALL, name, MENU_TEXT_1, 1, 0);
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_START]);
	sui_text([0, 0], MENU_TEXT_SMALL, sprintf(format, current), MENU_TEXT_1, 1, 0);
	sui_pop_frame();
	my_slider(strcat(cvar_s, "sldr"), [pos_x, pos_y + size_y * 0.5], [size_x, size_y * 0.5], minmaxsteps, current);
	if (current != old) cvar_set(cvar_s, ftos(current));
};

struct name_command {
	string name;
	string command;
};

name_command bindlist[] = 
{
	{ "Forward", "+forward" },
	{ "Back", "+back" },
	{ "Left", "+moveleft" },
	{ "Right", "+moveright" },
	{ "Jump", "+jump" },
	{ "Jump1", "+jump" },
	{ "Jump2", "+jump" },
	{ "Jump3", "+jump" },
	{ "Jump4", "+jump" },
	{ "Jump5", "+jump" },
	{ "Jump6", "+jump" },
	{ "Jump7", "+jump" },
	{ "Jump8", "+jump" },
	{ "Jump9", "+jump" },
	{ "Jump0", "+jump" },
};

void(string id, vector pos, vector size, string name, string command) bind_button =
{
	sui_push_frame(pos, size);
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_CENTER]);
	string key = sui_binder(id, [0, 0], size, name, command);
	if (sui_is_hovered(id)) sui_fill([0, 0], size, MENU_HIGHLIGHT, 0.1, 0);
	sui_text([6, 0], MENU_TEXT_SMALL, name, MENU_TEXT_1, 1, 0);
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_CENTER]);
	sui_text([-6, 0], MENU_TEXT_SMALL, key, MENU_TEXT_1, 1, 0);
	
	sui_pop_frame();
};


void(string id, vector pos, vector size, __inout vector scrollofs) bind_list =
{
	sui_fill(pos, size, MENU_BG_DARK, 0.75, 0);
	sui_list_view_begin(strcat(id, "scrl"), pos, size, [size_x - 6, 24], bindlist.length, scrollofs, [0, 6]);
	vector listitem_pos = '0 0 0';
	for (float index = sui_list_item(listitem_pos); index > -1; index = sui_list_item(listitem_pos))
	{
		sui_push_frame(listitem_pos, [size_x - 6, 24]);
		bind_button(strcat(id, ftos(index)), [0, 0], [size_x - 6, 24], bindlist[index].name, bindlist[index].command);
		sui_pop_frame();
	}
	sui_list_view_end();	
};


float current_menu;
const float MENU_MAIN = 1;
const float MENU_SETTINGS = 2;
const float MENU_HELP = 3;
const float MENU_INGAME = 4;

vector binds_scroll;
void() settings_menu =
{
	vector pos = [0, 0];
	vector size = [360, 280];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "Settings", MENU_TEXT_1, 1, 0);

	
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_START]);
	
	float xpos = 8;
	float ypos = 32;
	float width = size_x * 0.5 - 8 * 2;

	cvar_slider([xpos, ypos], [width, 32], [0, 1], "volume", "Volume", "%.2f");
	ypos += 32 + 4;
	cvar_slider([xpos, ypos], [width, 32], [0, 1], "musicvolume", "Music Volume", "%.2f");
	ypos += 32 + 4 + 8;
	
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Video", MENU_TEXT_1, 1, 0);
	ypos += 16;
	my_button("fs_btn", [xpos, ypos], [width, 20], "Fullscreen") ? localcmd("vid_fullscreen 2; vid_restart\n") : 0;
	ypos += 24;
	my_button("wn_btn", [xpos, ypos], [width, 20], "Windowed") ? localcmd("vid_fullscreen 0; vid_width 1024; vid_height 768; vid_restart\n") : 0;
	ypos += 24;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Window can be resized.", MENU_TEXT_1, 0.8, 0);
	ypos += 16;

	ypos = 32;
	xpos = 8 + width + 8 + 8;
	
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Controls", MENU_TEXT_1, 1, 0);
	ypos += 16;
	bind_list("bindlist", [xpos, ypos], [width, 160], binds_scroll);
	ypos += 160 + 8;

	cvar_slider([xpos, ypos], [width, 32], [0.1, 10], "sensitivity", "Sensitivity", "%.2f");
	ypos += 32;

	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_END]);


	if (sui_listen_back())
	{
		if (menu_in_game == 1)
			current_menu = MENU_INGAME;
		else
			current_menu = MENU_MAIN;
	}

	if (menu_in_game == TRUE)
		my_button("stg_back", [8, -8], [80, 20], "Back") ? current_menu = MENU_INGAME : 0;
	else
		my_button("stg_back", [8, -8], [80, 20], "Back") ? current_menu = MENU_MAIN : 0;


	sui_set_default_kb_focus("volume");
	
	sui_pop_frame();
};

void() help_menu =
{
	vector pos = [0, 0];
	vector size = [360, 280];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "Help", MENU_TEXT_1, 1, 0);
	
	float xpos = 0;
	float ypos = 32;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Bunch of Help and About", MENU_TEXT_1, 1, 0);
	
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_END]);

	if (sui_listen_back())
	{
		if (menu_in_game == TRUE)
			current_menu = MENU_INGAME;
		else
			current_menu = MENU_MAIN;
	}

	if (menu_in_game == TRUE)
		my_button("stg_back", [8, -8], [80, 20], "Back") ? current_menu = MENU_INGAME : 0;
	else
		my_button("stg_back", [8, -8], [80, 20], "Back") ? current_menu = MENU_MAIN : 0;

	sui_pop_frame();	
};

void() main_menu =
{
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 64], MENU_TEXT_LARGE, "vector0", [1, 1, 1], 1, 0);
	
	vector pos = [0, -24];
	vector size = [120, 158];
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	sui_push_frame(pos, size);
	
	//sui_fill([0, 0], size, MENU_BG, 0.3, 0);
	//sui_border_box([0, 0], size, 2, MENU_BORDER, 0.2, 0);

	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);

	float spacing = 24;
	float ypos = 8;
	vector bsize = [size_x - 16, 20];

	if (my_button("mm_start", [0, ypos], bsize, "New Game"))
	{
		menu_in_game = 1;
		current_menu = MENU_INGAME;
		localcmd("map test2\n");
	}
	ypos += spacing;

	if (my_button("mm_loadgame", [0, ypos], bsize, "Load Game"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_savegame", [0, ypos], bsize, "Save Game"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_settings", [0, ypos], bsize, "Settings"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_help", [0, ypos], bsize, "Help"))
		current_menu = MENU_HELP;
	ypos += spacing;

	my_button("mm_quit", [0, ypos], bsize, "Quit") ? localcmd("quit\n") : 0;

	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	sui_pop_frame();	
	sui_set_default_kb_focus("mm_start");
};


void() ingame_menu =
{
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 64], MENU_TEXT_LARGE, "vector0", [1, 1, 1], 1, 0);
	
	vector pos = [0, -24];
	vector size = [120, 158];
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	sui_push_frame(pos, size);
	
	sui_fill([0, 0], size, MENU_BG, 0.3, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.2, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);

	float spacing = 24;
	float ypos = 8;
	vector bsize = [size_x - 16, 20];

	if (my_button("mm_start", [0, ypos], bsize, "Resume Game")) 
		m_toggle(0);
	ypos += spacing;

	if (my_button("mm_loadgame", [0, ypos], bsize, "Load Game"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_savegame", [0, ypos], bsize, "Save Game"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_settings", [0, ypos], bsize, "Settings"))
		current_menu = MENU_SETTINGS;
	ypos += spacing;

	if (my_button("mm_help", [0, ypos], bsize, "Help"))
		current_menu = MENU_HELP;
	ypos += spacing;
	
	my_button("mm_quit", [0, ypos], bsize, "Quit") ? localcmd("quit\n") : 0;

	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	sui_pop_frame();	
	sui_set_default_kb_focus("mm_start");
};


void(vector size) root_menu =
{
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	sui_fill([0, 0], size, '0 0 0', 0.5, 0);
	switch (current_menu)
	{
		case MENU_MAIN: main_menu(); break;
		case MENU_SETTINGS: settings_menu(); break;
		case MENU_HELP: help_menu(); break;
		case MENU_INGAME: ingame_menu(); break;
		default: break;
	}
};