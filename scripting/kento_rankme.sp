#pragma semicolon  1

#define PLUGIN_VERSION "3.0.3.Kento.33.3"

#include <sourcemod> 
#include <adminmenu>
#include <kento_csgocolors>
#include <geoip>
#include <sdktools>
#include <cstrike>
#include <clientprefs>
#include <kento_rankme/rankme>

#pragma newdecls required
#pragma dynamic 131072 

#define SPEC 1
#define TR 2
#define CT 3

#define SENDER_WORLD 0
#define MAX_LENGTH_MENU 470

static const char g_sSqliteCreateGlobal[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, steam VARCHAR(40) NOT NULL, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,breachcharge NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC, thru_smoke NUMERIC, blind NUMERIC, assist_flash NUMERIC, assist_team_flash NUMERIC, assist_team_kill NUMERIC, wallbang NUMERIC)";
static const char g_sMysqlCreateGlobal[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, steam TEXT, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,breachcharge NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC, thru_smoke NUMERIC, blind NUMERIC, assist_flash NUMERIC, assist_team_flash NUMERIC, assist_team_kill NUMERIC, wallbang NUMERIC) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
static const char g_sSqliteCreateSeason[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, season_id INTEGER,steam VARCHAR(40) NOT NULL, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,breachcharge NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC, thru_smoke NUMERIC, blind NUMERIC, assist_flash NUMERIC, assist_team_flash NUMERIC, assist_team_kill NUMERIC, wallbang NUMERIC)";
static const char g_sMysqlCreateSeason[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, season_id INTEGER, steam TEXT, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,breachcharge NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC, thru_smoke NUMERIC, blind NUMERIC, assist_flash NUMERIC, assist_team_flash NUMERIC, assist_team_kill NUMERIC, wallbang NUMERIC) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
static const char g_sSqliteCreateSeasonID[] = "CREATE TABLE IF NOT EXISTS `%s` (season_id INTEGER PRIMARY KEY, start_date BIGINT, end_date BIGINT)";
static const char g_sMysqlCreateSeasonID[] = "CREATE TABLE IF NOT EXISTS `%s` (season_id INTEGER PRIMARY KEY, start_date BIGINT, end_date BIGINT) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
static const char g_sSqlInsertGlobal[] = "INSERT INTO `%s` VALUES (NULL,'%s','%s','%s','%d','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0');";
static const char g_sSqlInsertSeason[] = "INSERT INTO `%s` VALUES (NULL,'%d','%s','%s','%s','%d','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0');";

/* SM1.9 Fix */
static const char g_sSqlSaveGlobal[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE steam = '%s';";
static const char g_sSqlSaveSeason[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE steam = '%s' AND season_id = '%d';";
static const char g_sSqlSaveNameGlobal[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE name = '%s';";
static const char g_sSqlSaveNameSeason[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE name = '%s' AND season_id = '%d';";
static const char g_sSqlSaveIpGlobal[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE lastip = '%s';";
static const char g_sSqlSaveIpSeason[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE lastip = '%s' AND season_id = '%d';";
static const char g_sSqlSave2Global[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE steam = '%s';";
static const char g_sSqlSave2Season[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE steam = '%s' AND season_id = '%d';";
static const char g_sSqlSaveName2Global[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE name = '%s';";
static const char g_sSqlSaveName2Season[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE name = '%s' AND season_id = '%d';";
static const char g_sSqlSaveIp2Global[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE lastip = '%s';";
static const char g_sSqlSaveIp2Season[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', thru_smoke='%i', blind='%i', assist_flash='%i', assist_team_flash='%i', assist_team_kill='%i', wallbang='%i', lastconnect='%i', connected='%i' WHERE lastip = '%s' AND season_id = '%d';";

static const char g_sSqlRetrieveClientGlobal[] = "SELECT * FROM `%s` WHERE steam='%s';";
static const char g_sSqlRetrieveClientSeason[] = "SELECT * FROM `%s` WHERE steam='%s' AND season_id=%d;";
static const char g_sSqlRetrieveClientNameGlobal[] = "SELECT * FROM `%s` WHERE name='%s';";
static const char g_sSqlRetrieveClientNameSeason[] = "SELECT * FROM `%s` WHERE name='%s' AND season_id=%d;";
static const char g_sSqlRetrieveClientIpGlobal[] = "SELECT * FROM `%s` WHERE lastip='%s';";
static const char g_sSqlRetrieveClientIpSeason[] = "SELECT * FROM `%s` WHERE lastip='%s' AND season_id=%d;";
static const char g_sSqlRetrieveSeasonID[] = "SELECT * FROM `%s` WHERE `start_date` <= UNIX_TIMESTAMP() AND `end_date` >= UNIX_TIMESTAMP() ;";
static const char g_sSqlRemoveDuplicateSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.steam=`%s`.steam);";
static const char g_sSqlRemoveDuplicateNameSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.name=`%s`.name);";
static const char g_sSqlRemoveDuplicateIpSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.lastip=`%s`.lastip);";
static const char g_sSqlRemoveDuplicateMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.steam=vtable.steam);";
static const char g_sSqlRemoveDuplicateNameMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.name=vtable.name);";
static const char g_sSqlRemoveDuplicateIpMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.ip=vtable.ip);";
stock const char g_sWeaponsNamesGame[42][] =  { "knife", "glock", "hkp2000", "usp_silencer", "p250", "deagle", "elite", "fiveseven", "tec9", "cz75a", "revolver", "nova", "xm1014", "mag7", "sawedoff", "bizon", "mac10", "mp9", "mp7", "ump45", "p90", "galilar", "ak47", "scar20", "famas", "m4a1", "m4a1_silencer", "aug", "ssg08", "sg556", "awp", "g3sg1", "m249", "negev", "hegrenade", "flashbang", "smokegrenade", "inferno", "decoy", "taser", "mp5sd", "breachcharge"};
stock const char g_sWeaponsNamesFull[42][] =  { "Knife", "Glock", "P2000", "USP-S", "P250", "Desert Eagle", "Dual Berettas", "Five-Seven", "Tec 9", "CZ75-Auto", "R8 Revolver", "Nova", "XM1014", "Mag 7", "Sawed-off", "PP-Bizon", "MAC-10", "MP9", "MP7", "UMP45", "P90", "Galil AR", "AK-47", "SCAR-20", "Famas", "M4A4", "M4A1-S", "AUG", "SSG 08", "SG 553", "AWP", "G3SG1", "M249", "Negev", "HE Grenade", "Flashbang", "Smoke Grenade", "Inferno", "Decoy", "Zeus x27", "MP5-SD", "Breach Charges"};

char g_sSQLTableGlobal[200];
char g_sSQLTableSeason[200];
char g_sSQLTableSeasonID[200];
Handle g_hStatsDb;
bool OnDBGlobal[MAXPLAYERS + 1];
bool OnDBSeason[MAXPLAYERS + 1];
STATS_NAMES g_aSession[MAXPLAYERS + 1];
STATS_NAMES g_aStatsGlobal[MAXPLAYERS + 1];
STATS_NAMES g_aStatsSeason[MAXPLAYERS + 1];
WEAPONS_ENUM g_aWeaponsGlobal[MAXPLAYERS + 1];
WEAPONS_ENUM g_aWeaponsSeason[MAXPLAYERS + 1];
HITBOXES g_aHitBoxGlobal[MAXPLAYERS + 1];
HITBOXES g_aHitBoxSeason[MAXPLAYERS + 1];
int g_TotalPlayers;
int g_iSeasonID = 0;

Handle g_fwdOnPlayerLoaded;
Handle g_fwdOnPlayerSaved;

bool DEBUGGING = true;
int g_C4PlantedBy;
char g_sC4PlantedByName[MAX_NAME_LENGTH];

// Preventing duplicates
char g_aClientSteam[MAXPLAYERS + 1][64];
char g_aClientName[MAXPLAYERS + 1][MAX_NAME_LENGTH];
char g_aClientIp[MAXPLAYERS + 1][64];

/* Cooldown Timer */
Handle hRankTimer[MAXPLAYERS + 1] = INVALID_HANDLE;

/* Hide Chat */
Handle hidechatcookie;
bool hidechat[MAXPLAYERS+1];

char MSG[64];

#include <kento_rankme/cvars>
#include <kento_rankme/natives>
#include <kento_rankme/cmds>

public Plugin myinfo =  {
	name = "RankMe", 
	author = "lok1, Scooby, Kento, pracc, Kxnrl, CrazyHackGUT", 
	description = "Improved RankMe for CSGO", 
	version = PLUGIN_VERSION, 
	url = "https://github.com/rogeraabbccdd/Kento-Rankme"
};

public void OnPluginStart() {
	
	// CREATE CVARS
	CreateCvars();
	
	// EVENTS
	HookEventEx("player_death", EventPlayerDeath);
	HookEvent("player_spawn", EventPlayerSpawn);
	HookEventEx("player_hurt", EventPlayerHurt);
	HookEventEx("weapon_fire", EventWeaponFire);
	HookEventEx("bomb_planted", Event_BombPlanted);
	HookEventEx("bomb_defused", Event_BombDefused);
	HookEventEx("bomb_exploded", Event_BombExploded);
	HookEventEx("bomb_dropped", Event_BombDropped);
	HookEventEx("bomb_pickup", Event_BombPickup);
	HookEventEx("hostage_rescued", Event_HostageRescued);
	HookEventEx("vip_killed", Event_VipKilled);
	HookEventEx("vip_escaped", Event_VipEscaped);
	HookEventEx("round_end", Event_RoundEnd);
	HookEventEx("round_start", Event_RoundStart);
	HookEventEx("round_mvp", Event_RoundMVP);
	HookEventEx("player_changename", OnClientChangeName, EventHookMode_Pre);
	HookEventEx("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre); 
	//HookEvent("player_team", Event_PlayerTeam);	
	HookEventEx("cs_win_panel_match", Event_WinPanelMatch);
	
	// ADMNIN COMMANDS
	RegAdminCmd("sm_resetrank", CMD_ResetRank, ADMFLAG_ROOT, "RankMe: Resets the rank of a player");
	RegAdminCmd("sm_rankme_remove_duplicate", CMD_Duplicate, ADMFLAG_ROOT, "RankMe: Removes the duplicated rows on the database");
	RegAdminCmd("sm_rankpurge", CMD_Purge, ADMFLAG_ROOT, "RankMe: Purges from the rank players that didn't connected for X days");
	RegAdminCmd("sm_resetrank_all", CMD_ResetRankAll, ADMFLAG_ROOT, "RankMe: Resets the rank of all players");
	
	// PLAYER COMMANDS
	RegConsoleCmd("sm_session", CMD_Session, "RankMe: Shows the stats of your current session");
	RegConsoleCmd("sm_rank", CMD_Rank, "RankMe: Shows your rank");
	RegConsoleCmd("sm_top", CMD_Top, "RankMe: Shows the TOP");
	RegConsoleCmd("sm_topweapon", CMD_TopWeapon, "RankMe: Shows the TOP ordered by kills with a specific weapon");
	RegConsoleCmd("sm_topacc", CMD_TopAcc, "RankMe: Shows the TOP ordered by accuracy");
	RegConsoleCmd("sm_tophs", CMD_TopHS, "RankMe: Shows the TOP ordered by HeadShots");
	RegConsoleCmd("sm_toptime", CMD_TopTime, "RankMe: Shows the TOP ordered by Connected Time");
	RegConsoleCmd("sm_topkills", CMD_TopKills, "RankMe: Shows the TOP ordered by kills");
	RegConsoleCmd("sm_topdeaths", CMD_TopDeaths, "RankMe: Shows the TOP ordered by deaths");
	RegConsoleCmd("sm_hitboxme", CMD_HitBox, "RankMe: Shows the HitBox stats");
	RegConsoleCmd("sm_weaponme", CMD_WeaponMe, "RankMe: Shows the kills with each weapon");
	RegConsoleCmd("sm_resetmyrank", CMD_ResetOwnRank, "RankMe: Resets your own rank");
	RegConsoleCmd("sm_statsme", CMD_StatsMe, "RankMe: Shows your stats");
	RegConsoleCmd("sm_next", CMD_Next, "RankMe: Shows the next 9 players above you on the TOP");
	RegConsoleCmd("sm_statsme2", CMD_StatsMe2, "RankMe: Shows the stats from a player");
	RegConsoleCmd("sm_rankme", CMD_RankMe, "RankMe: Shows a menu with the basic commands");
	RegConsoleCmd("sm_topassists", CMD_TopAssists, "RankMe: Shows the TOP ordered by Assists");
	RegConsoleCmd("sm_toptk", CMD_TopTK, "RankMe: Shows the TOP ordered by TKs");
	RegConsoleCmd("sm_topmvp", CMD_TopMVP, "RankMe: Shows the TOP ordered by MVPs");
	RegConsoleCmd("sm_topdamage", CMD_TopDamage, "RankMe: Shows the TOP ordered by damage");
	RegConsoleCmd("sm_topkdr", CMD_TopKDR, "RankMe: Shows the TOP ordered by kdr");
	RegConsoleCmd("sm_toppoints", CMD_TopPoints, "RankMe: Shows the TOP ordered by points");
	RegConsoleCmd("sm_topfb", CMD_TopFB, "RankMe: Shows the TOP ordered by first bloods");
	RegConsoleCmd("sm_topns", CMD_TopNS, "RankMe: Shows the TOP ordered by no scopes");
	RegConsoleCmd("sm_topnsd", CMD_TopNSD, "RankMe: Shows the TOP ordered by no scope distance");
	RegConsoleCmd("sm_topfk", CMD_TopBlind, "RankMe: Shows the TOP ordered by flashed kills");
	RegConsoleCmd("sm_topthrusmoke", CMD_TopSmoke, "RankMe: Shows the TOP ordered by killing through smokes");
	RegConsoleCmd("sm_topwall", CMD_TopWall, "RankMe: Shows the TOP ordered by wallbangs");
	RegConsoleCmd("sm_rankmechat", CMD_HideChat, "Disable rankme chat messages");

	// LOAD RANKME.CFG
	AutoExecConfig(true, "kento.rankme");
		
	// LOAD TRANSLATIONS
	LoadTranslations("kento.rankme.phrases");
	
	//	Hook the say and say_team for chat triggers
	AddCommandListener(OnSayText, "say");
	AddCommandListener(OnSayText, "say_team");
	
	ConVar cvarVersion = CreateConVar("rankme_version", PLUGIN_VERSION, "RankMe Version", FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD);
	// UPDATE THE CVAR IF NEEDED
	char sVersionOnCvar[10];
	cvarVersion.GetString(sVersionOnCvar, sizeof(sVersionOnCvar));
	if (!StrEqual(PLUGIN_VERSION, sVersionOnCvar))
		cvarVersion.SetString(PLUGIN_VERSION, true, true);
	
	// Create the forwards
	g_fwdOnPlayerLoaded = CreateGlobalForward("RankMe_OnPlayerLoaded", ET_Hook, Param_Cell);
	g_fwdOnPlayerSaved = CreateGlobalForward("RankMe_OnPlayerSaved", ET_Hook, Param_Cell);
	
	/* Hide chat */
	hidechatcookie = RegClientCookie("rankme_hidechat", "Hide rankme chat messages", CookieAccess_Private);

	Format(MSG, sizeof(MSG), "%t", "Chat Prefix");
}

public void OnConVarChanged_SQLTable(Handle convar, const char[] oldValue, const char[] newValue) {

	DB_Connect(true); // Force reloading the stats
}

public void OnConVarChanged_MySQL(Handle convar, const char[] oldValue, const char[] newValue) {
	DB_Connect(false);
}

public void DB_Connect(bool firstload) {
	if(DEBUGGING) PrintToServer("Connecting to database...");
	if (g_bMysql != g_cvarMysql.BoolValue || firstload) {  // NEEDS TO CONNECT IF CHANGED MYSQL CVAR OR NEVER CONNECTED
		g_bMysql = g_cvarMysql.BoolValue;
		g_cvarSQLTableGlobal.GetString(g_sSQLTableGlobal, sizeof(g_sSQLTableGlobal));
		g_cvarSQLTableSeason.GetString(g_sSQLTableSeason, sizeof(g_sSQLTableSeason));
		g_cvarSQLTableSeasonID.GetString(g_sSQLTableSeasonID, sizeof(g_sSQLTableSeasonID));
		char sError[256];
		if (g_bMysql) {
			g_hStatsDb = SQL_Connect("rankme", false, sError, sizeof(sError));
		} else {
			g_hStatsDb = SQLite_UseDatabase("rankme", sError, sizeof(sError));
		}

		if (g_hStatsDb == INVALID_HANDLE)
		{
			SetFailState("[RankMe] Unable to connect to the database (%s)", sError);
		}
		if(DEBUGGING) PrintToServer("Connected!");

		// SQL_LockDatabase is redundent for SQL_SetCharset
		if(!SQL_SetCharset(g_hStatsDb, "utf8mb4")){
			SQL_SetCharset(g_hStatsDb, "utf8");
		}

		char sQuery[9999];
		if(DEBUGGING) PrintToServer("Creating tables!");
		if(g_bMysql)
		{
			Format(sQuery, sizeof(sQuery), g_sMysqlCreateGlobal, g_sSQLTableGlobal);
		}else{
			Format(sQuery, sizeof(sQuery), g_sSqliteCreateGlobal, g_sSQLTableGlobal);
		}
		SQL_LockDatabase(g_hStatsDb);
		SQL_FastQuery(g_hStatsDb, sQuery);

		if(g_bMysql)
		{
			Format(sQuery, sizeof(sQuery), g_sMysqlCreateSeason, g_sSQLTableSeason);
		}else{
			Format(sQuery, sizeof(sQuery), g_sSqliteCreateSeason, g_sSQLTableSeasonID);
		}
		SQL_FastQuery(g_hStatsDb, sQuery);

		if(g_bMysql)
		{
			Format(sQuery, sizeof(sQuery), g_sMysqlCreateSeasonID, g_sSQLTableSeasonID);
		}else{
			Format(sQuery, sizeof(sQuery), g_sSqliteCreateSeasonID, g_sSQLTableSeasonID);
		}
		SQL_FastQuery(g_hStatsDb, sQuery);

		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` MODIFY id INTEGER AUTO_INCREMENT", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_killed NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_escaped NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_played NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_win NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_draw NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_lose NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN mp5sd NUMERIC AFTER taser", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN breachcharge NUMERIC AFTER mp5sd", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN first_blood NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN no_scope NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN no_scope_dis NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN thru_smoke NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN blind NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN assist_flash NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN assist_team_flash NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN assist_team_kill NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN wallbang NUMERIC", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` CHANGE steam steam VARCHAR(40)", g_sSQLTableGlobal);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` MODIFY id INTEGER AUTO_INCREMENT", g_sSQLTableSeason);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` MODIFY season_id INTEGER AUTO_INCREMENT", g_sSQLTableSeasonID);
		SQL_FastQuery(g_hStatsDb, sQuery);
		SQL_UnlockDatabase(g_hStatsDb);

		for (int i = 1; i <= MaxClients; i++) {
			if (IsClientInGame(i))
				OnClientPutInServer(i);
		}
	}
	
}
public void OnConfigsExecuted() {
	GetCvarValues();

	if (g_hStatsDb == INVALID_HANDLE)
		DB_Connect(true);
	else
		DB_Connect(false);
	char sQuery[1000];
	if (g_AutoPurge > 0) {
		int DeleteBefore = GetTime() - (g_AutoPurge * 86400);
		Format(sQuery, sizeof(sQuery), "DELETE FROM `%s` WHERE lastconnect < '%d'", g_sSQLTableGlobal, DeleteBefore);
		SQL_TQuery(g_hStatsDb, SQL_PurgeCallback, sQuery);
	}
	
	Format(sQuery, sizeof(sQuery), g_sSqlRetrieveSeasonID, g_sSQLTableSeasonID);
	SQL_TQuery(g_hStatsDb, SQL_GetSeasonIDCallback, sQuery);

	if (g_bRankBots){
		Format(sQuery, sizeof(sQuery), "SELECT * FROM `%s` WHERE kills >= '%d'", g_sSQLTableGlobal, g_MinimalKills);
	}
	else{
		Format(sQuery, sizeof(sQuery), "SELECT * FROM `%s` WHERE kills >= '%d' AND steam <> 'BOT'", g_sSQLTableGlobal, g_MinimalKills);
	}
	SQL_TQuery(g_hStatsDb, SQL_GetPlayersCallback, sQuery);

	CheckUnique();
	BuildRankCache();
}

void CheckUnique(){
	char sQuery[1000];
	if(g_bMysql)	Format(sQuery, sizeof(sQuery), "SHOW INDEX FROM `%s` WHERE Key_name = 'steam'", g_sSQLTableGlobal);
	else			Format(sQuery, sizeof(sQuery), "PRAGMA INDEX_LIST('%s')", g_sSQLTableGlobal);
	SQL_TQuery(g_hStatsDb, SQL_SetUniqueCallback, sQuery);
}

public void SQL_SetUniqueCallback(Handle owner, Handle hndl, const char[] error, any Datapack){
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Check Unique Key Fail: %s", error);
		return;
	}
	
	bool hasunique;
	if(SQL_GetRowCount(hndl) > 0)	hasunique = true;
	else hasunique = false;

	char sQuery[1000];
	if (g_bRankBots){
		//only drop it when theres unique key
		if(hasunique){
			if(g_bMysql)	Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` DROP INDEX steam", g_sSQLTableGlobal);
			else			Format(sQuery, sizeof(sQuery), "DROP INDEX steam");
			SQL_TQuery(g_hStatsDb, SQL_NothingCallback, sQuery);
		}
	}
	else{
		Format(sQuery, sizeof(sQuery), "DELETE FROM `%s` WHERE steam = 'BOT'" ,g_sSQLTableGlobal);
		SQL_TQuery(g_hStatsDb, SQL_NothingCallback, sQuery);

		// check unique key is exists or not
		if(SQL_GetRowCount(hndl) < 1){
			if(g_bMysql)	Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD UNIQUE(steam)" ,g_sSQLTableGlobal);
			else			Format(sQuery, sizeof(sQuery), "CREATE UNIQUE INDEX steam ON `%s`(steam)" ,g_sSQLTableGlobal);
			SQL_TQuery(g_hStatsDb, SQL_NothingCallback, sQuery);
		}
	}
}

public void SQL_GetSeasonIDCallback(Handle owner, Handle hndl, const char[] error, any Datapack){
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Get Season ID failed: %s", error);
		return;
	}
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_iSeasonID = SQL_FetchInt(hndl, 0);
	}
	if(DEBUGGING) PrintToServer("Season ID is %d", g_iSeasonID);
}

void BuildRankCache()
{
	if(!g_bRankCache)
		return;
	
	ClearArray(g_arrayRankCache[0]);
	ClearArray(g_arrayRankCache[1]);
	ClearArray(g_arrayRankCache[2]);
	
	PushArrayString(g_arrayRankCache[0], "Rank By SteamId: This is First Line in Array");
	PushArrayString(g_arrayRankCache[1], "Rank By Name: This is First Line in Array");
	PushArrayString(g_arrayRankCache[2], "Rank By IP: This is First Line in Array");
	
	char query[1000];
	MakeSelectQuery(query, sizeof(query));

	if (g_RankMode == 1)
		Format(query, sizeof(query), "%s ORDER BY score DESC", query);
	else if(g_RankMode == 2)
		Format(query, sizeof(query), "%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC", query);
	
	SQL_TQuery(g_hStatsDb, SQL_BuildRankCache, query);
}

public void SQL_BuildRankCache(Handle owner, Handle hndl, const char[] error, any unuse)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] : build rank cache failed", error);
		return;
	}
	
	if(SQL_GetRowCount(hndl))
	{
		char steamid[32], name[128], ip[32];
		while(SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 1, steamid, 32);
			SQL_FetchString(hndl, 2, name, 128);
			SQL_FetchString(hndl, 3, ip, 32);
			PushArrayString(g_arrayRankCache[0], steamid);
			PushArrayString(g_arrayRankCache[1], name);
			PushArrayString(g_arrayRankCache[2], ip);
		}
	}
	else
		LogMessage("[RankMe] :  No mork rank");
}

