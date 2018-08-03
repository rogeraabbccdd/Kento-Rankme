// FROM SMLIB
stock Array_FindHighestValue(any:array[], size, start=0){
	if (start < 0) {
		start = 0;
	}

	new any:value = array[start];
	new any:tempValue;
	new x = start;
	
	for (new i=start; i < size; i++) {
		
		tempValue = array[i];
		
		if (tempValue > value) {
			value = tempValue;
			x = i;
		}
		
	}
	
	return x;
}

public Action:CMD_ResetRank(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new String:arg1[64];
	GetCmdArg(1,arg1,sizeof(arg1));
	new String:sEscapeArg1[129];
	SQL_EscapeString(g_hStatsDb,arg1,sEscapeArg1,sizeof(sEscapeArg1));
	//ReplaceString(arg1,sizeof(arg1)," ","");
	//ReplaceString(arg1,sizeof(arg1),"\"","");
	new String:query[2000];
	if(g_RankBy == 1){
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE name='%s'",g_sSQLTable,sEscapeArg1);
	} else if (g_RankBy == 0){
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE steam='%s'",g_sSQLTable,sEscapeArg1);
	} else if (g_RankBy == 2){
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE lastip='%s'",g_sSQLTable,sEscapeArg1);
	}
	SQL_TQuery(g_hStatsDb,SQL_NothingCallback,query);
	LogAction(client,-1,"[RankMe]: Rank has been reset (%s)",arg1);
	new String:auth[64];
	new String:name[MAX_NAME_LENGTH];
	new String:ip[64];
	for(new i=1;i<=MaxClients;i++){
		if(IsClientInGame(i)){
		
			if(g_RankBy == 1){
				
				GetClientName(i,name,sizeof(name));
				
				if(StrEqual(name,arg1,false))
					OnClientPutInServer(i);
			
			} else if(g_RankBy == 0){
				GetClientAuthId(i,AuthId_Steam2,auth,sizeof(auth));
				
				if(StrEqual(auth,arg1,false))
					OnClientPutInServer(i);
			} else if(g_RankBy == 2){
				
				GetClientIP(i,ip,sizeof(ip));
				
				if(StrEqual(ip,arg1,false))
					OnClientPutInServer(i);
			
			}
		}
	}
	CPrintToChat(client, "%s %T", MSG, "The rank has been reset",client);
	return Plugin_Handled;
}

public Action:CMD_ResetRankAll(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
		
	new String:query[2000];
	Format(query,sizeof(query),"DELETE FROM `%s` WHERE 1=1",g_sSQLTable);
	SQL_TQuery(g_hStatsDb,SQL_NothingCallback,query);
	
	LogAction(client,-1,"[RankMe]: All rank data has been reset");
	
	for(new i=1;i<=MaxClients;i++){
		if(IsClientInGame(i))
			OnClientPutInServer(i);
	}
	CPrintToChat(client, "%s %T", MSG, "All rank data has been reset",client);
	return Plugin_Handled;
}

public Action:CMD_Purge(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new String:arg1[64];
	
	GetCmdArg(1,arg1,sizeof(arg1));
	new String:sEscapeArg1[129];
	SQL_EscapeString(g_hStatsDb,arg1,sEscapeArg1,sizeof(sEscapeArg1));
	//ReplaceString(arg1,sizeof(arg1)," ","");
	//ReplaceString(arg1,sizeof(arg1),"\"","");
	
	new deletebefore;
	if(StringToInt(arg1) == 0){
		CPrintToChat(client, "%s %T", MSG, "Usagepurge",client);
		return Plugin_Handled;
	}
	deletebefore = GetTime() - (StringToInt(arg1)*86400);
	new String:query[2000];
	Format(query,sizeof(query),"DELETE FROM `%s` WHERE lastconnect < '%d'",g_sSQLTable,deletebefore);
	SQL_TQuery(g_hStatsDb,SQL_PurgeCallback,query);
	LogAction(client,-1,"[RankMe]: Purged rank (%s days inactivity)",arg1);
	CPrintToChat(client, "%s %T", MSG, "Purged",client);
	return Plugin_Handled;
}

public SQL_GetPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	g_TotalPlayers =SQL_GetRowCount(hndl);
}

public Action:CMD_TopWeapon(client,args){
	
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	if(args > 0){
		new String:arg1[20];
		new String:arg2[5];
		GetCmdArg(1,arg1,sizeof(arg1));
		GetCmdArg(2,arg2,sizeof(arg2));
		if(!StrEqual(arg1,"") && StringToInt(arg2) != 0){
			ShowTOPWeapon(client,GetWeaponNum(arg1),StringToInt(arg2));
		}	else if(!StrEqual(arg1,"")){
			ShowTOPWeapon(client,GetWeaponNum(arg1),0);
		}
	} else {
		new Handle:menu = CreateMenu(MenuHandler_TopWeapon_Choose);
		SetMenuTitle(menu,"Top Weapon:");
		for(new i=0;i<=39;i++){
			AddMenuItem(menu,g_sWeaponsNamesGame[i],g_sWeaponsNamesFull[i]);
		}
		DisplayMenu(menu,client,MENU_TIME_FOREVER);
	}
	return Plugin_Handled;
}

