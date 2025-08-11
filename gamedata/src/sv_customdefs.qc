// put custom server-only globals and fields here

const float FL_JUMPRELEASED = 4096;

void sub_remove()
{
	remove(self);
};

void sub_noop() {};

void BeginEvent(float event)
{
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, event);
};

void MulticastVector(vector vec)
{
	WriteCoord(MSG_MULTICAST, vec_x);
	WriteCoord(MSG_MULTICAST, vec_y);
	WriteCoord(MSG_MULTICAST, vec_z);
};

void MulticastByte(float val)
{
	WriteByte(MSG_MULTICAST, val);
};

void MulticastShort(float val)
{
	WriteShort(MSG_MULTICAST, val);
};

void MulticastFloat(float val)
{
	WriteFloat(MSG_MULTICAST, val);
};

void MulticastEnt(entity e)
{
	WriteEntity(MSG_MULTICAST, e);
};

void MulticastString(string s)
{
	WriteString(MSG_MULTICAST, s);
};

void light()
{
	remove(self);
};

entity player_chain_head;
.entity player_chain_next;
.entity player_chain_prev;

// Put an entity as the first of the linked list
void player_chain_add(entity adding)
{
	if (adding.player_chain_prev || adding.player_chain_next || (adding == player_chain_head && !adding.player_chain_next)) 
	{
		print("Trying to adding an entity into player chain while it already is in chain!\n");
		return;
	}
	if (player_chain_head) player_chain_head.player_chain_prev = adding;
	adding.player_chain_next = player_chain_head;
	player_chain_head = adding;
};

// Remove entity from linked list
void player_chain_remove(entity removing)
{
	if (removing == player_chain_head)
	{
		player_chain_head = removing.player_chain_next;
	}
	
	if (removing.player_chain_next) removing.player_chain_next.player_chain_prev = removing.player_chain_prev;
	if (removing.player_chain_prev) removing.player_chain_prev.player_chain_next = removing.player_chain_next;
	removing.player_chain_next = world;
	removing.player_chain_prev = world;
};