public Action OnClientChangeName(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled)
		return Plugin_Continue;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return Plugin_Continue;
	if (IsClientConnected(client))
	{
		char clientnewname[MAX_NAME_LENGTH];
		GetEventString(event, "newname", clientnewname, sizeof(clientnewname));
		if (client == g_C4PlantedBy)
			strcopy(g_sC4PlantedByName, sizeof(g_sC4PlantedByName), clientnewname);
		char Eclientnewname[MAX_NAME_LENGTH * 2 + 1];
		SQL_EscapeString(g_hStatsDb, clientnewname, Eclientnewname, sizeof(Eclientnewname));
		
		//ReplaceString(clientnewname, sizeof(clientnewname), "'", "");
		char query[10000];
		char query2[10000];
		if (g_RankBy == 1) {
			OnDBGlobal[client] = false;
			OnDBSeason[client] = false;
			g_aSession[client].Reset();
			g_aStatsGlobal[client].Reset();
			g_aStatsGlobal[client].SCORE = g_PointsStart;
			g_aStatsSeason[client].Reset();
			g_aStatsSeason[client].SCORE = g_PointsStart;
			g_aWeaponsGlobal[client].Reset();
			g_aWeaponsSeason[client].Reset();
			g_aSession[client].CONNECTED = GetTime();
			
			strcopy(g_aClientName[client], MAX_NAME_LENGTH, clientnewname);
			
			Format(query, sizeof(query), g_sSqlRetrieveClientNameGlobal, g_sSQLTableGlobal, Eclientnewname);
			Format(query2, sizeof(query2), g_sSqlRetrieveClientNameSeason, g_sSQLTableSeason, Eclientnewname, g_iSeasonID);
			if (DEBUGGING) {
				PrintToServer(query);
				LogError("%s", query);
				PrintToServer(query2);
				LogError("%s", query2);
			}
			SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallbackGlobal, query, client);
			SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallbackSeason, query2, client);
			
		} else {
			
			if (g_RankBy == 0){
				Format(query, sizeof(query), "UPDATE `%s` SET name='%s' WHERE steam = '%s';", g_sSQLTableGlobal, Eclientnewname, g_aClientSteam[client]);
				Format(query2, sizeof(query2), "UPDATE `%s` SET name='%s' WHERE steam = '%s' AND season_id = '%d';", g_sSQLTableSeason, Eclientnewname, g_aClientSteam[client], g_iSeasonID);
			}
			else{
				Format(query, sizeof(query), "UPDATE `%s` SET name='%s' WHERE lastip = '%s';", g_sSQLTableGlobal, Eclientnewname, g_aClientIp[client]);
				Format(query2, sizeof(query2), "UPDATE `%s` SET name='%s' WHERE lastip = '%s' AND season_id = '%d';", g_sSQLTableSeason, Eclientnewname, g_aClientIp[client], g_iSeasonID);
			}

			SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query);
			SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query2);
		}
	}
	return Plugin_Continue;
}

int GetCurrentPlayers() 
{
	int count;
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i) && (!IsFakeClient(i) || g_bRankBots) && GetClientTeam(i) != CS_TEAM_SPECTATOR && GetClientTeam(i) != CS_TEAM_NONE) {
			count++;
		}
	}
	return count;
}

