/// @description Insert description here
// You can write your code in this editor
//Draw cannon
draw_sprite_ext(sprTankGun,image_index,x,y,1,1,cannonangle,c_white,1);

//Draw self
draw_self();

/*Draw debug==========
draw_set_font(fntRingbearer);
draw_text(x,y+64,state);
draw_text(x,y+128,"cann_angle"+string(cannonangle));
draw_text(x,y+160,"traj"+string(trajtype));
draw_text(x,y+192,"ID"+string(id));
//===============*/

if(active){
	draw_sprite(sprArrow,0,x,y-48);
}

//draw_hp
var i=0;
for(i=0;i<3;i+=1){
	if(hp>i){
		draw_sprite(sprHp,0,x-24+(i*24),y+64);
	}
	else{
		draw_sprite(sprHp,1,x-24+(i*24),y+64);
	}
}

if(trajectory){	//draw the trajectory;
	draw_set_color(c_red);
	var xnow,xnext,ynow,ynext;
	var max_draw_i = 300;
	var i=0;
	xnow=x;
	ynow=y;
	xnext=x;
	ynext=y;
	var outofbound = (xnext<0 || ynext<0 || y>=room_height || x>=room_width);
	while(!outofbound){
		xnow=xnext;
		ynow=ynext;
		switch(trajtype){
			case 1:
				xnext = xnow + (shotpower*(cos(degtorad(cannonangle))));
				ynext = ynow - (shotpower*(sin(degtorad(cannonangle))));
				break;
			case 2:
				xnext = xnow + (shotpower*(cos(degtorad(cannonangle))));
				ynext = ynow - (shotpower*(sin(degtorad(cannonangle)))-grav*i);
				break;
			case 3:
				var phaseDev = (8*shotpower* sin(degtorad(i*10)));	//calculate phase deviation
				xnext = x + (i*(shotpower*(cos(degtorad(cannonangle))))) - phaseDev*sin(degtorad(cannonangle));
				ynext = y - (i*(shotpower*(sin(degtorad(cannonangle))))) - phaseDev*cos(degtorad(cannonangle));
				break;
			case 4:
				xnext = x + (i*(shotpower*(cos(degtorad(cannonangle)))));
				ynext = -1.3 * logn(0.9,xnext);
				break;
			default:
				break;
		}
		//Draw here
		draw_line(xnow,ynow,xnext,ynext);
		
		i+=1;
		outofbound = (xnext<0 || ynext<0 || y>=room_height || x>=room_width || i>=max_draw_i);
	}
	
}