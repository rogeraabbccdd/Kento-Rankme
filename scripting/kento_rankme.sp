#pragma semicolon  1

#define PLUGIN_VERSION "3.0.3.Kento.30"

#include <sourcemod> 
#include <adminmenu>
#include <kento_csgocolors>
#include <kento_rankme/rankme>
#include <geoip>
#include <sdktools>
#include <cstrike>
#include <clientprefs>

#pragma newdecls required

#define MSG "\x04 [RankMe] \x01\x0B\x01"
#define SPEC 1
#define TR 2
#define CT 3

#define SENDER_WORLD 0
#define MAX_LENGTH_MENU 470

static const char g_sSqliteCreate[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, steam TEXT, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC))";
static const char g_sMysqlCreate[] = "CREATE TABLE IF NOT EXISTS `%s` (id INTEGER PRIMARY KEY, steam TEXT, name TEXT, lastip TEXT, score NUMERIC, kills NUMERIC, deaths NUMERIC, assists NUMERIC, suicides NUMERIC, tk NUMERIC, shots NUMERIC, hits NUMERIC, headshots NUMERIC, connected NUMERIC, rounds_tr NUMERIC, rounds_ct NUMERIC, lastconnect NUMERIC,knife NUMERIC,glock NUMERIC,hkp2000 NUMERIC,usp_silencer NUMERIC,p250 NUMERIC,deagle NUMERIC,elite NUMERIC,fiveseven NUMERIC,tec9 NUMERIC,cz75a NUMERIC,revolver NUMERIC,nova NUMERIC,xm1014 NUMERIC,mag7 NUMERIC,sawedoff NUMERIC,bizon NUMERIC,mac10 NUMERIC,mp9 NUMERIC,mp7 NUMERIC,ump45 NUMERIC,p90 NUMERIC,galilar NUMERIC,ak47 NUMERIC,scar20 NUMERIC,famas NUMERIC,m4a1 NUMERIC,m4a1_silencer NUMERIC,aug NUMERIC,ssg08 NUMERIC,sg556 NUMERIC,awp NUMERIC,g3sg1 NUMERIC,m249 NUMERIC,negev NUMERIC,hegrenade NUMERIC,flashbang NUMERIC,smokegrenade NUMERIC,inferno NUMERIC,decoy NUMERIC,taser NUMERIC,mp5sd NUMERIC,head NUMERIC, chest NUMERIC, stomach NUMERIC, left_arm NUMERIC, right_arm NUMERIC, left_leg NUMERIC, right_leg NUMERIC,c4_planted NUMERIC,c4_exploded NUMERIC,c4_defused NUMERIC,ct_win NUMERIC, tr_win NUMERIC, hostages_rescued NUMERIC, vip_killed NUMERIC, vip_escaped NUMERIC, vip_played NUMERIC, mvp NUMERIC, damage NUMERIC, match_win NUMERIC, match_draw NUMERIC, match_lose NUMERIC, first_blood NUMERIC, no_scope NUMERIC, no_scope_dis NUMERIC) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci";
static const char g_sSqlInsert[] = "INSERT INTO `%s` VALUES (NULL,'%s','%s','%s','%d','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0');";

/* SM1.9 Fix */
static const char g_sSqlSave[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE steam = '%s';";
static const char g_sSqlSaveName[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE name = '%s';";
static const char g_sSqlSaveIp[] = "UPDATE `%s` SET score = '%i', kills = '%i', deaths='%i', assists='%i',suicides='%i',tk='%i',shots='%i',hits='%i',headshots='%i', rounds_tr = '%i', rounds_ct = '%i',lastip='%s',name='%s'%s,head='%i',chest='%i', stomach='%i',left_arm='%i',right_arm='%i',left_leg='%i',right_leg='%i' WHERE lastip = '%s';";
static const char g_sSqlSave2[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', lastconnect='%i', connected='%i' WHERE steam = '%s';";
static const char g_sSqlSaveName2[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', lastconnect='%i', connected='%i' WHERE name = '%s';";
static const char g_sSqlSaveIp2[] = "UPDATE `%s` SET c4_planted='%i',c4_exploded='%i',c4_defused='%i',ct_win='%i',tr_win='%i', hostages_rescued='%i',vip_killed = '%d',vip_escaped = '%d',vip_played = '%d', mvp='%i', damage='%i', match_win='%i', match_draw='%i', match_lose='%i', first_blood='%i', no_scope='%i', no_scope_dis='%i', lastconnect='%i', connected='%i' WHERE lastip = '%s';";

static const char g_sSqlRetrieveClient[] = "SELECT * FROM `%s` WHERE steam='%s';";
static const char g_sSqlRetrieveClientName[] = "SELECT * FROM `%s` WHERE name='%s';";
static const char g_sSqlRetrieveClientIp[] = "SELECT * FROM `%s` WHERE lastip='%s';";
static const char g_sSqlRemoveDuplicateSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.steam=`%s`.steam);";
static const char g_sSqlRemoveDuplicateNameSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.name=`%s`.name);";
static const char g_sSqlRemoveDuplicateIpSQLite[] = "delete from `%s` where `%s`.id > (SELECT min(id) from `%s` as t2 WHERE t2.lastip=`%s`.lastip);";
static const char g_sSqlRemoveDuplicateMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.steam=vtable.steam);";
static const char g_sSqlRemoveDuplicateNameMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.name=vtable.name);";
static const char g_sSqlRemoveDuplicateIpMySQL[] = "delete from `%s` USING `%s`, `%s` as vtable WHERE (`%s`.id>vtable.id) AND (`%s`.ip=vtable.ip);";
stock const char g_sWeaponsNamesGame[42][] =  { "knife", "glock", "hkp2000", "usp_silencer", "p250", "deagle", "elite", "fiveseven", "tec9", "cz75a", "revolver", "nova", "xm1014", "mag7", "sawedoff", "bizon", "mac10", "mp9", "mp7", "ump45", "p90", "galilar", "ak47", "scar20", "famas", "m4a1", "m4a1_silencer", "aug", "ssg08", "sg556", "awp", "g3sg1", "m249", "negev", "hegrenade", "flashbang", "smokegrenade", "inferno", "decoy", "taser", "mp5sd", "breachcharge"};
stock const char g_sWeaponsNamesFull[42][] =  { "Knife", "Glock", "P2000", "USP-S", "P250", "Desert Eagle", "Dual Berettas", "Five-Seven", "Tec 9", "CZ75-Auto", "R8 Revolver", "Nova", "XM1014", "Mag 7", "Sawed-off", "PP-Bizon", "MAC-10", "MP9", "MP7", "UMP45", "P90", "Galil AR", "AK-47", "SCAR-20", "Famas", "M4A4", "M4A1-S", "AUG", "SSG 08", "SG 553", "AWP", "G3SG1", "M249", "Negev", "HE Grenade", "Flashbang", "Smoke Grenade", "Inferno", "Decoy", "Zeus x27", "MP5-SD", "Breach Charges"};

ConVar g_cvarEnabled;
ConVar g_cvarChatChange;
ConVar g_cvarRankbots;
ConVar g_cvarAutopurge;
ConVar g_cvarDumpDB;
ConVar g_cvarPointsBombDefusedTeam;
ConVar g_cvarPointsBombDefusedPlayer;
ConVar g_cvarPointsBombPlantedTeam;
ConVar g_cvarPointsBombPlantedPlayer;
ConVar g_cvarPointsBombExplodeTeam;
ConVar g_cvarPointsBombExplodePlayer;
ConVar g_cvarPointsBombPickup;
ConVar g_cvarPointsBombDropped;
ConVar g_cvarPointsHostageRescTeam;
ConVar g_cvarPointsHostageRescPlayer;
ConVar g_cvarPointsVipEscapedTeam;
ConVar g_cvarPointsVipEscapedPlayer;
ConVar g_cvarPointsVipKilledTeam;
ConVar g_cvarPointsVipKilledPlayer;
ConVar g_cvarPointsHs;
ConVar g_cvarPointsKillCt;
ConVar g_cvarPointsKillTr;
ConVar g_cvarPointsKillBonusCt;
ConVar g_cvarPointsKillBonusTr;
ConVar g_cvarPointsKillBonusDifCt;
ConVar g_cvarPointsKillBonusDifTr;
ConVar g_cvarPointsStart;
ConVar g_cvarPointsKnifeMultiplier;
ConVar g_cvarPointsTaserMultiplier;
ConVar g_cvarPointsTrRoundWin;
ConVar g_cvarPointsCtRoundWin;
ConVar g_cvarPointsTrRoundLose;
ConVar g_cvarPointsCtRoundLose;
ConVar g_cvarPointsMvpCt;
ConVar g_cvarPointsMvpTr;
ConVar g_cvarMinimalKills;
ConVar g_cvarPercentPointsLose;
ConVar g_cvarPointsLoseRoundCeil;
ConVar g_cvarShowRankAll;
ConVar g_cvarRankAllTimer;
ConVar g_cvarResetOwnRank;
ConVar g_cvarMinimumPlayers;
ConVar g_cvarVipEnabled;
ConVar g_cvarPointsLoseTk;
ConVar g_cvarPointsLoseSuicide;
ConVar g_cvarShowBotsOnRank;
ConVar g_cvarRankBy;
ConVar g_cvarFfa;
ConVar g_cvarMysql;
ConVar g_cvarGatherStats;
ConVar g_cvarDaysToNotShowOnRank;
ConVar g_cvarRankMode;
ConVar g_cvarSQLTable;
ConVar g_cvarChatTriggers;

bool g_bEnabled;
bool g_bResetOwnRank;
bool g_bChatChange;
bool g_bRankBots;
bool g_bPointsLoseRoundCeil;
bool g_bShowRankAll;
bool g_bVipEnabled;
bool g_bShowBotsOnRank;
bool g_bFfa;
bool g_bMysql;
bool g_bGatherStats;
bool g_bDumpDB;
bool g_bChatTriggers;
float g_fRankAllTimer;
int g_RankBy;
int g_PointsBombDefusedTeam;
int g_PointsBombDefusedPlayer;
int g_PointsBombPlantedTeam;
int g_PointsBombPlantedPlayer;
int g_PointsBombExplodeTeam;
int g_PointsBombExplodePlayer;
int g_PointsBombPickup;
int g_PointsBombDropped;
int g_PointsHostageRescTeam;
int g_PointsHostageRescPlayer;
int g_PointsHs;
// Size = 4 -> for using client team for points
int g_PointsKill[4];
int g_PointsKillBonus[4];
int g_PointsKillBonusDif[4];
int g_PointsMvpTr;
int g_PointsMvpCt;
int g_MinimalKills;
int g_PointsStart;
float g_fPointsKnifeMultiplier;
float g_fPointsTaserMultiplier;
float g_fPercentPointsLose;
int g_PointsRoundWin[4];
int g_PointsRoundLose[4];
int g_MinimumPlayers;
int g_PointsLoseTk;
int g_PointsLoseSuicide;
int g_PointsVipEscapedTeam;
int g_PointsVipEscapedPlayer;
int g_PointsVipKilledTeam;
int g_PointsVipKilledPlayer;
int g_DaysToNotShowOnRank;
int g_RankMode;
char g_sSQLTable[200];
Handle g_hStatsDb;
bool OnDB[MAXPLAYERS + 1];
int g_aSession[MAXPLAYERS + 1][STATS_NAMES];
int g_aStats[MAXPLAYERS + 1][STATS_NAMES];
int g_aWeapons[MAXPLAYERS + 1][WEAPONS_ENUM];
int g_aHitBox[MAXPLAYERS + 1][HITBOXES];
int g_TotalPlayers;

ConVar g_cvarPointsMatchWin;
ConVar g_cvarPointsMatchDraw;
ConVar g_cvarPointsMatchLose;
int g_PointsMatchWin;
int g_PointsMatchDraw;
int g_PointsMatchLose;