public void OnPluginEnd() {
	if (!g_bEnabled)
		return;
	SQL_LockDatabase(g_hStatsDb);
	for (int client = 1; client <= MaxClients; client++) {
		if (IsClientInGame(client)) {
			if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
				return;
			char name[MAX_NAME_LENGTH];
			GetClientName(client, name, sizeof(name));
			char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
			SQL_EscapeString(g_hStatsDb, name, sEscapeName, sizeof(sEscapeName));
			
			// Make SQL-safe
			//ReplaceString(name, sizeof(name), "'", "");
			
			char weapons_query[2000] = "";
			int weapon_array[42];
			g_aWeaponsGlobal[client].GetData(weapon_array);
			for (int i = 0; i < 42; i++) {
				Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], weapon_array[i]);
			}

			/* SM1.9 Fix */
			char query[4000];
			char query2[4000];
	
			if (g_RankBy == 0) 
			{
				Format(query, sizeof(query), g_sSqlSaveGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
					g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, g_aClientSteam[client]);
	
				Format(query2, sizeof(query2), g_sSqlSave2Global, g_sSQLTableGlobal, g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
					g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
					g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
					g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD,
					g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
					GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientSteam[client]);
			} 
	
			else if (g_RankBy == 1) 
			{
				Format(query, sizeof(query), g_sSqlSaveNameGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
					g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, sEscapeName);
	
				Format(query2, sizeof(query2), g_sSqlSaveName2Global, g_sSQLTableGlobal, g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
					g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
					g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
					g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD, 
					g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
					GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, sEscapeName);
			} 
	
			else if (g_RankBy == 2) 
			{
				Format(query, sizeof(query), g_sSqlSaveIpGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
					g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, g_aClientIp[client]);
	
				Format(query2, sizeof(query2), g_sSqlSaveIp2Global,  g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
					g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
					g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
					g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD, 
					g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
					GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientIp[client]);
			}
			
			LogMessage(query);
			LogMessage(query2);
			SQL_FastQuery(g_hStatsDb, query);
			SQL_FastQuery(g_hStatsDb, query2);
			
			g_aWeaponsSeason[client].GetData(weapon_array);
			for (int i = 0; i < 42; i++) {
				Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], weapon_array[i]);
			}

			if (g_RankBy == 0) 
			{
				Format(query, sizeof(query), g_sSqlSaveSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
					g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, g_aClientSteam[client], g_iSeasonID);
	
				Format(query2, sizeof(query2), g_sSqlSave2Season, g_sSQLTableSeason, g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
					g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
					g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
					g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD,
					g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
					GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientSteam[client], g_iSeasonID);
			} 

			else if (g_RankBy == 1) 
			{
				Format(query, sizeof(query), g_sSqlSaveNameSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
					g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, sEscapeName, g_iSeasonID);
	
				Format(query2, sizeof(query2), g_sSqlSaveName2Season, g_sSQLTableSeason, g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
					g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
					g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
					g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD, 
					g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
					GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, sEscapeName, g_iSeasonID);
			} 
	
			else if (g_RankBy == 2) 
			{
				Format(query, sizeof(query), g_sSqlSaveIpSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
					g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, g_aClientIp[client], g_iSeasonID);
	
				Format(query2, sizeof(query2), g_sSqlSaveIp2Season,  g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
					g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
					g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
					g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD, 
					g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
					GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientIp[client], g_iSeasonID);
			}
			
			LogMessage(query);
			LogMessage(query2);
			SQL_FastQuery(g_hStatsDb, query);
			SQL_FastQuery(g_hStatsDb, query2);

			/**
			Start the forward OnPlayerSaved
			*/
			Action fResult;
			Call_StartForward(g_fwdOnPlayerSaved);
			Call_PushCell(client);
			int fError = Call_Finish(fResult);
			
			if (fError != SP_ERROR_NONE)
			{
				ThrowNativeError(fError, "Forward failed");
			}
		}
	}
	SQL_UnlockDatabase(g_hStatsDb);
}

public int GetWeaponNum(char[] weaponname) 
{
	for (int i = 0; i < 42; i++) {
		if (StrEqual(weaponname, g_sWeaponsNamesGame[i]))
			return i;
	}
	return 44;
}

public Action Event_VipEscaped(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStatsGlobal[i].SCORE += g_PointsVipEscapedTeam;
			g_aStatsSeason[i].SCORE += g_PointsVipEscapedTeam;
			g_aSession[i].SCORE += g_PointsVipEscapedTeam;
			
		}
		
	}
	g_aStatsGlobal[client].VIP_PLAYED++;
	g_aStatsSeason[client].VIP_PLAYED++;
	g_aSession[client].VIP_PLAYED++;
	g_aStatsGlobal[client].VIP_ESCAPED++;
	g_aStatsSeason[client].VIP_ESCAPED++;
	g_aSession[client].VIP_ESCAPED++;
	g_aStatsGlobal[client].SCORE += g_PointsVipEscapedPlayer;
	g_aStatsSeason[client].SCORE += g_PointsVipEscapedPlayer;
	g_aSession[client].SCORE += g_PointsVipEscapedPlayer;
	
	if (!g_bChatChange)
		return;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_VIPEscaped", i, g_PointsVipEscapedTeam);
	if (client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "VIPEscaped", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsVipEscapedTeam + g_PointsVipEscapedPlayer);
}

public Action Event_VipKilled(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == TR) {
			g_aStatsGlobal[i].SCORE += g_PointsVipKilledTeam;
			g_aStatsSeason[i].SCORE += g_PointsVipKilledTeam;
			g_aSession[i].SCORE += g_PointsVipKilledTeam;
			
		}
		
	}
	g_aStatsGlobal[client].VIP_PLAYED++;
	g_aStatsSeason[client].VIP_PLAYED++;
	g_aSession[client].VIP_PLAYED++;
	g_aStatsGlobal[killer].VIP_KILLED++;
	g_aStatsSeason[killer].VIP_KILLED++;
	g_aSession[killer].VIP_KILLED++;
	g_aStatsGlobal[killer].SCORE += g_PointsVipKilledPlayer;
	g_aStatsSeason[killer].SCORE += g_PointsVipKilledPlayer;
	g_aSession[killer].SCORE += g_PointsVipKilledPlayer;
	
	if (!g_bChatChange)
		return;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "TR_VIPKilled", i, g_PointsVipKilledTeam);
	if (client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "VIPKilled", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsVipKilledTeam + g_PointsVipKilledPlayer);
}

public Action Event_HostageRescued(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStatsGlobal[i].SCORE += g_PointsHostageRescTeam;
			g_aStatsSeason[i].SCORE += g_PointsHostageRescTeam;
			g_aSession[i].SCORE += g_PointsHostageRescTeam;
			
		}
		
	}
	g_aSession[client].HOSTAGES_RESCUED++;
	g_aStatsGlobal[client].HOSTAGES_RESCUED++;
	g_aStatsSeason[client].HOSTAGES_RESCUED++;
	g_aStatsGlobal[client].SCORE += g_PointsHostageRescPlayer;
	g_aStatsSeason[client].SCORE += g_PointsHostageRescPlayer;
	g_aSession[client].SCORE += g_PointsHostageRescPlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsHostageRescTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_Hostage", i, g_PointsHostageRescTeam);
	
	if (g_PointsHostageRescPlayer > 0 && client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Hostage", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsHostageRescPlayer + g_PointsHostageRescTeam);
	
}

public Action Event_RoundMVP(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsClientInGame(client))
		return;
	int team = GetClientTeam(client);
	
	if (((team == 2 && g_PointsMvpTr > 0) || (team == 3 && g_PointsMvpCt > 0)) && client != 0 && (g_bRankBots || !IsFakeClient(client))) {
		
		if (team == 2) {
			
			g_aStatsGlobal[client].SCORE += g_PointsMvpTr;
			g_aStatsSeason[client].SCORE += g_PointsMvpTr;
			g_aSession[client].SCORE += g_PointsMvpTr;
			for (int i = 1; i <= MaxClients; i++)
			if (IsClientInGame(i))
				if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "MVP", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsMvpTr);
			
		} else {
			
			g_aStatsGlobal[client].SCORE += g_PointsMvpCt;
			g_aStatsSeason[client].SCORE += g_PointsMvpCt;
			g_aSession[client].SCORE += g_PointsMvpCt;
			for (int i = 1; i <= MaxClients; i++)
			if (IsClientInGame(i))
				if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "MVP", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsMvpCt);	
		}
	}
	g_aStatsGlobal[client].MVP++;
	g_aStatsSeason[client].MVP++;
	g_aSession[client].MVP++;
}
public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int i;
	int Winner = GetEventInt(event, "winner");
	bool announced = false;
	for (i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && (g_bRankBots || !IsFakeClient(i))) {
			if (Winner == TR) {
				if(GetClientTeam(i) == TR){
					g_aSession[i].TR_WIN++;
					g_aStatsGlobal[i].TR_WIN++;
					g_aStatsSeason[i].TR_WIN++;
					if (g_PointsRoundWin[TR] > 0) {
						g_aSession[i].SCORE += g_PointsRoundWin[TR];
						g_aStatsGlobal[i].SCORE += g_PointsRoundWin[TR];
						g_aStatsSeason[i].SCORE += g_PointsRoundWin[TR];
						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "TR_Round", j, g_PointsRoundWin[TR]);
						}
					}
				}
				else if(GetClientTeam(i) == CT){
					if (g_PointsRoundLose[CT] > 0) {
						g_aStatsGlobal[i].SCORE -= g_PointsRoundLose[CT];
						g_aStatsSeason[i].SCORE -= g_PointsRoundLose[CT];

						/* Min points */
						if (g_bPointsMinEnabled)
						{
							if(g_aStatsGlobal[i].SCORE < g_PointsMin)
							{
								int diff = g_PointsMin - g_aStatsGlobal[i].SCORE;
								g_aStatsGlobal[i].SCORE = g_PointsMin;
								g_aSession[i].SCORE -= diff;
							}	
							else{
								g_aSession[i].SCORE -= g_PointsRoundLose[CT];
							}
							if(g_aStatsSeason[i].SCORE < g_PointsMin)
							{
								g_aStatsSeason[i].SCORE = g_PointsMin;
							}
						}

						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "CT_Round_Lose", j, g_PointsRoundLose[CT]);
						}
						
					}
				}
				announced = true;
			} else if (Winner == CT) {
				if(GetClientTeam(i) == CT){
					g_aSession[i].CT_WIN++;
					g_aStatsGlobal[i].CT_WIN++;
					g_aStatsSeason[i].CT_WIN++;
					if (g_PointsRoundWin[CT] > 0) {
						g_aSession[i].SCORE += g_PointsRoundWin[CT];
						g_aStatsGlobal[i].SCORE += g_PointsRoundWin[CT];
						g_aStatsSeason[i].SCORE += g_PointsRoundWin[CT];
						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "CT_Round", j, g_PointsRoundWin[CT]);
						}
					}
				}
				else if(GetClientTeam(i) == TR){
					if (g_PointsRoundLose[TR] > 0) {
						g_aStatsGlobal[i].SCORE -= g_PointsRoundLose[TR];
						g_aStatsSeason[i].SCORE -= g_PointsRoundLose[TR];

						/* Min points */
						if (g_bPointsMinEnabled)
						{
							if(g_aStatsGlobal[i].SCORE < g_PointsMin)
							{
								int diff = g_PointsMin - g_aStatsGlobal[i].SCORE;
								g_aStatsGlobal[i].SCORE = g_PointsMin;
								g_aSession[i].SCORE -= diff;
							}
							else {
								g_aSession[i].SCORE -= g_PointsRoundLose[TR];
							}
							if(g_aStatsSeason[i].SCORE < g_PointsMin)
							{
								g_aStatsSeason[i].SCORE = g_PointsMin;
							}
						}

						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "TR_Round_Lose", j, g_PointsRoundLose[TR]);
						}
					}
				}
				announced = true;
			}
			SalvarPlayer(i);
		}
	}
	
	DumpDB();
}


public void EventPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	/* Old rounds played, this have been moved to round start.
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!g_bRankBots && IsFakeClient(client))
		return;
	if (GetClientTeam(client) == TR) {
		g_aStatsGlobal[client].ROUNDS_TR++;
		g_aSession[client].ROUNDS_TR++;
	} else if (GetClientTeam(client) == CT) {
		g_aStatsGlobal[client].ROUNDS_CT++;
		g_aSession[client].ROUNDS_CT++;
	}
	*/
}


public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
		
	firstblood = false;
	
	int i;
	for(i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == TR) 
		{
			g_aStatsGlobal[i].ROUNDS_TR++;
			g_aStatsSeason[i].ROUNDS_TR++;
			g_aSession[i].ROUNDS_TR++;
		} 
		else if (IsClientInGame(i) && GetClientTeam(i) == CT) 
		{
			g_aStatsGlobal[i].ROUNDS_CT++;
			g_aStatsSeason[i].ROUNDS_CT++;
			g_aSession[i].ROUNDS_CT++;
		}
	}
}

public Action Event_BombPlanted(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_C4PlantedBy = client;
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == TR) {
			g_aStatsGlobal[i].SCORE += g_PointsBombPlantedTeam;
			g_aStatsSeason[i].SCORE += g_PointsBombPlantedTeam;
			g_aSession[i].SCORE += g_PointsBombPlantedTeam;
			
		}
		
	}
	g_aStatsGlobal[client].C4_PLANTED++;
	g_aStatsSeason[client].C4_PLANTED++;
	g_aSession[client].C4_PLANTED++;
	g_aStatsGlobal[client].SCORE += g_PointsBombPlantedPlayer;
	g_aStatsSeason[client].SCORE += g_PointsBombPlantedPlayer;
	g_aSession[client].SCORE += g_PointsBombPlantedPlayer;
	
	strcopy(g_sC4PlantedByName, sizeof(g_sC4PlantedByName), g_aClientName[client]);
	if (!g_bChatChange)
		return;
	if (g_PointsBombPlantedTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "TR_Planting", i, g_PointsBombPlantedTeam);
	if (g_PointsBombPlantedPlayer > 0 && client != 0 && (g_bRankBots || !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Planting", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsBombPlantedTeam + g_PointsBombPlantedPlayer);
	
}

public Action Event_BombDefused(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStatsGlobal[i].SCORE += g_PointsBombDefusedTeam;
			g_aStatsSeason[i].SCORE += g_PointsBombDefusedTeam;
			g_aSession[i].SCORE += g_PointsBombDefusedTeam;
			
		}
		
	}
	g_aStatsGlobal[client].C4_DEFUSED++;
	g_aStatsSeason[client].C4_DEFUSED++;
	g_aSession[client].C4_DEFUSED++;
	g_aStatsGlobal[client].SCORE += g_PointsBombDefusedPlayer;
	g_aStatsSeason[client].SCORE += g_PointsBombDefusedPlayer;
	g_aSession[client].SCORE += g_PointsBombDefusedPlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombDefusedTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_Defusing", i, g_PointsBombDefusedTeam);
	if (g_PointsBombDefusedPlayer > 0 && client != 0 && (g_bRankBots || !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Defusing", i, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsBombDefusedTeam + g_PointsBombDefusedPlayer);
}

public Action Event_BombExploded(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
		
	int client = g_C4PlantedBy;
	
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
		
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == TR) {
			g_aStatsGlobal[i].SCORE += g_PointsBombExplodeTeam;
			g_aStatsSeason[i].SCORE += g_PointsBombExplodeTeam;
			g_aSession[i].SCORE += g_PointsBombExplodeTeam;
			
		}
		
	}
	g_aStatsGlobal[client].C4_EXPLODED++;
	g_aStatsSeason[client].C4_EXPLODED++;
	g_aSession[client].C4_EXPLODED++;
	g_aStatsGlobal[client].SCORE += g_PointsBombExplodePlayer;
	g_aStatsSeason[client].SCORE += g_PointsBombExplodePlayer;
	g_aSession[client].SCORE += g_PointsBombExplodePlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombExplodeTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "TR_Exploding", i, g_PointsBombExplodeTeam);
	if (g_PointsBombExplodePlayer > 0 && client != 0 && (g_bRankBots || !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Exploding", i, g_sC4PlantedByName, g_aStatsGlobal[client].SCORE, g_PointsBombExplodeTeam + g_PointsBombExplodePlayer);
}

public Action Event_BombPickup(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_aStatsGlobal[client].SCORE += g_PointsBombPickup;
	g_aStatsSeason[client].SCORE += g_PointsBombPickup;
	g_aSession[client].SCORE += g_PointsBombPickup;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombPickup > 0)
		if(!hidechat[client])	CPrintToChat(client, "%s %T", MSG, "BombPickup", client, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsBombPickup);
	
}

