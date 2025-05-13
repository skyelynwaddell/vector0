
void CSQC_RendererRestarted(string rendererdescription)
{

}

void CSQC_Init(float apilevel, string enginename, float engineversion)
{

}

void CSQC_Shutdown()
{

}

void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	clearscene();

	setproperty(VF_DRAWENGINESBAR, FALSE);
	setproperty(VF_DRAWCROSSHAIR, FALSE);
	setproperty(VF_DRAWWORLD, TRUE);

	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	renderscene();
}

float CSQC_ConsoleCommand(string cmd)
{
	int argc = tokenize(cmd);

	switch (argv(0))
	{
		default:
		{
			return FALSE;
		}
	}
}

void CSQC_Input_Frame()
{

}

void CSQC_Parse_Event()
{

}