Handle g_fwdOnPlayerLoaded;
Handle g_fwdOnPlayerSaved;

bool DEBUGGING = false;
int g_C4PlantedBy;
char g_sC4PlantedByName[MAX_NAME_LENGTH];

// Preventing duplicates
char g_aClientSteam[MAXPLAYERS + 1][64];
char g_aClientName[MAXPLAYERS + 1][MAX_NAME_LENGTH];
char g_aClientIp[MAXPLAYERS + 1][64];

/* Rank cache */
ConVar g_cvarRankCache;
Handle g_arrayRankCache[3];
bool g_bRankCache;

/* Cooldown Timer */
Handle hRankTimer[MAXPLAYERS + 1] = INVALID_HANDLE;

/*RankMe Connect Announcer*/
ConVar g_cvarAnnounceConnect;
ConVar g_cvarAnnounceConnectChat;
ConVar g_cvarAnnounceConnectHint;
ConVar g_cvarAnnounceDisconnect;
ConVar g_cvarAnnounceTopConnect;
ConVar g_cvarAnnounceTopPosConnect;
ConVar g_cvarAnnounceTopConnectChat;
ConVar g_cvarAnnounceTopConnectHint;

bool g_bAnnounceConnect;
bool g_bAnnounceConnectChat;
bool g_bAnnounceConnectHint;
bool g_bAnnounceDisconnect;
bool g_bAnnounceTopConnect;
bool g_bAnnounceTopConnectChat;
bool g_bAnnounceTopConnectHint;

int g_AnnounceTopPosConnect;

int g_aPointsOnConnect[MAXPLAYERS+1];
int g_aPointsOnDisconnect[MAXPLAYERS+1];
int g_aRankOnConnect[MAXPLAYERS+1];
char g_sBufferClientName[MAXPLAYERS+1][MAX_NAME_LENGTH];

/* Assist */
ConVar g_cvarPointsAssistKill;
int g_PointsAssistKill;

/* Enable Or Disable Points In Warmup */
ConVar g_cvarGatherStatsWarmup;
bool g_bGatherStatsWarmup;

/* Min points */
ConVar g_cvarPointsMin;
int g_PointsMin;
ConVar g_cvarPointsMinEnabled;
bool g_bPointsMinEnabled;

/* Hide Chat */
Handle hidechatcookie;
bool hidechat[MAXPLAYERS+1];

/* First blood */
bool firstblood = false;
ConVar g_cvarPointsFb;
int g_PointsFb;

