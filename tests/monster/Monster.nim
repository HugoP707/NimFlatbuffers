import Nimflatbuffers

generateCode("MonsterSchema.fbs")
#import output/MyGame_Sample

var builder = newBuilder(1024)
#[
var
   weaponOne = builder.Create("Sword")
   weaponTwo = builder.Create("Axe")
builder.WeaponStart()
builder.WeaponAddName(weaponOne)
builder.WeaponAddDamage(3)
var sword = builder.WeaponEnd()

builder.WeaponStart()
builder.WeaponAddName(weaponTwo)
builder.WeaponAddDamage(5)
var axe = builder.WeaponEnd()

var inv = builder.MonsterStartinventoryVector(10)
var i = 9
while i >= 0:
   builder.Prepend(i.byte)
   dec i
inv = builder.EndVector(10)

var weapons = builder.MonsterStartweaponsVector(2)
builder.Prepend(axe)
builder.Prepend(axe)
weapons = builder.EndVector(2)

var path = builder.MonsterStartPathVector(2)
discard builder.CreateVec3(1.0, 2.0, 3.0)
discard builder.CreateVec3(4.0, 5.0, 6.0)
path = builder.EndVector(2)
]#
var name = builder.Create("Orc")
builder.MonsterStart()
builder.MonsterAddPos(builder.CreateVec3(1.0, 2.0, 3.0))
builder.MonsterAddHp(301)
builder.MonsterAddMana(10)
builder.MonsterAddName(name)
#[
builder.MonsterAddInventory(inv)
builder.MonsterAddColor(Color.Red)
builder.MonsterAddWeapons(weapons)
builder.MonsterAddEquippedType(EquipmentType.Weapon)
builder.MonsterAddEquipped(axe)
builder.MonsterAddPath(path)
]#
var orc = builder.MonsterEnd()

builder.Finish(orc)

var finishedBytes = builder.FinishedBytes()
# echo finishedBytes

var aMonster: Monster
GetRootAs(aMonster, finishedBytes, 0)

echo "Monster HP: ", aMonster.hp
echo "Monster Name: \"", aMonster.name, "\""
echo "Monster Pos: ",  aMonster.pos.x, aMonster.pos.y, aMonster.pos.z
