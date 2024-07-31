#include <sourcemod>
#include <sdktools>

// Minimum and maximum jump distance thresholds
const float MIN_JUMP_DISTANCE = 240.0;
const float MAX_JUMP_DISTANCE = 279.9;
//added value of Max LJ.

public void OnPluginStart()
{
	HookEvent("player_jump", OnPlayerJump);
}

public void OnPlayerJump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if (client <= 0 || !IsClientInGame(client))
	{
		return;
	}

	static float sf_LastOrigin[MAXPLAYERS+1][3];
	float f_CurrentOrigin[3];

	// Get player's current position
	GetClientAbsOrigin(client, f_CurrentOrigin);
	
	// Calculate the distance jumped
	float distance = CalculateDistance(sf_LastOrigin[client], f_CurrentOrigin);
	
	// Update last origin for next jump
	sf_LastOrigin[client][0] = f_CurrentOrigin[0];
	sf_LastOrigin[client][1] = f_CurrentOrigin[1];
	sf_LastOrigin[client][2] = f_CurrentOrigin[2];
	
	// Print the jump distance if it falls within the specified range
	if (distance > MIN_JUMP_DISTANCE && distance <= MAX_JUMP_DISTANCE)
	{
		PrintToChat(client, "You jumped %.2f units!", distance);
		PrintToServer("Player %N jumped %.2f units", client, distance);
	}
}

// Function to calculate the distance between two vectors
float CalculateDistance(const float vec1[3], const float vec2[3])
{
	return SquareRoot(Pow(vec2[0] - vec1[0], 2.0) + Pow(vec2[1] - vec1[1], 2.0) + Pow(vec2[2] - vec1[2], 2.0));
}
