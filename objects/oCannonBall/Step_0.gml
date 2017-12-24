/// @description Fly the cannonball until out of the room
// Will calculate it's trajectory
repeat(shootspeed){
	switch(trajtype){
		case 1:
			xnext = x + (shotpower*(cos(degtorad(cannonangle))));
			ynext = y - (shotpower*(sin(degtorad(cannonangle))));
			break;
		case 2:
			xnext = x + (shotpower*(cos(degtorad(cannonangle))));
			ynext = y - (shotpower*(sin(degtorad(cannonangle)))-grav*lifestep);
			break;
		case 3:
			var phaseDev = (8*shotpower* sin(degtorad(lifestep*10)));	//calculate phase deviation
			xnext = xanchor + (lifestep*(shotpower*(cos(degtorad(cannonangle))))) - phaseDev*sin(degtorad(cannonangle));
			ynext = yanchor - (lifestep*(shotpower*(sin(degtorad(cannonangle))))) - phaseDev*cos(degtorad(cannonangle));
			break;
		case 4:
			xnext = x + (lifestep*(shotpower*(cos(degtorad(cannonangle)))));
			ynext = -1.3 * logn(0.9,xnext);
			break;
		default: break;
	}
	//Move the cannonball
	x = xnext;
	y = ynext;

	lifestep+=1;
	var outofbound = (x<0 || y<0 || y>=room_height || x>=room_width);
	var hit = (place_meeting(x,y,oPlayer));
	var solidhit = (place_meeting(x,y,oSolid));
	if(outofbound){
		shooter.state = "shot_finished";
		instance_destroy();	
	}
	else if(hit){
		var hitted = instance_place(x,y,oPlayer);
		if(hitted!=shooter){	//Only if not hitting the shooter
			hitted.hp-=1;
			var explode = instance_create_layer(x,y,layer,oHitEffect);
			explode.shooter = shooter;
			instance_destroy();
		}
	}
	else if(solidhit){
		//Check if is at nonsolid
		var nons = place_meeting(x,y,oNonsolid);
		if(!nons){
			//Create a oNonsolidcircle
			instance_create_layer(x,y,layer,oNonsolid);
			var explode = instance_create_layer(x,y,layer,oHitEffect);
			explode.shooter = shooter;
			instance_destroy();
		}
	}
}