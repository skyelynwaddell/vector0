/*
frametimereset
Resets all the animations to the start
*/
void frametimereset() {
	self.bodyframe1time = 0;
	self.legsframe1time = 0;
};



/*
PlayerChangeLegState
Change the LEGS animation state by PLAYER_LEG_STATE
*/
void PlayerChangeLegState(int to)
{
	if (self.model_leg_state != to) {
        frametimereset();
        self.leg_anim_time_since_change = 0;
        self.model_leg_state = to;
    }
};


/*
PlayerChangeBodyState
Change the TORSO/BODY animation state by PLAYER_BODY_STATE
*/
void PlayerChangeBodyState(int to)
{
	if (self.model_body_state != to)
	{
		self.anim_finished = false;
		frametimereset();
		self.body_anim_time_since_change = 0;
		self.model_body_state = to;
	}
};

void PlayerChangeAnim(int to)
{
	self.body_anim = to;

	int type = self.weapon_ent.type;
	switch(to)
	{
		case PLAYER_TOP_ANIM_IDLE:
			self.anim_time = 20;

			if (type == WEAPON_PISTOL) PlayerChangeBodyState(PLAYER_BODY_STATE_IDLE_PISTOL);
			if (type == WEAPON_REVOLVER)  PlayerChangeBodyState(PLAYER_BODY_STATE_IDLE_PISTOL);
			if (type == WEAPON_SMG)  PlayerChangeBodyState(PLAYER_BODY_STATE_IDLE_RIFLE);
			if (type == WEAPON_PUMP)  PlayerChangeBodyState(PLAYER_BODY_STATE_IDLE_RIFLE);
		break;
		case PLAYER_TOP_ANIM_SHOOT:
			self.anim_time = 5;

			if (type == WEAPON_PISTOL) PlayerChangeBodyState(PLAYER_BODY_STATE_SHOOT_PISTOL);
			if (type == WEAPON_REVOLVER) PlayerChangeBodyState(PLAYER_BODY_STATE_SHOOT_PISTOL);
			if (type == WEAPON_SMG)  PlayerChangeBodyState(PLAYER_BODY_STATE_SHOOT_RIFLE);
			if (type == WEAPON_PUMP)  PlayerChangeBodyState(PLAYER_BODY_STATE_SHOOT_RIFLE);
		break;
		case PLAYER_TOP_ANIM_RELOAD:
			if (type == WEAPON_PISTOL) { self.anim_time = 25; PlayerChangeBodyState(PLAYER_BODY_STATE_RELOAD_PISTOL); }
			if (type == WEAPON_REVOLVER) { self.anim_time = 25; PlayerChangeBodyState(PLAYER_BODY_STATE_RELOAD_PISTOL); }
			if (type == WEAPON_SMG) { self.anim_time = 35; PlayerChangeBodyState(PLAYER_BODY_STATE_RELOAD_RIFLE); }
			if (type == WEAPON_PUMP) { self.anim_time = 35; PlayerChangeBodyState(PLAYER_BODY_STATE_RELOAD_RIFLE); }
		break;
	}
}


void PlayerAnimPlayer()
{
	if (self.anim_finished == true) return;

	self.body_anim_time_since_change += frametime;
	if (self.body_anim_time_since_change >= self.anim_time / VIEWMODEL_FPS)
	{
		self.body_anim_time_since_change = 0;
		self.anim_finished = true;
		PlayerChangeAnim(PLAYER_TOP_ANIM_IDLE);
	}
};