public MenuHandler_TopWeapon_Choose(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTOPWeapon(param1,GetWeaponNum(temp),0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

ShowTOPWeapon(client,weapon,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	WritePackCell(Datapack,weapon);
	if(at>0){
		WritePackCell(Datapack,at-1);
		
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY %s DESC LIMIT %i, 10",query,g_sWeaponsNamesGame[weapon],at-1);
	
	SQL_TQuery(g_hStatsDb,SQL_TopWeaponCallback,query,Datapack);

}

public SQL_TopWeaponCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
		
	new weapon = ReadPackCell(Datapack);
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTOPWeapon(client,weapon,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopWeapon);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];

	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		i++;
		SQL_FetchString(hndl,2,name,sizeof(name));
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %T: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Kills",client,SQL_FetchInt(hndl,17+weapon));
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%d;%d",weapon,0);
	AddMenuItem(menu,temp1,temp);
	
	
	Format(temp,sizeof(temp),"%d;%d",weapon,at+i);
	
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	Format(temp,sizeof(temp),"%d;%d",weapon,at-i);
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);
	
	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopWeapon(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		
		new String:v[2][5];
		ExplodeString(temp,";",v,2,5);
		if(StringToInt(v[1]) >= 0){
			ShowTOPWeapon(param1,StringToInt(v[0]),StringToInt(v[1])+1);
		} else {
			ShowTOPWeapon(param1,StringToInt(v[0]),0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_Top(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	
	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTOP(client,StringToInt(arg1));
	}	else {
		ShowTOP(client,0);
	}
	return Plugin_Handled;
}

ShowTOP(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	if(g_RankMode == 1)
		Format(query,sizeof(query),"%s ORDER BY score DESC LIMIT %i, 10",query,at-1);
	else if(g_RankMode == 2){
		if(g_bMysql)
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC, score DESC LIMIT %i, 10",query,at-1);
		else
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as float)/CAST(Case when deaths=0 then 1 ELSE deaths END as float) DESC, score DESC LIMIT %i, 10",query,at-1);
	}
	
	SQL_TQuery(g_hStatsDb,SQL_TopCallback,query,Datapack);

}

public SQL_TopCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTOP(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_Top);
	
	new Float:kdr;
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
		new deaths;
		if(SQL_FetchInt(hndl,6) == 0)
			deaths = 1;
		else 
			deaths=SQL_FetchInt(hndl,6);
		
		kdr = SQL_FetchFloat(hndl,5)/deaths;
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - KDR: %.2f\n",i+at,name,SQL_FetchInt(hndl,4),kdr);
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);
	
	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_Top(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTOP(param1,StringToInt(temp)+1);
		} else {
			ShowTOP(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

/*
public Action:CMD_TopKnife(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTOPKnife(client,StringToInt(arg1));
	}	else {
		ShowTOPKnife(client,0);
	}
	return Plugin_Handled;
}

ShowTOPKnife(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY knife DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopKnifeCallback,query,Datapack);

}

public SQL_TopKnifeCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTOPKnife(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopKnife);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %T: %d\n",i+at,name,SQL_FetchInt(hndl,4),"KnifeKills",client,SQL_FetchInt(hndl,17));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopKnife(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTOPKnife(param1,StringToInt(temp)+1);
		} else {
			ShowTOPKnife(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopTaser(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTOPTaser(client,StringToInt(arg1));
	}	else {
		ShowTOPTaser(client,0);
	}
	return Plugin_Handled;
}

ShowTOPTaser(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY taser DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopTaserCallback,query,Datapack);

}

public SQL_TopTaserCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTOPTaser(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopTaser);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %T: %d\n",i+at,name,SQL_FetchInt(hndl,4),"TaserKills",client,SQL_FetchInt(hndl,55));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopTaser(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTOPTaser(param1,StringToInt(temp)+1);
		} else {
			ShowTOPTaser(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopNade(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTOPNade(client,StringToInt(arg1));
	}	else {
		ShowTOPNade(client,0);
	}
	return Plugin_Handled;
}

ShowTOPNade(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:sQuery[400];
	// Make basic query
	Format(sQuery,sizeof(sQuery),"SELECT name,score,hegrenade+flashbang+smokegrenade as nadekill FROM `%s` where kills >= '%d'",g_sSQLTable,g_MinimalKills);
		
	// Append check for bots
	if(g_bRankBots && g_bShowBotsOnRank)
		Format(sQuery,sizeof(sQuery),"%s AND steam <> 'BOT'",sQuery);
	
	// Append check for inactivity
	if(g_DaysToNotShowOnRank > 0)
		Format(sQuery,sizeof(sQuery),"%s AND lastconnect >= '%d'",sQuery,GetTime()-(g_DaysToNotShowOnRank*86400));
	
	Format(sQuery,sizeof(sQuery),"%s ORDER BY nadekill DESC LIMIT %i, 10",sQuery,at-1);
			
	SQL_TQuery(g_hStatsDb,SQL_TopNadeCallback,sQuery,Datapack);

}

public SQL_TopNadeCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTOPNade(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopNade);
	new String:sBuffer[200];
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,0,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %T: %d\n",i+at,name,SQL_FetchInt(hndl,1),"Kills",client,SQL_FetchInt(hndl,2));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopNade(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTOPNade(param1,StringToInt(temp)+1);
		} else {
			ShowTOPNade(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
*/

public Action:CMD_TopHS(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopHS(client,StringToInt(arg1));
	}	else {
		ShowTopHS(client,0);
	}
	return Plugin_Handled;
}

ShowTopHS(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY headshots DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopHSCallback,query,Datapack);

}

public SQL_TopHSCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopHS(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopHS);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Headshots",SQL_FetchInt(hndl,12));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopHS(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopHS(param1,StringToInt(temp)+1);
		} else {
			ShowTopHS(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopKills(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopKills(client,StringToInt(arg1));
	}	else {
		ShowTopKills(client,0);
	}
	return Plugin_Handled;
}

ShowTopKills(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY kills DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopKillsCallback,query,Datapack);

}

public SQL_TopKillsCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopKills(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopKills);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Kills",SQL_FetchInt(hndl,5));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopKills(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopKills(param1,StringToInt(temp)+1);
		} else {
			ShowTopKills(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopDeaths(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopDeaths(client,StringToInt(arg1));
	}	else {
		ShowTopDeaths(client,0);
	}
	return Plugin_Handled;
}

ShowTopDeaths(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY deaths DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopDeathsCallback,query,Datapack);

}

public SQL_TopDeathsCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopDeaths(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopDeaths);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Deaths",SQL_FetchInt(hndl,6));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopDeaths(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopDeaths(param1,StringToInt(temp)+1);
		} else {
			ShowTopDeaths(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopAcc(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	
	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopAcc(client,StringToInt(arg1));
	}	else {
		ShowTopAcc(client,0);
	}
	return Plugin_Handled;
}

ShowTopAcc(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	
	if(g_bMysql)
		Format(query,sizeof(query),"%s ORDER BY CAST(hits as DECIMAL)/CAST(Case when shots=0 then 1 ELSE shots END as DECIMAL) DESC LIMIT %i, 10",query,at-1);
	else
		Format(query,sizeof(query),"%s ORDER BY CAST(hits as float)/CAST(Case when shots=0 then 1 ELSE shots END as float) DESC LIMIT %i, 10",query,at-1);
	
	SQL_TQuery(g_hStatsDb,SQL_TopAccCallback,query,Datapack);

}

public SQL_TopAccCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopAcc(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopAcc);

	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new shots;
	new hits;
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		shots = SQL_FetchInt(hndl,10);
		if(shots == 0)
			shots = 1;
		
		hits = SQL_FetchInt(hndl,11);
		
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %T: %.2f%%\n",i+at,name,SQL_FetchInt(hndl,4),"Accuracy",client,IntToFloat(hits)/shots*100);
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);
	
	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopAcc(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopAcc(param1,StringToInt(temp)+1);
		} else {
			ShowTopAcc(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_TopTime(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopTime(client,StringToInt(arg1));
	}	else {
		ShowTopTime(client,0);
	}
	return Plugin_Handled;
}

ShowTopTime(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY connected DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopTimeCallback,query,Datapack);

}