public Action Event_BombDropped(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_aStatsGlobal[client].SCORE -= g_PointsBombDropped;
	g_aStatsSeason[client].SCORE -= g_PointsBombDropped;
	
	/* Min points */
	if (g_bPointsMinEnabled)
	{
		if(g_aStatsGlobal[client].SCORE < g_PointsMin)
		{
			int diff = g_PointsMin - g_aStatsGlobal[client].SCORE;
			g_aStatsGlobal[client].SCORE = g_PointsMin;
			g_aSession[client].SCORE -= diff;
		}
		else{
			g_aSession[client].SCORE -= g_PointsBombDropped;
		}
		if(g_aStatsSeason[client].SCORE < g_PointsMin)
		{
			g_aStatsSeason[client].SCORE = g_PointsMin;
		}
	}
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombDropped > 0 && client == 0)
		if(!hidechat[client])	CPrintToChat(client, "%s %T", MSG, "BombDropped", client, g_aClientName[client], g_aStatsGlobal[client].SCORE, g_PointsBombDropped);
	
}

public Action EventPlayerDeath(Handle event, const char [] name, bool dontBroadcast)
// ----------------------------------------------------------------------------
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int assist = GetClientOfUserId(GetEventInt(event, "assister"));
	
	char weapon[64];
	GetEventString(event, "weapon", weapon, sizeof(weapon));
	ReplaceString(weapon, sizeof(weapon), "weapon_", "");

	if (!g_bRankBots && attacker != 0 && (IsFakeClient(victim) || IsFakeClient(attacker)))
		return;
	
	if (victim == attacker || attacker == 0) {
		g_aStatsGlobal[victim].SUICIDES++;
		g_aStatsSeason[victim].SUICIDES++;
		g_aSession[victim].SUICIDES++;
		g_aStatsGlobal[victim].SCORE -= g_PointsLoseSuicide;
		g_aStatsSeason[victim].SCORE -= g_PointsLoseSuicide;
		
		/* Min points */
		if (g_bPointsMinEnabled)
		{
			if(g_aStatsGlobal[victim].SCORE < g_PointsMin)
			{
				int diff = g_PointsMin - g_aStatsGlobal[victim].SCORE;
				g_aStatsGlobal[victim].SCORE = g_PointsMin;
				g_aSession[victim].SCORE -= diff;
			}
			else{
				g_aSession[victim].SCORE -= g_PointsLoseSuicide;
			}
			if(g_aStatsSeason[victim].SCORE < g_PointsMin)
			{
				g_aStatsSeason[victim].SCORE = g_PointsMin;
			}
		}
		
		if (g_PointsLoseSuicide > 0 && g_bChatChange) {
			if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "LostSuicide", victim, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_PointsLoseSuicide);
		}
		
	} 
	else if (!g_bFfa && (GetClientTeam(victim) == GetClientTeam(attacker))) {
		if (attacker < MAXPLAYERS) {
			g_aStatsGlobal[attacker].TK++;
			g_aStatsSeason[attacker].TK++;
			g_aSession[attacker].TK++;
			g_aStatsGlobal[attacker].SCORE -= g_PointsLoseTk;
			g_aStatsSeason[attacker].SCORE -= g_PointsLoseTk;
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if(g_aStatsGlobal[attacker].SCORE < g_PointsMin)
				{
					int diff = g_PointsMin - g_aStatsGlobal[attacker].SCORE;
					g_aStatsGlobal[attacker].SCORE = g_PointsMin;
					g_aSession[attacker].SCORE -= diff;
				}
				else{
					g_aSession[attacker].SCORE -= g_PointsLoseTk;
				}
				if(g_aStatsSeason[attacker].SCORE < g_PointsMin)
				{
					g_aStatsSeason[attacker].SCORE = g_PointsMin;
				}
			}
		
			if (g_PointsLoseTk > 0 && g_bChatChange) {
				if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "LostTK", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsLoseTk, g_aClientName[victim]);
				if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "LostTK", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsLoseTk, g_aClientName[victim]);
			}
		}
	} 
	else {
		int team = GetClientTeam(attacker);
		bool headshot = GetEventBool(event, "headshot");
		bool attackerblind = GetEventBool(event, "attackerblind");
		bool thrusmoke = GetEventBool(event, "thrusmoke");
		int penetrated = GetEventInt(event, "penetrated");
		
		/* knife */
		if (StrContains(weapon, "knife") != -1 ||  
			StrEqual(weapon, "bayonet") ||
			StrEqual(weapon, "melee") || 
			StrEqual(weapon, "axe") || 
			StrEqual(weapon, "hammer") || 
			StrEqual(weapon, "spanner") ||
			StrEqual(weapon, "fists"))		weapon = "knife";
		
		/* breachcharge has projectile */
		if (StrContains(weapon, "breachcharge") != -1) weapon = "breachcharge";
		
		/* firebomb = molotov */
		if (StrEqual(weapon, "firebomb")) weapon = "molotov";
		
		/* diversion = decoy, and decoy has projectile */
		if (StrContains(weapon, "diversion") != -1 || StrContains(weapon, "decoy") != -1) weapon = "decoy";
		
		int score_dif_global, score_dif_season;
		if (attacker < MAXPLAYERS)
		{
			score_dif_season = g_aStatsSeason[victim].SCORE - g_aStatsSeason[attacker].SCORE;
			score_dif_global = g_aStatsGlobal[victim].SCORE - g_aStatsGlobal[attacker].SCORE;
		}
			
		
		if (score_dif_global < 0 || attacker >= MAXPLAYERS) {
			score_dif_global = g_PointsKill[team];
		} else {
			if (g_PointsKillBonusDif[team] == 0)
				score_dif_global = g_PointsKill[team] + ((g_aStatsGlobal[victim].SCORE - g_aStatsGlobal[attacker].SCORE) * g_PointsKillBonus[team]);
			else
				score_dif_global = g_PointsKill[team] + (((g_aStatsGlobal[victim].SCORE - g_aStatsGlobal[attacker].SCORE) / g_PointsKillBonusDif[team]) * g_PointsKillBonus[team]);
		}

		if (score_dif_season < 0 || attacker >= MAXPLAYERS) {
			score_dif_season = g_PointsKill[team];
		} else {
			if (g_PointsKillBonusDif[team] == 0)
				score_dif_season = g_PointsKill[team] + ((g_aStatsSeason[victim].SCORE - g_aStatsSeason[attacker].SCORE) * g_PointsKillBonus[team]);
			else
				score_dif_season = g_PointsKill[team] + (((g_aStatsSeason[victim].SCORE - g_aStatsSeason[attacker].SCORE) / g_PointsKillBonusDif[team]) * g_PointsKillBonus[team]);
		}

		if (StrEqual(weapon, "knife")) {
			score_dif_global = RoundToCeil(score_dif_global * g_fPointsKnifeMultiplier);
		}
		else if (StrEqual(weapon, "taser")) {
			score_dif_global = RoundToCeil(score_dif_global * g_fPointsTaserMultiplier);
		}

		if (StrEqual(weapon, "knife")) {
			score_dif_season = RoundToCeil(score_dif_season * g_fPointsKnifeMultiplier);
		}
		else if (StrEqual(weapon, "taser")) {
			score_dif_season = RoundToCeil(score_dif_season * g_fPointsTaserMultiplier);
		}
		
		g_aStatsGlobal[victim].DEATHS++;
		g_aStatsSeason[victim].DEATHS++;
		g_aSession[victim].DEATHS++;
		if (attacker < MAXPLAYERS) {
			g_aStatsGlobal[attacker].KILLS++;
			g_aStatsSeason[attacker].KILLS++;
			g_aSession[attacker].KILLS++;
		}
		if (g_bPointsLoseRoundCeil) 
		{
			g_aStatsGlobal[victim].SCORE -= RoundToCeil(score_dif_global * g_fPercentPointsLose);
			g_aStatsSeason[victim].SCORE -= RoundToCeil(score_dif_season * g_fPercentPointsLose);
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if(g_aStatsGlobal[victim].SCORE < g_PointsMin)
				{
					int diff = g_PointsMin - g_aStatsGlobal[victim].SCORE;
					g_aStatsGlobal[victim].SCORE = g_PointsMin;
					g_aSession[victim].SCORE -= diff;
				}
				else{
					g_aSession[victim].SCORE -= RoundToCeil(score_dif_global * g_fPercentPointsLose);
				}
				if(g_aStatsSeason[victim].SCORE < g_PointsMin)
				{
					g_aStatsSeason[victim].SCORE = g_PointsMin;
				}
			}
		} 
		else 
		{
			g_aStatsGlobal[victim].SCORE -= RoundToFloor(score_dif_global * g_fPercentPointsLose);
			g_aStatsSeason[victim].SCORE -= RoundToFloor(score_dif_global * g_fPercentPointsLose);
			g_aSession[victim].SCORE -= RoundToFloor(score_dif_global * g_fPercentPointsLose);
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if(g_aStatsGlobal[victim].SCORE < g_PointsMin)
				{
					int diff = g_PointsMin - g_aStatsGlobal[victim].SCORE;
					g_aStatsGlobal[victim].SCORE = g_PointsMin;
					g_aSession[victim].SCORE -= diff;
				}
				else {
					g_aSession[victim].SCORE -= RoundToFloor(score_dif_global * g_fPercentPointsLose);
				}
				if(g_aStatsSeason[victim].SCORE < g_PointsMin)
				{
					g_aStatsSeason[victim].SCORE = g_PointsMin;
				}
			}
			
		}
		if (attacker < MAXPLAYERS) {
			g_aStatsGlobal[attacker].SCORE += score_dif_global;
			g_aStatsSeason[attacker].SCORE += score_dif_global;
			g_aSession[attacker].SCORE += score_dif_global;
			int num = GetWeaponNum(weapon); 
			if (num < 42){
				g_aWeaponsGlobal[attacker].AddKill(num);
				g_aWeaponsSeason[attacker].AddKill(num);
			}

		}
		
		if (g_MinimalKills == 0 || (g_aStatsGlobal[victim].KILLS >= g_MinimalKills && g_aStatsGlobal[attacker].KILLS >= g_MinimalKills)) {
			if (g_bChatChange) {
				//PrintToServer("%s %T",MSG,"Killing",g_aClientName[attacker],g_aStatsGlobal[attacker].SCORE,score_dif_global,g_aClientName[victim],g_aStatsGlobal[victim].SCORE);
				if(!hidechat[victim])	
				{
					CPrintToChat(victim, "%s %T", MSG, "Killing", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE);
				}
				if (attacker < MAXPLAYERS)
				{
					if(!hidechat[attacker])
					{
						CPrintToChat(attacker, "%s %T", MSG, "Killing", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE);
					}
				}
			}
		} else {
			if (g_aStatsGlobal[victim].KILLS < g_MinimalKills && g_aStatsGlobal[attacker].KILLS < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingBothNotRanked", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[attacker].KILLS, g_MinimalKills, g_aStatsGlobal[victim].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingBothNotRanked", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[attacker].KILLS, g_MinimalKills, g_aStatsGlobal[victim].KILLS, g_MinimalKills);
				}
			} else if (g_aStatsGlobal[victim].KILLS < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[victim].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[victim].KILLS, g_MinimalKills);
				}
			} else {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingKillerNotRanked", victim, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[attacker].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingKillerNotRanked", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, score_dif_global, g_aClientName[victim], g_aStatsGlobal[victim].SCORE, g_aStatsGlobal[attacker].KILLS, g_MinimalKills);
				}
			}
		}

		if (g_MinimalKills == 0 || (g_aStatsSeason[victim].KILLS >= g_MinimalKills && g_aStatsSeason[attacker].KILLS >= g_MinimalKills)) {
			if (g_bChatChange) {
				//PrintToServer("%s %T",MSG,"Killing",g_aClientName[attacker],g_aStatsSeason[attacker].SCORE,score_dif_season,g_aClientName[victim],g_aStatsSeason[victim].SCORE);
				if(!hidechat[victim])	
				{
					CPrintToChat(victim, "%s %T", MSG, "Killing", victim, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE);
				}
				if (attacker < MAXPLAYERS)
				{
					if(!hidechat[attacker])
					{
						CPrintToChat(attacker, "%s %T", MSG, "Killing", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE);
					}
				}
			}
		} else {
			if (g_aStatsSeason[victim].KILLS < g_MinimalKills && g_aStatsSeason[attacker].KILLS < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingBothNotRanked", victim, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[attacker].KILLS, g_MinimalKills, g_aStatsSeason[victim].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingBothNotRanked", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[attacker].KILLS, g_MinimalKills, g_aStatsSeason[victim].KILLS, g_MinimalKills);
				}
			} else if (g_aStatsSeason[victim].KILLS < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[victim].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[victim].KILLS, g_MinimalKills);
				}
			} else {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingKillerNotRanked", victim, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[attacker].KILLS, g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingKillerNotRanked", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, score_dif_season, g_aClientName[victim], g_aStatsSeason[victim].SCORE, g_aStatsSeason[attacker].KILLS, g_MinimalKills);
				}
			}
		}

		/* Headshot */
		if (headshot && attacker < MAXPLAYERS) {
			g_aStatsGlobal[attacker].HEADSHOTS++;
			g_aStatsSeason[attacker].HEADSHOTS++;
			g_aSession[attacker].HEADSHOTS++;
			g_aStatsGlobal[attacker].SCORE += g_PointsHs;
			g_aStatsSeason[attacker].SCORE += g_PointsHs;
			g_aSession[attacker].SCORE += g_PointsHs;
			if (g_bChatChange && g_PointsHs > 0)
			{
				if(!hidechat[attacker])
				{
					CPrintToChat(attacker, "%s %T", MSG, "Headshot", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsHs);
					CPrintToChat(attacker, "%s %T", MSG, "Headshot", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsHs);
				}
			}
					
		}

		if (attackerblind) {
			g_aStatsGlobal[attacker].BLIND++;
			g_aStatsSeason[attacker].BLIND++;
			g_aSession[attacker].BLIND++;
			g_aStatsGlobal[attacker].SCORE += g_PointsBlind;
			g_aStatsSeason[attacker].SCORE += g_PointsBlind;
			g_aSession[attacker].SCORE += g_PointsBlind;
			if (g_bChatChange && g_PointsBlind > 0)
			{
				if(!hidechat[attacker])
				{
					CPrintToChat(attacker, "%s %T", MSG, "Flashed Kill", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsBlind);
					CPrintToChat(attacker, "%s %T", MSG, "Flashed Kill", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsBlind);
				}
			}
				
		}

		if (thrusmoke) {
			g_aStatsGlobal[attacker].SMOKE++;
			g_aStatsSeason[attacker].SMOKE++;
			g_aSession[attacker].SMOKE++;
			g_aStatsGlobal[attacker].SCORE += g_PointsSmoke;
			g_aStatsSeason[attacker].SCORE += g_PointsSmoke;
			g_aSession[attacker].SCORE += g_PointsSmoke;
			if (g_bChatChange && g_PointsSmoke > 0)
			{
				if(!hidechat[attacker])
				{
					CPrintToChat(attacker, "%s %T", MSG, "Thru Smoke", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsSmoke);
					CPrintToChat(attacker, "%s %T", MSG, "Thru Smoke", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsSmoke);
				}
			}
					
		}

		if(penetrated > 0) {
			g_aStatsGlobal[attacker].WALL++;
			g_aStatsSeason[attacker].WALL++;
			g_aSession[attacker].WALL++;
			g_aStatsGlobal[attacker].SCORE += g_PointsWall;
			g_aStatsSeason[attacker].SCORE += g_PointsWall;
			g_aSession[attacker].SCORE += g_PointsWall;
			if (g_bChatChange && g_PointsWall > 0)
			{
				if(!hidechat[attacker])	
				{
					CPrintToChat(attacker, "%s %T", MSG, "Wallbang", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsWall);
					CPrintToChat(attacker, "%s %T", MSG, "Wallbang", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsWall);
				}
			}			
		}

		/* First blood */
		if (!firstblood && attacker < MAXPLAYERS) {
			
			g_aStatsGlobal[attacker].SCORE += g_PointsFb;
			g_aStatsSeason[attacker].SCORE += g_PointsFb;
			g_aSession[attacker].SCORE += g_PointsFb;
			
			g_aStatsGlobal[attacker].FB ++;
			g_aStatsSeason[attacker].FB ++;
			g_aSession[attacker].FB ++;
			if (g_bChatChange && g_PointsFb > 0)
			{
				if(!hidechat[attacker])
				{
					CPrintToChat(attacker, "%s %T", MSG, "First Blood", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsFb);
					CPrintToChat(attacker, "%s %T", MSG, "First Blood", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsFb);
				}
			}	
		}
		
		/* No scope */
		if( attacker < MAXPLAYERS && ((StrContains(weapon, "awp") != -1 || StrContains(weapon, "ssg08") != -1) || (g_bNSAllSnipers && (StrContains(weapon, "g3sg1") != -1 || StrContains(weapon, "scar20") != -1))) && (GetEntProp(attacker, Prop_Data, "m_iFOV") <= 0 || GetEntProp(attacker, Prop_Data, "m_iFOV") == GetEntProp(attacker, Prop_Data, "m_iDefaultFOV")))
		{
			g_aStatsGlobal[attacker].SCORE+= g_PointsNS;
			g_aStatsSeason[attacker].SCORE+= g_PointsNS;
			g_aSession[attacker].SCORE+= g_PointsNS;
			g_aStatsGlobal[attacker].NS++;
			g_aStatsSeason[attacker].NS++;
			g_aSession[attacker].NS++;
			
			float fNSD = Math_UnitsToMeters(Entity_GetDistance(victim, attacker));	
			
			// stats are int, so we change it from m to cm
			int iNSD = RoundToFloor(fNSD * 100);
			if(iNSD > g_aStatsGlobal[attacker].NSD) g_aStatsGlobal[attacker].NSD = iNSD;
			if(iNSD > g_aStatsSeason[attacker].NSD) g_aStatsSeason[attacker].NSD = iNSD;
			if(iNSD > g_aSession[attacker].NSD) g_aSession[attacker].NSD = iNSD;
			
			if(g_bChatChange && g_PointsNS > 0)
			{
				if(!hidechat[attacker])	
				{
					CPrintToChat(attacker, "%s %T", MSG, "No Scope", attacker, g_aClientName[attacker], g_aStatsGlobal[attacker].SCORE, g_PointsNS, g_aClientName[victim], weapon, fNSD);
					CPrintToChat(attacker, "%s %T", MSG, "No Scope", attacker, g_aClientName[attacker], g_aStatsSeason[attacker].SCORE, g_PointsNS, g_aClientName[victim], weapon, fNSD);
				}
			}
		}
	}
			
	/* Assist */
	if(assist && attacker < MAXPLAYERS)
	{
		bool assistedflash = GetEventBool(event, "assistedflash");

		/* Assist team kill */
		if(GetClientTeam(victim) == GetClientTeam(assist) && !g_bFfa)
		{
			if(assistedflash) {
				g_aStatsGlobal[assist].SCORE -= g_PointsAssistTeamFlash;
				g_aStatsSeason[assist].SCORE -= g_PointsAssistTeamFlash;
				g_aSession[assist].SCORE -= g_PointsAssistTeamFlash;
				g_aStatsGlobal[assist].ATF++;
				g_aStatsSeason[assist].ATF++;
				g_aSession[assist].ATF++;

				if(g_bChatChange && g_PointsAssistKill > 0)
				{
					if(!hidechat[assist])
					{
						CPrintToChat(assist, "%s %T", MSG, "AssistTeamFlash", assist, g_aClientName[assist], g_aStatsGlobal[assist].SCORE, g_PointsAssistTeamFlash, g_aClientName[attacker], g_aClientName[victim]);
						CPrintToChat(assist, "%s %T", MSG, "AssistTeamFlash", assist, g_aClientName[assist], g_aStatsSeason[assist].SCORE, g_PointsAssistTeamFlash, g_aClientName[attacker], g_aClientName[victim]);
					}	
				}
			}
			else {
				g_aStatsGlobal[assist].SCORE -= g_PointsLoseATk;
				g_aStatsSeason[assist].SCORE -= g_PointsLoseATk;
				g_aSession[assist].SCORE -= g_PointsLoseATk;
				g_aStatsGlobal[assist].ATK++;
				g_aStatsSeason[assist].ATK++;
				g_aSession[assist].ATK++;

				if(g_bChatChange && g_PointsAssistKill > 0){
					if(!hidechat[assist])
					{
						CPrintToChat(assist, "%s %T", MSG, "AssistTeamKill", assist, g_aClientName[assist], g_aStatsGlobal[assist].SCORE, g_PointsLoseATk, g_aClientName[attacker], g_aClientName[victim]);
						CPrintToChat(assist, "%s %T", MSG, "AssistTeamKill", assist, g_aClientName[assist], g_aStatsSeason[assist].SCORE, g_PointsLoseATk, g_aClientName[attacker], g_aClientName[victim]);
					}	
				}
			}
		}
		/* Assist kill */
		else
		{
			if(assistedflash) {
				g_aStatsGlobal[assist].SCORE += g_PointsAssistFlash;
				g_aStatsSeason[assist].SCORE += g_PointsAssistFlash;
				g_aSession[assist].SCORE += g_PointsAssistFlash;
				g_aStatsGlobal[assist].AF++;
				g_aStatsSeason[assist].AF++;
				g_aSession[assist].AF++;

				if(g_bChatChange && g_PointsAssistKill > 0)
				{
					if(!hidechat[assist])
					{
						CPrintToChat(assist, "%s %T", MSG, "AssistFlash", assist, g_aClientName[assist], g_aStatsGlobal[assist].SCORE, g_PointsAssistFlash, g_aClientName[attacker], g_aClientName[victim]);
						CPrintToChat(assist, "%s %T", MSG, "AssistFlash", assist, g_aClientName[assist], g_aStatsSeason[assist].SCORE, g_PointsAssistFlash, g_aClientName[attacker], g_aClientName[victim]);
					}	
				}
			}
			else {
				g_aStatsGlobal[assist].SCORE+= g_PointsAssistKill;
				g_aStatsSeason[assist].SCORE+= g_PointsAssistKill;
				g_aSession[assist].SCORE+= g_PointsAssistKill;
				g_aStatsGlobal[assist].ASSISTS++;
				g_aStatsSeason[assist].ASSISTS++;
				g_aSession[assist].ASSISTS++;
				
				if(g_bChatChange && g_PointsAssistKill > 0)
				{
					if(!hidechat[assist])
					{
						CPrintToChat(assist, "%s %T", MSG, "AssistKill", assist, g_aClientName[assist], g_aStatsGlobal[assist].SCORE, g_PointsAssistKill, g_aClientName[attacker], g_aClientName[victim]);
						CPrintToChat(assist, "%s %T", MSG, "AssistKill", assist, g_aClientName[assist], g_aStatsSeason[assist].SCORE, g_PointsAssistKill, g_aClientName[attacker], g_aClientName[victim]);
					}
				}
			}
		}
	}
	/*	
	if (attacker < MAXPLAYERS)
		if (g_aStatsGlobal[attacker].KILLS == 50)
		g_TotalPlayers++;
	*/	
	firstblood = true;
}

