
/*
CPlayerSpawn
Called on the client side when the player spawns, inits the viewmodel and sets up the custom skin for the pistol arms.
*/
void CPlayerSpawn() { 
	SpawnViewModel(); 
};


/*
HandleMovement
Detects inputs from control keys and updates
the players location and moves them.
*/
void HandleInputs(float ft)
{
	input_movevalues_x = bound(-350, input_movevalues_x, 350);
	input_movevalues_y = bound(-350, input_movevalues_y, 350);
	input_movevalues_z = bound(-350, input_movevalues_z, 350);
};

/*
CSQC_Input_Frame
Called every game TICK and gets the current INPUTs being pressed
*/
void CSQC_Input_Frame()
{
	float ft = frametime;
	HandleInputs(ft);
	previous_buttons = input_buttons;
};
