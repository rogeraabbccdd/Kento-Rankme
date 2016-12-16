//Weapon Stats Update
//Replace the code under Weapons Kills.
<?php $weapon_string="knife,usp_silencer,hkp2000,elite,p250,fiveseven,cz75a,deagle,glock,tec9,revolver,nova,xm1014,mag7,sawedoff,mp9,mp7,ump45,p90,bizon,mac10,famas,m4a1_silencer,m4a1,aug,galilar,ak47,sg556,ssg08,scar20,awp,g3sg1,m249,negev,hegrenade,flashbang,smokegrenade,decoy,inferno,taser";
	$weapon_array = explode(",",$weapon_string);
	if($row['kills'] == 0){$kills = 1;} else {$kills=$row['kills'];}
	$i =0;
	foreach($weapon_array as $weapon){
		if(is_int($i/2)){
			echo "<tr>";
		}
		$temp = strval($row[$weapon]/$kills*100);
		
		$weapon_names=array('Knife','USP-S','P2000','Dual Berettas','P250','FiveSeven','CZ75','Deagle','Glock','TEC-9','R8 Revolver','Nova','XM1014','MAG-7','Sawed-Off','MP9','MP7','UMP-45','P90','PP-Bizon','Mac10','Famas','M4A1-S','M4A4','AUG','Galil AR','AK-47','SG 553','SSG 08','SCAR-20','AWP','G3SG1','M249','Negev','HE','Flashbang','Smoke','Decoy','Inferno','Taser');
		echo "<td>{$weapon_names[$i]}</td>"; echo "<td>{$row[$weapon]} ("; 
		$ts = 1;
		$temp = strval($row[$weapon]/$kills*100);
		if(strpos($temp,".") !== false || $ts == 0){
			for($i1 = 0; $i1<=strpos($temp,".")+2;$i1++){
				if( strlen($temp)-1 <$i1 ){
$ts=0;
				}else{
echo $temp[$i1];
}
				
			}
		} else { echo $temp . ".00";} echo	"%)</td>";
		$i++;
		if(is_int($i/2)){
			echo "</tr>";
		}
	}
?>

//STATISTICS Update
//Put the code at anywhere you want.
<tr>
	<td>Assists:
	</td>
	
	<td align=right><?php echo $row['assists'];?>
	</td>
</tr>
<tr>
	<td>MVPs:
	</td>
	
	<td align=right><?php echo $row['mvp'];?>
	</td>
</tr>
<tr>
	<td>Total damage:
	</td>
	
	<td align=right><?php echo $row['damage'];?>
	</td>
</tr>