public Action EventPlayerHurt(Handle event, const char [] name, bool dontBroadcast)
// ----------------------------------------------------------------------------
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (!g_bRankBots && (attacker == 0 || IsFakeClient(victim) || IsFakeClient(attacker)))
		return;
		
	if (victim != attacker && attacker > 0 && attacker < MAXPLAYERS) {
		int hitgroup = GetEventInt(event, "hitgroup");
		if (hitgroup == 0) // Player was hit by knife, he, flashbang, or smokegrenade.
			return;
		
		if(hitgroup == 8) hitgroup = 1;
		
		g_aStatsGlobal[attacker].HITS++;
		g_aStatsSeason[attacker].HITS++;
		g_aSession[attacker].HITS++;
		switch(hitgroup) {
			case 1:
			{
				g_aHitBoxGlobal[attacker].HEAD++;
				g_aHitBoxSeason[attacker].HEAD++;
			}
			case 2:
			{
				g_aHitBoxGlobal[attacker].CHEST++;
				g_aHitBoxSeason[attacker].CHEST++;
			}
			case 3:
			{
				g_aHitBoxGlobal[attacker].STOMACH++;
				g_aHitBoxSeason[attacker].STOMACH++;
			}
			case 4:
			{
				g_aHitBoxGlobal[attacker].LEFT_ARM++;
				g_aHitBoxSeason[attacker].LEFT_ARM++;
			}
			case 5:
			{
				g_aHitBoxGlobal[attacker].RIGHT_ARM++;
				g_aHitBoxSeason[attacker].RIGHT_ARM++;
			}
			case 6:
			{
				g_aHitBoxGlobal[attacker].LEFT_LEG++;
				g_aHitBoxSeason[attacker].LEFT_LEG++;
			}
			case 7:
			{
				g_aHitBoxGlobal[attacker].RIGHT_LEG++;
				g_aHitBoxSeason[attacker].RIGHT_LEG++;
			}
		}
		
		int damage = GetEventInt(event, "dmg_health");
		g_aStatsGlobal[attacker].DAMAGE += damage;
		g_aStatsSeason[attacker].DAMAGE += damage;
		g_aSession[attacker].DAMAGE += damage;
		
		//PrintToChat(attacker, "Hitgroup %i: %i hits", hitgroup, g_aHitBoxGlobal[attacker][hitgroup]);
		//PrintToServer("Stats Hits: %i\nSession Hits: %i\nHitBox %i -> %i",g_aStatsGlobal[attacker].HITS,g_aSession[attacker].HITS,hitgroup,g_aHitBoxGlobal[attacker][hitgroup]);
	}
}

public Action EventWeaponFire(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
		
	// Don't count knife being used neither hegrenade, flashbang and smokegrenade being threw
	char sWeaponUsed[50];
	GetEventString(event, "weapon", sWeaponUsed, sizeof(sWeaponUsed));
	ReplaceString(sWeaponUsed, sizeof(sWeaponUsed), "weapon_", "");
	if (StrContains(sWeaponUsed, "knife") != -1 || 
		StrEqual(sWeaponUsed, "bayonet") || 
		StrEqual(sWeaponUsed, "melee") || 
		StrEqual(sWeaponUsed, "axe") || 
		StrEqual(sWeaponUsed, "hammer") || 
		StrEqual(sWeaponUsed, "spanner") || 
		StrEqual(sWeaponUsed, "fists") || 
		StrEqual(sWeaponUsed, "hegrenade") || 
		StrEqual(sWeaponUsed, "flashbang") || 
		StrEqual(sWeaponUsed, "smokegrenade") || 
		StrEqual(sWeaponUsed, "inferno") || 
		StrEqual(sWeaponUsed, "molotov") || 
		StrEqual(sWeaponUsed, "incgrenade") ||
		StrContains(sWeaponUsed, "decoy") != -1 ||
		StrEqual(sWeaponUsed, "firebomb") ||
		StrEqual(sWeaponUsed, "diversion") ||
		StrContains(sWeaponUsed, "breachcharge") != -1)
		return; 
	
	g_aStatsGlobal[client].SHOTS++;
	g_aStatsSeason[client].SHOTS++;
	g_aSession[client].SHOTS++;
}

