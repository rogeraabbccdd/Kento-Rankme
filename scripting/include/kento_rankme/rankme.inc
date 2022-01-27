#if defined _rankme_included
  #endinput
#endif
#define _rankme_included

enum struct WEAPONS_ENUM{
	int KNIFE;
	int GLOCK;
	int HKP2000;
	int USP_SILENCER;
	int P250;
	int DEAGLE;
	int ELITE;
	int FIVESEVEN;
	int TEC9;
	int CZ75A;
	int REVOLVER;
	int NOVA;
	int XM1014;
	int MAG7;
	int SAWEDOFF;
	int BIZON;
	int MAC10;
	int MP9;
	int MP7;
	int UMP45;
	int P90;
	int GALILAR;
	int AK47;
	int SCAR20;
	int FAMAS;
	int M4A1;
	int M4A1_SILENCER;
	int AUG;
	int SSG08;
	int SG556;
	int AWP;
	int G3SG1;
	int M249;
	int NEGEV;
	int HEGRENADE;
	int FLASHBANG;
	int SMOKEGRENADE;
	int INFERNO;
	int DECOY;
	int TASER;
	int MP5SD;
	int BREACHCHARGE;
	int GetData(int[] data) {
		data[0] = this.KNIFE;
		data[1] = this.GLOCK;
		data[2] = this.HKP2000;
		data[3] = this.USP_SILENCER;
		data[4] = this.P250;
		data[5] = this.DEAGLE;
		data[6] = this.ELITE;
		data[7] = this.FIVESEVEN;
		data[8] = this.TEC9;
		data[9] = this.CZ75A;
		data[10] = this.REVOLVER;
		data[11] = this.NOVA;
		data[12] = this.XM1014;
		data[13] = this.MAG7;
		data[14] = this.SAWEDOFF;
		data[15] = this.BIZON;
		data[16] = this.MAC10;
		data[17] = this.MP9;
		data[18] = this.MP7;
		data[19] = this.UMP45;
		data[20] = this.P90;
		data[21] = this.GALILAR;
		data[22] = this.AK47;
		data[23] = this.SCAR20;
		data[24] = this.FAMAS;
		data[25] = this.M4A1;
		data[26] = this.M4A1_SILENCER;
		data[27] = this.AUG;
		data[28] = this.SSG08;
		data[29] = this.SG556;
		data[30] = this.AWP;
		data[31] = this.G3SG1;
		data[32] = this.M249;
		data[33] = this.NEGEV;
		data[34] = this.HEGRENADE;
		data[35] = this.FLASHBANG;
		data[36] = this.SMOKEGRENADE;
		data[37] = this.INFERNO;
		data[38] = this.DECOY;
		data[39] = this.TASER;
		data[40] = this.MP5SD;
		data[41] = this.BREACHCHARGE;
	}
	void Reset() {
		this.KNIFE = 0;
		this.GLOCK = 0;
		this.HKP2000 = 0;
		this.USP_SILENCER = 0;
		this.P250 = 0;
		this.DEAGLE = 0;
		this.ELITE = 0;
		this.FIVESEVEN = 0;
		this.TEC9 = 0;
		this.CZ75A = 0;
		this.REVOLVER = 0;
		this.NOVA = 0;
		this.XM1014 = 0;
		this.MAG7 = 0;
		this.SAWEDOFF = 0;
		this.BIZON = 0;
		this.MAC10 = 0;
		this.MP9 = 0;
		this.MP7 = 0;
		this.UMP45 = 0;
		this.P90 = 0;
		this.GALILAR = 0;
		this.AK47 = 0;
		this.SCAR20 = 0;
		this.FAMAS = 0;
		this.M4A1 = 0;
		this.M4A1_SILENCER = 0;
		this.AUG = 0;
		this.SSG08 = 0;
		this.SG556 = 0;
		this.AWP = 0;
		this.G3SG1 = 0;
		this.M249 = 0;
		this.NEGEV = 0;
		this.HEGRENADE = 0;
		this.FLASHBANG = 0;
		this.SMOKEGRENADE = 0;
		this.INFERNO = 0;
		this.DECOY = 0;
		this.TASER = 0;
		this.MP5SD = 0;
		this.BREACHCHARGE = 0;
	}
	void AddKill(int num) {
		switch(num) {
			case 0: {
				this.KNIFE++;
			}
			case 1: {
				this.GLOCK++;
			}
			case 2: {
				this.HKP2000++;
			}
			case 3: {
				this.USP_SILENCER++;
			}
			case 4: {
				this.P250++;
			}
			case 5: {
				this.DEAGLE++;
			}
			case 6: {
				this.ELITE++;
			}
			case 7: {
				this.FIVESEVEN++;
			}
			case 8: {
				this.TEC9++;
			}
			case 9: {
				this.CZ75A++;
			}
			case 10: {
				this.REVOLVER++;
			}
			case 11: {
				this.NOVA++;
			}
			case 12: {
				this.XM1014++;
			}
			case 13: {
				this.MAG7++;
			}
			case 14: {
				this.SAWEDOFF++;
			}
			case 15: {
				this.BIZON++;
			}
			case 16: {
				this.MAC10++;
			}
			case 17: {
				this.MP9++;
			}
			case 18: {
				this.MP7++;
			}
			case 19: {
				this.UMP45++;
			}
			case 20: {
				this.P90++;
			}
			case 21: {
				this.GALILAR++;
			}
			case 22: {
				this.AK47++;
			}
			case 23: {
				this.SCAR20++;
			}
			case 24: {
				this.FAMAS++;
			}
			case 25: {
				this.M4A1++;
			}
			case 26: {
				this.M4A1_SILENCER++;
			}
			case 27: {
				this.AUG++;
			}
			case 28: {
				this.SSG08++;
			}
			case 29: {
				this.SG556++;
			}
			case 30: {
				this.AWP++;
			}
			case 31: {
				this.G3SG1++;
			}
			case 32: {
				this.M249++;
			}
			case 33: {
				this.NEGEV++;
			}
			case 34: {
				this.HEGRENADE++;
			}
			case 35: {
				this.FLASHBANG++;
			}
			case 36: {
				this.SMOKEGRENADE++;
			}
			case 37: {
				this.INFERNO++;
			}
			case 38: {
				this.DECOY++;
			}
			case 39: {
				this.TASER++;
			}
			case 40: {
				this.MP5SD++;
			}
			case 41: {
				this.BREACHCHARGE++;
			}
		}
	}
} 

