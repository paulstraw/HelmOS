# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

StarSystem.create(name: 'Sol')
Star.create(name: 'Sol', radius: 695500, x: 231425818500000000, y: 462851637000000000, star_system: StarSystem.find_by(name: 'Sol'))
Planet.create([
  {
    name: 'Mercury',
    radius: 2440,
    star: Star.find_by(name: 'Sol'),
    apogee: 69817445,
    perigee: 46001009
  },
  {
    name: 'Venus',
    radius: 6052,
    star: Star.find_by(name: 'Sol'),
    apogee: 108942780,
    perigee: 107476170
  },
  {
    name: 'Earth',
    radius: 6378,
    star: Star.find_by(name: 'Sol'),
    apogee: 152098233,
    perigee: 147098291
  },
  {
    name: 'Mars',
    radius: 3390,
    star: Star.find_by(name: 'Sol'),
    apogee: 249232432,
    perigee: 206655215
  },
  {
    name: 'Jupiter',
    radius: 69911,
    star: Star.find_by(name: 'Sol'),
    apogee: 816001807,
    perigee: 740679835
  },
  {
    name: 'Saturn',
    radius: 58232,
    star: Star.find_by(name: 'Sol'),
    apogee: 1503509229,
    perigee: 1349823615
  },
  {
    name: 'Uranus',
    radius: 25362,
    star: Star.find_by(name: 'Sol'),
    apogee: 3006318143,
    perigee: 2734998229
  },
  {
    name: 'Neptune',
    radius: 24622,
    star: Star.find_by(name: 'Sol'),
    apogee: 4537039826,
    perigee: 4459753056
  },
  {
    name: 'Pluto',
    radius: 1184,
    star: Star.find_by(name: 'Sol'),
    apogee: 7376124302,
    perigee: 4436756954
  },
])

# https://solarsystem.nasa.gov/planets/profile.cfm?Object=Ura_Ariel&Display=Facts

# earth satellites
Satellite.create(name: 'Moon', radius: 1738, orbitable: Planet.find_by(name: 'Earth'), apogee: 406395, perigee: 357643)

# mars satellites
Satellite.create(name: 'Deimos', radius: 6, orbitable: Planet.find_by(name: 'Mars'), apogee: 23471, perigee: 23456)
Satellite.create(name: 'Phobos', radius: 11, orbitable: Planet.find_by(name: 'Mars'), apogee: 9517, perigee: 9234)

# jupiter satellites
Satellite.create(name: 'Io', radius: 1821, orbitable: Planet.find_by(name: 'Jupiter'), apogee: 423400, perigee: 420000)
Satellite.create(name: 'Europa', radius: 1561, orbitable: Planet.find_by(name: 'Jupiter'), apogee: 676938, perigee: 664862)
Satellite.create(name: 'Ganymede', radius: 2634, orbitable: Planet.find_by(name: 'Jupiter'), apogee: 1071600, perigee: 1069200)
Satellite.create(name: 'Callisto', radius: 2410, orbitable: Planet.find_by(name: 'Jupiter'), apogee: 1897000, perigee: 1869000)

# saturn satellites
Satellite.create(name: 'Titan', radius: 2576, orbitable: Planet.find_by(name: 'Saturn'), apogee: 1257060, perigee: 1186680)
Satellite.create(name: 'Rhea', radius: 764, orbitable: Planet.find_by(name: 'Saturn'), apogee: 527595, perigee: 526541)

# uranus satellites
Satellite.create(name: 'Miranda', radius: 236, orbitable: Planet.find_by(name: 'Uranus'), apogee: 130069, perigee: 129731)
Satellite.create(name: 'Ariel', radius: 579, orbitable: Planet.find_by(name: 'Uranus'), apogee: 191129, perigee: 190671)
Satellite.create(name: 'Umbriel', radius: 585, orbitable: Planet.find_by(name: 'Uranus'), apogee: 267037, perigee: 264963)
Satellite.create(name: 'Titania', radius: 789, orbitable: Planet.find_by(name: 'Uranus'), apogee: 436780, perigee: 435820)
Satellite.create(name: 'Oberon', radius: 761, orbitable: Planet.find_by(name: 'Uranus'), apogee: 584317, perigee: 582683)

# neptune satellites
Satellite.create(name: 'Triton', radius: 1353, orbitable: Planet.find_by(name: 'Neptune'), apogee: 354759, perigee: 354759)

# pluto satellites
Satellite.create(name: 'Charon', radius: 604, orbitable: Planet.find_by(name: 'Pluto'), apogee: 17575, perigee: 17497)



Faction.create(name: 'United Republic', home_planet: Planet.find_by(name: 'Earth'), hex_color: '248ac4')