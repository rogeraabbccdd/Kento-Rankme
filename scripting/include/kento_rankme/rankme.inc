
#if defined _rankme_included
  #endinput
#endif
#define _rankme_included
enum WEAPONS_ENUM{
	KNIFE,
	GLOCK,
	USP,
	P228,
	DEAGLE,
	ELITE,
	FIVESEVEN,
	M3,
	XM1014,
	MAC10,
	TMP,
	MP5NAVY,
	UMP45,
	P90,
	GALIL,
	AK47,
	SG550,
	FAMAS,
	M4A1,
	AUG,
	SCOUT,
	SG552,
	AWP,
	G3SG1,
	M249,
	HEGRENADE,
	FLASHBANG,
	SMOKEGRENADE
}
enum STATS_NAMES{
	SCORE,
	KILLS,
	DEATHS,
	SUICIDES,
	TK,
	SHOTS,
	HITS,
	HEADSHOTS,
	CONNECTED,
	ROUNDS_TR,
	ROUNDS_CT,
	C4_PLANTED,
	C4_EXPLODED,
	C4_DEFUSED,
	CT_WIN,
	TR_WIN,
	HOSTAGES_RESCUED,
	VIP_KILLED,
	VIP_ESCAPED,
	VIP_PLAYED
}

enum HITBOXES{
	NULL_HITBOX,
	HEAD,
	CHEST,
	STOMACH,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}


public SharedPlugin __pl_rankme= 
{
	name = "rankme",
	file = "rankme.smx",
	#if defined REQUIRE_PLUGIN
	required = 1
	#else
	required = 0
	#endif
};

typedef RankCallback = function void(int client, int rank, any data);

#if !defined REQUIRE_PLUGIN
public void __pl_rankme_SetNTVOptional()
{
	MarkNativeAsOptional("RankMe_GivePoint");
	MarkNativeAsOptional("RankMe_GetRank");
	MarkNativeAsOptional("RankMe_GetPoints");
	MarkNativeAsOptional("RankMe_GetStats");
	MarkNativeAsOptional("RankMe_GetSession");
	MarkNativeAsOptional("RankMe_GetWeaponStats");
	MarkNativeAsOptional("RankMe_GetHitbox");
}
#endif

/*********************************************************
 * Give point(s) to a player on the server
 *
 * @param client	The client index of the player to receive the points
 * @param points		Points to be given to the player
 * @param reason	The reason to be given the points
 * @param printtoplayer	Print the change to the player
 * @param printtoall	Print the change to the everyone
 * @noreturn		
 *********************************************************/
native void RankMe_GivePoint(int client, int points, char[] reason, int printtoplayer, int printtoall);

/*********************************************************
 * Get rank of a player on the server
 *
 * @param client	The client index of the player to get the rank
 * @param callback	The return Callback
 * @param data	Any data you would like that return on the callback
 * @noreturn		
 *********************************************************/
native void RankMe_GetRank(int client, RankCallback callback, any data = 0);

/*********************************************************
 * Get the score (points) of a player on the server
 *
 * @param client	The client index of the player to get the rank
 * @param data	Any data you would like that return on the callback
 * @return		The score of the client
 *********************************************************/
native int RankMe_GetPoints(int client);

/*********************************************************
 * Get stats of a player on the server
 *
 * @param client	The client index of the player to get the stats
 * @param stats_return	The array that will return the data following the ENUM STATS_NAME;
 * @noreturn		
 *********************************************************/
native void RankMe_GetStats(int client, int[] stats_return);

/*********************************************************
 * Get session of a player on the server
 *
 * @param client	The client index of the player to get the session
 * @param session_return	The array that will return the data following the ENUM STATS_NAME;
 * @noreturn		
 *********************************************************/
native void RankMe_GetSession(int client,int[] session_return);

/*********************************************************
 * Get weapon stats of a player on the server
 *
 * @param client	The client index of the player to get the session
 * @param session_return	The array that will return the data following the ENUM WEAPONS_ENUM;
 * @noreturn		
 *********************************************************/
native void RankMe_GetWeaponStats(int client, int[] weapons_return);

/*********************************************************
 * Get hitbox stats of a player on the server
 *
 * @param client	The client index of the player to get the session
 * @param session_return	The array that will return the data following the ENUM HITBOXES;
 * @noreturn		
 *********************************************************/
native void RankMe_GetHitbox(int client, int[] hitbox_return);

/**********************************************************************
 * When a player has been loaded
 * *
 * @param         client        The client index of the player that has been loaded
 * @noreturn
 **********************************************************************/
forward Action RankMe_OnPlayerLoaded(int client);

/**********************************************************************
 * When a player has been saved
 * *
 * @param         client        The client index of the player that has been saved
 * @noreturn
 **********************************************************************/
forward Action RankMe_OnPlayerSaved(int client);
