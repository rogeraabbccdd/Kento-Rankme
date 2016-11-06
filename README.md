# RankMe Kento Edition
Rankme plugin for CSGO servers, improved from [benscobie's rankme](https://github.com/benscobie/sourcemod-rankme)

IF YOU WANT TO UPDATE YOUR RANKME TO MINE, YOU HAVE TO DELETE YOUR OLD RANKME DATABASE

## Forum Thread
https://forums.alliedmods.net/showthread.php?p=2467665

##Changes
* Add Color Support (Edited csgocolors.inc)
* Add CSGO Weapons (Revolver, USP-S, M4A1-S, CZ75-A...etc)
* Fix Molotov & Inc Grenade Bug (They are count in "Inferno")
* Fix knife_falchion, knife_push and knife_survival_bowie will not count bug
* Include [RankMe Connect Announcer](https://forums.alliedmods.net/showthread.php?t=169162)
* Add Kill Assist Support. (Edited from [pracc's rankme](http://hlmod.ru/resources/cs-go-rankme-web.132/), You will get point if you assist kill enemy.)
* Weapon Stats Update For Old Rankme Webinterface (check "how to update.txt" in the folder for more info)

##New Cvars

###From [RankMe Connect Announcer](https://forums.alliedmods.net/showthread.php?t=169162)
"rankme_announcer_player_connect"		"1"	//Announce when a player connect with position and points?
"rankme_announcer_player_connect_chat"		"1" 	//Announce when a player connect at chat?
"rankme_announcer_player_connect_hint"		"0"	//Announce when a player connect at hintbox?
"rankme_announcer_player_disconnect"		"1"	//Announce when a player disconnect with position and points?
"rankme_announcer_top_player_connect"		"1"	//Announce when a top player connect?
"rankme_announcer_top_pos_player_connect"	"10"	//Max position to announce that a top player connect?
"rankme_announcer_top_player_connect_chat"	"1"	//Announce when a top player connect at chat?
"rankme_announcer_top_player_connect_hint"	"0"	//Announce when a top player connect at hintbox?

###From [pracc's rankme](http://hlmod.ru/resources/cs-go-rankme-web.132/)
"rankme_points_assiist_kill"	"1"	// How many points a player loess for assist kill?

##Credits
* [lok1](https://forums.alliedmods.net/showthread.php?t=155621) - Developed the original RankMe plugin that this plugin is based on.
* [benscobie](https://github.com/benscobie/sourcemod-rankme) - This plugin is improved from his version.
* [pracc](http://hlmod.ru/resources/cs-go-rankme-web.132/) - Code of kill assist is edited from his rankme

##Pictures Preview
![](http://i.imgur.com/61RcRQf.jpg "")

![](http://i.imgur.com/HDcyseY.jpg "")

![](http://i.imgur.com/61RcRQf.jpg "")

![](http://i.imgur.com/GMc9AKk.jpg "")

![](http://i.imgur.com/DA8FYdA.jpg "")

![](http://i.imgur.com/z9PpSmj.jpg "")

##Known Bugs
* [Can't run in SM1.9 server](https://forums.alliedmods.net/showpost.php?p=2467450&postcount=1247)

##To Do
* Add assist stats to database (I think KD is enough, no need to add Assist)
* Rewrite with new syntax (Maybe? I'm too lazy.)
