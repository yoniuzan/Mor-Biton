 /// @description Action if active
//Active code
			hspd = 0;
if(active){
	//Can read input
	var mv_right = keyboard_check(vk_right);
	var mv_left = keyboard_check(vk_left);
	var tap_left = keyboard_check_pressed(vk_left);
	var tap_right = keyboard_check_pressed(vk_right);
	var mv_up = keyboard_check(vk_up);
	var mv_down = keyboard_check(vk_down);
	var kb_space = keyboard_check_pressed(vk_space);
	
	
	switch(state){
		case "idle":
			break;
		case "aim":
			kbleft.visible = false;
			kbright.visible = false;
			kbup.visible = true;
			kbdown.visible = true;
			cannonangle = cannonangle+((mv_up-mv_down)*anglestep);
			if(kb_space){
				state="move";
				curr_move=maxmove;	//Reset amount of move that can be performed
			}
			cannonangle = clamp(cannonangle,-10,190);
			agdisplay.text = string(cannonangle);
			break;
		case "move":
			kbleft.visible = true;
			kbright.visible = true;
			kbup.visible = false;
			kbdown.visible = false;
			if(mv_right && curr_move>0){
				hspd+=mvstep;
				curr_move-=1;
			}
			if(mv_left && curr_move>0){
				hspd-=mvstep;
				curr_move-=1;
			}
			if(curr_move<=0 || kb_space){
				state="shottype";
				trajectory = true;	//show predicted trajectory;
			}
			break;
		case "shottype":
			if(tap_left){
				trajtype-=1;	
			}
			if(tap_right){
				trajtype+=1;	
			}
			trajtype = clamp(trajtype,1,4);	//1 to 4: direct shoot, high trajectory, crazy sheep, guided arms
			if(kb_space){
				state = "shotpower";	
			}
			break;
		case "shotpower":
			if(tap_left){
				shotpower-=1;	
			}
			if(tap_right){
				shotpower+=1;	
			}
			shotpower = clamp(shotpower,1,5);
			if(kb_space){
				state = "shoot";
				trajectory = false;
			}
			break;
		case "shoot":
			kbleft.visible = false;
			kbright.visible = false;
			kbup.visible = false;
			kbdown.visible = false;
			var cannonball = instance_create_layer(x,y,layer,oCannonBall);
			cannonball.cannonangle = cannonangle;
			cannonball.shotpower = shotpower;
			cannonball.trajtype = trajtype;
			cannonball.shooter = id;
			cannonball.grav = grav;
			audio_play_sound(sndShoot,10,false);
			state="shoot_wait";
			break;
		case "shoot_wait":
			break;
		case "shot_finished":
			oController.state="next_player";
			break;
	}
}
else if(hp<=0){
	instance_destroy();	
}

//Horizontal movement
//nonsolid verification
if(place_meeting(x+hspd,y,oSolid)){
	//Check 45 degree up
	if(!place_meeting(x+hspd,y-(2*abs(hspd)),oSolid)){
		x+=hspd;
		y-=2*abs(hspd);
	}
	else{	
		while(!place_meeting(x+sign(hspd),y,oSolid)){
			x+=sign(hspd);
		}
		hspd=0;
	}
}
else{
	x+=hspd;	
}
//Clamp x
x = clamp(x,0,room_width);

// Gravity calculation
vspd+=tankgrav;
//Solid collision

if(place_meeting(x,y+vspd,oSolid)){
	while(!place_meeting(x,y+sign(vspd),oSolid)){
		y+=sign(vspd);
	}
	vspd=0;
}
else{
	y+=vspd;	
}