enum struct STATS_NAMES{
	int SCORE;
	int KILLS;
	int DEATHS;
	int ASSISTS;
	int SUICIDES;
	int TK;
	int SHOTS;
	int HITS;
	int HEADSHOTS;
	int CONNECTED;
	int ROUNDS_TR;
	int ROUNDS_CT;
	int C4_PLANTED;
	int C4_EXPLODED;
	int C4_DEFUSED;
	int CT_WIN;
	int TR_WIN;
	int HOSTAGES_RESCUED;
	int VIP_KILLED;
	int VIP_ESCAPED;
	int VIP_PLAYED;
	int MVP;
	int DAMAGE;
	int MATCH_WIN;
	int MATCH_DRAW;
	int MATCH_LOSE;
	int FB;
	int NS;
	int NSD;
	int SMOKE;
	int BLIND;
	int AF;
	int ATF;
	int ATK;
	int WALL;
	void GetData(int[] data) {
		data[0] = this.SCORE;
		data[1] = this.KILLS;
		data[2] = this.DEATHS;
		data[3] = this.ASSISTS;
		data[4] = this.SUICIDES;
		data[5] = this.TK;
		data[6] = this.SHOTS;
		data[7] = this.HITS;
		data[8] = this.HEADSHOTS;
		data[9] = this.CONNECTED;
		data[10] = this.ROUNDS_TR;
		data[11] = this.ROUNDS_CT;
		data[12] = this.C4_PLANTED;
		data[13] = this.C4_EXPLODED;
		data[14] = this.C4_DEFUSED;
		data[15] = this.CT_WIN;
		data[16] = this.TR_WIN;
		data[17] = this.HOSTAGES_RESCUED;
		data[18] = this.VIP_KILLED;
		data[19] = this.VIP_ESCAPED;
		data[20] = this.VIP_PLAYED;
		data[21] = this.MVP;
		data[22] = this.DAMAGE;
		data[23] = this.MATCH_WIN;
		data[24] = this.MATCH_DRAW;
		data[25] = this.MATCH_LOSE;
		data[26] = this.FB;
		data[27] = this.NS;
		data[28] = this.NSD;
		data[29] = this.SMOKE;
		data[30] = this.BLIND;
		data[31] = this.AF;
		data[32] = this.ATF;
		data[33] = this.ATK;
		data[34] = this.WALL;
	}
	void Reset() {
		this.SCORE = 0;
		this.KILLS = 0;
		this.DEATHS = 0;
		this.ASSISTS = 0;
		this.SUICIDES = 0;
		this.TK = 0;
		this.SHOTS = 0;
		this.HITS = 0;
		this.HEADSHOTS = 0;
		this.CONNECTED = 0;
		this.ROUNDS_TR = 0;
		this.ROUNDS_CT = 0;
		this.C4_PLANTED = 0;
		this.C4_EXPLODED = 0;
		this.C4_DEFUSED = 0;
		this.CT_WIN = 0;
		this.TR_WIN = 0;
		this.HOSTAGES_RESCUED = 0;
		this.VIP_KILLED = 0;
		this.VIP_ESCAPED = 0;
		this.VIP_PLAYED = 0;
		this.MVP = 0;
		this.DAMAGE = 0;
		this.MATCH_WIN = 0;
		this.MATCH_DRAW = 0;
		this.MATCH_LOSE = 0;
		this.FB = 0;
		this.NS = 0;
		this.NSD = 0;
		this.SMOKE = 0;
		this.BLIND = 0;
		this.AF = 0;
		this.ATF = 0;
		this.ATK = 0;
		this.WALL = 0;
	}
}

