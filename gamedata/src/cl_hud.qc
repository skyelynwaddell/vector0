void draw_gui() 
{
    sui_begin(g_width, g_height);

	// string chapter = "CHAPTER 1";
	// string mission_name = "MISSION ESCAPE";
	// vector textsize = '8 8 0'; // character size

	// // --- CHAPTER LINE ---
	// vector chapter_dim = textsize * strlen(chapter);
	// vector chapter_pos;
	// chapter_pos.x = (g_width - chapter_dim.x) * 0.5;
	// chapter_pos.y = (g_height - textsize.y) * 0.5 - 10; // 10px above center
	// sui_text(chapter_pos, textsize, chapter, '1 1 1', 1.0, 0);

	// // --- MISSION NAME LINE ---
	// vector mission_dim = textsize * strlen(mission_name);
	// vector mission_pos;
	// mission_pos.x = (g_width - mission_dim.x) * 0.5;
	// mission_pos.y = (g_height - textsize.y) * 0.5 + 10; // 10px below center
	// sui_text(mission_pos, textsize, mission_name, '1 1 1', 1.0, 0);

	// Convert ammo values to string

	vector textsize = '20 20 0';

	// Health/Armor
	string ha_str = strcat(ftos(health), " | ", ftos(armor));
	float ha_width = stringwidth(ha_str, TRUE, textsize);

	vector pos;
	pos.x = 25; 
	pos.y = g_height - 40;
	pos.z = 0;
	sui_text(pos, textsize, ha_str, '1 1 1', 1.0, 0);

	if (cl_viewmodel != VIEWMODEL_NONE)
	{

	// Health Ammo
	string ammo_str = strcat(ftos(ammo_count), " | ", ftos(total_ammo));
	float ammo_width = stringwidth(ammo_str, TRUE, textsize);

	pos.x = g_width - ammo_width - 25;
	pos.y = g_height - 40;
	pos.z = 0;
	sui_text(pos, textsize, ammo_str, '1 1 1', 1.0, 0);
	}

	if (self.viewmodel.debug_mode == true)
	{
		string origin_str;
		string angles_str;

		origin_str = ftos(self.viewmodel.origin.x);
		origin_str = strcat(origin_str, ", ");
		origin_str = strcat(origin_str, ftos(self.viewmodel.origin.y));
		origin_str = strcat(origin_str, ", ");
		origin_str = strcat(origin_str, ftos(self.viewmodel.origin.z));

		angles_str = ftos(self.viewmodel.angles.x);
		angles_str = strcat(angles_str, ", ");
		angles_str = strcat(angles_str, ftos(self.viewmodel.angles.y));
		angles_str = strcat(angles_str, ", ");
		angles_str = strcat(angles_str, ftos(self.viewmodel.angles.z));

		pos = [10, 10, 0];
		vector size = '10 10 0';

		drawstring(pos, strcat("Origin: ", origin_str), size, '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("Angles: ", angles_str), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("LEFT/RIGHT: Angle X"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("UP/DOWN: Angle Y"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("DEL/END: Angle Z"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("PGDN/PGUP: Origin X"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("MWHEELDOWN/SPACE: Origin Y"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
		sui_text(pos, size, strcat("ENTER/BACKSPACE: Origin Z"), '1 1 1', 1.0, 0);
		pos.y += size.y + 2;
	}

	sui_end();
};

			// case K_LEFTARROW:
			// 	self.viewmodel.angles[0] -= 1;
			// break;
			// case K_RIGHTARROW:
			// 	self.viewmodel.angles[0] += 1;
			// break;
			// case K_UPARROW:
			// 	self.viewmodel.angles[1] -= 1;
			// break;
			// case K_DOWNARROW:
			// 	self.viewmodel.angles[1] += 1;
			// break;
			// case K_DEL:
			// 	self.viewmodel.angles[2] -= 1;
			// break;
			// case K_END:
			// 	self.viewmodel.angles[2] += 1;
			// break;
			// case K_MWHEELDOWN:
			// 	self.viewmodel.origin[2] -= 1;
			// break;
			// case K_SPACE:
			// 	self.viewmodel.origin[2] += 1;
			// break;
			// case K_PGDN:
			// 	self.viewmodel.origin[0] -= 1;
			// break;
			// case K_PGUP:
			// 	self.viewmodel.origin[0] += 1;
			// break;
			// case K_ENTER:
			// 	self.viewmodel.origin[1] -= 1;
			// break;
			// case K_BACKSPACE:
			// 	self.viewmodel.origin[1] += 1;
			// break;
