# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Faction.create(name: 'United Republic')

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

Satellite.create(name: 'Moon', radius: 1738, orbitable: Planet.find_by(name: 'Earth'), apogee: 406395, perigee: 357643)
