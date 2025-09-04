class CViewModel {
    void CViewModel();
    int current_viewmodel;
    float bob_time;
    vector bob_offset;
    float bob_factor;
    int debug_mode;
    virtual void Animate(float ft);
    virtual void SetFrame(int to);
    virtual void SetModelIndex(int to);
    virtual void ChangeViewModel(int to);
    virtual void UpdateBobbing(entity player, float ft);
};

const float VIEWMODEL_FPS = 24.0;
.CViewModel viewmodel;
sViewModel viewmodels[36];


/*
SetFrame
Changes the current animation that is playing in a model.
It sets the INDEX of the animation.
*/
void CViewModel::SetFrame(int to)
{
    if (current_viewmodel == WEAPON_NONE) return;
    this.frame = to;
    this.frame1time = 0;
};


/*
Called when you want to change the View Model
to one of the VIEWMODEL constants, ie. Pistol, Shotgun etc.
*/
void CViewModel::ChangeViewModel(int to)
{
    if (to == WEAPON_NONE) 
    {
        setmodelindex(viewmodel, WEAPON_NONE);
        this.current_viewmodel = WEAPON_NONE;
        return;
    }

    this.current_viewmodel = to;

    sViewModel *m = &viewmodels[this.current_viewmodel];
    setorigin(this, m.origin);
    this.angles = m.angles;
    setsize(this, m.scale, m.scale);
    this.SetModelIndex(getmodelindex((string)m.model_index));
    this.SetFrame(m.anim_idle);
};

/*
CViewModel
Constructor to initialize the View Model Entity
*/
void CViewModel::CViewModel()
{
    sViewModel *m;    

    // === PISTOL VIEWMODEL ===
    m = &viewmodels[WEAPON_PISTOL];
    m.model_path = "models/arms_newpistol/arms_newpistol.glb";
    m.model_index = (__int32)precache_model(m.model_path);
    m.anim_idle = 0;
    m.anim_shoot = 4;
    m.anim_reload = 3;
    m.anim_idle_length = 20;
    m.anim_shoot_length = 4;
    m.anim_reload_length = 25;
    m.anim_finished = false;
    m.automatic = false;
    m.origin = [72, 29, -93];
    m.angles = [-1, -218, 358];
    m.scale = [1, 1, 1];

    // === PUMP VIEWMODEL ===
    m = &viewmodels[WEAPON_PUMP];
    m.model_path = "models/arms_pump/arms_pump.glb";
    m.model_index = (__int32)precache_model(m.model_path);
    m.anim_idle = 2;
    m.anim_shoot = 5;
    m.anim_reload = 3;
    m.anim_idle_length = 20;
    m.anim_shoot_length = 15;
    m.anim_reload_length = 35;
    m.anim_finished = false;
    m.automatic = true;
    m.origin = [-35, -45, -108];
    m.angles = [-4, -163, 358];
    m.scale = [1, 1, 1];

    // === REVOLVER VIEWMODEL ===
    m = &viewmodels[WEAPON_REVOLVER];
    m.model_path = "models/arms_revolver/arms_revolver.glb";
    m.model_index = (__int32)precache_model(m.model_path);
    m.anim_idle = 1;
    m.anim_shoot = 4;
    m.anim_reload = 2;
    m.anim_idle_length = 20;
    m.anim_shoot_length = 9;
    m.anim_reload_length = 57;
    m.anim_finished = false;
    m.automatic = false;
    m.origin = [-35, -8, -124];
    m.angles = [3, -174, 358];
    m.scale = [1, 1, 1];

    // === SMG VIEWMODEL ===
    m = &viewmodels[WEAPON_SMG];
    m.model_path = "models/arms_smg/arms_smg.glb";
    m.model_index = (__int32)precache_model(m.model_path);
    m.anim_idle = 0;
    m.anim_shoot = 2;
    m.anim_reload = 1;
    m.anim_idle_length = 20;
    m.anim_shoot_length = 5;
    m.anim_reload_length = 40;
    m.anim_finished = false;
    m.automatic = true;
    m.origin = [-35, 0, -105];
    m.angles = [3, -179, 358];
    m.scale = [1, 1, 1];

    // Init Global Viewmodel
    this.classname = "CViewModel";
    this.debug_mode = false;
    this.ChangeViewModel(WEAPON_PISTOL);
    this.drawmask = MASK_VIEWMODEL;
    this.renderflags |= RF_VIEWMODEL | RF_DEPTHHACK;
    this.effects |= EF_NOSHADOW;

    this.SetFrame(m.anim_idle);

};


/*
Animate
Called every game TICK to animate the viewmodels current animation
*/
void CViewModel::Animate(float ft)
{
    if (current_viewmodel == WEAPON_NONE) return;

    sViewModel *m = &viewmodels[this.current_viewmodel];

    int current_anim_length = 0;
    int IDLE   = m.anim_idle;
    int SHOOT  = m.anim_shoot;
    int RELOAD = m.anim_reload;

    switch(this.frame)
    {
        case IDLE:   current_anim_length = m.anim_idle_length;   break;
        case SHOOT:  current_anim_length = m.anim_shoot_length;  break;
        case RELOAD: current_anim_length = m.anim_reload_length; break;
        
        default: current_anim_length = 0; break;
    }

    this.frame1time += ft;

    if (this.frame1time >= current_anim_length / VIEWMODEL_FPS)
    {
        this.SetFrame(m.anim_idle);
        m.anim_finished = TRUE;
        return;
    }

    m.anim_finished = FALSE;
};


/*
SetModelIndex
Change the model based on index, and retrieved with 
getmodelindex on the model filepath
*/
void CViewModel::SetModelIndex(int to)
{
    setmodelindex(this, to);
};

const float VIEWBOB_FREQUENCY = 10.0; // sine speed
const float VIEWBOB_DECAY     = 0.05; // decay when stopping
const float VIEWBOB_RAMP      = 0.05; // ramp-in speed
/*
CViewModel::UpdateBobbing
Smooth forward/back bob with ramp-in
*/
void CViewModel::UpdateBobbing(entity player, float ft)
{   
    if (self.oldvelocity[1] != 0) return;
    float VIEWBOB_AMPLITUDE = cvar("cl_bob") * 10;


    // compute movement delta
    vector delta = player.origin - player.oldorigin;
    float moving = vlen(delta); // distance moved this frame

    // ramp factor for smooth start/stop
    if (moving > 0.05)
        this.bob_factor = min(this.bob_factor + VIEWBOB_RAMP, 1.0);
    else
        this.bob_factor = max(this.bob_factor - VIEWBOB_RAMP, 0.0);

    if (this.bob_factor <= 0.0)
    {
        // fully stopped, decay offset
        this.bob_offset[0] = lerp(this.bob_offset[0], 0, VIEWBOB_DECAY);
    }
    else
    {
        // accumulate bob time based on movement
        float _bob_spd = clampf(moving * 0.005, 0, 0.01);
        this.bob_time += _bob_spd;

        // forward/back sine bob, scaled by ramp factor
        float bobX = sin(this.bob_time * VIEWBOB_FREQUENCY) * VIEWBOB_AMPLITUDE * this.bob_factor;

        this.bob_offset[0] = bobX;
    }

    // apply bob
    this.origin = viewmodels[this.current_viewmodel].origin + this.bob_offset;

    // remember last origin for next frame
   // player.oldorigin = player.origin;
}


/*
SpawnViewModel
Called when a level loads to spawn in the View Model Entity
*/
void SpawnViewModel()
{
	self.viewmodel = spawn(CViewModel);
	self.viewmodel.owner = self;
};