public void SalvarPlayer(int client) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
	if (!OnDBGlobal[client])
		return;
	
	char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hStatsDb, g_aClientName[client], sEscapeName, sizeof(sEscapeName));
	//SQL_EscapeString(g_hStatsDb,name,name,sizeof(name));
	
	// Make SQL-safe
	//ReplaceString(name, sizeof(name), "'", "");
	
	char weapons_query[2000] = "";
	int weapon_array[42];
	g_aWeaponsGlobal[client].GetData(weapon_array);
	for (int i = 0; i < 42; i++) {
		Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], weapon_array[i]);
	}
	
	/* SM1.9 Fix*/
	char query[4000];
	char query2[4000];
	
	if (g_RankBy == 0) 
	{
		Format(query, sizeof(query), g_sSqlSaveGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
			g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, g_aClientSteam[client]);
	
		Format(query2, sizeof(query2), g_sSqlSave2Global, g_sSQLTableGlobal, g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
			g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
			g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
			g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD, 
			g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
			GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientSteam[client]);
	} 
	
	else if (g_RankBy == 1) 
	{
		Format(query, sizeof(query), g_sSqlSaveNameGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
			g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, sEscapeName);
	
		Format(query2, sizeof(query2), g_sSqlSaveName2Global, g_sSQLTableGlobal, g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
			g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
			g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
			g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD, 
			g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
			GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, sEscapeName);
	} 
	
	else if (g_RankBy == 2) 
	{
		Format(query, sizeof(query), g_sSqlSaveIpGlobal, g_sSQLTableGlobal, g_aStatsGlobal[client].SCORE, g_aStatsGlobal[client].KILLS, g_aStatsGlobal[client].DEATHS, g_aStatsGlobal[client].ASSISTS, g_aStatsGlobal[client].SUICIDES, g_aStatsGlobal[client].TK, 
			g_aStatsGlobal[client].SHOTS, g_aStatsGlobal[client].HITS, g_aStatsGlobal[client].HEADSHOTS, g_aStatsGlobal[client].ROUNDS_TR, g_aStatsGlobal[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxGlobal[client].HEAD, g_aHitBoxGlobal[client].CHEST, g_aHitBoxGlobal[client].STOMACH, g_aHitBoxGlobal[client].LEFT_ARM, g_aHitBoxGlobal[client].RIGHT_ARM, g_aHitBoxGlobal[client].LEFT_LEG, g_aHitBoxGlobal[client].RIGHT_LEG, g_aClientIp[client]);
	
		Format(query2, sizeof(query2), g_sSqlSaveIp2Global,  g_aStatsGlobal[client].C4_PLANTED, g_aStatsGlobal[client].C4_EXPLODED, g_aStatsGlobal[client].C4_DEFUSED, g_aStatsGlobal[client].CT_WIN, g_aStatsGlobal[client].TR_WIN, 
			g_aStatsGlobal[client].HOSTAGES_RESCUED, g_aStatsGlobal[client].VIP_KILLED, g_aStatsGlobal[client].VIP_ESCAPED, g_aStatsGlobal[client].VIP_PLAYED, g_aStatsGlobal[client].MVP, g_aStatsGlobal[client].DAMAGE, 
			g_aStatsGlobal[client].MATCH_WIN, g_aStatsGlobal[client].MATCH_DRAW, g_aStatsGlobal[client].MATCH_LOSE, 
			g_aStatsGlobal[client].FB, g_aStatsGlobal[client].NS, g_aStatsGlobal[client].NSD, 
			g_aStatsGlobal[client].SMOKE, g_aStatsGlobal[client].BLIND, g_aStatsGlobal[client].AF, g_aStatsGlobal[client].ATF, g_aStatsGlobal[client].ATK, g_aStatsGlobal[client].WALL,
			GetTime(), g_aStatsGlobal[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientIp[client]);
	}
	
	SQL_TQuery(g_hStatsDb, SQL_SaveCallback, query, client, DBPrio_High);
	SQL_TQuery(g_hStatsDb, SQL_SaveCallback, query2, client, DBPrio_High);
	
	if (DEBUGGING) {
		PrintToServer(query);
		PrintToServer(query2);
		LogError("%s", query);
		LogError("%s", query2);
	}

	g_aWeaponsSeason[client].GetData(weapon_array);
	for (int i = 0; i < 42; i++) {
		Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], weapon_array[i]);
	}

	if (g_RankBy == 0) 
	{
		Format(query, sizeof(query), g_sSqlSaveSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
			g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, g_aClientSteam[client]);
	
		Format(query2, sizeof(query2), g_sSqlSave2Season, g_sSQLTableSeason, g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
			g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
			g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
			g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD, 
			g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
			GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientSteam[client]);
	} 
	
	else if (g_RankBy == 1) 
	{
		Format(query, sizeof(query), g_sSqlSaveNameSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
			g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, sEscapeName);
	
		Format(query2, sizeof(query2), g_sSqlSaveName2Season, g_sSQLTableSeason, g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
			g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
			g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
			g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD, 
			g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
			GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, sEscapeName);
	} 
	
	else if (g_RankBy == 2) 
	{
		Format(query, sizeof(query), g_sSqlSaveIpSeason, g_sSQLTableSeason, g_aStatsSeason[client].SCORE, g_aStatsSeason[client].KILLS, g_aStatsSeason[client].DEATHS, g_aStatsSeason[client].ASSISTS, g_aStatsSeason[client].SUICIDES, g_aStatsSeason[client].TK, 
			g_aStatsSeason[client].SHOTS, g_aStatsSeason[client].HITS, g_aStatsSeason[client].HEADSHOTS, g_aStatsSeason[client].ROUNDS_TR, g_aStatsSeason[client].ROUNDS_CT, g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBoxSeason[client].HEAD, g_aHitBoxSeason[client].CHEST, g_aHitBoxSeason[client].STOMACH, g_aHitBoxSeason[client].LEFT_ARM, g_aHitBoxSeason[client].RIGHT_ARM, g_aHitBoxSeason[client].LEFT_LEG, g_aHitBoxSeason[client].RIGHT_LEG, g_aClientIp[client]);
	
		Format(query2, sizeof(query2), g_sSqlSaveIp2Season,  g_aStatsSeason[client].C4_PLANTED, g_aStatsSeason[client].C4_EXPLODED, g_aStatsSeason[client].C4_DEFUSED, g_aStatsSeason[client].CT_WIN, g_aStatsSeason[client].TR_WIN, 
			g_aStatsSeason[client].HOSTAGES_RESCUED, g_aStatsSeason[client].VIP_KILLED, g_aStatsSeason[client].VIP_ESCAPED, g_aStatsSeason[client].VIP_PLAYED, g_aStatsSeason[client].MVP, g_aStatsSeason[client].DAMAGE, 
			g_aStatsSeason[client].MATCH_WIN, g_aStatsSeason[client].MATCH_DRAW, g_aStatsSeason[client].MATCH_LOSE, 
			g_aStatsSeason[client].FB, g_aStatsSeason[client].NS, g_aStatsSeason[client].NSD, 
			g_aStatsSeason[client].SMOKE, g_aStatsSeason[client].BLIND, g_aStatsSeason[client].AF, g_aStatsSeason[client].ATF, g_aStatsSeason[client].ATK, g_aStatsSeason[client].WALL,
			GetTime(), g_aStatsSeason[client].CONNECTED + GetTime() - g_aSession[client].CONNECTED, g_aClientIp[client]);
	}
	
	SQL_TQuery(g_hStatsDb, SQL_SaveCallback, query, client, DBPrio_High);
	SQL_TQuery(g_hStatsDb, SQL_SaveCallback, query2, client, DBPrio_High);
	
	if (DEBUGGING) {
		PrintToServer(query);
		PrintToServer(query2);
		LogError("%s", query);
		LogError("%s", query2);
	}
}


public void SQL_SaveCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Save Player Fail: %s", error);
		return;
	}
	
	/**
		Start the forward OnPlayerSaved
	*/
	Action fResult;
	Call_StartForward(g_fwdOnPlayerSaved);
	Call_PushCell(client);
	int fError = Call_Finish(fResult);
	
	if (fError != SP_ERROR_NONE)
	{
		ThrowNativeError(fError, "Forward failed");
	}
	
}

public void OnClientPutInServer(int client) {
	
	// If the database isn't connected, you can't run SQL_EscapeString.
	if (g_hStatsDb != INVALID_HANDLE)
		LoadPlayer(client);
		
	// Cookie
	if(IsValidClient(client) && !IsFakeClient(client)){
		char buffer[5];
		GetClientCookie(client, hidechatcookie, buffer, sizeof(buffer));
		if(StrEqual(buffer, "") || StrEqual(buffer,"0"))	hidechat[client] = false;
		else if(StrEqual(buffer,"1"))	hidechat[client] = true;
	}
}

public void LoadPlayer(int client) {
	
	OnDBGlobal[client] = false;
	// stats
	g_aSession[client].Reset();
	g_aStatsGlobal[client].Reset();
	g_aStatsGlobal[client].SCORE = g_PointsStart;
	g_aStatsSeason[client].Reset();
	g_aStatsSeason[client].SCORE = g_PointsStart;
	// weapons
	g_aWeaponsGlobal[client].Reset();
	g_aWeaponsSeason[client].Reset();
	g_aSession[client].CONNECTED = GetTime();
	//hitboxes
	g_aHitBoxGlobal[client].Reset();
	g_aHitBoxSeason[client].Reset();
	
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	strcopy(g_aClientName[client], MAX_NAME_LENGTH, name);
	char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hStatsDb, name, sEscapeName, sizeof(sEscapeName));
	//ReplaceString(name, sizeof(name), "'", "");
	char auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
	strcopy(g_aClientSteam[client], sizeof(g_aClientSteam[]), auth);
	char ip[32];
	GetClientIP(client, ip, sizeof(ip));
	strcopy(g_aClientIp[client], sizeof(g_aClientIp[]), ip);
	char query[10000];
	char query2[10000];
	if (g_RankBy == 1){
		FormatEx(query, sizeof(query), g_sSqlRetrieveClientNameGlobal, g_sSQLTableGlobal, sEscapeName);
		FormatEx(query2, sizeof(query2), g_sSqlRetrieveClientNameSeason, g_sSQLTableSeason, g_iSeasonID, sEscapeName);
	}
	else if (g_RankBy == 0)
	{
		FormatEx(query, sizeof(query), g_sSqlRetrieveClientGlobal, g_sSQLTableGlobal, auth);
		FormatEx(query2, sizeof(query2), g_sSqlRetrieveClientSeason, g_sSQLTableSeason, g_iSeasonID, auth);
	}
		
	else if (g_RankBy == 2){
		FormatEx(query, sizeof(query), g_sSqlRetrieveClientIpGlobal, g_sSQLTableGlobal, ip);
		FormatEx(query2, sizeof(query2), g_sSqlRetrieveClientIpSeason, g_sSQLTableSeason, g_iSeasonID, ip);
	}

	
	if (DEBUGGING) {
		PrintToServer(query);
		LogError("%s", query);
		PrintToServer(query2);
		LogError("%s", query2);
	}
	if (g_hStatsDb != INVALID_HANDLE){
		SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallbackGlobal, query, client);
		SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallbackSeason, query2, client);
	}

}

