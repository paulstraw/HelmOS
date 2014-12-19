## Units

30856775800000			km in a parsec
30000					parsecs in the milky way
925703274000000000		km in the milky way
9223372036854775807		64 bit integer


## Firefly Things

* http://scifi.stackexchange.com/questions/27397/how-do-the-ships-in-firefly-travel-immense-distances
* http://pics.fireflyprops.net/TVIN-2.1.pdf
* http://www.reddit.com/r/AskScienceFiction/comments/1oo2gy/firefly_how_big_is_the_firefly_universe/
* http://photos.summer-glau.com/albums/userpics/10001/CNC.png


## Style

All game interaction is via your ship's "operating system". Right now, I'm thinking something along the lines of a console overlaid on a "main view", where a map or combat info would be displayed (depending on the current situation).


## Mechanics

### "World"

* A collection of solar systems (one home system per faction, plus "contested/unclaimed"-type systems), each with several planets and other features
* Star bases?


### Economy/Resources

* Fuel
	* Used to power ships for travel, combat, etc
	* Primary resource
* "Ore"
	* Potentially gathered from planets by "away teams"?
	* Can be refined into fuel?
	* Can be traded for upgrades?


* raw materials can be gathered and sold for "credits"
	* raw materials onboard are lost when you die
		* all are dropped, a small percentage go to the ship that killed you
	* credits are used for
		* trading/auction house
		* buying upgrade schematics
		* fuel
	* if sold where they're rare, they fetch a better price
* if you get stranded with no way to make fuel, you can send out a distress beacon and a fuelling vessel will come to provide you with enough for transit to the closest fuelling station??? OR just every orbitable thing has ore that can be collected and refined into fuel
* upgrade schematics (purchased from vendors _only_)
	* hull plating (crafting)
	* weapons
	* basically all ship systems???
	* craftable weapon types???


### Ships

* Primary systems
	* Life support
	* Engines
	* Weapons
		* Lasers
		* (Dazzlers)[http://en.wikipedia.org/wiki/Dazzler_(weapon)]?
		* (Teleforce)[http://en.wikipedia.org/wiki/Teleforce]?
		* Missiles
		* EMP (temporarily disable systems)
	* Shields
		* EM shielding? (would only deflect projectile-based attacks)
		* 
	* Communications
	* Energy grid


### Travel

* Likely no physical control over travel
* Select planetary body/satellite/whatever to travel to, automatically enter orbit after x seconds/minutes
* Travel between solar systems by traveling to a "warp gate", then "using" it to jump


### Combat

* FTL-like, ideally
* How is combat initiated?
* NPC combat?


## Classes

### CelestialBody

rails g model CelestialBody name x:integer{limit:8} y:integer{limit:8} diameter:integer


### Satellite

rails g model Satellite name celestial_body:references


### Ship

rails g model Ship name captain:references in_battle:boolean


### Battle

rails g model Battle status:integer

has_many :ship_battles
has_many :ships, through: :ship_battles


### ShipBattle

rails g model ShipBattle ship:references battle:references


