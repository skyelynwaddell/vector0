//
//	Main.qc - mostly functions that will be called from the engine and are expected to exist
//

void main() {};

// Create Event
void worldspawn()
{	
    precache_everything();
};

// Update Event
void StartFrame()
{
    network_send_clientstats();
};


void SpectatorConnect()
{	
};