enum struct HITBOXES{
	int NULL_HITBOX;
	int HEAD;
	int CHEST;
	int STOMACH;
	int LEFT_ARM;
	int RIGHT_ARM;
	int LEFT_LEG;
	int RIGHT_LEG;
	int Sum() {
		return this.HEAD + this.CHEST + this.STOMACH + this.LEFT_ARM + this.RIGHT_ARM + this.LEFT_LEG + this.RIGHT_LEG;
	}
	int GetData(int[] data) {
		data[0] = this.NULL_HITBOX;
		data[1] = this.HEAD;
		data[2] = this.CHEST;
		data[3] = this.STOMACH;
		data[4] = this.LEFT_ARM;
		data[5] = this.RIGHT_ARM;
		data[6] = this.LEFT_LEG;
		data[7] = this.RIGHT_LEG;
	}
	void Reset() {
		this.NULL_HITBOX = 0;
		this.HEAD = 0;
		this.CHEST = 0;
		this.STOMACH = 0;
		this.LEFT_ARM = 0;
		this.RIGHT_ARM = 0;
		this.LEFT_LEG = 0;
		this.RIGHT_LEG = 0;
	}
}


public SharedPlugin __pl_rankme= 
{
	name = "rankme",
	file = "kento_rankme.smx",
	#if defined REQUIRE_PLUGIN
	required = 1
	#else
	required = 0
	#endif
}

typedef RankCallback = function Action(int client, int rank, any data);

public void __pl_rankme_SetNTVOptional()
{
	MarkNativeAsOptional("RankMe_GivePoint");
	MarkNativeAsOptional("RankMe_GetRank");
	MarkNativeAsOptional("RankMe_GetPoints");
	MarkNativeAsOptional("RankMe_GetStats");
	MarkNativeAsOptional("RankMe_GetSession");
	MarkNativeAsOptional("RankMe_GetWeaponStats");
	MarkNativeAsOptional("RankMe_GetHitbox");
	MarkNativeAsOptional("RankMe_IsPlayerLoaded");
}

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
 * @param client	The client index of the player to get the rank.
 * @param global  Whether or not to get the global points for the client.
 * @return		The score of the client
 *********************************************************/
native int RankMe_GetPoints(int client, bool global = false);

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

/*********************************************************
 * Get if player is loaded 
 *
 * @param client	Client index
 * @return			If the client is loaded
 *********************************************************/
native void RankMe_IsPlayerLoaded(int client);

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