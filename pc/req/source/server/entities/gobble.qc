//==- GobbleGum Code by MotoLegacy -==//
void(float gum) setSpecial;
void() nuke;
void(vector where, float type) Spawn_Powerup;

void() activateGobble =
{
	local entity gum;
	gum = spawn();
	setorigin(gum, self.origin);
	gum.angles = self.angles;
	gum.origin = self.origin + '-100 0 12';
	switch(self.holdgum) {
		case G_KILLJOY:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 3);
			break;
		case G_IMMOLATION:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 6);
			break;
		case G_SCORE:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 2);
			break;
		case G_CARPENTER:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 5);
			break;
		case G_WINTER:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 4);
			break;
		case G_CACHE:
			self.gumcount--;
			if (self.gumcount <= 0) {
				self.holdgum = 0;
				return; }
			makevectors (self.v_angle);
			Spawn_Powerup(gum.origin, 1);
			break;
		case G_ROBBIN:
			nuke();
			EndRound();
			addmoney(self, 1500, 0);
			self.holdgum = 0;
			break;

	}
}

void() activateSwordFlay =
{
	self.meleedamage = 750;
	self.gumtime = time + 150;
}

void() giveAllPerks =
{
	self.perks = self.perks | 8;
	self.perks = self.perks | 16;
	self.perks = self.perks | 1;
	self.perks = self.perks | 32;
	self.perks = self.perks | 4;
	self.perks = self.perks | 2;
	self.perks = self.perks | 64;
	self.perks = self.perks | 128;
	self.perks = self.perks | 256;
	self.perks = self.perks | 512;
	self.perks = self.perks | 1024;
	SetupBlood(self);
	SetPerk(self, self.perks);
}

void(entity who) resetGum =
{
	who.meleedamage = 150;
}

void(entity who) CheckGum =
{
	if (who.gumtime < time)
		resetGum(who);
}

float(float gum) getGumSkin =
{
	/*
	0 - Orange
	1 - Green
	2 - Red
	3 - Blue
	4 - Purple
	*/
	switch(gum) {
		case G_SWORD:
			return 1;
			break;
		case G_CARPENTER:
		case G_ROBBIN:
		case G_INPLAIN:
		case G_KILLJOY:
		case G_SCORE:
		case G_IMMOLATION:
		case G_WINTER:
		case G_CACHE:
			return 4;
			break;
		case G_PERK:
			return 0;
			break;
		default:
			return 1;
			break;
	}
}

void(float gum) giveGum =
{
	switch(gum) {
		case G_PERK:
			giveAllPerks();
			break;
		case G_SWORD:
			activateSwordFlay();
			break;
		case G_CARPENTER:
		case G_KILLJOY:
		case G_ROBBIN:
		case G_SCORE:
		case G_IMMOLATION:
		case G_WINTER:
		case G_CACHE:
			setSpecial(gum);
			break;
		default:
			centerprint(self, "You broke something.");
			break;
	}

	sound_perk_delay = time + 4.5;
	self.isBuying = false;
	string modelname = GetWeaponModel(self.weapon, 0);
	float startframe = GetFrame(self.weapon,TAKE_OUT_START);
	float endframe = GetFrame(self.weapon,TAKE_OUT_END);
	self.weaponskin = backupWepSkin;
	self.perk_delay = self.fire_delay;
	Set_W_Frame (startframe, endframe, 0, 0, 0, SUB_Null, modelname, false, S_BOTH);
}

void() givePerkaholic = { giveGum(G_PERK); }
void() giveSwordFlay = { giveGum(G_SWORD); }
void() giveKillJoy = { giveGum(G_KILLJOY); }
void() giveRoundRobbin = { giveGum(G_ROBBIN); }
void() giveInPlainSight = { giveGum(G_INPLAIN); }
void() giveScore = { giveGum(G_SCORE); }
void() giveSale = { giveGum(G_IMMOLATION); }
void() giveCarpenter = { giveGum(G_CARPENTER); }
void() giveWinter = { giveGum(G_WINTER); }
void() giveCacheBack = { giveGum(G_CACHE); }

