class WeaponEntity {
    void WeaponEntity();
    virtual void WeaponThink();
};

.WeaponEntity weapon_ent;

void WeaponEntity::WeaponThink()
{
    makevectors(self.owner.angles);
    vector local_offset = [20, 0, 40];

    self.origin.x = self.owner.origin.x + (v_forward.x * local_offset.x) + (v_right.x * local_offset.y) + (v_up.x * local_offset.z);
    self.origin.y = self.owner.origin.y + (v_forward.y * local_offset.x) + (v_right.y * local_offset.y) + (v_up.y * local_offset.z);
    self.origin.z = self.owner.origin.z + (v_forward.z * local_offset.x) + (v_right.z * local_offset.y) + (v_up.z * local_offset.z);

    self.angles[1] = self.owner.angles[1];
    //self.angles[1] = self.owner.angles[1];

    //printf("weapon origin %f %f %f \n", self.origin.x,  self.origin.y, self.origin.z);
	//printf("player forward %f %f %f \n", v_forward.x,  v_forward.y, v_forward.z);
    
    //self.nextthink = time;
};

void WeaponEntity::WeaponEntity()
{
    
    self.classname = "WeaponEntity";
    self.solid = SOLID_NOT;
	setmodel(self, "models/pump/pump.glb");
    self.scale = 0.5;
    self.movetype = MOVETYPE_NOCLIP;
    self.origin = [0,0,0];
    self.angles = [0,0,0];
    // self.think = self.WeaponThink;
    self.nextthink = time;
    self.drawmask = 1;
    self.predraw = self.WeaponThink;
};

void WeaponEntitySpawn()
{
    self.weapon_ent = spawn(WeaponEntity);
    self.weapon_ent.owner = self;
};