/*
CPlayerSpawn
Called on the client side when the player spawns, inits the viewmodel and sets up the custom skin for the pistol arms.
*/
void CPlayerSpawn() { 
	SpawnViewModel(); 
	self.model_leg_state = PLAYER_LEG_STATE_IDLE;
	PlayerChangeAnim(PLAYER_TOP_ANIM_IDLE);
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


/*
PlayerStateMachine
Handles the anim states of the player and other network players
*/
void PlayerStateMachine()
{
	addentity(self); // Add player model (only call for enemies [not me])

	// Player skely stuffs :0
	float head = skel_find_bone(self.skeletonindex, "head");
	float hips = skel_find_bone(self.skeletonindex, "hips");
	float hand = skel_find_bone(self.skeletonindex, "hand.R.002");
	float stomach = skel_find_bone(self.skeletonindex, "stomach");
	float foot = skel_find_bone(self.skeletonindex, "foot.R");

	// retain/add frac (anim blends)
	float crossfade_duration = 0.5; // seconds
	self.leg_anim_time_since_change += frametime;
	float t = clampf(self.leg_anim_time_since_change / crossfade_duration, 0, 1);
	float retainfrac = 1.0 - t; // fade out old animation
	float addfrac    = t;       // fade in new animation

	// Create skele if non existant
	if (!self.skeletonindex) self.skeletonindex = skel_create(self.modelindex);

	//Clear skeleton first
	skel_build(self.skeletonindex, self, self.modelindex, 0, 0, 0, 1);

	// Calculate the velocity vector (in units per second)
	const int MOVE_SPD = 320;
	const float min_move_spd = 0.2;
	float move_delta = VectorLength(self.origin - self.oldorigin) / frametime;
	float current_speed = clampf(move_delta / MOVE_SPD, 0, 1.0);
	float move_spd = current_speed >= min_move_spd ? frametime : 0;

	// ---------------------------------------
	// --- Lower body ---
	self.frame1time = self.legsframe1time;
	switch(self.model_leg_state)
	{
		// IDLE
		case PLAYER_LEG_STATE_IDLE:
			if (current_speed > min_move_spd) 
				PlayerChangeLegState(PLAYER_LEG_STATE_RUN);

			self.frame = PLAYER_ANIM_IDLE;
			self.frame1time += frametime;
		break;

		// RUN
		case PLAYER_LEG_STATE_RUN:
			if (current_speed <= min_move_spd) 
				PlayerChangeLegState(PLAYER_LEG_STATE_IDLE);
			
			self.frame = PLAYER_ANIM_RUN;
			self.frame1time += move_spd;
		break;
	}
	self.legsframe1time = self.frame1time;
	skel_build(self.skeletonindex, self, self.modelindex, retainfrac, hips, 0, addfrac);
	// ---------------------------------------

	// ---------------------------------------
	// --- Upper body ---
	self.frame1time = self.bodyframe1time;
	switch(self.model_body_state)
	{
		// PISTOL IDLE
		case PLAYER_BODY_STATE_IDLE_PISTOL:
			self.frame = PLAYER_ANIM_PISTOL;
		break;

		// PISTOL SHOOT
		case PLAYER_BODY_STATE_SHOOT_PISTOL:
			self.frame = PLAYER_ANIM_PISTOL_SHOOT;
		break;

		// PISTOL RELOAD
		case PLAYER_BODY_STATE_RELOAD_PISTOL:
			self.frame = PLAYER_ANIM_PISTOL_RELOAD;
		break;

		// RIFLE IDLE
		case PLAYER_BODY_STATE_IDLE_RIFLE:
			self.frame = PLAYER_ANIM_RIFLE;
		break;

		// RIFLE SHOOT
		case PLAYER_BODY_STATE_SHOOT_RIFLE:
			self.frame = PLAYER_ANIM_RIFLE_SHOOT;
		break;

		// RIFLE RELOAD
		case PLAYER_BODY_STATE_RELOAD_RIFLE:
			self.frame = PLAYER_ANIM_RIFLE_RELOAD;
		break;

	}
	self.frame1time += frametime;
	self.bodyframe1time = self.frame1time;
	skel_build(self.skeletonindex, self, self.modelindex, 0, stomach, hand, 1.0);
	// ---------------------------------------


	// ---------------------------------------
	// --- Rotate Hips ---
	makevectors([self.oldangles.y, 0, 0]);
	skel_premul_bone(self.skeletonindex, hips, [0,0,0], v_forward, v_right, v_up);

	// --- Rotate Stomach/Torso ---
	makevectors([0, 0, -self.oldangles.x]);
	skel_premul_bone(self.skeletonindex, stomach, [0,0,0], v_forward, v_right, v_up);
	// ---------------------------------------

	PlayerAnimPlayer();
};