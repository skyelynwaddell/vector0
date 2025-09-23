int sock;
int buffer;
int WS_IsConnected() { return sock >= 0; };

/*
WS_SendMessage
Called to send a message to the websocket server

*/
void WS_SendMessage(string message)
{
    if (WS_IsConnected())
    {
        //Header
        fwrite(sock, message, strlen(message));
    }
};


/*
WS_Connect
Called to connect to the GameLauncher websocket server
*/
int WS_Connect()
{
    sock = fopen("ws://127.0.0.1:2997", -1);
    if (WS_IsConnected() == false)
    {
        print("Failed to connect to WS server.\n");
        return false;
    }
    
    print("Connected to WS server.\n");
    WS_SendMessage("hello world");
    return true;
};


/*
WS_Update
Called every TICK to read incoming
messages from the websocket server
*/
void WS_Update()
{
    if (WS_IsConnected())
    {
        int incoming = fgets(sock);
        if (incoming > 0)
        {
            print("Got from ws: ");
            print(incoming);
            print("\n");
        }
    }
};