/* No scope */
ConVar g_cvarPointsNS;
int g_PointsNS;
ConVar g_cvarNSAllSnipers;
bool g_bNSAllSnipers;

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
	g_cvarEnabled = CreateConVar("rankme_enabled", "1", "Is RankMe enabled? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarRankbots = CreateConVar("rankme_rankbots", "0", "Rank bots? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarAutopurge = CreateConVar("rankme_autopurge", "0", "Auto-Purge inactive players? X = Days  0 = Off", _, true, 0.0);
	g_cvarPointsBombDefusedTeam = CreateConVar("rankme_points_bomb_defused_team", "2", "How many points CTs got for defusing the C4?", _, true, 0.0);
	g_cvarPointsBombDefusedPlayer = CreateConVar("rankme_points_bomb_defused_player", "2", "How many points the CT who defused got additional?", _, true, 0.0);
	g_cvarPointsBombPlantedTeam = CreateConVar("rankme_points_bomb_planted_team", "2", "How many points TRs got for planting the C4?", _, true, 0.0);
	g_cvarPointsBombPlantedPlayer = CreateConVar("rankme_points_bomb_planted_player", "2", "How many points the TR who planted got additional?", _, true, 0.0);
	g_cvarPointsBombExplodeTeam = CreateConVar("rankme_points_bomb_exploded_team", "2", "How many points TRs got for exploding the C4?", _, true, 0.0);
	g_cvarPointsBombExplodePlayer = CreateConVar("rankme_points_bomb_exploded_player", "2", "How many points the TR who planted got additional?", _, true, 0.0);
	g_cvarPointsHostageRescTeam = CreateConVar("rankme_points_hostage_rescued_team", "2", "How many points CTs got for rescuing the hostage?", _, true, 0.0);
	g_cvarPointsHostageRescPlayer = CreateConVar("rankme_points_hostage_rescued_player", "2", "How many points the CT who rescued got additional?", _, true, 0.0);
	g_cvarPointsHs = CreateConVar("rankme_points_hs", "1", "How many additional points a player got for a HeadShot?", _, true, 0.0);
	g_cvarPointsKillCt = CreateConVar("rankme_points_kill_ct", "2", "How many points a CT got for killing?", _, true, 0.0);
	g_cvarPointsKillTr = CreateConVar("rankme_points_kill_tr", "2", "How many points a TR got for killing?", _, true, 0.0);
	g_cvarPointsKillBonusCt = CreateConVar("rankme_points_kill_bonus_ct", "1", "How many points a CT got for killing additional by the diffrence of points?", _, true, 0.0);
	g_cvarPointsKillBonusTr = CreateConVar("rankme_points_kill_bonus_tr", "1", "How many points a TR got for killing additional by the diffrence of points?", _, true, 0.0);
	g_cvarPointsKillBonusDifCt = CreateConVar("rankme_points_kill_bonus_dif_ct", "100", "How many points of diffrence is needed for a CT to got the bonus?", _, true, 0.0);
	g_cvarPointsKillBonusDifTr = CreateConVar("rankme_points_kill_bonus_dif_tr", "100", "How many points of diffrence is needed for a TR to got the bonus?", _, true, 0.0);
	g_cvarPointsCtRoundWin = CreateConVar("rankme_points_ct_round_win", "0", "How many points an alive CT got for winning the round?", _, true, 0.0);
	g_cvarPointsTrRoundWin = CreateConVar("rankme_points_tr_round_win", "0", "How many points an alive TR got for winning the round?", _, true, 0.0);
	g_cvarPointsCtRoundLose = CreateConVar("rankme_points_ct_round_lose", "0", "How many points an alive CT lost for losing the round?", _, true, 0.0);
	g_cvarPointsTrRoundLose = CreateConVar("rankme_points_tr_round_lose", "0", "How many points an alive TR lost for losing the round?", _, true, 0.0);
	g_cvarPointsKnifeMultiplier = CreateConVar("rankme_points_knife_multiplier", "2.0", "Multiplier of points by knife", _, true, 0.0);
	g_cvarPointsTaserMultiplier = CreateConVar("rankme_points_taser_multiplier", "2.0", "Multiplier of points by taser", _, true, 0.0);
	g_cvarPointsStart = CreateConVar("rankme_points_start", "1000", "Starting points", _, true, 0.0);
	g_cvarMinimalKills = CreateConVar("rankme_minimal_kills", "0", "Minimal kills for entering the rank", _, true, 0.0);
	g_cvarPercentPointsLose = CreateConVar("rankme_percent_points_lose", "1.0", "Multiplier of losing points. (WARNING: MAKE SURE TO INPUT IT AS FLOAT) 1.0 equals lose same amount as won by the killer, 0.0 equals no lose", _, true, 0.0);
	g_cvarPointsLoseRoundCeil = CreateConVar("rankme_points_lose_round_ceil", "1", "If the points is f1oat, round it to next the highest or lowest? 1 = highest 0 = lowest", _, true, 0.0, true, 1.0);
	g_cvarChatChange = CreateConVar("rankme_changes_chat", "1", "Show points changes on chat? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarShowRankAll = CreateConVar("rankme_show_rank_all", "0", "When rank command is used, show for all the rank of the player? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarRankAllTimer = CreateConVar("rankme_rank_all_timer", "30.0", "Cooldown timer to prevent rank command spam.\n0.0 = disabled", _, true, 0.0);
	g_cvarShowBotsOnRank = CreateConVar("rankme_show_bots_on_rank", "0", "Show bots on rank/top/etc? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarResetOwnRank = CreateConVar("rankme_resetownrank", "0", "Allow player to reset his own rank? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarMinimumPlayers = CreateConVar("rankme_minimumplayers", "2", "Minimum players to start giving points", _, true, 0.0);
	g_cvarVipEnabled = CreateConVar("rankme_vip_enabled", "0", "Show AS_ maps statiscs (VIP mod) on statsme and session?", _, true, 0.0, true, 1.0);
	g_cvarPointsVipEscapedTeam = CreateConVar("rankme_points_vip_escaped_team", "2", "How many points CTs got helping the VIP to escaping?", _, true, 0.0);
	g_cvarPointsVipEscapedPlayer = CreateConVar("rankme_points_vip_escaped_player", "2", "How many points the VIP got for escaping?", _, true, 0.0);
	g_cvarPointsVipKilledTeam = CreateConVar("rankme_points_vip_killed_team", "2", "How many points TRs got for killing the VIP?", _, true, 0.0);
	g_cvarPointsVipKilledPlayer = CreateConVar("rankme_points_vip_killed_player", "2", "How many points the TR who killed the VIP got additional?", _, true, 0.0);
	g_cvarPointsLoseTk = CreateConVar("rankme_points_lose_tk", "0", "How many points a player lose for Team Killing?", _, true, 0.0);
	g_cvarPointsLoseSuicide = CreateConVar("rankme_points_lose_suicide", "0", "How many points a player lose for Suiciding?", _, true, 0.0);
	g_cvarPointsFb = CreateConVar("rankme_points_fb", "1", "How many additional points a player got for a First Blood?", _, true, 0.0);
	g_cvarPointsNS = CreateConVar("rankme_points_ns", "1", "How many additional points a player got for a no scope kill?", _, true, 0.0);	
	g_cvarNSAllSnipers = CreateConVar("rankme_points_ns_allsnipers", "0", "0: ssg08 and awp only, 1: ssg08, awp, g3sg1, scar20", _, true, 0.0, true, 1.0);	
	g_cvarRankBy = CreateConVar("rankme_rank_by", "0", "Rank players by? 0 = STEAM:ID 1 = Name 2 = IP", _, true, 0.0, true, 2.0);
	g_cvarFfa = CreateConVar("rankme_ffa", "0", "Free-For-All (FFA) mode? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarMysql = CreateConVar("rankme_mysql", "0", "Using MySQL? 1 = true 0 = false (SQLite)", _, true, 0.0, true, 1.0);
	g_cvarDumpDB = CreateConVar("rankme_dump_db", "0", "Dump the Database to SQL file? (required to be 1 if using the web interface and SQLite, case MySQL, it won't be dumped) 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarGatherStats = CreateConVar("rankme_gather_stats", "1", "Gather Statistics (a.k.a count points)? (turning this off won't disallow to see the stats already gathered) 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarDaysToNotShowOnRank = CreateConVar("rankme_days_to_not_show_on_rank", "0", "Days inactive to not be shown on rank? X = days 0 = off", _, true, 0.0);
	g_cvarRankMode = CreateConVar("rankme_rank_mode", "1", "Rank by what? 1 = by points 2 = by KDR ", _, true, 1.0, true, 2.0);
	g_cvarSQLTable = CreateConVar("rankme_sql_table", "rankme", "The name of the table that will be used. (Max: 100)");
	g_cvarChatTriggers = CreateConVar("rankme_chat_triggers", "1", "Enable (non-command) chat triggers. (e.g: rank, statsme, top) Recommended to be set to 0 when running with EventScripts for avoiding double responses. 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarPointsMvpCt = CreateConVar("rankme_points_mvp_ct", "1", "How many points a CT got for being the MVP?", _, true, 0.0);
	g_cvarPointsMvpTr = CreateConVar("rankme_points_mvp_tr", "1", "How many points a TR got for being the MVP?", _, true, 0.0);
	g_cvarPointsBombPickup = CreateConVar("rankme_points_bomb_pickup", "0", "How many points a player gets for picking up the bomb?", _, true, 0.0);
	g_cvarPointsBombDropped = CreateConVar("rankme_points_bomb_dropped", "0", "How many points a player loess for dropping the bomb?", _, true, 0.0);
	g_cvarPointsMatchWin = CreateConVar("rankme_points_match_win", "2", "How many points a player win for winning the match?", _, true, 0.0);
	g_cvarPointsMatchLose = CreateConVar("rankme_points_match_lose", "2", "How many points a player loess for losing the match?", _, true, 0.0);
	g_cvarPointsMatchDraw = CreateConVar("rankme_points_match_draw", "0", "How many points a player win when match draw?", _, true, 0.0);
	
	/* Assist */
	g_cvarPointsAssistKill = CreateConVar("rankme_points_assiist_kill","1","How many points a player gets for assist kill?",_,true,0.0);
	
	/* Enable Or Disable Points In Warmup */
	g_cvarGatherStatsWarmup = CreateConVar("rankme_gather_stats_warmup","1","Gather Statistics In Warmup?", _, true, 0.0, true, 1.0);
	
	/* Min points */
	g_cvarPointsMinEnabled = CreateConVar("rankme_points_min_enabled", "1", "Is minimum points enabled? 1 = true 0 = false", _, true, 0.0, true, 1.0);
	g_cvarPointsMin = CreateConVar("rankme_points_min", "0", "Minimum points", _, true, 0.0);
	
	/* Rank cache */
	g_cvarRankCache = CreateConVar("rankme_rank_cache", "0", "Get player rank via cache, auto build cache on every OnMapStart.", _, true, 0.0, true, 1.0);
	g_arrayRankCache[0] = CreateArray(ByteCountToCells(128));
	g_arrayRankCache[1] = CreateArray(ByteCountToCells(128));
	g_arrayRankCache[2] = CreateArray(ByteCountToCells(128));
	
	// CVAR HOOK
	g_cvarEnabled.AddChangeHook(OnConVarChanged);
	g_cvarChatChange.AddChangeHook(OnConVarChanged);
	g_cvarShowBotsOnRank.AddChangeHook(OnConVarChanged);
	g_cvarShowRankAll.AddChangeHook(OnConVarChanged);
	g_cvarRankAllTimer.AddChangeHook(OnConVarChanged);
	g_cvarResetOwnRank.AddChangeHook(OnConVarChanged);
	g_cvarMinimumPlayers.AddChangeHook(OnConVarChanged);
	g_cvarRankbots.AddChangeHook(OnConVarChanged);
	g_cvarAutopurge.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombDefusedTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombDefusedPlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombPlantedTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombPlantedPlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombExplodeTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombExplodePlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsHostageRescTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsHostageRescPlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsHs.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillCt.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillTr.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillBonusCt.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillBonusTr.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillBonusDifCt.AddChangeHook(OnConVarChanged);
	g_cvarPointsKillBonusDifTr.AddChangeHook(OnConVarChanged);
	g_cvarPointsCtRoundWin.AddChangeHook(OnConVarChanged);
	g_cvarPointsTrRoundWin.AddChangeHook(OnConVarChanged);
	g_cvarPointsCtRoundLose.AddChangeHook(OnConVarChanged);
	g_cvarPointsTrRoundLose.AddChangeHook(OnConVarChanged);
	g_cvarPointsKnifeMultiplier.AddChangeHook(OnConVarChanged);
	g_cvarPointsTaserMultiplier.AddChangeHook(OnConVarChanged);
	g_cvarPointsStart.AddChangeHook(OnConVarChanged);
	g_cvarMinimalKills.AddChangeHook(OnConVarChanged);
	g_cvarPercentPointsLose.AddChangeHook(OnConVarChanged);
	g_cvarPointsLoseRoundCeil.AddChangeHook(OnConVarChanged);
	g_cvarVipEnabled.AddChangeHook(OnConVarChanged);
	g_cvarPointsVipEscapedTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsVipEscapedPlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsVipKilledTeam.AddChangeHook(OnConVarChanged);
	g_cvarPointsVipKilledPlayer.AddChangeHook(OnConVarChanged);
	g_cvarPointsLoseTk.AddChangeHook(OnConVarChanged);
	g_cvarPointsLoseSuicide.AddChangeHook(OnConVarChanged);
	g_cvarRankBy.AddChangeHook(OnConVarChanged);
	g_cvarFfa.AddChangeHook(OnConVarChanged);
	g_cvarDumpDB.AddChangeHook(OnConVarChanged);
	g_cvarGatherStats.AddChangeHook(OnConVarChanged);
	g_cvarDaysToNotShowOnRank.AddChangeHook(OnConVarChanged);
	g_cvarRankMode.AddChangeHook(OnConVarChanged);
	g_cvarMysql.AddChangeHook(OnConVarChanged_MySQL);
	g_cvarSQLTable.AddChangeHook(OnConVarChanged_SQLTable);
	g_cvarChatTriggers.AddChangeHook(OnConVarChanged);
	g_cvarPointsMvpCt.AddChangeHook(OnConVarChanged);
	g_cvarPointsMvpTr.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombPickup.AddChangeHook(OnConVarChanged);
	g_cvarPointsBombDropped.AddChangeHook(OnConVarChanged);
	g_cvarPointsMatchWin.AddChangeHook(OnConVarChanged);
	g_cvarPointsMatchDraw.AddChangeHook(OnConVarChanged);
	g_cvarPointsMatchLose.AddChangeHook(OnConVarChanged);
	g_cvarPointsFb.AddChangeHook(OnConVarChanged);
	g_cvarPointsNS.AddChangeHook(OnConVarChanged);
	g_cvarNSAllSnipers.AddChangeHook(OnConVarChanged);
	
	/* Assist */
	g_cvarPointsAssistKill.AddChangeHook(OnConVarChanged);
	
	/* Enable Or Disable Points In Warmup */
	g_cvarGatherStatsWarmup.AddChangeHook(OnConVarChanged);
	
	/* Min points */
	g_cvarPointsMinEnabled.AddChangeHook(OnConVarChanged);
	g_cvarPointsMin.AddChangeHook(OnConVarChanged);
	
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
	
	/*RankMe Connect Announcer*/
	g_cvarAnnounceConnect = CreateConVar("rankme_announcer_player_connect","1","Announce when a player connect with position and points?",_,true,0.0,true,1.0);
	g_cvarAnnounceConnectChat = CreateConVar("rankme_announcer_player_connect_chat","1","Announce when a player connect at chat?",_,true,0.0,true,1.0);
	g_cvarAnnounceConnectHint = CreateConVar("rankme_announcer_player_connect_hint","0","Announce when a player connect at hintbox?",_,true,0.0,true,1.0);
	g_cvarAnnounceDisconnect = CreateConVar("rankme_announcer_player_disconnect","1","Announce when a player disconnect with position and points?",_,true,0.0,true,1.0);
	g_cvarAnnounceTopConnect = CreateConVar("rankme_announcer_top_player_connect","1","Announce when a top player connect?",_,true,0.0,true,1.0);
	g_cvarAnnounceTopPosConnect = CreateConVar("rankme_announcer_top_pos_player_connect","10","Max position to announce that a top player connect?",_,true,0.0);
	g_cvarAnnounceTopConnectChat = CreateConVar("rankme_announcer_top_player_connect_chat","1","Announce when a top player connect at chat?",_,true,0.0,true,1.0);
	g_cvarAnnounceTopConnectHint = CreateConVar("rankme_announcer_top_player_connect_hint","0","Announce when a top player connect at hintbox?",_,true,0.0,true,1.0);
	
	g_cvarAnnounceConnect.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceConnectChat.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceConnectHint.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceDisconnect.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceTopConnect.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceTopPosConnect.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceTopConnectChat.AddChangeHook(OnConVarChanged);
	g_cvarAnnounceTopConnectHint.AddChangeHook(OnConVarChanged);
	
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
	RegConsoleCmd("sm_rankmechat", CMD_HideChat, "Disable rankme chat messages");
	hidechatcookie = RegClientCookie("rankme_hidechat", "Hide rankme chat messages", CookieAccess_Private);
}

public void OnConVarChanged_SQLTable(Handle convar, const char[] oldValue, const char[] newValue) {
	
	g_cvarSQLTable.GetString(g_sSQLTable, sizeof(g_sSQLTable));
	DB_Connect(true); // Force reloading the stats
}

public void OnConVarChanged_MySQL(Handle convar, const char[] oldValue, const char[] newValue) {
	DB_Connect(false);
}

public void DB_Connect(bool firstload) {
	
	if (g_bMysql != g_cvarMysql.BoolValue || firstload) {  // NEEDS TO CONNECT IF CHANGED MYSQL CVAR OR NEVER CONNECTED
		g_bMysql = g_cvarMysql.BoolValue;
		g_cvarSQLTable.GetString(g_sSQLTable, sizeof(g_sSQLTable));
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
		SQL_LockDatabase(g_hStatsDb);
		char sQuery[9999];
		
		if(g_bMysql)
		{
			Format(sQuery, sizeof(sQuery), g_sMysqlCreate, g_sSQLTable);
			SQL_FastQuery(g_hStatsDb, sQuery);
		}
		if(!g_bMysql)
		{
			Format(sQuery, sizeof(sQuery), g_sSqliteCreate, g_sSQLTable);
			SQL_FastQuery(g_hStatsDb, sQuery);
		}
		
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` MODIFY id INTEGER AUTO_INCREMENT", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_killed NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_escaped NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN vip_played NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_win NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_draw NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN match_lose NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN mp5sd NUMERIC AFTER taser", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN breachcharge NUMERIC AFTER mp5sd", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN first_blood NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN no_scope NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		Format(sQuery, sizeof(sQuery), "ALTER TABLE `%s` ADD COLUMN no_scope_dis NUMERIC", g_sSQLTable);
		SQL_FastQuery(g_hStatsDb, sQuery);
		SQL_UnlockDatabase(g_hStatsDb);
		
		for (int i = 1; i <= MaxClients; i++) {
			if (IsClientInGame(i))
				OnClientPutInServer(i);
		}
	}
	
}
public void OnConfigsExecuted() {
	
	if (g_hStatsDb == INVALID_HANDLE)
		DB_Connect(true);
	else
		DB_Connect(false);
	int AutoPurge = g_cvarAutopurge.IntValue;
	char sQuery[1000];
	if (AutoPurge > 0) {
		int DeleteBefore = GetTime() - (AutoPurge * 86400);
		Format(sQuery, sizeof(sQuery), "DELETE FROM `%s` WHERE lastconnect < '%d'", g_sSQLTable, DeleteBefore);
		SQL_TQuery(g_hStatsDb, SQL_PurgeCallback, sQuery);
	}
	
	g_bShowBotsOnRank = g_cvarShowBotsOnRank.BoolValue;
	g_RankBy = g_cvarRankBy.IntValue;
	g_bEnabled = g_cvarEnabled.BoolValue;
	g_bChatChange = g_cvarChatChange.BoolValue;
	g_bShowRankAll = g_cvarShowRankAll.BoolValue;
	g_fRankAllTimer = g_cvarRankAllTimer.FloatValue;
	g_bRankBots = g_cvarRankbots.BoolValue;
	g_bFfa = g_cvarFfa.BoolValue;
	g_bDumpDB = g_cvarDumpDB.BoolValue;
	g_PointsBombDefusedTeam = g_cvarPointsBombDefusedTeam.IntValue;
	g_PointsBombDefusedPlayer = g_cvarPointsBombDefusedPlayer.IntValue;
	g_PointsBombPlantedTeam = g_cvarPointsBombPlantedTeam.IntValue;
	g_PointsBombPlantedPlayer = g_cvarPointsBombPlantedPlayer.IntValue;
	g_PointsBombExplodeTeam = g_cvarPointsBombExplodeTeam.IntValue;
	g_PointsBombExplodePlayer = g_cvarPointsBombExplodePlayer.IntValue;
	g_PointsHostageRescTeam = g_cvarPointsHostageRescTeam.IntValue;
	g_PointsHostageRescPlayer = g_cvarPointsHostageRescPlayer.IntValue;
	g_PointsHs = g_cvarPointsHs.IntValue;
	g_PointsKill[CT] = g_cvarPointsKillCt.IntValue;
	g_PointsKill[TR] = g_cvarPointsKillTr.IntValue;
	g_PointsKillBonus[CT] = g_cvarPointsKillBonusCt.IntValue;
	g_PointsKillBonus[TR] = g_cvarPointsKillBonusTr.IntValue;
	g_PointsKillBonusDif[CT] = g_cvarPointsKillBonusDifCt.IntValue;
	g_PointsKillBonusDif[TR] = g_cvarPointsKillBonusDifTr.IntValue;
	g_PointsStart = g_cvarPointsStart.IntValue;
	g_fPointsKnifeMultiplier = g_cvarPointsKnifeMultiplier.FloatValue;
	g_fPointsTaserMultiplier = g_cvarPointsTaserMultiplier.FloatValue;
	g_PointsRoundWin[TR] = g_cvarPointsTrRoundWin.IntValue;
	g_PointsRoundWin[CT] = g_cvarPointsCtRoundWin.IntValue;
	g_PointsRoundLose[TR] = g_cvarPointsTrRoundLose.IntValue;
	g_PointsRoundLose[CT] = g_cvarPointsCtRoundLose.IntValue;
	g_MinimalKills = g_cvarMinimalKills.IntValue;
	g_fPercentPointsLose = g_cvarPercentPointsLose.FloatValue;
	g_bPointsLoseRoundCeil = g_cvarPointsLoseRoundCeil.BoolValue;
	g_MinimumPlayers = g_cvarMinimumPlayers.IntValue;
	g_bResetOwnRank = g_cvarResetOwnRank.BoolValue;
	g_PointsVipEscapedTeam = g_cvarPointsVipEscapedTeam.IntValue;
	g_PointsVipEscapedPlayer = g_cvarPointsVipEscapedPlayer.IntValue;
	g_PointsVipKilledTeam = g_cvarPointsVipKilledTeam.IntValue;
	g_PointsVipKilledPlayer = g_cvarPointsVipKilledPlayer.IntValue;
	g_bVipEnabled = g_cvarVipEnabled.BoolValue;
	g_PointsLoseTk = g_cvarPointsLoseTk.IntValue;
	g_PointsLoseSuicide = g_cvarPointsLoseSuicide.IntValue;
	g_DaysToNotShowOnRank = g_cvarDaysToNotShowOnRank.IntValue;
	g_bGatherStats = g_cvarGatherStats.BoolValue;
	g_RankMode = g_cvarRankMode.IntValue;
	g_bChatTriggers = g_cvarChatTriggers.BoolValue;
	g_PointsMvpCt = g_cvarPointsMvpCt.IntValue;
	g_PointsMvpTr = g_cvarPointsMvpTr.IntValue;
	g_PointsBombDropped = g_cvarPointsBombDropped.IntValue;
	g_PointsBombPickup = g_cvarPointsBombPickup.IntValue;
	g_PointsMatchWin = g_cvarPointsMatchWin.IntValue;
	g_PointsMatchDraw = g_cvarPointsMatchDraw.IntValue;
	g_PointsMatchLose = g_cvarPointsMatchLose.IntValue;
	g_PointsFb = g_cvarPointsFb.IntValue;
	g_PointsNS = g_cvarPointsNS.IntValue;
	g_bNSAllSnipers = g_cvarNSAllSnipers.BoolValue;
	
	/* Assist */
	g_PointsAssistKill = g_cvarPointsAssistKill.IntValue;
	
	/* Enable Or Disable Points In Warmup */
	g_bGatherStatsWarmup = g_cvarGatherStatsWarmup.BoolValue;
	
	/* Min points */
	g_PointsMin = g_cvarPointsMin.IntValue;
	g_bPointsMinEnabled = g_cvarPointsMin.BoolValue;
	
	/*RankMe Connect Announcer*/
	g_bAnnounceConnect = g_cvarAnnounceConnect.BoolValue;
	g_bAnnounceConnectChat = g_cvarAnnounceConnectChat.BoolValue;
	g_bAnnounceConnectHint = g_cvarAnnounceConnectHint.BoolValue;
	g_bAnnounceDisconnect = g_cvarAnnounceDisconnect.BoolValue;
	g_bAnnounceTopConnect = g_cvarAnnounceTopConnect.BoolValue;
	g_AnnounceTopPosConnect = g_cvarAnnounceTopPosConnect.BoolValue;
	g_bAnnounceTopConnectChat = g_cvarAnnounceTopConnectChat.BoolValue;
	g_bAnnounceTopConnectHint = g_cvarAnnounceTopConnectHint.BoolValue;
	
	if (g_bRankBots)
		Format(sQuery, sizeof(sQuery), "SELECT * FROM `%s` WHERE kills >= '%d'", g_sSQLTable, g_MinimalKills);
	else
		Format(sQuery, sizeof(sQuery), "SELECT * FROM `%s` WHERE kills >= '%d' AND steam <> 'BOT'", g_sSQLTable, g_MinimalKills);
	
	SQL_TQuery(g_hStatsDb, SQL_GetPlayersCallback, sQuery);
	
	BuildRankCache();
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
		Format(query, sizeof(query), "%s ORDER BY CAST(CAST(kills as float)/CAST (deaths as float) as float) DESC", query);
	
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
public Action CMD_Duplicate(int client, int args) {
	char sQuery[400];
	
	if (g_bMysql) {
		
		if (g_RankBy == 0)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateMySQL, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
		else if (g_RankBy == 1)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateNameMySQL, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
		else if (g_RankBy == 2)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateIpMySQL, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
	} else {
		
		if (g_RankBy == 0)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateSQLite, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
		else if (g_RankBy == 1)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateNameSQLite, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
		else if (g_RankBy == 2)
			FormatEx(sQuery, sizeof(sQuery), g_sSqlRemoveDuplicateIpSQLite, g_sSQLTable, g_sSQLTable, g_sSQLTable, g_sSQLTable);
		
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

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("RankMe_GivePoint", Native_GivePoint);
	CreateNative("RankMe_GetRank", Native_GetRank);
	CreateNative("RankMe_GetPoints", Native_GetPoints);
	CreateNative("RankMe_GetStats", Native_GetStats);
	CreateNative("RankMe_GetSession", Native_GetSession);
	CreateNative("RankMe_GetWeaponStats", Native_GetWeaponStats);
	CreateNative("RankMe_GetHitbox", Native_GetHitbox);
	
	RegPluginLibrary("rankme");
	
	return APLRes_Success;
}
public int Native_GivePoint(Handle plugin, int numParams)
{
	int iClient = GetNativeCell(1);
	int iPoints = GetNativeCell(2);
	
	int len;
	GetNativeStringLength(3, len);
	
	if (len <= 0)
	{
		return;
	}
	
	
	char[] Reason = new char[len + 1];
	char Name[MAX_NAME_LENGTH];
	GetNativeString(3, Reason, len + 1);
	int iPrintToPlayer = GetNativeCell(4);
	int iPrintToAll = GetNativeCell(5);
	g_aStats[iClient][SCORE] += iPoints;
	g_aSession[iClient][SCORE] += iPoints;
	GetClientName(iClient, Name, sizeof(Name));
	if (!g_bChatChange)
		return;
	if (iPrintToAll == 1) {
		for (int i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i))
			//CPrintToChatEx(i,i,"%s %T",MSG,"GotPointsBy",Name,g_aStats[iClient][SCORE],iPoints,Reason);
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "GotPointsBy", i, Name, g_aStats[iClient][SCORE], iPoints, Reason);
	} else if (iPrintToPlayer == 1) {
		//CPrintToChatEx(iClient,iClient,"%s %T",MSG,"GotPointsBy",Name,g_aStats[iClient][SCORE],iPoints,Reason);
		if(!hidechat[iClient]) CPrintToChat(iClient, "%s %T", MSG, "GotPointsBy", iClient, Name, g_aStats[iClient][SCORE], iPoints, Reason);
	}
}

public int Native_GetRank(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	Function callback = GetNativeCell(2);
	any data = GetNativeCell(3);
	
	Handle pack = CreateDataPack();
	
	WritePackCell(pack, client);
	WritePackFunction(pack, callback);
	WritePackCell(pack, data);
	WritePackCell(pack, view_as<int>(plugin));
	
	if(g_bRankCache)
	{
		GetClientRank(pack);
		return;
	}

	char query[10000];
	MakeSelectQuery(query, sizeof(query));
	
	if (g_RankMode == 1)
		Format(query, sizeof(query), "%s ORDER BY score DESC", query);
	else if (g_RankMode == 2)
		Format(query, sizeof(query), "%s ORDER BY CAST(CAST(kills as float)/CAST (deaths as float) as float) DESC", query);
	
	SQL_TQuery(g_hStatsDb, SQL_GetRankCallback, query, pack);
}

void GetClientRank(Handle pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);
	Function callback = ReadPackFunction(pack);
	any args = ReadPackCell(pack);
	Handle plugin = ReadPackCell(pack);
	CloseHandle(pack);
	
	int rank;
	switch(g_RankBy)
	{
		case 0:
		{
			char steamid[32];
			GetClientAuthId(client, AuthId_Steam2, steamid, 32, true);
			rank = FindStringInArray(g_arrayRankCache[0], steamid);
		}
		case 1:
		{
			char name[128];
			GetClientName(client, name, 128);
			rank = FindStringInArray(g_arrayRankCache[1], name);
		}
		case 2:
		{
			char ip[128];
			GetClientIP(client, ip, 128);
			rank = FindStringInArray(g_arrayRankCache[2], ip);
		}
	}

	if(rank > 0)
		CallRankCallback(client, rank, callback, args, plugin);
	else
		CallRankCallback(client, 0, callback, args, plugin);
}

public void SQL_GetRankCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	Handle pack = data;
	ResetPack(pack);
	int client = ReadPackCell(pack);
	Function callback = ReadPackFunction(pack);
	any args = ReadPackCell(pack);
	Handle plugin = ReadPackCell(pack);
	CloseHandle(pack);
	
	if (hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		CallRankCallback(0, 0, callback, 0, plugin);
		return;
	}
	int i;
	g_TotalPlayers = SQL_GetRowCount(hndl);
	
	char Receive[64];
	
	while (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		i++;
		
		if (g_RankBy == 0) {
			SQL_FetchString(hndl, 1, Receive, sizeof(Receive));
			if (StrEqual(Receive, g_aClientSteam[client], false))
			{
				CallRankCallback(client, i, callback, args, plugin);
				break;
			}
		} else if (g_RankBy == 1) {
			SQL_FetchString(hndl, 2, Receive, sizeof(Receive));
			if (StrEqual(Receive, g_aClientName[client], false))
			{
				CallRankCallback(client, i, callback, args, plugin);
				break;
			}
		} else if (g_RankBy == 2) {
			SQL_FetchString(hndl, 3, Receive, sizeof(Receive));
			if (StrEqual(Receive, g_aClientIp[client], false))
			{
				CallRankCallback(client, i, callback, args, plugin);
				break;
			}
		}
	}
}

void CallRankCallback(int client, int rank, Function callback, any data, Handle plugin)
{
	Call_StartFunction(plugin, callback);
	Call_PushCell(client);
	Call_PushCell(rank);
	Call_PushCell(data);
	Call_Finish();
	CloseHandle(plugin);
}

public int Native_GetPoints(Handle plugin, int numParams)
{
	int Client = GetNativeCell(1);
	return g_aStats[Client][SCORE];
}

public int Native_GetStats(Handle plugin, int numParams)
{
	int iClient = GetNativeCell(1);
	int array[20];
	for (int i = 0; i < 20; i++)
	array[i] = g_aStats[iClient][i];
	
	SetNativeArray(2, array, 20);
}

public int Native_GetSession(Handle plugin, int numParams)
{
	int iClient = GetNativeCell(1);
	int array[20];
	for (int i = 0; i < 20; i++)
	array[i] = g_aSession[iClient][i];
	
	SetNativeArray(2, array, 20);
}

public int Native_GetWeaponStats(Handle plugin, int numParams)
{
	int iClient = GetNativeCell(1);
	int array[41];
	for (int i = 0; i < 42; i++)
	array[i] = g_aWeapons[iClient][i];
	
	SetNativeArray(2, array, 41);
}

public int Native_GetHitbox(Handle plugin, int numParams)
{
	int iClient = GetNativeCell(1);
	int array[8];
	for (int i = 0; i < 8; i++)
	array[i] = g_aHitBox[iClient][i];
	
	SetNativeArray(2, array, 8);
}

public void DumpDB() {
	if (!g_bDumpDB || g_bMysql)
		return;
	char sQuery[1000];
	FormatEx(sQuery, sizeof(sQuery), "SELECT * from `%s`", g_sSQLTable);
	SQL_TQuery(g_hStatsDb, SQL_DumpCallback, sQuery);
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
		if (g_RankBy == 1) {
			OnDB[client] = false;
			for (int i = 0; i <= 19; i++) {
				g_aSession[client][i] = 0;
				g_aStats[client][i] = 0;
			}
			g_aStats[client][SCORE] = g_PointsStart;
			for (int i = 0; i < 42; i++) {
				g_aWeapons[client][i] = 0;
			}
			g_aSession[client][CONNECTED] = GetTime();
			
			strcopy(g_aClientName[client], MAX_NAME_LENGTH, clientnewname);
			
			Format(query, sizeof(query), g_sSqlRetrieveClientName, g_sSQLTable, Eclientnewname);
			if (DEBUGGING) {
				PrintToServer(query);
				LogError("%s", query);
			}
			SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallback, query, client);
			
		} else {
			
			if (g_RankBy == 0)
				Format(query, sizeof(query), "UPDATE `%s` SET name='%s' WHERE steam = '%s';", g_sSQLTable, Eclientnewname, g_aClientSteam[client]);
			else
				Format(query, sizeof(query), "UPDATE `%s` SET name='%s' WHERE lastip = '%s';", g_sSQLTable, Eclientnewname, g_aClientIp[client]);
			
			SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query);
		}
	}
	return Plugin_Continue;
}

// Code made by Antithasys
public Action OnSayText(int client, const char[] command, int argc)
{
	if (!g_bEnabled || !g_bChatTriggers || client == SENDER_WORLD || IsChatTrigger())
	{  // Don't parse if plugin is disabled or if is from the console or a chat trigger (e.g: ! or /)
		return Plugin_Continue;
	}
	
	char cpMessage[256];
	char sWords[64][256];
	GetCmdArgString(cpMessage, sizeof(cpMessage)); // Get the message
	StripQuotes(cpMessage); // Text come inside quotes
	//ReplaceString(cpMessage,sizeof(cpMessage),"\"","");
	ExplodeString(cpMessage, " ", sWords, sizeof(sWords), sizeof(sWords[])); // Explode it for use at top, topknife, topnade and topweapon
	
	// Proccess the text
	if (StrEqual(cpMessage, "rank", false))
	{
		//LogToFile("rankme.debug.log","\"rank\" chat hook called by client %d.",client);
		CMD_Rank(client, 0);
	}
	else if (StrEqual(cpMessage, "statsme", false))
	{
		CMD_StatsMe(client, 0);
	}
	else if (StrEqual(cpMessage, "hitboxme", false))
	{
		CMD_HitBox(client, 0);
	}
	else if (StrEqual(cpMessage, "weaponme", false))
	{
		CMD_WeaponMe(client, 0);
	}
	else if (StrEqual(cpMessage, "session", false))
	{
		CMD_Session(client, 0);
	}
	else if (StrEqual(cpMessage[0], "next", false))
	{
		CMD_Next(client, 0);
	}
	else if (StrContains(sWords[0], "toptk", false) == 0)
	{
		CMD_TopTK(client, 0);
	}
	else if (StrContains(sWords[0], "topmvp", false) == 0)
	{
		CMD_TopMVP(client, 0);
	}
	else if (StrContains(sWords[0], "topdamage", false) == 0)
	{
		CMD_TopDamage(client, 0);
	}

	
	else if (StrContains(sWords[0], "tophs", false) == 0)
	{
		if (strcmp(cpMessage, "tophs") == 0)
		{
			ShowTopHS(client, 0);
		}
		else
		{
			ShowTopHS(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "topkills", false) == 0)
	{
		if (strcmp(cpMessage, "topkills") == 0)
		{
			ShowTopKills(client, 0);
		}
		else
		{
			ShowTopKills(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "topdeaths", false) == 0)
	{
		if (strcmp(cpMessage, "topdeaths") == 0)
		{
			ShowTopDeaths(client, 0);
		}
		else
		{
			ShowTopDeaths(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "topassists", false) == 0)
	{
		if (strcmp(cpMessage, "topassists") == 0)
		{
			ShowTopAssists(client, 0);
		}
		else
		{
			ShowTopAssists(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "topacc", false) == 0)
	{
		if (strcmp(cpMessage, "topacc") == 0)
		{
			ShowTopAcc(client, 0);
		}
		else
		{
			ShowTopAcc(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "toptime", false) == 0)
	{
		if (strcmp(cpMessage, "toptime") == 0)
		{
			ShowTopTime(client, 0);
		}
		else
		{
			ShowTopTime(client, StringToInt(cpMessage[7]));
		}
	}
	else if (StrContains(sWords[0], "topweapon", false) == 0)
	{
		if (strcmp(cpMessage, "topweapon") == 0)
		{
			CMD_TopWeapon(client, 0); // Build the menu on the next frame
		}
		else
		{
			if (GetWeaponNum(sWords[1]) == 30)
			{
				CMD_TopWeapon(client, 0);
			}
			else
			{
				ShowTOPWeapon(client, GetWeaponNum(sWords[1]), StringToInt(sWords[2]));
			}
		}
	}
	else if (StrContains(sWords[0], "top", false) == 0)
	{
		if (strcmp(cpMessage, "top") == 0)
		{
			ShowTOP(client, 0);
		}
		else
		{
			ShowTOP(client, StringToInt(cpMessage[3]));
		}
	}
	return Plugin_Continue;
}

int GetCurrentPlayers() 
{
	int count;
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i) && (!IsFakeClient(i) || g_bRankBots)) {
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
			for (int i = 0; i < 42; i++) {
				Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], g_aWeapons[client][i]);
			}
			
			/* SM1.9 Fix */
			char query[4000];
			char query2[4000];
	
			if (g_RankBy == 0) 
			{
				Format(query, sizeof(query), g_sSqlSave, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
					g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], g_aClientSteam[client]);
	
				Format(query2, sizeof(query2), g_sSqlSave2, g_sSQLTable, g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
					g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], g_aClientSteam[client]);
			} 
	
			else if (g_RankBy == 1) 
			{
				Format(query, sizeof(query), g_sSqlSaveName, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
					g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], sEscapeName);
	
				Format(query2, sizeof(query2), g_sSqlSaveName2, g_sSQLTable, g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
					g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], sEscapeName);
			} 
	
			else if (g_RankBy == 2) 
			{
				Format(query, sizeof(query), g_sSqlSaveIp, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
					g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
					g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], g_aClientIp[client]);
	
				Format(query2, sizeof(query2), g_sSqlSaveIp2,  g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
					g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], g_aClientIp[client]);
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
	return 43;
}

public Action Event_VipEscaped(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStats[i][SCORE] += g_PointsVipEscapedTeam;
			g_aSession[i][SCORE] += g_PointsVipEscapedTeam;
			
		}
		
	}
	g_aStats[client][VIP_PLAYED]++;
	g_aSession[client][VIP_PLAYED]++;
	g_aStats[client][VIP_ESCAPED]++;
	g_aSession[client][VIP_ESCAPED]++;
	g_aStats[client][SCORE] += g_PointsVipEscapedPlayer;
	g_aSession[client][SCORE] += g_PointsVipEscapedPlayer;
	
	if (!g_bChatChange)
		return;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_VIPEscaped", i, g_PointsVipEscapedTeam);
	if (client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "VIPEscaped", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsVipEscapedTeam + g_PointsVipEscapedPlayer);
}

public Action Event_VipKilled(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == TR) {
			g_aStats[i][SCORE] += g_PointsVipKilledTeam;
			g_aSession[i][SCORE] += g_PointsVipKilledTeam;
			
		}
		
	}
	g_aStats[client][VIP_PLAYED]++;
	g_aSession[client][VIP_PLAYED]++;
	g_aStats[killer][VIP_KILLED]++;
	g_aSession[killer][VIP_KILLED]++;
	g_aStats[killer][SCORE] += g_PointsVipKilledPlayer;
	g_aSession[killer][SCORE] += g_PointsVipKilledPlayer;
	
	if (!g_bChatChange)
		return;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "TR_VIPKilled", i, g_PointsVipKilledTeam);
	if (client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "VIPKilled", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsVipKilledTeam + g_PointsVipKilledPlayer);
}

public Action Event_HostageRescued(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStats[i][SCORE] += g_PointsHostageRescTeam;
			g_aSession[i][SCORE] += g_PointsHostageRescTeam;
			
		}
		
	}
	g_aSession[client][HOSTAGES_RESCUED]++;
	g_aStats[client][HOSTAGES_RESCUED]++;
	g_aStats[client][SCORE] += g_PointsHostageRescPlayer;
	g_aSession[client][SCORE] += g_PointsHostageRescPlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsHostageRescTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_Hostage", i, g_PointsHostageRescTeam);
	
	if (g_PointsHostageRescPlayer > 0 && client != 0 && (g_bRankBots && !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Hostage", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsHostageRescPlayer + g_PointsHostageRescTeam);
	
}

public Action Event_RoundMVP(Handle event, const char[] name, bool dontBroadcast) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsClientInGame(client))
		return;
	int team = GetClientTeam(client);
	
	if (((team == 2 && g_PointsMvpTr > 0) || (team == 3 && g_PointsMvpCt > 0)) && client != 0 && (g_bRankBots && !IsFakeClient(client))) {
		
		if (team == 2) {
			
			g_aStats[client][SCORE] += g_PointsMvpTr;
			g_aSession[client][SCORE] += g_PointsMvpTr;
			for (int i = 1; i <= MaxClients; i++)
			if (IsClientInGame(i))
				if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "MVP", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsMvpTr);
			
		} else {
			
			g_aStats[client][SCORE] += g_PointsMvpCt;
			g_aSession[client][SCORE] += g_PointsMvpCt;
			for (int i = 1; i <= MaxClients; i++)
			if (IsClientInGame(i))
				if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "MVP", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsMvpCt);	
		}
	}
	g_aStats[client][MVP]++;
	g_aSession[client][MVP]++;
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
					g_aSession[i][TR_WIN]++;
					g_aStats[i][TR_WIN]++;
					if (g_PointsRoundWin[TR] > 0 && IsPlayerAlive(i)) {
						g_aSession[i][SCORE] += g_PointsRoundWin[TR];
						g_aStats[i][SCORE] += g_PointsRoundWin[TR];
						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "TR_Round", j, g_PointsRoundWin[TR]);
						}
					}
				}
				else if(GetClientTeam(i) == CT){
					if (g_PointsRoundLose[CT] > 0 && IsPlayerAlive(i)) {
						g_aSession[i][SCORE] -= g_PointsRoundLose[CT];
						g_aStats[i][SCORE] -= g_PointsRoundLose[CT];
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
					g_aSession[i][CT_WIN]++;
					g_aStats[i][CT_WIN]++;
					if (g_PointsRoundWin[CT] > 0 && IsPlayerAlive(i)) {
						g_aSession[i][SCORE] += g_PointsRoundWin[CT];
						g_aStats[i][SCORE] += g_PointsRoundWin[CT];
						if (!announced && g_bChatChange) {
							for (int j = 1; j <= MaxClients; j++)
							if (IsClientInGame(j))
								if(!hidechat[j]) CPrintToChat(j, "%s %T", MSG, "CT_Round", j, g_PointsRoundWin[CT]);
						}
					}
				}
				else if(GetClientTeam(i) == TR){
					if (g_PointsRoundLose[TR] > 0 && IsPlayerAlive(i)) {
						g_aSession[i][SCORE] -= g_PointsRoundLose[TR];
						g_aStats[i][SCORE] -= g_PointsRoundLose[TR];
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
		g_aStats[client][ROUNDS_TR]++;
		g_aSession[client][ROUNDS_TR]++;
	} else if (GetClientTeam(client) == CT) {
		g_aStats[client][ROUNDS_CT]++;
		g_aSession[client][ROUNDS_CT]++;
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
			g_aStats[i][ROUNDS_TR]++;
			g_aSession[i][ROUNDS_TR]++;
		} 
		else if (IsClientInGame(i) && GetClientTeam(i) == CT) 
		{
			g_aStats[i][ROUNDS_CT]++;
			g_aSession[i][ROUNDS_CT]++;
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
			g_aStats[i][SCORE] += g_PointsBombPlantedTeam;
			g_aSession[i][SCORE] += g_PointsBombPlantedTeam;
			
		}
		
	}
	g_aStats[client][C4_PLANTED]++;
	g_aSession[client][C4_PLANTED]++;
	g_aStats[client][SCORE] += g_PointsBombPlantedPlayer;
	g_aSession[client][SCORE] += g_PointsBombPlantedPlayer;
	
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
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Planting", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsBombPlantedTeam + g_PointsBombPlantedPlayer);
	
}

public Action Event_BombDefused(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for (int i = 1; i <= MaxClients; i++) {
		
		if (IsClientInGame(i) && GetClientTeam(i) == CT) {
			g_aStats[i][SCORE] += g_PointsBombDefusedTeam;
			g_aSession[i][SCORE] += g_PointsBombDefusedTeam;
			
		}
		
	}
	g_aStats[client][C4_DEFUSED]++;
	g_aSession[client][C4_DEFUSED]++;
	g_aStats[client][SCORE] += g_PointsBombDefusedPlayer;
	g_aSession[client][SCORE] += g_PointsBombDefusedPlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombDefusedTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "CT_Defusing", i, g_PointsBombDefusedTeam);
	if (g_PointsBombDefusedPlayer > 0 && client != 0 && (g_bRankBots || !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Defusing", i, g_aClientName[client], g_aStats[client][SCORE], g_PointsBombDefusedTeam + g_PointsBombDefusedPlayer);
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
			g_aStats[i][SCORE] += g_PointsBombExplodeTeam;
			g_aSession[i][SCORE] += g_PointsBombExplodeTeam;
			
		}
		
	}
	g_aStats[client][C4_EXPLODED]++;
	g_aSession[client][C4_EXPLODED]++;
	g_aStats[client][SCORE] += g_PointsBombExplodePlayer;
	g_aSession[client][SCORE] += g_PointsBombExplodePlayer;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombExplodeTeam > 0)
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "TR_Exploding", i, g_PointsBombExplodeTeam);
	if (g_PointsBombExplodePlayer > 0 && client != 0 && (g_bRankBots || !IsFakeClient(client)))
		for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i))
		if(!hidechat[i]) CPrintToChat(i, "%s %T", MSG, "Exploding", i, g_sC4PlantedByName, g_aStats[client][SCORE], g_PointsBombExplodeTeam + g_PointsBombExplodePlayer);
}

public Action Event_BombPickup(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_aStats[client][SCORE] += g_PointsBombPickup;
	g_aSession[client][SCORE] += g_PointsBombPickup;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombPickup > 0)
		if(!hidechat[client])	CPrintToChat(client, "%s %T", MSG, "BombPickup", client, g_aClientName[client], g_aStats[client][SCORE], g_PointsBombPickup);
	
}

public Action Event_BombDropped(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_aStats[client][SCORE] -= g_PointsBombDropped;
	g_aSession[client][SCORE] -= g_PointsBombDropped;
	
	if (!g_bChatChange)
		return;
	if (g_PointsBombDropped > 0 && client == 0)
		if(!hidechat[client])	CPrintToChat(client, "%s %T", MSG, "BombDropped", client, g_aClientName[client], g_aStats[client][SCORE], g_PointsBombDropped);
	
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
		g_aStats[victim][SUICIDES]++;
		g_aSession[victim][SUICIDES]++;
		g_aStats[victim][SCORE] -= g_PointsLoseSuicide;
		g_aSession[victim][SCORE] -= g_PointsLoseSuicide;
		
		/* Min points */
		if (g_bPointsMinEnabled)
		{
			if (g_aStats[victim][SCORE] < g_PointsMin)
			{
				g_aStats[victim][SCORE] = g_PointsMin;
			}
		}
		
		if (g_PointsLoseSuicide > 0 && g_bChatChange) {
			if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "LostSuicide", victim, g_aClientName[victim], g_aStats[victim][SCORE], g_PointsLoseSuicide);
		}
		
	} else if (!g_bFfa && (GetClientTeam(victim) == GetClientTeam(attacker))) {
		if (attacker < MAXPLAYERS) {
			g_aStats[attacker][TK]++;
			g_aSession[attacker][TK]++;
			g_aStats[attacker][SCORE] -= g_PointsLoseTk;
			g_aSession[attacker][SCORE] -= g_PointsLoseTk;
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if (g_aStats[victim][SCORE] < g_PointsMin)
				{
					g_aStats[victim][SCORE] = g_PointsMin;
				}
			}
		
			if (g_PointsLoseTk > 0 && g_bChatChange) {
				if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "LostTK", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], g_PointsLoseTk, g_aClientName[victim]);
				if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "LostTK", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], g_PointsLoseTk, g_aClientName[victim]);
			}
		}
	} else {
		int team = GetClientTeam(attacker);
		bool headshot = GetEventBool(event, "headshot");
		
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
		
		int score_dif;
		if (attacker < MAXPLAYERS)
			score_dif = g_aStats[victim][SCORE] - g_aStats[attacker][SCORE];
		
		if (score_dif < 0 || attacker >= MAXPLAYERS) {
			score_dif = g_PointsKill[team];
		} else {
			if (g_PointsKillBonusDif[team] == 0)
				score_dif = g_PointsKill[team] + ((g_aStats[victim][SCORE] - g_aStats[attacker][SCORE]) * g_PointsKillBonus[team]);
			else
				score_dif = g_PointsKill[team] + (((g_aStats[victim][SCORE] - g_aStats[attacker][SCORE]) / g_PointsKillBonusDif[team]) * g_PointsKillBonus[team]);
		}
		if (StrEqual(weapon, "knife")) {
			score_dif = RoundToCeil(score_dif * g_fPointsKnifeMultiplier);
		}
		else if (StrEqual(weapon, "taser")) {
			score_dif = RoundToCeil(score_dif * g_fPointsTaserMultiplier);
		}
		if (headshot && attacker < MAXPLAYERS) {
			g_aStats[attacker][HEADSHOTS]++;
			g_aSession[attacker][HEADSHOTS]++;
		}
		
		g_aStats[victim][DEATHS]++;
		g_aSession[victim][DEATHS]++;
		if (attacker < MAXPLAYERS) {
			g_aStats[attacker][KILLS]++;
			g_aSession[attacker][KILLS]++;
		}
		if (g_bPointsLoseRoundCeil) 
		{
			g_aStats[victim][SCORE] -= RoundToCeil(score_dif * g_fPercentPointsLose);
			g_aSession[victim][SCORE] -= RoundToCeil(score_dif * g_fPercentPointsLose);
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if (g_aStats[victim][SCORE] < g_PointsMin)
				{
					g_aStats[victim][SCORE] = g_PointsMin;
				}
			}
			
		} 
		else 
		{
			g_aStats[victim][SCORE] -= RoundToFloor(score_dif * g_fPercentPointsLose);
			g_aSession[victim][SCORE] -= RoundToFloor(score_dif * g_fPercentPointsLose);
			
			/* Min points */
			if (g_bPointsMinEnabled)
			{
				if (g_aStats[victim][SCORE] < g_PointsMin)
				{
					g_aStats[victim][SCORE] = g_PointsMin;
				}
			}
		}
		if (attacker < MAXPLAYERS) {
			g_aStats[attacker][SCORE] += score_dif;
			g_aSession[attacker][SCORE] += score_dif;
			if (GetWeaponNum(weapon) < 42)
				g_aWeapons[attacker][GetWeaponNum(weapon)]++;
		}
		
		if (g_MinimalKills == 0 || (g_aStats[victim][KILLS] >= g_MinimalKills && g_aStats[attacker][KILLS] >= g_MinimalKills)) {
			if (g_bChatChange) {
				//PrintToServer("%s %T",MSG,"Killing",g_aClientName[attacker],g_aStats[attacker][SCORE],score_dif,g_aClientName[victim],g_aStats[victim][SCORE]);
				if(!hidechat[victim])	
				{
					CPrintToChat(victim, "%s %T", MSG, "Killing", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE]);
				}
				if (attacker < MAXPLAYERS)
				{
					if(!hidechat[attacker])
					{
						CPrintToChat(attacker, "%s %T", MSG, "Killing", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE]);
					}
				}
			}
		} else {
			if (g_aStats[victim][KILLS] < g_MinimalKills && g_aStats[attacker][KILLS] < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingBothNotRanked", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[attacker][KILLS], g_MinimalKills, g_aStats[victim][KILLS], g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingBothNotRanked", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[attacker][KILLS], g_MinimalKills, g_aStats[victim][KILLS], g_MinimalKills);
				}
			} else if (g_aStats[victim][KILLS] < g_MinimalKills) {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[victim][KILLS], g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingVictimNotRanked", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[victim][KILLS], g_MinimalKills);
				}
			} else {
				if (g_bChatChange) {
					if(!hidechat[victim])	CPrintToChat(victim, "%s %T", MSG, "KillingKillerNotRanked", victim, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[attacker][KILLS], g_MinimalKills);
					if (attacker < MAXPLAYERS)
						if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "KillingKillerNotRanked", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], score_dif, g_aClientName[victim], g_aStats[victim][SCORE], g_aStats[attacker][KILLS], g_MinimalKills);
				}
			}
		}
		if (headshot && attacker < MAXPLAYERS) {
			
			g_aStats[attacker][SCORE] += g_PointsHs;
			g_aSession[attacker][SCORE] += g_PointsHs;
			if (g_bChatChange && g_PointsHs > 0)
				if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "Headshot", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], g_PointsHs);
		}
		/* First blood */
		if (!firstblood && attacker < MAXPLAYERS) {
			
			g_aStats[attacker][SCORE] += g_PointsFb;
			g_aSession[attacker][SCORE] += g_PointsFb;
			
			g_aStats[attacker][FB] ++;
			g_aSession[attacker][FB] ++;
			if (g_bChatChange && g_PointsFb > 0)
				if(!hidechat[attacker])	CPrintToChat(attacker, "%s %T", MSG, "First Blood", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], g_PointsFb);
		}
		
		/* No scope */
		if( attacker < MAXPLAYERS && ((StrContains(weapon, "awp") != -1 || StrContains(weapon, "ssg08") != -1) || (g_bNSAllSnipers && (StrContains(weapon, "g3sg1") != -1 || StrContains(weapon, "scar20") != -1))) && (GetEntProp(attacker, Prop_Data, "m_iFOV") <= 0 || GetEntProp(attacker, Prop_Data, "m_iFOV") == GetEntProp(attacker, Prop_Data, "m_iDefaultFOV")))
		{
			g_aStats[attacker][SCORE]+= g_PointsNS;
			g_aSession[attacker][SCORE]+= g_PointsNS;
			g_aStats[attacker][NS]++;
			g_aSession[attacker][NS]++;
			
			float fNSD = Math_UnitsToMeters(Entity_GetDistance(victim, attacker));	
			
			// stats are int, so we change it from m to cm
			int iNSD = RoundToFloor(fNSD * 100);
			if(iNSD > g_aStats[attacker][NSD]) g_aStats[attacker][NSD] = iNSD;
			if(iNSD > g_aSession[attacker][NSD]) g_aSession[attacker][NSD] = iNSD;
			
			if(g_bChatChange && g_PointsNS > 0){
				if(!hidechat[attacker])	
				{
					CPrintToChat(attacker, "%s %T", MSG, "No Scope", attacker, g_aClientName[attacker], g_aStats[attacker][SCORE], g_PointsNS, g_aClientName[victim], weapon, fNSD);
				}
			}
		}
	}
			
	/* Assist */
	if(assist && attacker < MAXPLAYERS){
		
		//Do not attack your teammate, my friend
		if(GetClientTeam(victim) == GetClientTeam(assist))	return;
		else
		{
			g_aStats[assist][SCORE]+= g_PointsAssistKill;
			g_aSession[assist][SCORE]+= g_PointsAssistKill;
			g_aStats[assist][ASSISTS]++;
			g_aSession[assist][ASSISTS]++;
			
			if(g_bChatChange && g_PointsAssistKill > 0){
				if(!hidechat[assist])	CPrintToChat(assist, "%s %T", MSG, "AssistKill", assist, g_aClientName[assist], g_aStats[assist][SCORE], g_PointsAssistKill, g_aClientName[attacker], g_aClientName[victim]);
			}
		}
	}
	
	if (attacker < MAXPLAYERS)
		if (g_aStats[attacker][KILLS] == 50)
		g_TotalPlayers++;
		
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
		
		g_aStats[attacker][HITS]++;
		g_aSession[attacker][HITS]++;
		g_aHitBox[attacker][hitgroup]++;
		
		int damage = GetEventInt(event, "dmg_health");
		g_aStats[attacker][DAMAGE] += damage;
		g_aSession[attacker][DAMAGE] += damage;
		
		//PrintToChat(attacker, "Hitgroup %i: %i hits", hitgroup, g_aHitBox[attacker][hitgroup]);
		//PrintToServer("Stats Hits: %i\nSession Hits: %i\nHitBox %i -> %i",g_aStats[attacker][HITS],g_aSession[attacker][HITS],hitgroup,g_aHitBox[attacker][hitgroup]);
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
	
	g_aStats[client][SHOTS]++;
	g_aSession[client][SHOTS]++;
}

public void SalvarPlayer(int client) {
	if (!g_bEnabled || !g_bGatherStats || g_MinimumPlayers > GetCurrentPlayers())
		return;
	if (!g_bRankBots && (!IsValidClient(client) || IsFakeClient(client)))
		return;
	if (!OnDB[client])
		return;
	
	char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hStatsDb, g_aClientName[client], sEscapeName, sizeof(sEscapeName));
	//SQL_EscapeString(g_hStatsDb,name,name,sizeof(name));
	
	// Make SQL-safe
	//ReplaceString(name, sizeof(name), "'", "");
	
	char weapons_query[1000] = "";
	for (int i = 0; i < 42; i++) {
		Format(weapons_query, sizeof(weapons_query), "%s,%s='%d'", weapons_query, g_sWeaponsNamesGame[i], g_aWeapons[client][i]);
	}
	
	/* SM1.9 Fix*/
	char query[4000];
	char query2[4000];
	
	if (g_RankBy == 0) 
	{
		Format(query, sizeof(query), g_sSqlSave, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
			g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], g_aClientSteam[client]);
	
		Format(query2, sizeof(query2), g_sSqlSave2, g_sSQLTable, g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
			g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], g_aClientSteam[client]);
	} 
	
	else if (g_RankBy == 1) 
	{
		Format(query, sizeof(query), g_sSqlSaveName, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
			g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], sEscapeName);
	
		Format(query2, sizeof(query2), g_sSqlSaveName2, g_sSQLTable, g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
			g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], sEscapeName);
	} 
	
	else if (g_RankBy == 2) 
	{
		Format(query, sizeof(query), g_sSqlSaveIp, g_sSQLTable, g_aStats[client][SCORE], g_aStats[client][KILLS], g_aStats[client][DEATHS], g_aStats[client][ASSISTS], g_aStats[client][SUICIDES], g_aStats[client][TK], 
			g_aStats[client][SHOTS], g_aStats[client][HITS], g_aStats[client][HEADSHOTS], g_aStats[client][ROUNDS_TR], g_aStats[client][ROUNDS_CT], g_aClientIp[client], sEscapeName, weapons_query, 
			g_aHitBox[client][1], g_aHitBox[client][2], g_aHitBox[client][3], g_aHitBox[client][4], g_aHitBox[client][5], g_aHitBox[client][6], g_aHitBox[client][7], g_aClientIp[client]);
	
		Format(query2, sizeof(query2), g_sSqlSaveIp2,  g_aStats[client][C4_PLANTED], g_aStats[client][C4_EXPLODED], g_aStats[client][C4_DEFUSED], g_aStats[client][CT_WIN], g_aStats[client][TR_WIN], 
			g_aStats[client][HOSTAGES_RESCUED], g_aStats[client][VIP_KILLED], g_aStats[client][VIP_ESCAPED], g_aStats[client][VIP_PLAYED], g_aStats[client][MVP], g_aStats[client][DAMAGE], g_aStats[client][MATCH_WIN], g_aStats[client][MATCH_DRAW], g_aStats[client][MATCH_LOSE], g_aStats[client][FB], g_aStats[client][NS], g_aStats[client][NSD], GetTime(), g_aStats[client][CONNECTED] + GetTime() - g_aSession[client][CONNECTED], g_aClientIp[client]);
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
	
	OnDB[client] = false;
	for (int i = 0; i <= 19; i++) {
		g_aSession[client][i] = 0;
		g_aStats[client][i] = 0;
	}
	g_aStats[client][SCORE] = g_PointsStart;
	for (int i = 0; i < 42; i++) {
		g_aWeapons[client][i] = 0;
	}
	g_aSession[client][CONNECTED] = GetTime();
	
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
	if (g_RankBy == 1)
		FormatEx(query, sizeof(query), g_sSqlRetrieveClientName, g_sSQLTable, sEscapeName);
	else if (g_RankBy == 0)
		FormatEx(query, sizeof(query), g_sSqlRetrieveClient, g_sSQLTable, auth);
	else if (g_RankBy == 2)
		FormatEx(query, sizeof(query), g_sSqlRetrieveClientIp, g_sSQLTable, ip);
	
	if (DEBUGGING) {
		PrintToServer(query);
		LogError("%s", query);
	}
	if (g_hStatsDb != INVALID_HANDLE)
		SQL_TQuery(g_hStatsDb, SQL_LoadPlayerCallback, query, client);
	
}

public void SQL_LoadPlayerCallback(Handle owner, Handle hndl, const char[] error, any client)
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
		for (int i = 0; i <= 11; i++) {
			g_aStats[client][i] = SQL_FetchInt(hndl, 4 + i);
		}
		
		//ALL 41 Weapons
		for (int i = 0; i < 42; i++) {
			g_aWeapons[client][i] = SQL_FetchInt(hndl, 17 + i);
		}
		
		//ALL 8 Hitboxes
		for (int i = 1; i <= 7; i++) {
			g_aHitBox[client][i] = SQL_FetchInt(hndl, 57 + i);
		}
		
		g_aStats[client][C4_PLANTED] = SQL_FetchInt(hndl, 66);
		g_aStats[client][C4_EXPLODED] = SQL_FetchInt(hndl, 67);
		g_aStats[client][C4_DEFUSED] = SQL_FetchInt(hndl, 68);
		g_aStats[client][CT_WIN] = SQL_FetchInt(hndl, 69);
		g_aStats[client][TR_WIN] = SQL_FetchInt(hndl, 70);
		g_aStats[client][HOSTAGES_RESCUED] = SQL_FetchInt(hndl, 71);
		g_aStats[client][VIP_KILLED] = SQL_FetchInt(hndl, 72);
		g_aStats[client][VIP_ESCAPED] = SQL_FetchInt(hndl, 73);
		g_aStats[client][VIP_PLAYED] = SQL_FetchInt(hndl, 74);
		g_aStats[client][MVP] = SQL_FetchInt(hndl, 75);
		g_aStats[client][DAMAGE] = SQL_FetchInt(hndl, 76);
		g_aStats[client][MATCH_WIN] = SQL_FetchInt(hndl, 77);
		g_aStats[client][MATCH_DRAW] = SQL_FetchInt(hndl, 78);
		g_aStats[client][MATCH_LOSE] = SQL_FetchInt(hndl, 79);
		g_aStats[client][FB] = SQL_FetchInt(hndl, 80);
		g_aStats[client][NS] = SQL_FetchInt(hndl, 81);
		g_aStats[client][NSD] = SQL_FetchInt(hndl, 82);
	} else {
		char query[10000];
		char sEscapeName[MAX_NAME_LENGTH * 2 + 1];
		SQL_EscapeString(g_hStatsDb, g_aClientName[client], sEscapeName, sizeof(sEscapeName));
		//SQL_EscapeString(g_hStatsDb,name,name,sizeof(name));
		//ReplaceString(name, sizeof(name), "'", "");
		
		Format(query, sizeof(query), g_sSqlInsert, g_sSQLTable, g_aClientSteam[client], sEscapeName, g_aClientIp[client], g_PointsStart);
		SQL_TQuery(g_hStatsDb, SQL_NothingCallback, query, _, DBPrio_High);
		
		if (DEBUGGING) {
			PrintToServer(query);
			
			LogError("%s", query);
		}
	}
	OnDB[client] = true;
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
	OnDB[client] = false;
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
		WriteFileLine(File1, g_sMysqlCreate, g_sSQLTable);
		WriteFileLine(File1, "");
	}
	
	if(!g_bMysql)
	{
		WriteFileLine(File1, g_sSqliteCreate, g_sSQLTable);
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
		
		WriteFileLine(File1, "INSERT INTO `%s` VALUES (%s);", g_sSQLTable, fields_values);
	}
	CloseHandle(File1);
}

public void OnConVarChanged(Handle convar, const char[] oldValue, const char[] newValue) {
	int g_bQueryPlayerCount;
	
	if (convar == g_cvarShowBotsOnRank) {
		g_bShowBotsOnRank = g_cvarShowBotsOnRank.BoolValue;
		g_bQueryPlayerCount = true;
	}
	else if (convar == g_cvarRankBy) {
		g_RankBy = g_cvarRankBy.IntValue;
	}
	else if (convar == g_cvarEnabled) {
		g_bEnabled = g_cvarEnabled.BoolValue;
	}
	else if (convar == g_cvarShowRankAll) {
		g_bShowRankAll = g_cvarShowRankAll.BoolValue;
	}
	else if (convar == g_cvarRankAllTimer) {
		g_fRankAllTimer = g_cvarRankAllTimer.FloatValue;
	}
	else if (convar == g_cvarChatChange) {
		g_bChatChange = g_cvarChatChange.BoolValue;
	}
	else if (convar == g_cvarRankbots) {
		g_bRankBots = g_cvarRankbots.BoolValue;
		g_bQueryPlayerCount = true;
	}
	else if (convar == g_cvarFfa) {
		g_bFfa = g_cvarFfa.BoolValue;
	}
	else if (convar == g_cvarDumpDB) {
		g_bDumpDB = g_cvarDumpDB.BoolValue;
	}
	else if (convar == g_cvarPointsBombDefusedTeam) {
		g_PointsBombDefusedTeam = g_cvarPointsBombDefusedTeam.IntValue;
	}
	else if (convar == g_cvarPointsBombDefusedPlayer) {
		g_PointsBombDefusedPlayer = g_cvarPointsBombDefusedPlayer.IntValue;
	}
	else if (convar == g_cvarPointsBombPlantedTeam) {
		g_PointsBombPlantedTeam = g_cvarPointsBombPlantedTeam.IntValue;
	}
	else if (convar == g_cvarPointsBombPlantedPlayer) {
		g_PointsBombPlantedPlayer = g_cvarPointsBombPlantedPlayer.IntValue;
	}
	else if (convar == g_cvarPointsBombExplodeTeam) {
		g_PointsBombExplodeTeam = g_cvarPointsBombExplodeTeam.IntValue;
	}
	else if (convar == g_cvarPointsBombExplodePlayer) {
		g_PointsBombExplodePlayer = g_cvarPointsBombExplodePlayer.IntValue;
	}
	else if (convar == g_cvarPointsHostageRescTeam) {
		g_PointsHostageRescTeam = g_cvarPointsHostageRescTeam.IntValue;
	}
	else if (convar == g_cvarPointsHostageRescPlayer) {
		g_PointsHostageRescPlayer = g_cvarPointsHostageRescPlayer.IntValue;
	}
	else if (convar == g_cvarPointsHs) {
		g_PointsHs = g_cvarPointsHs.IntValue;
	}
	else if (convar == g_cvarPointsKillCt) {
		g_PointsKill[CT] = g_cvarPointsKillCt.IntValue;
	}
	else if (convar == g_cvarPointsKillTr) {
		g_PointsKill[TR] = g_cvarPointsKillTr.IntValue;
	}
	else if (convar == g_cvarPointsKillBonusCt) {
		g_PointsKillBonus[CT] = g_cvarPointsKillBonusCt.IntValue;
	}
	else if (convar == g_cvarPointsKillBonusTr) {
		g_PointsKillBonus[TR] = g_cvarPointsKillBonusTr.IntValue;
	}
	else if (convar == g_cvarPointsKillBonusDifCt) {
		g_PointsKillBonusDif[CT] = g_cvarPointsKillBonusDifCt.IntValue;
	}
	else if (convar == g_cvarPointsKillBonusDifTr) {
		g_PointsKillBonusDif[TR] = g_cvarPointsKillBonusDifTr.IntValue;
	}
	else if (convar == g_cvarPointsStart) {
		g_PointsStart = g_cvarPointsStart.IntValue;
	}
	else if (convar == g_cvarPointsKnifeMultiplier) {
		g_fPointsKnifeMultiplier = g_cvarPointsKnifeMultiplier.FloatValue;
	}
	else if (convar == g_cvarPointsTaserMultiplier) {
		g_fPointsTaserMultiplier = g_cvarPointsTaserMultiplier.FloatValue;
	}
	else if (convar == g_cvarPointsTrRoundWin) {
		g_PointsRoundWin[TR] = g_cvarPointsTrRoundWin.IntValue;
	}
	else if (convar == g_cvarPointsCtRoundWin) {
		g_PointsRoundWin[CT] = g_cvarPointsCtRoundWin.IntValue;
	}
	else if (convar == g_cvarPointsTrRoundLose) {
		g_PointsRoundLose[TR] = g_cvarPointsTrRoundLose.IntValue;
	}
	else if (convar == g_cvarPointsCtRoundLose) {
		g_PointsRoundLose[CT] = g_cvarPointsCtRoundLose.IntValue;
	}
	else if (convar == g_cvarMinimalKills) {
		g_MinimalKills = g_cvarMinimalKills.IntValue;
	}
	else if (convar == g_cvarPercentPointsLose) {
		g_fPercentPointsLose = g_cvarPercentPointsLose.FloatValue;
	}
	else if (convar == g_cvarPointsLoseRoundCeil) {
		g_bPointsLoseRoundCeil = g_cvarPointsLoseRoundCeil.BoolValue;
	}
	else if (convar == g_cvarMinimumPlayers) {
		g_MinimumPlayers = g_cvarMinimumPlayers.IntValue;
	}
	else if (convar == g_cvarResetOwnRank) {
		g_bResetOwnRank = g_cvarResetOwnRank.BoolValue;
	}
	else if (convar == g_cvarPointsVipEscapedTeam) {
		g_PointsVipEscapedTeam = g_cvarPointsVipEscapedTeam.IntValue;
	}
	else if (convar == g_cvarPointsVipEscapedPlayer) {
		g_PointsVipEscapedPlayer = g_cvarPointsVipEscapedPlayer.IntValue;
	}
	else if (convar == g_cvarPointsVipKilledTeam) {
		g_PointsVipKilledTeam = g_cvarPointsVipKilledTeam.IntValue;
	}
	else if (convar == g_cvarPointsVipKilledPlayer) {
		g_PointsVipKilledPlayer = g_cvarPointsVipKilledPlayer.IntValue;
	}
	else if (convar == g_cvarVipEnabled) {
		g_bVipEnabled = g_cvarVipEnabled.BoolValue;
	}
	else if (convar == g_cvarDaysToNotShowOnRank) {
		g_DaysToNotShowOnRank = g_cvarDaysToNotShowOnRank.IntValue;
		g_bQueryPlayerCount = true;
	}
	else if (convar == g_cvarGatherStats) {
		g_bGatherStats = g_cvarGatherStats.BoolValue;
	}
	else if (convar == g_cvarRankMode) {
		g_RankMode = g_cvarRankMode.IntValue;
		BuildRankCache();
	}
	else if (convar == g_cvarChatTriggers) {
		g_bChatTriggers = g_cvarChatTriggers.BoolValue;
	}
	else if (convar == g_cvarPointsMvpCt) {
		g_PointsMvpCt = g_cvarPointsMvpCt.IntValue;
	}
	else if (convar == g_cvarPointsMvpTr) {
		g_PointsMvpTr = g_cvarPointsMvpTr.IntValue;
	}
	else if (convar == g_cvarPointsBombPickup) {
		g_PointsBombDropped = g_cvarPointsBombPickup.IntValue;
	}
	else if (convar == g_cvarPointsBombDropped) {
		g_PointsBombDropped = g_cvarPointsBombDropped.IntValue;
	}
	
	/*RankMe Connect Announcer*/
	else if(convar == g_cvarAnnounceConnect) {
		g_bAnnounceConnect = g_cvarAnnounceConnect.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceConnectChat) {
		g_bAnnounceConnectChat = g_cvarAnnounceConnectChat.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceConnectHint) {
		g_bAnnounceConnectHint = g_cvarAnnounceConnectHint.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceDisconnect) {
		g_bAnnounceDisconnect = g_cvarAnnounceDisconnect.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceTopConnect) {
		g_bAnnounceTopConnect = g_cvarAnnounceTopConnect.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceTopPosConnect) {
		g_AnnounceTopPosConnect = g_cvarAnnounceTopPosConnect.IntValue;
	}
	
	else if(convar == g_cvarAnnounceTopConnectChat) {
		g_bAnnounceTopConnectChat = g_cvarAnnounceTopConnectChat.BoolValue;
	}
	
	else if(convar == g_cvarAnnounceTopConnectHint) {
		g_bAnnounceTopConnectHint = g_cvarAnnounceTopConnectHint.BoolValue;
	}
	
	/* Assist */
	else if (convar == g_cvarPointsAssistKill){
		g_PointsAssistKill = g_cvarPointsAssistKill.IntValue;
	}
	
	/* Enable Or Disable Points In Warmup */
	else if (convar == g_cvarGatherStatsWarmup){
		g_bGatherStatsWarmup = g_cvarGatherStatsWarmup.BoolValue;
	}
	
	/* Min points */
	else if (convar == g_cvarPointsMin){
		g_PointsMin = g_cvarPointsMin.IntValue;
	}
	
	else if (convar == g_cvarPointsMinEnabled){
		g_bPointsMinEnabled = g_cvarPointsMinEnabled.BoolValue;
	}
	
	/* Rank Cache */
	else if (convar == g_cvarRankCache) {
		g_bRankCache = g_cvarRankCache.BoolValue;
	}
	
	else if (convar == g_cvarPointsMatchWin) {
		g_PointsMatchWin = g_cvarPointsMatchWin.IntValue;
	}
	
	else if (convar == g_cvarPointsMatchDraw) {
		g_PointsMatchDraw = g_cvarPointsMatchDraw.IntValue;
	}
	
	else if (convar == g_cvarPointsMatchLose) {
		g_PointsMatchLose = g_cvarPointsMatchLose.IntValue;
	}
	
	else if (convar == g_cvarPointsFb) {
		g_PointsFb = g_cvarPointsFb.IntValue;
	}
	
	else if (convar == g_cvarPointsNS) {
		g_PointsNS = g_cvarPointsNS.IntValue;
	}
	
	else if (convar == g_cvarNSAllSnipers) {
		g_bNSAllSnipers = g_cvarNSAllSnipers.BoolValue;
	}
	
	if (g_bQueryPlayerCount && g_hStatsDb != INVALID_HANDLE) {
		char query[10000];
		MakeSelectQuery(query, sizeof(query));
		SQL_TQuery(g_hStatsDb, SQL_GetPlayersCallback, query);
	}
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
	Format(sQuery, strsize, "SELECT * FROM `%s` WHERE kills >= '%d'", g_sSQLTable, g_MinimalKills);
	
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

public Action Event_PlayerDisconnect(Handle event, const char[] name, bool dontBroadcast)
{
	if(!g_bAnnounceDisconnect)
		return;
		
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
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

/* Hide Chat */
public Action CMD_HideChat(int client, int args){
	if(!hidechat[client]){
		SetClientCookie(client, hidechatcookie, "1");
		CPrintToChat(client, "%s %T", MSG, "Hide Rankme Chat", client);
		hidechat[client] = true;
	}
	else if(hidechat[client]){
		SetClientCookie(client, hidechatcookie, "0");
		CPrintToChat(client, "%s %T", MSG, "Show Rankme Chat", client);
		hidechat[client] = false;
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
					g_aStats[i][MATCH_LOSE]++;
					g_aStats[i][SCORE] -= g_PointsMatchLose;
				}
				else if (GetClientTeam(i) == CT)
				{
					g_aStats[i][MATCH_WIN]++;
					g_aStats[i][SCORE] += g_PointsMatchWin;
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
				g_aStats[i][MATCH_DRAW]++;
				g_aStats[i][SCORE] += g_PointsMatchDraw;
				
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
					g_aStats[i][MATCH_WIN]++;
					g_aStats[i][SCORE] += g_PointsMatchWin;
				}
				else if (GetClientTeam(i) == CT)
				{
					g_aStats[i][MATCH_LOSE]++;
					g_aStats[i][SCORE] -= g_PointsMatchLose;
				}
			}
		}
	}
}