void(float gum) chewGum =
{
	resetGum(other);
	void(optional float f) gumfunction;

	switch (gum) {
		case G_SWORD:
			gumfunction = giveSwordFlay;
			break;
		case G_ROBBIN:
			gumfunction = giveRoundRobbin;
			break;
		case G_INPLAIN:
			gumfunction = giveInPlainSight;
			break;
		case G_KILLJOY:
			gumfunction = giveKillJoy;
			break;
		case G_PERK:
			gumfunction = givePerkaholic;
			break;
		case G_SCORE:
			gumfunction = giveScore;
			break;
		case G_IMMOLATION:
			gumfunction = giveSale;
			break;
		case G_CARPENTER:
			gumfunction = giveCarpenter;
			break;
		case G_WINTER:
			gumfunction = giveWinter;
			break;
		case G_CACHE:
			gumfunction = giveCacheBack;
			break;
		default:
			centerprint(other, "You broke something.");
	}

	other.weaponskin = getGumSkin(gum);
	other.isBuying = true;
	entity tempe = self;
	self = other;
	
	if (self.sprinting)
		W_SprintStop();
	
	self.knife_delay = self.reload_delay2 = self.fire_delay2 = self.fire_delay = self.reload_delay = 4.5 + time;
	self.limit --;		
	Set_W_Frame (0, 22, 0, 0, PERK, gumfunction, "models/machines/v_perk.mdl", true, S_RIGHT);
	self = tempe;
	sound (other, CHAN_ITEM, "sounds/machines/perk_drink.wav", 1, ATTN_NORM);
}

float(float spent) gobbleCost =
{
	float cost;
	switch (spent) {
		case 0: cost = 500; break;
		case 1: cost = 1500; break;
		case 2: cost = 2500; break;
		case 3: cost = 5000; break;
		case 4: cost = 10000; break;
		default: cost = 25000; break; 
	}

	if (firesale_finished)
		cost -= 490;

	return cost;
}

void() changeGumState =
{
	self.papState++;
	if (self.papState == 3)
		self.papState = 0;
}

void() touch_gum =
{
	if (other.classname != "player" || other.downed || other.isBuying == true)
		return;

	float cost = gobbleCost(other.gumnum);

	if (self.papState == 0) {
		if (self.machinebuy == 1)
			return;
		useprint (other, 16, cost, 0);
		if (other.button7 && other.points >= cost) {
			float gum;
			gum = random();
			if (gum < 0.1)
				gumcache = G_SWORD;
			else if (gum < 0.2)
				gumcache = G_ROBBIN;
			else if (gum < 0.3)
				gumcache = G_INPLAIN;
			else if (gum < 0.4)
				gumcache = G_KILLJOY;
			else if (gum < 0.5)
				gumcache = G_PERK;
			else if (gum < 0.6)
				gumcache = G_SCORE;
			else if (gum < 0.7)
				gumcache = G_IMMOLATION;
			else if (gum < 0.8)
				gumcache = G_CARPENTER;
			else if (gum < 0.9)
				gumcache = G_WINTER;
			else
				gumcache = G_CACHE;
			addmoney(other, -cost, 0);
			other.gumnum++;
			self.think = changeGumState;
			self.nextthink = time + 0.1;
			self.machinebuy = 1;
		}
	}

	if (self.papState == 1) {
		if (self.machinewait == 0) {
			self.machinebuy = 0;
			self.think = changeGumState;
			self.nextthink = time + 3;
			self.machinewait = 1;
		}
	}

	if (self.papState == 2) {
		useprint(other, 17, 0, gumcache);
		if (other.button7) {
			chewGum(gumcache);
			self.think = changeGumState;
			self.nextthink = time + 0.1;
			self.machinewait = 0;
		}
	}

}

void() perk_gobblegum =
{
	self.solid = SOLID_TRIGGER;
	precache_model ("models/machines/double_tap.mdl");
	precache_model ("models/machines/v_perk.mdl");
	precache_sound ("sounds/machines/perk_drink.wav");
	setorigin (self, self.origin);
	setmodel (self, "models/machines/double_tap.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.classname = "perk_gobblegum";
	self.touch = touch_gum;
}