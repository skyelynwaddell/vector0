class CViewModel {
    void() CViewModel;
    virtual void(float ft) Animate;
    virtual void(int to) SetFrame;
    virtual void(int to) SetModelIndex;
};

enum VIEWMODEL_ANIMS
{
	PISTOL_IDLE = 0,
	PISTOL_SHOOT = 3,
	PISTOL_RELOAD = 1
};

CViewModel viewmodel;
float anim_finished;
float viewmodel_anim_lengths[16];
float VIEWMODEL_FPS = 24.0;

void CViewModel::CViewModel()
{
    this.drawmask = MASK_VIEWMODEL;
    this.renderflags |= RF_VIEWMODEL | RF_DEPTHHACK;
    this.effects |= EF_NOSHADOW;
    this.angles = [0, 0, 0];
    setorigin(this, [0, 0, 0]);
    setsize(this, [0, 0, 0], [0, 0, 0]);

    viewmodel_anim_lengths[PISTOL_IDLE] = 20 / VIEWMODEL_FPS;
    viewmodel_anim_lengths[PISTOL_SHOOT] = 4 / VIEWMODEL_FPS;;
    viewmodel_anim_lengths[PISTOL_RELOAD] = 25 / VIEWMODEL_FPS;
}

void CViewModel::Animate(float ft)
{
    this.frame1time += ft;
    if (this.frame1time >= viewmodel_anim_lengths[this.frame])
    {
        this.SetFrame(0); // Reset to idle after animation
        anim_finished = TRUE;
    }
    else
    {
        anim_finished = FALSE;
    }
}

void CViewModel::SetFrame(int to)
{
    this.frame = to;
    this.frame1time = 0;
}

void CViewModel::SetModelIndex(int to)
{
    setmodelindex(this, to);
}