public SQL_TopTimeCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopTime(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopTime);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	new time;
	new hours;
	new minutes;
	
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		time = SQL_FetchInt(hndl,13);
		hours = RoundToFloor(time/3600.0);
		time = time-(hours*3600);
		minutes = RoundToFloor(time/60.0);
		time = time-(minutes*60);
		
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %d:%d:%d\n",i+at,name,SQL_FetchInt(hndl,4),hours,minutes,time);
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopTime(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopTime(param1,StringToInt(temp)+1);
		} else {
			ShowTopTime(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MenuHandler_DoNothing(Handle:menu, MenuAction:action, param1, param2){
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action:CMD_Rank(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	//LogToFile("rankme.debug.log","\"sm_rank\" command called by client %d.",client);
	if(g_aStats[client][KILLS] < g_MinimalKills){
		CPrintToChat(client,"%s %T",MSG,"NotRanked",client,g_aStats[client][KILLS],g_MinimalKills);
		return Plugin_Handled;
	}
	
	// check cooldown
	if(g_bShowRankAll && hRankTimer[client] != INVALID_HANDLE)
	{
		CPrintToChat(client,"%s %T",MSG,"RankCooldown",client);
		return Plugin_Handled;
	}
	
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	
	if(g_RankMode == 1)
		Format(query,sizeof(query),"%s ORDER BY score DESC",query);
	else if(g_RankMode == 2){
		if(g_bMysql)
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC, score DESC",query);
		else
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as float)/CAST(Case when deaths=0 then 1 ELSE deaths END as float) DESC, score DESC",query);
	}	
		
	SQL_TQuery(g_hStatsDb,SQL_RankCallback,query,client);
	return Plugin_Handled;
}

public SQL_RankCallback(Handle:owner, Handle:hndl, const String:error[], any:client){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	if(client == 0 || !IsClientInGame(client))
		return;
	//LogToFile("rankme.debug.log","Rank SQL callback called by client %d.",client);
	new i;
	
	g_TotalPlayers =SQL_GetRowCount(hndl);
	new String:Name_receive[MAX_NAME_LENGTH];
	new String:Auth_receive[64];
	new String:Ip_receive[64];
	
	new ikills = g_aStats[client][KILLS];
	new ideaths=g_aStats[client][DEATHS];
	
	new deaths;
	if(ideaths == 0)
		deaths = 1;
	else 
		deaths=ideaths;
	
	new Float:kills = IntToFloat(ikills);
	
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		i++;
		SQL_FetchString(hndl,2,Name_receive,MAX_NAME_LENGTH*2+1);
		SQL_FetchString(hndl,1,Auth_receive,64);
		SQL_FetchString(hndl,3,Ip_receive,64);
	//	PrintToServer("%d %s %s",i, Name_receive, Auth_receive);
		if((g_RankBy == 1 && StrEqual(Name_receive,g_aClientName[client],false)) || (g_RankBy == 0 && StrEqual(Auth_receive,g_aClientSteam[client],false)) || (g_RankBy == 2 && StrEqual(Ip_receive,g_aClientIp[client],false))){

			if(g_bShowRankAll)
			{
				for(new j = 1; j <= MaxClients;j++)
				{
					if(IsClientInGame(j))
					{
						CPrintToChat(j,"%s %T",MSG,"IsRankedAt",j,g_aClientName[client],i,g_TotalPlayers,g_aStats[client][SCORE],g_aStats[client][KILLS],g_aStats[client][DEATHS],g_aStats[client][ASSISTS],kills/deaths,g_aStats[client][TK],g_aStats[client][MVP]);
						if (g_fRankAllTimer > 0.0)hRankTimer[j] = CreateTimer(g_fRankAllTimer, KillRankAllTimer, j);
					}
				}
			} 
			else 
			{
				CPrintToChat(client,"%s %T",MSG,"IsRankedAt",client,g_aClientName[client],i,g_TotalPlayers,g_aStats[client][SCORE],g_aStats[client][KILLS],g_aStats[client][DEATHS],g_aStats[client][ASSISTS],kills/deaths,g_aStats[client][TK],g_aStats[client][MVP]);
			}
			break;
		}
	} 
}

public Action:KillRankAllTimer(Handle:timer, client)
{
	if(hRankTimer[client] != INVALID_HANDLE)
	{
		hRankTimer[client] = INVALID_HANDLE;
	}
}

public Action:CMD_Session(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new Handle:panel = CreateMenuEx(_,MenuHandler_DoNothing,MENU_ACTIONS_ALL);
	new String:text[255];
	new String:temp[255];
	SetMenuPagination(panel,3);
	Format(temp,sizeof(temp),"- %T\n","BasicStats",client);
	StrCat(text,255,temp);
	Format(temp,sizeof(temp),"%T: %i\n","Points",client,g_aSession[client][SCORE]);
	StrCat(text,255,temp);
	new ikills = g_aSession[client][KILLS];
	new ideaths=g_aSession[client][DEATHS];
	new deaths;
	if(ideaths == 0)
		deaths = 1;
	else 
		deaths=ideaths;
	new Float:kills = IntToFloat(ikills);

	new shots;
	if(g_aSession[client][SHOTS] == 0)
		shots = 1;
	else
		shots = g_aSession[client][SHOTS];
	
	new rounds = g_aSession[client][ROUNDS_TR] + g_aSession[client][ROUNDS_CT];
	if((g_aSession[client][ROUNDS_TR] == 0) && (g_aSession[client][ROUNDS_CT] == 0))
	{
		rounds = 1;
	}
	
	new idamage = g_aSession[client][DAMAGE];
	new Float:damage = IntToFloat(idamage);
	
	Format(temp,255,"%T   KDR: %.2f\n","KillsDeathsAssists",client,ikills,ideaths,g_aSession[client][ASSISTS],kills/deaths);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %d\n","Headshots", client, g_aSession[client][HEADSHOTS],"Suicides",client,g_aSession[client][SUICIDES],"TKs",client,g_aSession[client][TK]);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %.2f   %T: %.2f\n ","Damage", client, idamage,"KPR", client, kills/rounds,"DPR", client, damage/rounds);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";

	Format(temp,sizeof(temp),"- %T\n","RoundStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d/%d   %T: %d/%d   %T: %d\n ","TRWins",client,g_aSession[client][TR_WIN],g_aSession[client][ROUNDS_TR],"CTWins",client,g_aSession[client][CT_WIN],g_aSession[client][ROUNDS_CT],"MVPs",client,g_aSession[client][MVP]);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","HitStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %.2f%%\n ","Shots",client,shots,"Hits",client,g_aSession[client][HITS],"Accuracy",client,IntToFloat(g_aSession[client][HITS])/shots*100);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","BombHostagesStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %d\n","PlantedBombs",client,g_aSession[client][C4_PLANTED],"ExplodedBombs",client,g_aSession[client][C4_EXPLODED],"DefusedBombs",client,g_aSession[client][C4_DEFUSED]);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d","RescuedHostages",client,g_aSession[client][HOSTAGES_RESCUED]);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	if(g_bVipEnabled){
		Format(temp,sizeof(temp),"- %T\n","VIPStats",client);
		StrCat(text,255,temp);
		Format(temp,255,"%T: %d/%d   %T: %d\n ","VIPEscapes",client,g_aSession[client][VIP_ESCAPED],g_aSession[client][VIP_PLAYED],"VIPsKilled",client,g_aSession[client][VIP_KILLED]);
		StrCat(text,255,temp);
		AddMenuItem(panel,"",text);
		text="";
	}
	
	Format(temp,sizeof(temp),"- %T\n","OtherStats",client);
	StrCat(text,255,temp);
	new time = GetTime()-g_aSession[client][CONNECTED];
	new hours = RoundToFloor(time/3600.0);
	time = time-(hours*3600);
	
	new minutes = RoundToFloor(time/60.0);
	time = time-(minutes*60);
	
	Format(temp,255,"%T","TimeConnected",client,hours,minutes,time);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	DisplayMenu(panel,client,MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Action:CMD_HitBox(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new Handle:panel = CreateMenuEx(_,MenuHandler_DoNothing,MENU_ACTIONS_ALL);
	new String:temp[255];
	new ihits;
	new Float:hits;
	ihits = g_aHitBox[client][1]+g_aHitBox[client][2]+g_aHitBox[client][3]+g_aHitBox[client][4]+g_aHitBox[client][5]+g_aHitBox[client][6]+g_aHitBox[client][7];
	new String:text[255];
	if(ihits == 0)
		hits= 1.0;
	else
		hits = IntToFloat(ihits);
	
	Format(temp,255,"HitBox:\n");
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","Head",client,g_aHitBox[client][1],(g_aHitBox[client][1]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","Chest",client,g_aHitBox[client][2],(g_aHitBox[client][2]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","Stomach",client,g_aHitBox[client][3],(g_aHitBox[client][3]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","LeftArm",client,g_aHitBox[client][4],(g_aHitBox[client][4]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","RightArm",client,g_aHitBox[client][5],(g_aHitBox[client][5]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)\n","LeftLeg",client,g_aHitBox[client][6],(g_aHitBox[client][6]/hits)*100);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d (%.2f%%)","RightLeg",client,g_aHitBox[client][7],(g_aHitBox[client][7]/hits)*100);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);

	DisplayMenu(panel,client,MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public Action:CMD_WeaponMe(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new weapons_a[40];
	for(new a=0;a<=39;a++){
		weapons_a[a] = g_aWeapons[client][a];
	}
	new weapons_b[40][2];
	new index;
	new start;
	new bool:indexs[40];
	for(new a =0; a<=39;a++){
		index =Array_FindHighestValue(weapons_a, sizeof(weapons_a));
		weapons_b[a][0] = index;
		weapons_b[a][1] = weapons_a[index];
		
		
		if(weapons_a[index] == 0){
			start=a;
			break;
		}
		weapons_a[index] = 0;
		indexs[index]=true;
	}

	for(new b=0; b<=39; b++){
	
		if(indexs[b] ==false){
			if(start <=39)
				weapons_b[start][0]=b;
			
			start++;
		}
	}
	new Handle:panel = CreateMenu(MenuHandler_DoNothing);
	
	new ikills =g_aStats[client][KILLS];
	
	new Float:hits;
	if(ikills == 0)
		hits= 1.0;
	else
		hits = IntToFloat(ikills);

	new String:temp[255];
	Format(temp,sizeof(temp),"%T","WeaponsStats",client);
	SetMenuTitle(panel, temp);
	for(new i=0;i<=39;i++){
		Format(temp,sizeof(temp),"%s: %d (%.2f%%)",g_sWeaponsNamesFull[weapons_b[i][0]],weapons_b[i][1],(weapons_b[i][1]/hits)*100);
		AddMenuItem(panel,temp,temp,ITEMDRAW_DISABLED);
	}
	
	DisplayMenu(panel,client,MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Action:CMD_StatsMe(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	if(g_RankMode == 1)
		Format(query,sizeof(query),"%s ORDER BY score DESC",query);
	else if(g_RankMode == 2){
		if(g_bMysql)
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC, score DESC",query);
		else
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as float)/CAST(Case when deaths=0 then 1 ELSE deaths END as float) DESC, score DESC",query);
	}	
	
	SQL_TQuery(g_hStatsDb,SQL_StatsMeCallback,query,client);
	return Plugin_Handled;
	
}

public Action:CMD_StatsMe2(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
		
	new String:arg1[MAX_NAME_LENGTH];
	GetCmdArg(1,arg1,sizeof(arg1));
	StripQuotes(arg1);
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	
	new String:order[2000];
	if(g_RankMode == 1)
		Format(order,sizeof(order),"ORDER BY score DESC");
	else if(g_RankMode == 2){
		if(g_bMysql)
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC, score DESC",query);
		else
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as float)/CAST(Case when deaths=0 then 1 ELSE deaths END as float) DESC, score DESC",query);
	}	
	new Handle:hDatapack = CreateDataPack();
	
	WritePackCell(hDatapack,client);
	new bool:tn_is_ml;
	new String:tname[MAX_NAME_LENGTH];
	new targets[1];
	
	
	if(ProcessTargetString(arg1,0,targets,1,COMMAND_FILTER_NO_MULTI,tname,sizeof(tname),tn_is_ml) == 1){
		new target = targets[0];
	
		WritePackCell(hDatapack,0);
		Format(query,sizeof(query),"%s %s", query,order);
	
		WritePackCell(hDatapack,target);
		
	} else if(StrContains(arg1,"#",false) == 0) {
		
		WritePackCell(hDatapack,1);
		
		if(StringToInt(arg1[1]) > g_TotalPlayers)
			Format(arg1,sizeof(arg1),"#%d",g_TotalPlayers);
			
		Format(query,sizeof(query),"%s %s LIMIT %d, 1",query,order, StringToInt(arg1[1]) - 1);

		WritePackCell(hDatapack,StringToInt(arg1[1]));
		
	} else if(g_RankBy == 0 && StrContains(arg1,"STEAM_") == 0) {
		
		WritePackCell(hDatapack,2);
		
		Format(query,sizeof(query),"%s %s", query,order);
		
		WritePackString(hDatapack,arg1);
		
	} else {
		
		CloseHandle(hDatapack);
		
		CPrintToChat(client,"%s %T", MSG,"UsageStatsme2",client);
		
		return Plugin_Handled;
	}
	//PrintToServer(query);
	SQL_TQuery(g_hStatsDb,SQL_StatsMe2Callback,query,hDatapack);
	
	return Plugin_Handled;
	
}

public SQL_StatsMe2Callback(Handle:owner, Handle:hndl, const String:error[], any:hDatapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	
	ResetPack(hDatapack);
	
	new client = ReadPackCell(hDatapack);
	
	if(client == 0 || !IsClientInGame(client))
		return;
		
	new type = ReadPackCell(hDatapack);
	new i;
	
	new String:auth[64];
	new String:name[MAX_NAME_LENGTH];
	
	new target;
	
	if(type == 0){
		
		target = ReadPackCell(hDatapack);
		
		GetClientAuthId(target,AuthId_Steam2,auth,sizeof(auth));
		
		GetClientName(target,name,sizeof(name));
		
	} else if (type == 1) {
		
		i = ReadPackCell(hDatapack);
	
	} else if(type == 2) {
	
		ReadPackString(hDatapack,auth,sizeof(auth));
		
	}
	CloseHandle(hDatapack);
	new String:Auth_receive[64];
	new String:Name_receive[MAX_NAME_LENGTH];
	
	if(type != 1){
		
		while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			i++;
			SQL_FetchString(hndl,1,Auth_receive,64);
			
			SQL_FetchString(hndl,2,Name_receive,MAX_NAME_LENGTH);
			
			if((g_RankBy == 1 && StrEqual(name,Name_receive)) || (g_RankBy == 0 && StrEqual(Auth_receive,auth,false)))
				break;
		}

	} else if (SQL_HasResultSet(hndl)){
		SQL_FetchRow(hndl);
		SQL_FetchString(hndl,1,Auth_receive,64);
		
		SQL_FetchString(hndl,2,Name_receive,MAX_NAME_LENGTH);
	} else {
		return;
	}
	
	new Handle:panel = CreateMenuEx(_,MenuHandler_DoNothing,MENU_ACTIONS_ALL);
	
	SetMenuTitle(panel,Name_receive);
	
	new String:text[255];
	SetMenuPagination(panel,3);
	new ikills = SQL_FetchInt(hndl,5);
	new ideaths= SQL_FetchInt(hndl,6);
	new deaths;
	if(ideaths == 0)
		deaths = 1;
	else 
		deaths=ideaths;
	new Float:kills = IntToFloat(ikills);
	new shots = SQL_FetchInt(hndl,10);
	if(shots == 0)
		shots = 1;
	
	new rounds = SQL_FetchInt(hndl,14) + SQL_FetchInt(hndl,15);
	if((SQL_FetchInt(hndl,14) == 0) && (SQL_FetchInt(hndl,15) == 0))
	{
		rounds = 1;
	}

	new idamage = SQL_FetchInt(hndl,74);
	new Float:damage = IntToFloat(idamage);
	
	new hits = SQL_FetchInt(hndl,11);
	new String:temp[255];
	Format(temp,sizeof(temp),"- %T\n","BasicStats",client);
	StrCat(text,255,temp);
	if(i == 0)
		Format(temp,sizeof(temp),"%T: %i\n","Points",client,SQL_FetchInt(hndl,4));
	else
		Format(temp,sizeof(temp),"Rank: %i/%i   %T: %i\n",i,g_TotalPlayers,"Points",client,SQL_FetchInt(hndl,4));
	StrCat(text,255,temp);
	Format(temp,255,"%T   KDR: %.2f\n","KillsDeathsAssists",client,ikills,ideaths,SQL_FetchInt(hndl,7),kills/deaths);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %d\n","Headshots", client, SQL_FetchInt(hndl,12),"Suicides",client,SQL_FetchInt(hndl,8),"TKs",client,SQL_FetchInt(hndl,9));
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %.2f   %T: %.2f\n ","Damage", client, idamage,"KPR", client, kills/rounds, "DPR", client, damage/rounds);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";

	Format(temp,sizeof(temp),"- %T\n","RoundStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d/%d   %T: %d/%d   %T: %d\n%T: %d   %T: %d   %T: %d\n","TRWins",client,SQL_FetchInt(hndl,68),SQL_FetchInt(hndl,14),"CTWins",client,SQL_FetchInt(hndl,67),SQL_FetchInt(hndl,15),"MVPs",client,SQL_FetchInt(hndl,73), "Match Wins", client, SQL_FetchInt(hndl, 75), "Match Draws", client, SQL_FetchInt(hndl, 76), "Match Loses", client, SQL_FetchInt(hndl, 77));
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","HitStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %.2f%%\n ","Shots",client,shots,"Hits",client,hits,"Accuracy",client,IntToFloat(hits)/shots*100);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","BombHostagesStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %d\n","PlantedBombs",client,SQL_FetchInt(hndl,64),"ExplodedBombs",client,SQL_FetchInt(hndl,65),"DefusedBombs",client,SQL_FetchInt(hndl,66));
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d","RescuedHostages",client,SQL_FetchInt(hndl,69));
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
				
	if(g_bVipEnabled){
		Format(temp,sizeof(temp),"- %T\n","VIPStats",client);
		StrCat(text,255,temp);
		Format(temp,255,"%T: %d/%d   %T: %d\n ","VIPEscapes",client,SQL_FetchInt(hndl,71),SQL_FetchInt(hndl,72),"VIPsKilled",client,SQL_FetchInt(hndl,70));
		StrCat(text,255,temp);
		AddMenuItem(panel,"",text);
		text="";
	}
	
	Format(temp,sizeof(temp),"- %T\n","OtherStats",client);
	StrCat(text,255,temp);
	
	new time = SQL_FetchInt(hndl,13);
	if(target != 0 && IsClientInGame(target))
		time += GetTime()-g_aSession[client][CONNECTED];
		
	new hours = RoundToFloor(time/3600.0);
	time = time-(hours*3600);
	
	new minutes = RoundToFloor(time/60.0);
	time = time-(minutes*60);
	
	Format(temp,255,"%T","TimeConnected",client,hours,minutes,time);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	DisplayMenu(panel,client,MENU_TIME_FOREVER);
			
		
	
}

public SQL_StatsMeCallback(Handle:owner, Handle:hndl, const String:error[], any:client){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	if(client == 0 || !IsClientInGame(client))
		return;
	new i;
	
	g_TotalPlayers =SQL_GetRowCount(hndl);
	new String:Auth_receive[64];
	new String:Name_receive[MAX_NAME_LENGTH];
	new String:Ip_receive[64];
	if(g_aStats[client][KILLS] >= g_MinimalKills){
		
		while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			i++;
			SQL_FetchString(hndl,1,Auth_receive,64);
			
			SQL_FetchString(hndl,2,Name_receive,MAX_NAME_LENGTH);
			
			SQL_FetchString(hndl,3,Ip_receive,64);
			
			if((g_RankBy == 1 && StrEqual(g_aClientName[client],Name_receive)) || (g_RankBy == 0 && StrEqual(Auth_receive,g_aClientSteam[client],false)) || (g_RankBy == 2 && StrEqual(Ip_receive,g_aClientIp[client],false)))
				break;
		}
	} else {
		i = 0;
	}
	new Handle:panel = CreateMenuEx(_,MenuHandler_DoNothing,MENU_ACTIONS_ALL);
	new String:text[255];
	SetMenuPagination(panel,3);
	new ikills = g_aStats[client][KILLS];
	new ideaths=g_aStats[client][DEATHS];
	new deaths;
	if(ideaths == 0)
		deaths = 1;
	else 
		deaths=ideaths;
	new Float:kills = IntToFloat(ikills);
	new shots;
	if(g_aStats[client][SHOTS] == 0)
		shots = 1;
	else
		shots = g_aStats[client][SHOTS];
	
	new rounds = g_aStats[client][ROUNDS_TR] + g_aStats[client][ROUNDS_CT];
	if((g_aStats[client][ROUNDS_TR] ==0) && (g_aStats[client][ROUNDS_CT] == 0))
	{
		rounds = 1;
	}
	
	new idamage = g_aStats[client][DAMAGE];
	new Float:damage = IntToFloat(idamage);

	new String:temp[255];
	Format(temp,sizeof(temp),"- %T\n","BasicStats",client);
	StrCat(text,255,temp);
	if(i == 0)
		Format(temp,sizeof(temp),"%T: %i [%i]\n","Points",client,g_aStats[client][SCORE],g_aSession[client][SCORE]);
	else
		Format(temp,sizeof(temp),"Rank: %i/%i   %T: %i [%i]\n",i,SQL_GetRowCount(hndl),"Points",client,g_aStats[client][SCORE],g_aSession[client][SCORE]);
	StrCat(text,255,temp);
	Format(temp,255,"%T   KDR: %.2f\n","KillsDeathsAssists",client,ikills,ideaths,g_aStats[client][ASSISTS],kills/deaths);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d  %T: %d  %T: %d\n","Headshots",client,g_aStats[client][HEADSHOTS],"Suicides",client,g_aStats[client][SUICIDES],"TKs",client,g_aStats[client][TK]);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d  %T: %.2f   %T: %.2f\n ","Damage", client, idamage,"KPR", client, kills/rounds, "DPR", client, damage/rounds);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","RoundStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d/%d   %T: %d/%d   %T: %d\n%T: %d   %T: %d   %T: %d \n","TRWins",client,g_aStats[client][TR_WIN],g_aStats[client][ROUNDS_TR],"CTWins",client,g_aStats[client][CT_WIN],g_aStats[client][ROUNDS_CT],"MVPs",client,g_aStats[client][MVP], "Match Wins", client, g_aStats[client][MATCH_WIN], "Match Draws", client, g_aStats[client][MATCH_DRAW], "Match Loses", client, g_aStats[client][MATCH_LOSE]);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","HitStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %.2f%%\n ","Shots",client,shots,"Hits",client,g_aStats[client][HITS],"Accuracy",client,IntToFloat(g_aStats[client][HITS])/shots*100);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	
	Format(temp,sizeof(temp),"- %T\n","BombHostagesStats",client);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d   %T: %d   %T: %d\n","PlantedBombs",client,g_aStats[client][C4_PLANTED],"ExplodedBombs",client,g_aStats[client][C4_EXPLODED],"DefusedBombs",client,g_aStats[client][C4_DEFUSED]);
	StrCat(text,255,temp);
	Format(temp,255,"%T: %d","RescuedHostages",client,g_aStats[client][HOSTAGES_RESCUED]);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
				
	if(g_bVipEnabled){
		Format(temp,sizeof(temp),"- %T\n","VIPStats",client);
		StrCat(text,255,temp);
		Format(temp,255,"%T: %d/%d   %T: %d\n ","VIPEscapes",client,g_aStats[client][VIP_ESCAPED],g_aStats[client][VIP_PLAYED],"VIPsKilled",client,g_aStats[client][VIP_KILLED]);
		StrCat(text,255,temp);
		AddMenuItem(panel,"",text);
		text="";
	}
	
	Format(temp,sizeof(temp),"- %T\n","OtherStats",client);
	StrCat(text,255,temp);
	new time = g_aStats[client][CONNECTED] + GetTime()-g_aSession[client][CONNECTED];
	new hours = RoundToFloor(time/3600.0);
	time = time-(hours*3600);
	
	new minutes = RoundToFloor(time/60.0);
	time = time-(minutes*60);
	
	Format(temp,255,"%T","TimeConnected",client,hours,minutes,time);
	StrCat(text,255,temp);
	AddMenuItem(panel,"",text);
	text="";
	DisplayMenu(panel,client,MENU_TIME_FOREVER);
			
		
	
}