public void SQL_LoadPlayerCallbackGlobal(Handle owner, Handle hndl, const char[] error, any client)
{
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
		
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Load Player Fail: %s", error);
		return;
	}
	if (!IsClientInGame(client))
		return;
	
	if (g_RankBy == 1) {
		char name[MAX_NAME_LENGTH];
		GetClientName(client, name, sizeof(name));
		if (!StrEqual(name, g_aClientName[client]))
			return;
	} else if (g_RankBy == 0) {
		char auth[64];
		GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
		if (!StrEqual(auth, g_aClientSteam[client]))
			return;
	} else if (g_RankBy == 2) {
		char ip[64];
		GetClientIP(client, ip, sizeof(ip));
		if (!StrEqual(ip, g_aClientIp[client]))
			return;
	}
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//Player infos
		g_aStatsGlobal[client].SCORE = SQL_FetchInt(hndl, 4);
		g_aStatsGlobal[client].KILLS = SQL_FetchInt(hndl, 5);
		g_aStatsGlobal[client].DEATHS = SQL_FetchInt(hndl, 6);
		g_aStatsGlobal[client].ASSISTS = SQL_FetchInt(hndl, 7);
		g_aStatsGlobal[client].SUICIDES = SQL_FetchInt(hndl, 8);
		g_aStatsGlobal[client].TK = SQL_FetchInt(hndl, 9);
		g_aStatsGlobal[client].SHOTS = SQL_FetchInt(hndl, 10);
		g_aStatsGlobal[client].HITS = SQL_FetchInt(hndl, 11);
		g_aStatsGlobal[client].HEADSHOTS = SQL_FetchInt(hndl, 12);
		g_aStatsGlobal[client].CONNECTED = SQL_FetchInt(hndl, 13);
		g_aStatsGlobal[client].ROUNDS_TR = SQL_FetchInt(hndl, 14);
		g_aStatsGlobal[client].ROUNDS_CT = SQL_FetchInt(hndl, 15);

		//Weapons
		g_aWeaponsGlobal[client].KNIFE = SQL_FetchInt(hndl, 17);
		g_aWeaponsGlobal[client].GLOCK = SQL_FetchInt(hndl, 18);
		g_aWeaponsGlobal[client].HKP2000 = SQL_FetchInt(hndl, 19);
		g_aWeaponsGlobal[client].USP_SILENCER = SQL_FetchInt(hndl, 20);
		g_aWeaponsGlobal[client].P250 = SQL_FetchInt(hndl, 21);
		g_aWeaponsGlobal[client].DEAGLE = SQL_FetchInt(hndl, 22);
		g_aWeaponsGlobal[client].ELITE = SQL_FetchInt(hndl, 23);
		g_aWeaponsGlobal[client].FIVESEVEN = SQL_FetchInt(hndl, 24);
		g_aWeaponsGlobal[client].TEC9 = SQL_FetchInt(hndl, 25);
		g_aWeaponsGlobal[client].CZ75A = SQL_FetchInt(hndl, 26);
		g_aWeaponsGlobal[client].REVOLVER = SQL_FetchInt(hndl, 27);
		g_aWeaponsGlobal[client].NOVA = SQL_FetchInt(hndl, 28);
		g_aWeaponsGlobal[client].XM1014 = SQL_FetchInt(hndl, 29);
		g_aWeaponsGlobal[client].MAG7 = SQL_FetchInt(hndl, 30);
		g_aWeaponsGlobal[client].SAWEDOFF = SQL_FetchInt(hndl, 31);
		g_aWeaponsGlobal[client].BIZON = SQL_FetchInt(hndl, 32);
		g_aWeaponsGlobal[client].MAC10 = SQL_FetchInt(hndl, 33);
		g_aWeaponsGlobal[client].MP9 = SQL_FetchInt(hndl, 34);
		g_aWeaponsGlobal[client].MP7 = SQL_FetchInt(hndl, 35);
		g_aWeaponsGlobal[client].UMP45 = SQL_FetchInt(hndl, 36);
		g_aWeaponsGlobal[client].P90 = SQL_FetchInt(hndl, 37);
		g_aWeaponsGlobal[client].GALILAR = SQL_FetchInt(hndl, 38);
		g_aWeaponsGlobal[client].AK47 = SQL_FetchInt(hndl, 39);
		g_aWeaponsGlobal[client].SCAR20 = SQL_FetchInt(hndl, 40);
		g_aWeaponsGlobal[client].FAMAS = SQL_FetchInt(hndl, 41);
		g_aWeaponsGlobal[client].M4A1 = SQL_FetchInt(hndl, 42);
		g_aWeaponsGlobal[client].M4A1_SILENCER = SQL_FetchInt(hndl, 43);
		g_aWeaponsGlobal[client].AUG = SQL_FetchInt(hndl, 44);
		g_aWeaponsGlobal[client].SSG08 = SQL_FetchInt(hndl, 45);
		g_aWeaponsGlobal[client].SG556 = SQL_FetchInt(hndl, 46);
		g_aWeaponsGlobal[client].AWP = SQL_FetchInt(hndl, 47);
		g_aWeaponsGlobal[client].G3SG1 = SQL_FetchInt(hndl, 48);
		g_aWeaponsGlobal[client].M249 = SQL_FetchInt(hndl, 49);
		g_aWeaponsGlobal[client].NEGEV = SQL_FetchInt(hndl, 50);
		g_aWeaponsGlobal[client].HEGRENADE = SQL_FetchInt(hndl, 51);
		g_aWeaponsGlobal[client].FLASHBANG = SQL_FetchInt(hndl, 52);
		g_aWeaponsGlobal[client].SMOKEGRENADE = SQL_FetchInt(hndl, 53);
		g_aWeaponsGlobal[client].INFERNO = SQL_FetchInt(hndl, 54);
		g_aWeaponsGlobal[client].DECOY = SQL_FetchInt(hndl, 55);
		g_aWeaponsGlobal[client].TASER = SQL_FetchInt(hndl, 56);
		g_aWeaponsGlobal[client].MP5SD = SQL_FetchInt(hndl, 57);
		g_aWeaponsGlobal[client].BREACHCHARGE = SQL_FetchInt(hndl, 58);
		
		//ALL 8 Hitboxes
		g_aHitBoxGlobal[client].HEAD = SQL_FetchInt(hndl, 59);
		g_aHitBoxGlobal[client].CHEST = SQL_FetchInt(hndl, 60);
		g_aHitBoxGlobal[client].STOMACH = SQL_FetchInt(hndl, 61);
		g_aHitBoxGlobal[client].LEFT_ARM = SQL_FetchInt(hndl, 62);
		g_aHitBoxGlobal[client].RIGHT_ARM = SQL_FetchInt(hndl, 63);
		g_aHitBoxGlobal[client].LEFT_LEG = SQL_FetchInt(hndl, 64);
		g_aHitBoxGlobal[client].RIGHT_LEG = SQL_FetchInt(hndl, 65);
		
		// other stats
		g_aStatsGlobal[client].C4_PLANTED = SQL_FetchInt(hndl, 66);
		g_aStatsGlobal[client].C4_EXPLODED = SQL_FetchInt(hndl, 67);
		g_aStatsGlobal[client].C4_DEFUSED = SQL_FetchInt(hndl, 68);
		g_aStatsGlobal[client].CT_WIN = SQL_FetchInt(hndl, 69);
		g_aStatsGlobal[client].TR_WIN = SQL_FetchInt(hndl, 70);
		g_aStatsGlobal[client].HOSTAGES_RESCUED = SQL_FetchInt(hndl, 71);
		g_aStatsGlobal[client].VIP_KILLED = SQL_FetchInt(hndl, 72);
		g_aStatsGlobal[client].VIP_ESCAPED = SQL_FetchInt(hndl, 73);
		g_aStatsGlobal[client].VIP_PLAYED = SQL_FetchInt(hndl, 74);
		g_aStatsGlobal[client].MVP = SQL_FetchInt(hndl, 75);
		g_aStatsGlobal[client].DAMAGE = SQL_FetchInt(hndl, 76);
		g_aStatsGlobal[client].MATCH_WIN = SQL_FetchInt(hndl, 77);
		g_aStatsGlobal[client].MATCH_DRAW = SQL_FetchInt(hndl, 78);
		g_aStatsGlobal[client].MATCH_LOSE = SQL_FetchInt(hndl, 79);
		g_aStatsGlobal[client].FB = SQL_FetchInt(hndl, 80);
		g_aStatsGlobal[client].NS = SQL_FetchInt(hndl, 81);
		g_aStatsGlobal[client].NSD = SQL_FetchInt(hndl, 82);
		g_aStatsGlobal[client].SMOKE = SQL_FetchInt(hndl, 83);
		g_aStatsGlobal[client].BLIND = SQL_FetchInt(hndl, 84);
		g_aStatsGlobal[client].AF = SQL_FetchInt(hndl, 85);
		g_aStatsGlobal[client].ATF = SQL_FetchInt(hndl, 86);
		g_aStatsGlobal[client].ATK = SQL_FetchInt(hndl, 87);
		g_aStatsGlobal[client].WALL = SQL_FetchInt(hndl, 88);
	} else {
		char query[10000];
		char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
		SQL_EscapeString(g_hStatsDb, g_aClientName[client], sEscapeName, sizeof(sEscapeName));
		//SQL_EscapeString(g_hStatsDb,name,name,sizeof(name));
		//ReplaceString(name, sizeof(name), "'", "");
		
		Format(query, sizeof(query), g_sSqlInsertGlobal, g_sSQLTableGlobal, g_aClientSteam[client], sEscapeName, g_aClientIp[client], g_PointsStart);
		SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query, _, DBPrio_High);
		
		if (DEBUGGING) {
			PrintToServer(query);
			LogError("%s", query);
		}
	}

	OnDBGlobal[client] = true;
	/**
	Start the forward OnPlayerLoaded
	*/
	Action fResult;
	Call_StartForward(g_fwdOnPlayerLoaded);
	Call_PushCell(client);
	int fError = Call_Finish(fResult);
	
	if (fError != SP_ERROR_NONE)
	{
		ThrowNativeError(fError, "Forward failed");
	}
}

public void SQL_LoadPlayerCallbackSeason(Handle owner, Handle hndl, const char[] error, any client)
{
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
		
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Load Player Season Fail: %s", error);
		return;
	}
	if (!IsClientInGame(client))
		return;
	
	if (g_RankBy == 1) {
		char name[MAX_NAME_LENGTH];
		GetClientName(client, name, sizeof(name));
		if (!StrEqual(name, g_aClientName[client]))
			return;
	} else if (g_RankBy == 0) {
		char auth[64];
		GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
		if (!StrEqual(auth, g_aClientSteam[client]))
			return;
	} else if (g_RankBy == 2) {
		char ip[64];
		GetClientIP(client, ip, sizeof(ip));
		if (!StrEqual(ip, g_aClientIp[client]))
			return;
	}
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//Player infos
		g_aStatsSeason[client].SCORE = SQL_FetchInt(hndl, 5);
		g_aStatsSeason[client].KILLS = SQL_FetchInt(hndl, 6);
		g_aStatsSeason[client].DEATHS = SQL_FetchInt(hndl, 7);
		g_aStatsSeason[client].ASSISTS = SQL_FetchInt(hndl, 8);
		g_aStatsSeason[client].SUICIDES = SQL_FetchInt(hndl, 9);
		g_aStatsSeason[client].TK = SQL_FetchInt(hndl, 10);
		g_aStatsSeason[client].SHOTS = SQL_FetchInt(hndl, 11);
		g_aStatsSeason[client].HITS = SQL_FetchInt(hndl, 12);
		g_aStatsSeason[client].HEADSHOTS = SQL_FetchInt(hndl, 13);
		g_aStatsSeason[client].CONNECTED = SQL_FetchInt(hndl, 14);
		g_aStatsSeason[client].ROUNDS_TR = SQL_FetchInt(hndl, 15);
		g_aStatsSeason[client].ROUNDS_CT = SQL_FetchInt(hndl, 16);

		//Weapons
		g_aWeaponsSeason[client].KNIFE = SQL_FetchInt(hndl, 18);
		g_aWeaponsSeason[client].GLOCK = SQL_FetchInt(hndl, 19);
		g_aWeaponsSeason[client].HKP2000 = SQL_FetchInt(hndl, 20);
		g_aWeaponsSeason[client].USP_SILENCER = SQL_FetchInt(hndl, 21);
		g_aWeaponsSeason[client].P250 = SQL_FetchInt(hndl, 22);
		g_aWeaponsSeason[client].DEAGLE = SQL_FetchInt(hndl, 23);
		g_aWeaponsSeason[client].ELITE = SQL_FetchInt(hndl, 24);
		g_aWeaponsSeason[client].FIVESEVEN = SQL_FetchInt(hndl, 25);
		g_aWeaponsSeason[client].TEC9 = SQL_FetchInt(hndl, 26);
		g_aWeaponsSeason[client].CZ75A = SQL_FetchInt(hndl, 27);
		g_aWeaponsSeason[client].REVOLVER = SQL_FetchInt(hndl, 28);
		g_aWeaponsSeason[client].NOVA = SQL_FetchInt(hndl, 29);
		g_aWeaponsSeason[client].XM1014 = SQL_FetchInt(hndl, 30);
		g_aWeaponsSeason[client].MAG7 = SQL_FetchInt(hndl, 31);
		g_aWeaponsSeason[client].SAWEDOFF = SQL_FetchInt(hndl, 32);
		g_aWeaponsSeason[client].BIZON = SQL_FetchInt(hndl, 33);
		g_aWeaponsSeason[client].MAC10 = SQL_FetchInt(hndl, 34);
		g_aWeaponsSeason[client].MP9 = SQL_FetchInt(hndl, 35);
		g_aWeaponsSeason[client].MP7 = SQL_FetchInt(hndl, 36);
		g_aWeaponsSeason[client].UMP45 = SQL_FetchInt(hndl, 37);
		g_aWeaponsSeason[client].P90 = SQL_FetchInt(hndl, 38);
		g_aWeaponsSeason[client].GALILAR = SQL_FetchInt(hndl, 39);
		g_aWeaponsSeason[client].AK47 = SQL_FetchInt(hndl, 40);
		g_aWeaponsSeason[client].SCAR20 = SQL_FetchInt(hndl, 41);
		g_aWeaponsSeason[client].FAMAS = SQL_FetchInt(hndl, 42);
		g_aWeaponsSeason[client].M4A1 = SQL_FetchInt(hndl, 43);
		g_aWeaponsSeason[client].M4A1_SILENCER = SQL_FetchInt(hndl, 44);
		g_aWeaponsSeason[client].AUG = SQL_FetchInt(hndl, 45);
		g_aWeaponsSeason[client].SSG08 = SQL_FetchInt(hndl, 46);
		g_aWeaponsSeason[client].SG556 = SQL_FetchInt(hndl, 47);
		g_aWeaponsSeason[client].AWP = SQL_FetchInt(hndl, 48);
		g_aWeaponsSeason[client].G3SG1 = SQL_FetchInt(hndl, 49);
		g_aWeaponsSeason[client].M249 = SQL_FetchInt(hndl, 50);
		g_aWeaponsSeason[client].NEGEV = SQL_FetchInt(hndl, 51);
		g_aWeaponsSeason[client].HEGRENADE = SQL_FetchInt(hndl, 52);
		g_aWeaponsSeason[client].FLASHBANG = SQL_FetchInt(hndl, 53);
		g_aWeaponsSeason[client].SMOKEGRENADE = SQL_FetchInt(hndl, 54);
		g_aWeaponsSeason[client].INFERNO = SQL_FetchInt(hndl, 55);
		g_aWeaponsSeason[client].DECOY = SQL_FetchInt(hndl, 56);
		g_aWeaponsSeason[client].TASER = SQL_FetchInt(hndl, 57);
		g_aWeaponsSeason[client].MP5SD = SQL_FetchInt(hndl, 58);
		g_aWeaponsSeason[client].BREACHCHARGE = SQL_FetchInt(hndl, 59);
		
		//ALL 8 Hitboxes
		g_aHitBoxSeason[client].HEAD = SQL_FetchInt(hndl, 60);
		g_aHitBoxSeason[client].CHEST = SQL_FetchInt(hndl, 61);
		g_aHitBoxSeason[client].STOMACH = SQL_FetchInt(hndl, 62);
		g_aHitBoxSeason[client].LEFT_ARM = SQL_FetchInt(hndl, 63);
		g_aHitBoxSeason[client].RIGHT_ARM = SQL_FetchInt(hndl, 64);
		g_aHitBoxSeason[client].LEFT_LEG = SQL_FetchInt(hndl, 65);
		g_aHitBoxSeason[client].RIGHT_LEG = SQL_FetchInt(hndl, 66);
		
		// other stats
		g_aStatsSeason[client].C4_PLANTED = SQL_FetchInt(hndl, 67);
		g_aStatsSeason[client].C4_EXPLODED = SQL_FetchInt(hndl, 68);
		g_aStatsSeason[client].C4_DEFUSED = SQL_FetchInt(hndl, 69);
		g_aStatsSeason[client].CT_WIN = SQL_FetchInt(hndl, 70);
		g_aStatsSeason[client].TR_WIN = SQL_FetchInt(hndl, 71);
		g_aStatsSeason[client].HOSTAGES_RESCUED = SQL_FetchInt(hndl, 72);
		g_aStatsSeason[client].VIP_KILLED = SQL_FetchInt(hndl, 73);
		g_aStatsSeason[client].VIP_ESCAPED = SQL_FetchInt(hndl, 74);
		g_aStatsSeason[client].VIP_PLAYED = SQL_FetchInt(hndl, 75);
		g_aStatsSeason[client].MVP = SQL_FetchInt(hndl, 76);
		g_aStatsSeason[client].DAMAGE = SQL_FetchInt(hndl, 77);
		g_aStatsSeason[client].MATCH_WIN = SQL_FetchInt(hndl, 78);
		g_aStatsSeason[client].MATCH_DRAW = SQL_FetchInt(hndl, 79);
		g_aStatsSeason[client].MATCH_LOSE = SQL_FetchInt(hndl, 80);
		g_aStatsSeason[client].FB = SQL_FetchInt(hndl, 81);
		g_aStatsSeason[client].NS = SQL_FetchInt(hndl, 82);
		g_aStatsSeason[client].NSD = SQL_FetchInt(hndl, 83);
		g_aStatsSeason[client].SMOKE = SQL_FetchInt(hndl, 84);
		g_aStatsSeason[client].BLIND = SQL_FetchInt(hndl, 85);
		g_aStatsSeason[client].AF = SQL_FetchInt(hndl, 86);
		g_aStatsSeason[client].ATF = SQL_FetchInt(hndl, 87);
		g_aStatsSeason[client].ATK = SQL_FetchInt(hndl, 88);
		g_aStatsSeason[client].WALL = SQL_FetchInt(hndl, 89);
	} else {
		char query[10000];
		char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
		SQL_EscapeString(g_hStatsDb, g_aClientName[client], sEscapeName, sizeof(sEscapeName));
		//SQL_EscapeString(g_hStatsDb,name,name,sizeof(name));
		//ReplaceString(name, sizeof(name), "'", "");
		
		Format(query, sizeof(query), g_sSqlInsertSeason, g_sSQLTableSeason, g_iSeasonID, g_aClientSteam[client], sEscapeName, g_aClientIp[client], g_PointsStart);
		SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query, _, DBPrio_High);
		
		if (DEBUGGING) {
			PrintToServer(query);
			LogError("%s", query);
		}
	}
	OnDBSeason[client] = true;
}

