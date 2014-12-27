## Next Up

1. Get travel working, and properly connected with cached client values
2. Show ships in orbit, enable map interaction
3. Battle, I guess?


## Little Things

1. Chat not subscribing properly immediately after signup
2. If you refresh during travel, things work properly, but then once you refresh again after arriving, you get "stuck" as if you were still travelling until you refresh again.


## Units

30856775800000			km in a parsec  
30000					parsecs in the milky way  
925703274000000000		km in the milky way  
9223372036854775807		64 bit integer

299792					speed of light per second  
149896					0.5c/second  
59958.4					0.2c/second  
29979.2					0.1c/second  
4496880					15c/second

In-game travel is "sublight", but will actually be at  ~15c in real world time.

### Mercury

* 57910000				distance from sun
* 193					1c seconds from sun
* 12					15c seconds from sun


### Venus

* 108200000				distance from sun
* 360					1c seconds from sun
* 24					15c seconds from sun


### Earth

* 149600000				distance from sun
* 500					1c seconds from sun
* 33					15c seconds from sun


### Mars

* 227900000				distance from sun
* 760					1c seconds from sun
* 50					15c seconds from sun


### Jupiter

* 778500000				distance from sun
* 2596					1c seconds from sun
* 173					15c seconds from sun


### Saturn

* 1433000000			distance from sun
* 4779					1c seconds from sun
* 318					15c seconds from sun


### Uranus

* 2877000000			distance from sun
* 9596					1c seconds from sun
* 639					15c seconds from sun


### Neptune

* 4503000000			distance from sun
* 15020					1c seconds from sun
* 1001					15c seconds from sun


### Pluto

* 3670000000			distance from sun
* 12241					1c seconds from sun
* 816					15c seconds from sun


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
* orbit calculation http://www.orbiter-forum.com/showthread.php?t=26682

### Factions

* United Republic
* "Trade Federation"?
* "Pioneers"?


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


### Gathering/Progression

* faction home star systems are essentially your faction's "capital city", in WoW parlance
* brief tutorial at home star system, then go directly to pvp-enabled "starter" star system
* [game progression/"leveling" path](http://paul.st/Z3tv)
* away teams are used to gather resources
	* team is sent to planet, takes time to gather resources before they can be "picked back up"
		* time it takes is dependent on team skill and resource "level"
	* ships start with set number of "free" away teams
	* additional away teams can be hired throughout the game
		* more away teams = faster resource collection
		* more skilled teams cost more credits
		* credits to pay away teams are debited weekly
			* if ship doesn't have enough credits to pay, teams that can't be paid for leave


### Ships

* Primary systems
	* Life support
	* Engines
	* Weapons
		* Lasers?
		* Railgun
		* [Dazzlers](http://en.wikipedia.org/wiki/Dazzler_(weapon))?
		* [Teleforce](http://en.wikipedia.org/wiki/Teleforce)? (Particle beams)
		* Missiles
		* EMP (temporarily disable systems)
	* Shields (would likely only deflect projectile-based attacks?)
		* EM shielding?
		* "Star Wars" (SDI)-esque system?
		* Could also go the "traditional" shield route. Less realistic, but probably easier, and likely more fun.
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

### StarSystem

rails g model StarSystem name


### Star

rails g model Star name radius:integer{limit:8} x:integer{limit:8} y:integer{limit:8} star_system:references


### Planet

rails g model Planet name radius:integer{limit:8} star:references apogee:integer{limit:8} perigee:integer{limit:8}


### Satellite

rails g model Satellite name orbitable:references{polymorphic} apogee:integer{limit:8} perigee:integer{limit:8} radius:integer{limit:8}


### Ship

rails g model Ship name captain:references in_battle:boolean


### Battle

rails g model Battle status:integer

has_many :ship_battles
has_many :ships, through: :ship_battles


### ShipBattle

rails g model ShipBattle ship:references battle:references


### CommunicationChannel

rails g model CommunicationChannel name global:boolean


### Communication

rails g model Communication author:references communication_channel:references content:text
