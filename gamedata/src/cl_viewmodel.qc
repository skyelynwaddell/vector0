/*
VIEWMODEL
Holds all the types of View Models in the game
*/

class CViewModel {
    void CViewModel();
    int current_viewmodel;
    virtual void Animate(float ft);
    virtual void SetFrame(int to);
    virtual void SetModelIndex(int to);
    virtual void ChangeViewModel(int to);
};

const float VIEWMODEL_FPS = 24.0;
.CViewModel viewmodel;
sViewModel viewmodels[36];

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

    this.SetModelIndex(getmodelindex(m.model_index));
    this.SetFrame(m.anim_idle);

    this.forceshader = shaderforname(
        strcat("custommaterials/", m.material_name),
        sprintf(
            "{\nprogram defaultskin\n{\nmap textures/%s\n}\n}\n",
            m.texture
        )
    );

	// replace the default skins with our custom one
    for (int i = 0; i < MAX_SKINS; i++)
    {
        if (m.skins[i] == __NULL__) break; // we reached the end of the skins array

        string full_material = strcat("custommaterials/", m.material_name);
        string replace_cmd = strcat("replace \"", m.skins[i], "\" \"", full_material, "\"\n");
        setcustomskin(viewmodel, __NULL__, replace_cmd);
    }
};


/*
CViewModel
Constructor to initialize a View Model Entity
*/
void CViewModel::CViewModel()
{
    sViewModel *m;    

    // === PISTOL VIEWMODEL ===
    m = &viewmodels[WEAPON_PISTOL];
    m.model_path = "models/arms_newpistol/arms_newpistol_baked.glb";
    m.model_index = precache_model(m.model_path);
    m.anim_idle = 0;
    m.anim_shoot = 3;
    m.anim_reload = 1;
    m.anim_idle_length = 20;
    m.anim_shoot_length = 4;
    m.anim_reload_length = 25;
    m.anim_finished = false;
    m.automatic = false;
    m.origin = [71, 56, -101];
    m.angles = [-1, -222, 358];
    m.scale = [1, 1, 1];
    m.material_name = "pistol_arms";
    m.texture = "pistol_baked.png";
    m.skins[0] = "Arms";
    m.skins[1] = "Magazine";
    m.skins[2] = "Pistol";

    // Init Global Viewmodel
    this.ChangeViewModel(WEAPON_PISTOL);
    this.drawmask = MASK_VIEWMODEL;
    this.renderflags |= RF_VIEWMODEL | RF_DEPTHHACK;
    this.effects |= EF_NOSHADOW;

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
    int IDLE = m.anim_idle;
    int SHOOT = m.anim_shoot;
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
SetModelIndex
Change the model based on index, and retrieved with 
getmodelindex on the model filepath
*/
void CViewModel::SetModelIndex(int to)
{
    setmodelindex(this, to);
};


/*
SpawnViewModel
Called when a level loads to spawn in the View Model Entity
*/
void SpawnViewModel()
{
	self.viewmodel = spawn(CViewModel);
	self.viewmodel.owner = self;
};