public PanelNoHandle(Handle:menu, MenuAction:action, param1, param2){

	

}

public Action:CMD_Next(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	if(g_RankMode == 1)
		Format(query,sizeof(query),"%s ORDER BY score DESC",query);
	else if(g_RankMode == 2){
		if(g_bMysql)
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as DECIMAL)/CAST(Case when deaths=0 then 1 ELSE deaths END as DECIMAL) DESC, score DESC",query);
		else
			Format(query,sizeof(query),"%s ORDER BY CAST(kills as float)/CAST(Case when deaths=0 then 1 ELSE deaths END as float) DESC, score DESC",query);
	}	
	
	SQL_TQuery(g_hStatsDb,SQL_NextCallback,query,client);
	return Plugin_Handled;
}

public SQL_NextCallback(Handle:owner, Handle:hndl, const String:error[], any:client){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		return;
	}
	if(client == 0 || !IsClientInGame(client))
		return;
	new i;
	new a;
	g_TotalPlayers =SQL_GetRowCount(hndl);
	new String:next_players_name[10][MAX_NAME_LENGTH];
	new next_players_score[10];
	new bool:dobreak;
	
	new String:Auth_receive[64];
	new String:Name_receive[MAX_NAME_LENGTH];
	new String:Ip_receive[64];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		i++;
		
		SQL_FetchString(hndl,1,Auth_receive,64);
		SQL_FetchString(hndl,2,Name_receive,MAX_NAME_LENGTH);
		SQL_FetchString(hndl,3,Ip_receive,64);
		
		if((g_RankBy == 1 && StrEqual(g_aClientName[client],Name_receive)) || (g_RankBy == 0 && StrEqual(Auth_receive,g_aClientSteam[client],false)) || (g_RankBy == 2 && StrEqual(Ip_receive,g_aClientIp[client],false))){
		
			dobreak=true;
		
		}
		else {
		
			if(i<=10){
				SQL_FetchString(hndl,2,next_players_name[i-1],MAX_NAME_LENGTH-1);
				next_players_score[i-1]=SQL_FetchInt(hndl,4);
			}
			else {
				for(a=0;a<9;a++){
				
					next_players_score[a] = next_players_score[a+1];
					strcopy(next_players_name[a],MAX_NAME_LENGTH-1,next_players_name[a+1]);
				}
				SQL_FetchString(hndl,2,next_players_name[9],MAX_NAME_LENGTH-1);
				next_players_score[9]=SQL_FetchInt(hndl,4);
			}
		}
		if(dobreak)
			break;
	} 
	new Handle:panel = CreateMenuEx(_,MenuHandler_DoNothing,MENU_ACTIONS_ALL);
	new String:text[500];
	new String:temp[255];
	Format(temp,sizeof(temp),"%T\n","Next9Players",client);
	StrCat(text,255,temp);
	
	new max;
	if(i<10){
		max = i-1; 
	} else {
		max = 9;
	}
	for(new b=0;b<=max;b++){
		if(!StrEqual(next_players_name[b],"",false)){
			Format(temp,sizeof(temp),"- %s (%d) => +%d\n",next_players_name[b],next_players_score[b],next_players_score[b]-g_aStats[client][SCORE]);
			StrCat(text,500,temp);
		}
		
	}
	AddMenuItem(panel,"",text);
	DisplayMenu(panel,client,MENU_TIME_FOREVER);
	
	CloseHandle(panel);
}

