
void func_brush()
{
	if (self.spawnflags & 2)
		self.solid = SOLID_NOT;
	else
		self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
}
