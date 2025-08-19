class WeaponEntity {
    void WeaponEntity();
    int type;
    virtual void ChangeWeapon(int to);
    virtual float WeaponPredraw();
};

.WeaponEntity weapon_ent;
string hand_bone = "weapon_bone"; // attach weapons to this bone name

// Change weapon by WEAPON_TYPE
void WeaponEntity::ChangeWeapon(int to_type)
{
    self.type = to_type;
    switch(self.type){
        default:
        case WEAPON_NONE:       setmodel(self,0);                           break;
        case WEAPON_PISTOL:     setmodel(self, "models/9mm/9mm.glb");       break;
        case WEAPON_PUMP:       setmodel(self, "models/pump/pump.glb");     break;
        case WEAPON_REVOLVER:   setmodel(self, "models/magnum/magnum.glb"); break;
        case WEAPON_SMG:        setmodel(self, "models/smg/smg.glb");       break;
    }
};

float WeaponEntity::WeaponPredraw()
{
    // attach weapon to the hand bone
    float bone_index = gettagindex(self.owner, hand_bone);
    vector tagorigin = gettaginfo(self.owner, bone_index);

    self.origin[0] = tagorigin[0];
    self.origin[1] = tagorigin[1];
    self.origin[2] = tagorigin[2];

    self.angles[0] = self.owner.oldangles[0];
    self.angles[1] = self.owner.oldangles[1];
    self.angles[2] = self.owner.oldangles[2];

    return true;
};

void WeaponEntity::WeaponEntity()
{
    self.classname = "WeaponEntity";
	self.ChangeWeapon(WEAPON_PISTOL);
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NOCLIP;
    self.drawmask = 1;
    self.predraw = self.WeaponPredraw;
};

void WeaponEntitySpawn()
{
    self.weapon_ent = spawn(WeaponEntity);
    self.weapon_ent.owner = self;
    setattachment(self.weapon_ent, self, hand_bone);
};