public Action:CMD_ResetOwnRank(client,args){

	if(!g_bEnabled || !g_bResetOwnRank || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;
	new String:query[2000];
	if(g_RankBy == 1){
		
		new String:sEscape[MAX_NAME_LENGTH*2+1];
		SQL_EscapeString(g_hStatsDb,g_aClientName[client],sEscape,sizeof(sEscape));
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE name='%s'",g_sSQLTable,sEscape);
	} else if(g_RankBy == 0){
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE steam='%s'",g_sSQLTable,g_aClientSteam[client]);
	} else if(g_RankBy == 2){
		Format(query,sizeof(query),"DELETE FROM `%s` WHERE lastip='%s'",g_sSQLTable,g_aClientIp[client]);
	}
	SQL_TQuery(g_hStatsDb,SQL_NothingCallback,query);
	LogAction(client,-1,"[RankMe]: Reseted own rank (%s - %s - %s)",g_aClientName[client],g_aClientSteam[client],g_aClientIp[client]);
	OnClientPutInServer(client);
	CPrintToChat(client,"%s %T",MSG,"ResetMyRank", client);
	return Plugin_Handled;
}

public Float:IntToFloat(integer){
	new String:s[300];
	IntToString(integer,s,sizeof(s));
	return StringToFloat(s);
}

public FloatToInt(Float:ifloat){
	new String:s[300];
	FloatToString(ifloat,s,sizeof(s));
	return StringToInt(s);
}


public Action:CMD_RankMe(client,args){

	new Handle:hMenu = CreateMenu(MenuHandler_RankMe);
	
	SetMenuExitButton(hMenu,true);
	
	SetMenuTitle(hMenu,"%t", "RankMe Menu");
	
	char myrank[512];
	Format(myrank, sizeof(myrank), "%t", "My Rank");
	AddMenuItem(hMenu,"rank", myrank);
	
	if(g_bResetOwnRank)
	{
		char resetmyrank[512];
		Format(resetmyrank, sizeof(resetmyrank), "%t", "Reset My Rank");
		AddMenuItem(hMenu,"resetmyrank", resetmyrank);
	}
	
	char mystats[512];
	Format(mystats, sizeof(mystats), "%t", "My Stats");
	AddMenuItem(hMenu,"statsme", mystats);
	
	char session[512];
	Format(session, sizeof(session), "%t", "Session");
	AddMenuItem(hMenu,"session", session);
	
	char otherstats[512];
	Format(otherstats, sizeof(otherstats), "%t", "Show Other Players Stats");
	AddMenuItem(hMenu,"statsme2", otherstats);
	
	char hitboxme[512];
	Format(hitboxme, sizeof(hitboxme), "%t", "My HitBox Stats");
	AddMenuItem(hMenu,"hitboxme", hitboxme);
	
	char weaponme[512];
	Format(weaponme, sizeof(weaponme), "%t", "My Weapon Stats");
	AddMenuItem(hMenu,"weaponme", weaponme);
	
	char next[512];
	Format(next, sizeof(next), "%t", "Show Players Above Me");
	AddMenuItem(hMenu,"next", next);
	
	char top10[512];
	Format(top10, sizeof(top10), "%t", "TOP 10");
	AddMenuItem(hMenu,"top10", top10);

	char topkills[512];
	Format(topkills, sizeof(topkills), "%t", "TOP Kills");
	AddMenuItem(hMenu,"topkills", topkills);

	char topdeaths[512];
	Format(topdeaths, sizeof(topdeaths), "%t", "TOP Deaths");
	AddMenuItem(hMenu,"topdeaths", topdeaths);
	
	char topassists[512];
	Format(topassists, sizeof(topassists), "%t", "TOP Assists");
	AddMenuItem(hMenu,"topassists", topassists);
	
	char tophs[512];
	Format(tophs, sizeof(tophs), "%t", "TOP HS");
	AddMenuItem(hMenu,"tophs", tophs);
	
	char topweapon[512];
	Format(topweapon, sizeof(topweapon), "%t", "TOP Weapon");
	AddMenuItem(hMenu,"topweapon", topweapon);
	
	char toptk[512];
	Format(toptk, sizeof(toptk), "%t", "TOP TK");
	AddMenuItem(hMenu,"toptk", toptk);
	
	char topmvp[512];
	Format(topmvp, sizeof(topmvp), "%t", "TOP MVP");
	AddMenuItem(hMenu,"topmvp", topmvp);
	
	char topdamage[512];
	Format(topdamage, sizeof(topdamage), "%t", "TOP Damage");
	AddMenuItem(hMenu,"topdamage", topdamage);
	
	/*
	char topnade[512];
	Format(topnade, sizeof(topnade), "%t", "TOP Grenade");
	AddMenuItem(hMenu,"topnade", topnade);
	
	char topnknife[512];
	Format(topnknife, sizeof(topnknife), "%t", "TOP Knife");
	AddMenuItem(hMenu,"topnade", topnknife);
	
	char toptaser[512];
	Format(toptaser, sizeof(toptaser), "%t", "TOP Taser");
	AddMenuItem(hMenu,"topnade", toptaser);
	*/
	
	char topacc[512];
	Format(topacc, sizeof(topacc), "%t", "TOP Accuracy");
	AddMenuItem(hMenu,"topacc", topacc);

	char toptime[512];
	Format(toptime, sizeof(toptime), "%t", "TOP Time Connected");
	AddMenuItem(hMenu,"toptime", toptime);
	
	if(CheckCommandAccess(client, "sm_resetrank", ADMFLAG_ROOT))
	{
		char resetrank[512];
		Format(resetrank, sizeof(resetrank), "%t", "Reset a player rank");
		AddMenuItem(hMenu,"resetrank", resetrank);
	}	
	if(CheckCommandAccess(client, "sm_resetrank_all", ADMFLAG_ROOT))
	{
		char resetrankall[512];
		Format(resetrankall, sizeof(resetrankall), "%t", "Reset all the rank");
		AddMenuItem(hMenu,"resetrankall", resetrankall);
	}
	DisplayMenu(hMenu,client,MENU_TIME_FOREVER);
	
}

public MenuHandler_RankMe(Handle:menu, MenuAction:action, client, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		
		if(StrEqual(temp,"rank"))
			CMD_Rank(client,0);
		
		else if(StrEqual(temp,"resetmyrank"))
			CMD_ResetOwnRank(client,0);
		
		else if(StrEqual(temp,"statsme"))
			CMD_StatsMe(client,0);
			
		else if(StrEqual(temp,"session"))
			CMD_Session(client,0);
		
		else if(StrEqual(temp,"hitboxme"))
			CMD_HitBox(client,0);
			
		else if(StrEqual(temp,"weaponme"))
			CMD_WeaponMe(client,0);
				
		else if(StrEqual(temp,"next"))
			CMD_Next(client,0);
		
		else if(StrEqual(temp,"top10"))
			ShowTOP(client,0);
			
		else if(StrEqual(temp,"topweapon"))
			CMD_TopWeapon(client,0);
		
		/*
		else if(StrEqual(temp,"toptaser"))
			CMD_TopTaser(client,0);
			
		else if(StrEqual(temp,"topknife"))
			CMD_TopKnife(client,0);
		
		else if(StrEqual(temp,"topnade"))
			ShowTOPNade(client, 0);
		*/
		
		else if(StrEqual(temp,"topacc"))
			ShowTopAcc(client,0);
		
		else if(StrEqual(temp,"tophs"))
			ShowTopHS(client,0);
		
		else if(StrEqual(temp,"toptime"))
			ShowTopTime(client,0);
			
		else if(StrEqual(temp,"topkills"))
			ShowTopKills(client,0);
			
		else if(StrEqual(temp,"topdeaths"))
			ShowTopDeaths(client,0);
			
		else if(StrEqual(temp,"topassists"))
			ShowTopAssists(client,0);
			
		else if(StrEqual(temp,"toptk"))
			ShowTopTK(client,0);
			
		else if(StrEqual(temp,"topmvp"))
			ShowTopMVP(client,0);
			
		else if(StrEqual(temp,"topdamage"))
			ShowTopDamage(client,0);
			
		else if(StrEqual(temp,"resetrank")){
			
			new Handle:hMenu = CreateMenu(MenuHandler_TargetResetRank);
			AddTargetsToMenu2(hMenu,0,COMMAND_FILTER_NO_BOTS);
			
			DisplayMenu(hMenu,client,MENU_TIME_FOREVER);
		}
		else if(StrEqual(temp,"statsme2")){
			
			new Handle:hMenu = CreateMenu(MenuHandler_TargetStatsMe2);
			AddTargetsToMenu2(hMenu,0,COMMAND_FILTER_NO_BOTS);
			
			DisplayMenu(hMenu,client,MENU_TIME_FOREVER);
		}
		
		else if(StrEqual(temp,"resetrankall"))
			CMD_ResetRankAll(client,0);
		
		
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	
}

public MenuHandler_TargetResetRank(Handle:menu, MenuAction:action, client, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		new target = GetClientOfUserId(StringToInt(temp));
		
		if(g_RankBy == 1){
			
			ClientCommand(client,"sm_resetrank \"%s\"",g_aClientName[target]);
		} else if(g_RankBy == 0){
			
			ClientCommand(client,"sm_resetrank \"%s\"",g_aClientSteam[target]);
		} else if(g_RankBy == 2){
			
			ClientCommand(client,"sm_resetrank \"%s\"",g_aClientIp[target]);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	
}

public MenuHandler_TargetStatsMe2(Handle:menu, MenuAction:action, client, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		new target = GetClientOfUserId(StringToInt(temp));
		
		if(g_RankBy == 0 || g_RankBy == 2){
			
			ClientCommand(client,"sm_statsme2 \"%s\"",g_aClientName[target]);
		} else {
			
			ClientCommand(client,"sm_statsme2 \"%s\"",g_aClientSteam[target]);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	
}

/* Assist */
public Action:CMD_TopAssists(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopAssists(client,StringToInt(arg1));
	}	else {
		ShowTopAssists(client,0);
	}
	return Plugin_Handled;
}

ShowTopAssists(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY assists DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopAssistsCallback,query,Datapack);

}

public SQL_TopAssistsCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopAssists(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopAssists);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Assists",SQL_FetchInt(hndl,7));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopAssists(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopAssists(param1,StringToInt(temp)+1);
		} else {
			ShowTopAssists(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

/* Top TK */
public Action:CMD_TopTK(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopTK(client,StringToInt(arg1));
	}	else {
		ShowTopTK(client,0);
	}
	return Plugin_Handled;
}

ShowTopTK(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY tk DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopTKCallback,query,Datapack);

}

