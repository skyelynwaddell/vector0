void() CPlayerSpawn =
{
	string weaponmodel = precache_model("models/arms_newpistol/arms_newpistol_baked.glb");
	viewmodel = spawn(CViewModel);
	viewmodel.owner = self;

	viewmodel.angles = [-1, -222, 358];
	viewmodel.origin = [71, 56, -101];
	viewmodel.SetModelIndex(getmodelindex(weaponmodel));
    viewmodel.SetFrame(PISTOL_IDLE);

	viewmodel.forceshader = shaderforname(
		"custommaterials/pistol_arms",
		"{\n"
			"program defaultskin\n"
			"{\n"
				"map textures/pistol_baked.png\n"
			"}\n"
		"}\n"
	);

	setcustomskin(viewmodel, __NULL__, "replace \"Arms\" \"custommaterials/pistol_arms\"\n");
	setcustomskin(viewmodel, __NULL__, "replace \"Magazine\" \"custommaterials/pistol_arms\"\n");
	setcustomskin(viewmodel, __NULL__, "replace \"Pistol\" \"custommaterials/pistol_arms\"\n");
}

void() CSQC_Input_Frame =
{
	input_movevalues_x = bound(-350, input_movevalues_x, 350);
	input_movevalues_y = bound(-350, input_movevalues_y, 350);
	input_movevalues_z = bound(-350, input_movevalues_z, 350);

	if (input_buttons & 1)
    {
        viewmodel.SetFrame(PISTOL_SHOOT);
    }
};