public void SQL_PurgeCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	
	PrintToServer("[RankMe]: %d players purged by inactivity", SQL_GetAffectedRows(owner));
	if (client != 0) {
		PrintToChat(client, "[RankMe]: %d players purged by inactivity", SQL_GetAffectedRows(owner));
	}
	//LogAction(-1,-1,"[RankMe]: %d players purged by inactivity",SQL_GetAffectedRows(owner));
	
}

public void SQL_NothingCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
}

public void OnClientDisconnect(int client) {
	if (!g_bEnabled)
		return;
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
	SalvarPlayer(client);
	OnDBGlobal[client] = false;
	OnDBSeason[client] = false;
}

public void DumpDB() {
	if (!g_bDumpDB || g_bMysql)
		return;
	char sQuery[1000];
	FormatEx(sQuery, sizeof(sQuery), "SELECT * from `%s`", g_sSQLTableGlobal);
	SQL_TQuery(g_hStatsDb, SQL_DumpCallback, sQuery);
}

public void SQL_DumpCallback(Handle owner, Handle hndl, const char[] error, any Datapack) {
	
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	
	Handle File1;
	char fields_values[600];
	char field[100];
	char prepared_field[200];
	
	fields_values[0] = 0;
	
	File1 = OpenFile("rank.sql", "w");
	if (File1 == INVALID_HANDLE) {
		
		LogError("[RankMe] Unable to open dump file.");
		
	}
	int fields = SQL_GetFieldCount(hndl);
	bool first;
	
	if(g_bMysql)
	{
		WriteFileLine(File1, g_sMysqlCreateGlobal, g_sSQLTableGlobal);
		WriteFileLine(File1, "");
	}
	
	if(!g_bMysql)
	{
		WriteFileLine(File1, g_sSqliteCreateGlobal, g_sSQLTableGlobal);
		WriteFileLine(File1, "");
	}
	
	while (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		field = "";
		fields_values = "";
		first = true;
		for (int i = 0; i <= fields - 1; i++) {
			SQL_FetchString(hndl, i, field, sizeof(field));
			// ReplaceString(field, sizeof(field), "\\","\\\\",false);
			// ReplaceString(field,sizeof(field),"\"", "\\\"", false);
			SQL_EscapeString(g_hStatsDb, field, prepared_field, sizeof(prepared_field));
			
			if (first) {
				Format(fields_values, sizeof(fields_values), "\"%s\"", prepared_field);
				first = false;
			}
			else
				Format(fields_values, sizeof(fields_values), "%s,\"%s\"", fields_values, prepared_field);
		}
		
		WriteFileLine(File1, "INSERT INTO `%s` VALUES (%s);", g_sSQLTableGlobal, fields_values);
	}
	CloseHandle(File1);
}

stock bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

stock void MakeSelectQuery(char[] sQuery, int strsize) {
	
	// Make basic query
	Format(sQuery, strsize, "SELECT * FROM `%s` WHERE kills >= '%d'", g_sSQLTableGlobal, g_MinimalKills);
	
	// Append check for bots
	if (!g_bShowBotsOnRank)
		Format(sQuery, strsize, "%s AND steam <> 'BOT'", sQuery);
	
	// Append check for inactivity
	if (g_DaysToNotShowOnRank > 0)
		Format(sQuery, strsize, "%s AND lastconnect >= '%d'", sQuery, GetTime() - (g_DaysToNotShowOnRank * 86400));
} 

public Action RankMe_OnPlayerLoaded(int client){

	/*RankMe Connect Announcer*/
	if(!g_bAnnounceConnect && !g_bAnnounceTopConnect)
		return Plugin_Handled;
	
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return Plugin_Handled;
	
	RankMe_GetRank(client, RankConnectCallback);
	
	return Plugin_Continue;
}

public Action RankConnectCallback(int client, int rank, any data)
{
	
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
		
	g_aPointsOnConnect[client] = RankMe_GetPoints(client);
	
	g_aRankOnConnect[client] = rank;
		
	char sClientName[MAX_NAME_LENGTH];
	GetClientName(client,sClientName,sizeof(sClientName));
	
	/* Geoip, code from cksurf */
	char s_Country[32];
	char s_address[32];		
	GetClientIP(client, s_address, 32);
	Format(s_Country, sizeof(s_Country), "Unknown");
	GeoipCountry(s_address, s_Country, sizeof(s_Country));
	// if(!strcmp(s_Country, NULL_STRING))
	if (s_Country[0] == 0)
		Format( s_Country, sizeof(s_Country), "Unknown", s_Country );
	else				
		if( StrContains( s_Country, "United", false ) != -1 || 
			StrContains( s_Country, "Republic", false ) != -1 || 
			StrContains( s_Country, "Federation", false ) != -1 || 
			StrContains( s_Country, "Island", false ) != -1 || 
			StrContains( s_Country, "Netherlands", false ) != -1 || 
			StrContains( s_Country, "Isle", false ) != -1 || 
			StrContains( s_Country, "Bahamas", false ) != -1 || 
			StrContains( s_Country, "Maldives", false ) != -1 || 
			StrContains( s_Country, "Philippines", false ) != -1 || 
			StrContains( s_Country, "Vatican", false ) != -1 )
		{
			Format( s_Country, sizeof(s_Country), "The %s", s_Country );
		}			
	
	if(!ShouldHideAnnounce(client))
	{
		if(g_bAnnounceConnect){
			if(g_bAnnounceConnectChat){
				CPrintToChatAll("%s %t",MSG,"PlayerJoinedChat",sClientName,g_aRankOnConnect[client],g_aPointsOnConnect[client],s_Country);
			}
			
			if(g_bAnnounceConnectHint){
				PrintHintTextToAll("%t","PlayerJoinedHint",sClientName,g_aRankOnConnect[client],g_aPointsOnConnect[client],s_Country);		
			}
		}
		
		if(g_bAnnounceTopConnect && rank <= g_AnnounceTopPosConnect){
			
			if(g_bAnnounceTopConnectChat){	
				CPrintToChatAll("%s %t",MSG,"TopPlayerJoinedChat",g_AnnounceTopPosConnect,sClientName,g_aRankOnConnect[client],s_Country);			
			}
			
			if(g_bAnnounceTopConnectHint){
				PrintHintTextToAll("%t","TopPlayerJoinedHint",g_AnnounceTopPosConnect,sClientName,g_aRankOnConnect[client],s_Country);
			}
		}
	}
}

public Action Event_PlayerDisconnect(Handle event, const char[] name, bool dontBroadcast)
{
	if(!g_bAnnounceDisconnect)
		return;

	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(ShouldHideAnnounce(client))	return;
	
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || !g_bRankBots)
		return;
	
	char sName[MAX_NAME_LENGTH];
	GetClientName(client,sName,MAX_NAME_LENGTH);
	strcopy(g_sBufferClientName[client],MAX_NAME_LENGTH,sName);
	
	g_aPointsOnDisconnect[client] = RankMe_GetPoints(client);
	
	char disconnectReason[64];
	GetEventString(event, "reason", disconnectReason, sizeof(disconnectReason));
	
	CPrintToChatAll("%s %t",MSG,"PlayerLeft",g_sBufferClientName[client], g_aPointsOnDisconnect[client], disconnectReason);
}

/* Enable Or Disable Points In Warmup */
public void OnGameFrame()
{
	//If cvar disable
	if(!g_bGatherStatsWarmup)
	{
		//In Warmup
		if(GameRules_GetProp("m_bWarmupPeriod") == 1)
		{
			g_bGatherStats = false;
		}
		
		//Not in warmup
		else 
		{
			g_bGatherStats = true;
		}
	}	
}

public Action Event_WinPanelMatch(Handle event, const char[] name, bool dontBroadcast) {
	if(CS_GetTeamScore(CT) > CS_GetTeamScore(TR))
	{
		for(int i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i))
			{
				if(!hidechat[i])
				{
					CPrintToChat(i, "%T", "CT_Win", i, g_PointsMatchWin);
					CPrintToChat(i, "%T", "TR_Lose", i, g_PointsMatchLose);
				}
				
				if(GetClientTeam(i) == TR)
				{
					g_aStatsGlobal[i].MATCH_LOSE++;
					g_aStatsSeason[i].MATCH_LOSE++;
					g_aStatsGlobal[i].SCORE -= g_PointsMatchLose;
					g_aStatsSeason[i].SCORE -= g_PointsMatchLose;

					/* Min points */
					if (g_bPointsMinEnabled)
					{
						if(g_aStatsGlobal[i].SCORE < g_PointsMin)
						{
							int diff = g_PointsMin - g_aStatsGlobal[i].SCORE;
							g_aStatsGlobal[i].SCORE = g_PointsMin;
							g_aSession[i].SCORE -= diff;
						}
						else{
							g_aSession[i].SCORE -= g_PointsMatchLose;
						}
						if(g_aStatsSeason[i].SCORE < g_PointsMin)
						{
							g_aStatsSeason[i].SCORE = g_PointsMin;
						}
					}
				}
				else if (GetClientTeam(i) == CT)
				{
					g_aStatsGlobal[i].MATCH_WIN++;
					g_aStatsSeason[i].MATCH_WIN++;
					g_aStatsGlobal[i].SCORE += g_PointsMatchWin;
					g_aStatsSeason[i].SCORE += g_PointsMatchWin;
					g_aSession[i].SCORE += g_PointsMatchWin;
				}
			}
		}
	}
	
	else if(CS_GetTeamScore(CT) == CS_GetTeamScore(TR))
	{
		for(int i=1;i<=MaxClients;i++)
		{
			if (IsClientInGame(i) && (GetClientTeam(i) == TR || GetClientTeam(i) == CT))
			{
				g_aStatsGlobal[i].MATCH_DRAW++;
				g_aStatsSeason[i].MATCH_DRAW++;
				g_aStatsGlobal[i].SCORE += g_PointsMatchDraw;
				g_aStatsSeason[i].SCORE += g_PointsMatchDraw;
				g_aSession[i].SCORE += g_PointsMatchDraw;
				
				if(!hidechat[i])	CPrintToChat(i, "%T", "Draw", i, g_PointsMatchDraw);
			}
		}
	}
	
	else if(CS_GetTeamScore(CT) < CS_GetTeamScore(TR))
	{
		for(int i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i))
			{
				if(!hidechat[i])
				{
					CPrintToChat(i, "%s %T", MSG, "TR_Win", i, g_PointsMatchWin);
					CPrintToChat(i, "%s %T", MSG, "CT_Lose", i, g_PointsMatchLose);
				}
				
				if(GetClientTeam(i) == TR)
				{
					g_aStatsGlobal[i].MATCH_WIN++;
					g_aStatsSeason[i].MATCH_WIN++;
					g_aStatsGlobal[i].SCORE += g_PointsMatchWin;
					g_aStatsSeason[i].SCORE += g_PointsMatchWin;
					g_aSession[i].SCORE += g_PointsMatchWin;
				}
				else if (GetClientTeam(i) == CT)
				{
					g_aStatsGlobal[i].MATCH_LOSE++;
					g_aStatsSeason[i].MATCH_LOSE++;
					g_aStatsGlobal[i].SCORE -= g_PointsMatchLose;
					g_aStatsSeason[i].SCORE -= g_PointsMatchLose;

					/* Min points */
					if (g_bPointsMinEnabled)
					{
						if(g_aStatsGlobal[i].SCORE < g_PointsMin)
						{
							int diff = g_PointsMin - g_aStatsGlobal[i].SCORE;
							g_aStatsGlobal[i].SCORE = g_PointsMin;
							g_aSession[i].SCORE -= diff;
						}
						else{
						g_aSession[i].SCORE -= g_PointsMatchLose;
						}
						if(g_aStatsSeason[i].SCORE < g_PointsMin)
						{
							g_aStatsSeason[i].SCORE = g_PointsMin;
						}
					}
				}
			}
		}
	}
}

stock bool ShouldHideAnnounce(int client)
{
	if(StrEqual(g_sAnnounceAdmin, "") || StrEqual(g_sAnnounceAdmin, " "))	return false;
	else
	{
		if (CheckCommandAccess(client, "rankme_admin", ReadFlagString(g_sAnnounceAdmin), true))	return true;
		else return false;
	}
}

public Action CMD_Duplicate(int client, int args) {
	char sQuery[400];
	
	if (g_bMysql) {
		
		if (g_RankBy == 0)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateMySQL, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
		else if (g_RankBy == 1)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateNameMySQL, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
		else if (g_RankBy == 2)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateIpMySQL, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
	} else {
		
		if (g_RankBy == 0)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateSQLite, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
		else if (g_RankBy == 1)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateNameSQLite, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
		else if (g_RankBy == 2)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateIpSQLite, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal, g_sSQLTableGlobal);
		
	}
	
	SQL_TQuery(g_hStatsDb, SQL_DuplicateCallback, sQuery, client);
	
	return Plugin_Handled;
}

public void SQL_DuplicateCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	
	PrintToServer("[RankMe]: %d duplicated rows removed", SQL_GetAffectedRows(owner));
	if (client != 0) {
		PrintToChat(client, "[RankMe]: %d duplicated rows removed", SQL_GetAffectedRows(owner));
	}
	//LogAction(-1,-1,"[RankMe]: %d players purged by inactivity",SQL_GetAffectedRows(owner));
	
}
