/// @description This is the state machine

switch(state){
	case "start":
		state="activate_player";	//Chagne state
		break;
	case "activate_player":
		//Check if exists, if not, skip to next player
		if(instance_exists(playerid[curr_player])){
			playerid[curr_player].active = true;	//Start at aim
			playerid[curr_player].state = "aim";
			state="display_message";
		}
		else{
			state="next_player";	
		}
		break;
	case "display_message":
		display_text = instance_create_layer(room_width/2,160,layer,oDisplayText);
		display_text.text = "Player " + string(curr_player+1) + " Turn";
		display_text.font = fntRingbearer48;
		display_text.color= c_white;
		alarm[0] = room_speed*2;
		state = "dm_wait";
		break;
	case "dm_wait":	//Wait for alarm[0] trigger
		break;
	case "turn_wait":
		//Wait for player to finish it's turn.
		break;
	case "next_player":
		if(instance_exists(playerid[curr_player])){
			playerid[curr_player].active = false;
			playerid[curr_player].state = "idle";
		}
		curr_player+=1;	//Change to next player
		if(curr_player>=global.player){
			curr_player=0;	
		}
		playeralive=0;
		state = "activate_player";
		with(oPlayer){
			oController.playeralive+=1;	
		}
		if(playeralive<=1){
			state= "end";	
		}
		break;
	case "end":
		var text = instance_create_layer(room_width/2,256,layer,oDisplayText);
		text.text = "You Win, Player!";
		text.font = fntRingbearer60;
		text.color= c_white;
		alarm[1] = room_speed*3;
		state = "end_wait";
		break;
	case "end_wait":
		break;
	default: break;
}