public SQL_TopTKCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopTK(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopTK);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"TKs",SQL_FetchInt(hndl,9));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopTK(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopTK(param1,StringToInt(temp)+1);
		} else {
			ShowTopTK(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

/* Top MVP */
public Action:CMD_TopMVP(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopMVP(client,StringToInt(arg1));
	}	else {
		ShowTopMVP(client,0);
	}
	return Plugin_Handled;
}

ShowTopMVP(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY mvp DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopMVPCallback,query,Datapack);

}

public SQL_TopMVPCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopMVP(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopMVP);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"MVPs",SQL_FetchInt(hndl,73));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopMVP(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopMVP(param1,StringToInt(temp)+1);
		} else {
			ShowTopMVP(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

/* Top Damage */
public Action:CMD_TopDamage(client,args){
	if(!g_bEnabled || client == 0 || !IsClientInGame(client))
		return Plugin_Handled;

	new String:arg1[5];
	GetCmdArg(1,arg1,sizeof(arg1));
	if(!StrEqual(arg1,"") && StringToInt(arg1) != 0){
		ShowTopDamage(client,StringToInt(arg1));
	}	else {
		ShowTopDamage(client,0);
	}
	return Plugin_Handled;
}

ShowTopDamage(client,at){
	if(client == 0 || !IsClientInGame(client))
		return;
	new Handle:Datapack= CreateDataPack();
	
	WritePackCell(Datapack,client);
	
	if(at>0){
		WritePackCell(Datapack,at-1);
	}	else {
		WritePackCell(Datapack,0);
		at = 1; // For not needing to build twice the query. (for at > 0 and at <= 0)
	}
	new String:query[2000];
	MakeSelectQuery(query,sizeof(query));
	Format(query,sizeof(query),"%s ORDER BY damage DESC LIMIT %i, 10",query,at-1);
		
	SQL_TQuery(g_hStatsDb,SQL_TopDamageCallback,query,Datapack);

}

public SQL_TopDamageCallback(Handle:owner, Handle:hndl, const String:error[], any:Datapack){
	if(hndl == INVALID_HANDLE)
	{
		LogError("[RankMe] Query Fail: %s", error);
		PrintToServer(error);
		return;
	}
	ResetPack(Datapack);
	new i;
	new client = ReadPackCell(Datapack);
	if(client == 0 || !IsClientInGame(client))
		return;
	new at = ReadPackCell(Datapack);
	CloseHandle(Datapack);
	if(!SQL_HasResultSet(hndl) || SQL_GetRowCount(hndl) ==0){
		ShowTopDamage(client,g_TotalPlayers-9);
		return;
	}
	new String:name[256];
	new String:temp[500];
	
	new Handle:menu = CreateMenuEx(GetMenuStyleHandle(MenuStyle:MenuStyle_Radio),MenuHandler_TopDamage);
	
	Format(temp,sizeof(temp)," %T\n","Showing",client,at+1,at+10,g_TotalPlayers);
	SetMenuTitle(menu,"");
	new String:sBuffer[200];
	while(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		i++;
		
		SQL_FetchString(hndl,2,name,sizeof(name));
			
		
	
		Format(sBuffer,sizeof(sBuffer),"%d - %s (%d) - %t: %d\n",i+at,name,SQL_FetchInt(hndl,4),"Damage",SQL_FetchInt(hndl,74));
		
		if(strlen(temp)+strlen(sBuffer) < MAX_LENGTH_MENU){
			Format(temp,sizeof(temp),"%s%s",temp,sBuffer);
			sBuffer="\0";
		}
	} 
	Format(temp,sizeof(temp),"%s\n ",temp);
	AddMenuItem(menu,temp,temp);
	
	
	IntToString(at+i,temp,sizeof(temp));
	new String:temp1[20];
	Format(temp1,sizeof(temp1),"%T","Next",client);
	if(i>9)
		AddMenuItem(menu,temp,temp1);
	IntToString(at-i,temp,sizeof(temp));
	Format(temp1,sizeof(temp1),"%T","Back",client);
	if(at+i-1 >9)
		AddMenuItem(menu,temp,temp1);

	DisplayMenuAtItem(menu,client,at,MENU_TIME_FOREVER);
}

public MenuHandler_TopDamage(Handle:menu, MenuAction:action, param1, param2){
	
	if (action == MenuAction_Select)
	{
		new String:temp[250];
	
		GetMenuItem(menu, param2, temp, sizeof(temp));
		if(StringToInt(temp) >= 0){
			ShowTopDamage(param1,StringToInt(temp)+1);
		} else {
			ShowTopDamage(param1,0);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}