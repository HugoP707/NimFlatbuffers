import
  Nimflatbuffers


type
  ControllerState* = object of FlatObj


proc throttle*(this: ControllerState): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `throttle=`*(this: var ControllerState; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc steer*(this: ControllerState): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `steer=`*(this: var ControllerState; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc pitch*(this: ControllerState): float32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `pitch=`*(this: var ControllerState; n: float32) =
  discard this.tab.MutateSlot(8, n)

proc yaw*(this: ControllerState): float32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `yaw=`*(this: var ControllerState; n: float32) =
  discard this.tab.MutateSlot(10, n)

proc roll*(this: ControllerState): float32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `roll=`*(this: var ControllerState; n: float32) =
  discard this.tab.MutateSlot(12, n)

proc jump*(this: ControllerState): bool =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `jump=`*(this: var ControllerState; n: bool) =
  discard this.tab.MutateSlot(14, n)

proc boost*(this: ControllerState): bool =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boost=`*(this: var ControllerState; n: bool) =
  discard this.tab.MutateSlot(16, n)

proc handbrake*(this: ControllerState): bool =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `handbrake=`*(this: var ControllerState; n: bool) =
  discard this.tab.MutateSlot(18, n)

proc useItem*(this: ControllerState): bool =
  var o = this.tab.Offset(20)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `useItem=`*(this: var ControllerState; n: bool) =
  discard this.tab.MutateSlot(20, n)

proc ControllerStateStart*(this: var Builder) =
  this.StartObject(9)

proc ControllerStateAddThrottle*(this: var Builder; throttle: float32) =
  this.PrependSlot(0, throttle, default(float32))

proc ControllerStateAddSteer*(this: var Builder; steer: float32) =
  this.PrependSlot(1, steer, default(float32))

proc ControllerStateAddPitch*(this: var Builder; pitch: float32) =
  this.PrependSlot(2, pitch, default(float32))

proc ControllerStateAddYaw*(this: var Builder; yaw: float32) =
  this.PrependSlot(3, yaw, default(float32))

proc ControllerStateAddRoll*(this: var Builder; roll: float32) =
  this.PrependSlot(4, roll, default(float32))

proc ControllerStateAddJump*(this: var Builder; jump: bool) =
  this.PrependSlot(5, jump, default(bool))

proc ControllerStateAddBoost*(this: var Builder; boost: bool) =
  this.PrependSlot(6, boost, default(bool))

proc ControllerStateAddHandbrake*(this: var Builder; handbrake: bool) =
  this.PrependSlot(7, handbrake, default(bool))

proc ControllerStateAddUseItem*(this: var Builder; useItem: bool) =
  this.PrependSlot(8, useItem, default(bool))

proc ControllerStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerInput* = object of FlatObj


proc playerIndex*(this: PlayerInput): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var PlayerInput; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc controllerState*(this: PlayerInput): ControllerState =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PlayerInputStart*(this: var Builder) =
  this.StartObject(2)

proc PlayerInputAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(0, playerIndex, default(int32))

proc PlayerInputAddControllerState*(this: var Builder; controllerState: uoffset) =
  this.PrependSlot(1, controllerState, default(uoffset))

proc PlayerInputEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  Vector3* = object of FlatObj


proc x*(this: Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc `x=`*(this: var Vector3; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 4, n)

proc y*(this: Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc `y=`*(this: var Vector3; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 8, n)

proc z*(this: Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 12)
proc `z=`*(this: var Vector3; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 12, n)

proc CreateVector3*(this: var Builder; x: float32; y: float32; z: float32): uoffset =
  this.Prep(4, 12)
  this.Prepend(z)
  this.Prepend(y)
  this.Prepend(x)
  result = this.Offset()


type
  Rotator* = object of FlatObj


proc pitch*(this: Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc `pitch=`*(this: var Rotator; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 4, n)

proc yaw*(this: Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc `yaw=`*(this: var Rotator; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 8, n)

proc roll*(this: Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 12)
proc `roll=`*(this: var Rotator; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 12, n)

proc CreateRotator*(this: var Builder; pitch: float32; yaw: float32;
                    roll: float32): uoffset =
  this.Prep(4, 12)
  this.Prepend(roll)
  this.Prepend(yaw)
  this.Prepend(pitch)
  result = this.Offset()


type
  Quaternion* = object of FlatObj


proc x*(this: Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc `x=`*(this: var Quaternion; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 4, n)

proc y*(this: Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc `y=`*(this: var Quaternion; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 8, n)

proc z*(this: Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 12)
proc `z=`*(this: var Quaternion; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 12, n)

proc w*(this: Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 16)
proc `w=`*(this: var Quaternion; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 16, n)

proc CreateQuaternion*(this: var Builder; x: float32; y: float32; z: float32;
                       w: float32): uoffset =
  this.Prep(4, 16)
  this.Prepend(w)
  this.Prepend(z)
  this.Prepend(y)
  this.Prepend(x)
  result = this.Offset()


type
  BoxShape* = object of FlatObj


proc length*(this: BoxShape): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `length=`*(this: var BoxShape; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc width*(this: BoxShape): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `width=`*(this: var BoxShape; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc height*(this: BoxShape): float32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `height=`*(this: var BoxShape; n: float32) =
  discard this.tab.MutateSlot(8, n)

proc BoxShapeStart*(this: var Builder) =
  this.StartObject(3)

proc BoxShapeAddLength*(this: var Builder; length: float32) =
  this.PrependSlot(0, length, default(float32))

proc BoxShapeAddWidth*(this: var Builder; width: float32) =
  this.PrependSlot(1, width, default(float32))

proc BoxShapeAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(2, height, default(float32))

proc BoxShapeEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  SphereShape* = object of FlatObj


proc diameter*(this: SphereShape): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `diameter=`*(this: var SphereShape; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc SphereShapeStart*(this: var Builder) =
  this.StartObject(1)

proc SphereShapeAddDiameter*(this: var Builder; diameter: float32) =
  this.PrependSlot(0, diameter, default(float32))

proc SphereShapeEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  CylinderShape* = object of FlatObj


proc diameter*(this: CylinderShape): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `diameter=`*(this: var CylinderShape; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc height*(this: CylinderShape): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `height=`*(this: var CylinderShape; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc CylinderShapeStart*(this: var Builder) =
  this.StartObject(2)

proc CylinderShapeAddDiameter*(this: var Builder; diameter: float32) =
  this.PrependSlot(0, diameter, default(float32))

proc CylinderShapeAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(1, height, default(float32))

proc CylinderShapeEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  CollisionShapeType* {.pure.} = enum
    BoxShape = 0'u8, SphereShape = 1'u8, CylinderShape = 2'u8

type
  CollisionShape* = object of FlatObj

type
  Touch* = object of FlatObj

proc playerName*(this: Touch): string =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc gameSeconds*(this: Touch): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameSeconds=`*(this: var Touch; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc location*(this: Touch): Vector3 =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc normal*(this: Touch): Vector3 =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc team*(this: Touch): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `team=`*(this: var Touch; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc playerIndex*(this: Touch): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var Touch; n: int32) =
  discard this.tab.MutateSlot(14, n)

proc TouchStart*(this: var Builder) =
  this.StartObject(6)

proc TouchAddPlayerName*(this: var Builder; playerName: uoffset) =
  this.PrependSlot(1, playerName, default(uoffset))

proc TouchAddGameSeconds*(this: var Builder; gameSeconds: float32) =
  this.PrependSlot(1, gameSeconds, default(float32))

proc TouchAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(2, location, default(uoffset))

proc TouchAddNormal*(this: var Builder; normal: uoffset) =
  this.PrependSlot(3, normal, default(uoffset))

proc TouchAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(4, team, default(int32))

proc TouchAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(5, playerIndex, default(int32))

proc TouchEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  ScoreInfo* = object of FlatObj


proc score*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `score=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc goals*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `goals=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc ownGoals*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ownGoals=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(8, n)

proc assists*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `assists=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(10, n)

proc saves*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `saves=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc shots*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `shots=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(14, n)

proc demolitions*(this: ScoreInfo): int32 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `demolitions=`*(this: var ScoreInfo; n: int32) =
  discard this.tab.MutateSlot(16, n)

proc ScoreInfoStart*(this: var Builder) =
  this.StartObject(7)

proc ScoreInfoAddScore*(this: var Builder; score: int32) =
  this.PrependSlot(0, score, default(int32))

proc ScoreInfoAddGoals*(this: var Builder; goals: int32) =
  this.PrependSlot(1, goals, default(int32))

proc ScoreInfoAddOwnGoals*(this: var Builder; ownGoals: int32) =
  this.PrependSlot(2, ownGoals, default(int32))

proc ScoreInfoAddAssists*(this: var Builder; assists: int32) =
  this.PrependSlot(3, assists, default(int32))

proc ScoreInfoAddSaves*(this: var Builder; saves: int32) =
  this.PrependSlot(4, saves, default(int32))

proc ScoreInfoAddShots*(this: var Builder; shots: int32) =
  this.PrependSlot(5, shots, default(int32))

proc ScoreInfoAddDemolitions*(this: var Builder; demolitions: int32) =
  this.PrependSlot(6, demolitions, default(int32))

proc ScoreInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  Physics* = object of FlatObj


proc location*(this: Physics): Vector3 =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc rotation*(this: Physics): Rotator =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc velocity*(this: Physics): Vector3 =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc angularVelocity*(this: Physics): Vector3 =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PhysicsStart*(this: var Builder) =
  this.StartObject(4)

proc PhysicsAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(0, location, default(uoffset))

proc PhysicsAddRotation*(this: var Builder; rotation: uoffset) =
  this.PrependSlot(1, rotation, default(uoffset))

proc PhysicsAddVelocity*(this: var Builder; velocity: uoffset) =
  this.PrependSlot(2, velocity, default(uoffset))

proc PhysicsAddAngularVelocity*(this: var Builder; angularVelocity: uoffset) =
  this.PrependSlot(3, angularVelocity, default(uoffset))

proc PhysicsEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerInfo* = object of FlatObj


proc physics*(this: PlayerInfo): Physics =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc scoreInfo*(this: PlayerInfo): ScoreInfo =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc isDemolished*(this: PlayerInfo): bool =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isDemolished=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(8, n)

proc hasWheelContact*(this: PlayerInfo): bool =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `hasWheelContact=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(10, n)

proc isSupersonic*(this: PlayerInfo): bool =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isSupersonic=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(12, n)

proc isBot*(this: PlayerInfo): bool =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isBot=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(14, n)

proc jumped*(this: PlayerInfo): bool =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `jumped=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(16, n)

proc doubleJumped*(this: PlayerInfo): bool =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `doubleJumped=`*(this: var PlayerInfo; n: bool) =
  discard this.tab.MutateSlot(18, n)
proc name*(this: PlayerInfo): string =
  var o = this.tab.Offset(20)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc team*(this: PlayerInfo): int32 =
  var o = this.tab.Offset(22)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `team=`*(this: var PlayerInfo; n: int32) =
  discard this.tab.MutateSlot(22, n)

proc boost*(this: PlayerInfo): int32 =
  var o = this.tab.Offset(24)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boost=`*(this: var PlayerInfo; n: int32) =
  discard this.tab.MutateSlot(24, n)

proc hitbox*(this: PlayerInfo): BoxShape =
  var o = this.tab.Offset(26)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc hitboxOffset*(this: PlayerInfo): Vector3 =
  var o = this.tab.Offset(28)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc spawnId*(this: PlayerInfo): int32 =
  var o = this.tab.Offset(30)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `spawnId=`*(this: var PlayerInfo; n: int32) =
  discard this.tab.MutateSlot(30, n)

proc PlayerInfoStart*(this: var Builder) =
  this.StartObject(14)

proc PlayerInfoAddPhysics*(this: var Builder; physics: uoffset) =
  this.PrependSlot(0, physics, default(uoffset))

proc PlayerInfoAddScoreInfo*(this: var Builder; scoreInfo: uoffset) =
  this.PrependSlot(1, scoreInfo, default(uoffset))

proc PlayerInfoAddIsDemolished*(this: var Builder; isDemolished: bool) =
  this.PrependSlot(2, isDemolished, default(bool))

proc PlayerInfoAddHasWheelContact*(this: var Builder; hasWheelContact: bool) =
  this.PrependSlot(3, hasWheelContact, default(bool))

proc PlayerInfoAddIsSupersonic*(this: var Builder; isSupersonic: bool) =
  this.PrependSlot(4, isSupersonic, default(bool))

proc PlayerInfoAddIsBot*(this: var Builder; isBot: bool) =
  this.PrependSlot(5, isBot, default(bool))

proc PlayerInfoAddJumped*(this: var Builder; jumped: bool) =
  this.PrependSlot(6, jumped, default(bool))

proc PlayerInfoAddDoubleJumped*(this: var Builder; doubleJumped: bool) =
  this.PrependSlot(7, doubleJumped, default(bool))

proc PlayerInfoAddName*(this: var Builder; name: uoffset) =
  this.PrependSlot(9, name, default(uoffset))

proc PlayerInfoAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(9, team, default(int32))

proc PlayerInfoAddBoost*(this: var Builder; boost: int32) =
  this.PrependSlot(10, boost, default(int32))

proc PlayerInfoAddHitbox*(this: var Builder; hitbox: uoffset) =
  this.PrependSlot(11, hitbox, default(uoffset))

proc PlayerInfoAddHitboxOffset*(this: var Builder; hitboxOffset: uoffset) =
  this.PrependSlot(12, hitboxOffset, default(uoffset))

proc PlayerInfoAddSpawnId*(this: var Builder; spawnId: int32) =
  this.PrependSlot(13, spawnId, default(int32))

proc PlayerInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DropShotBallInfo* = object of FlatObj


proc absorbedForce*(this: DropShotBallInfo): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `absorbedForce=`*(this: var DropShotBallInfo; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc damageIndex*(this: DropShotBallInfo): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `damageIndex=`*(this: var DropShotBallInfo; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc forceAccumRecent*(this: DropShotBallInfo): float32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `forceAccumRecent=`*(this: var DropShotBallInfo; n: float32) =
  discard this.tab.MutateSlot(8, n)

proc DropShotBallInfoStart*(this: var Builder) =
  this.StartObject(3)

proc DropShotBallInfoAddAbsorbedForce*(this: var Builder; absorbedForce: float32) =
  this.PrependSlot(0, absorbedForce, default(float32))

proc DropShotBallInfoAddDamageIndex*(this: var Builder; damageIndex: int32) =
  this.PrependSlot(1, damageIndex, default(int32))

proc DropShotBallInfoAddForceAccumRecent*(this: var Builder;
    forceAccumRecent: float32) =
  this.PrependSlot(2, forceAccumRecent, default(float32))

proc DropShotBallInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  BallInfo* = object of FlatObj


proc physics*(this: BallInfo): Physics =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc latestTouch*(this: BallInfo): Touch =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc dropShotInfo*(this: BallInfo): DropShotBallInfo =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc shapeType*(this: BallInfo): CollisionShapeType =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[CollisionShapeType](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `shapeType=`*(this: var BallInfo; n: CollisionShapeType) =
  discard this.tab.MutateSlot(10, n)

proc shape*(this: BallInfo): FlatObj =
  var o = this.tab.Offset(10)
  if o != 0:
    this.tab.Union(result.tab, o)
  else:
    discard

proc BallInfoStart*(this: var Builder) =
  this.StartObject(4)

proc BallInfoAddPhysics*(this: var Builder; physics: uoffset) =
  this.PrependSlot(0, physics, default(uoffset))

proc BallInfoAddLatestTouch*(this: var Builder; latestTouch: uoffset) =
  this.PrependSlot(1, latestTouch, default(uoffset))

proc BallInfoAddDropShotInfo*(this: var Builder; dropShotInfo: uoffset) =
  this.PrependSlot(2, dropShotInfo, default(uoffset))

proc BallInfoAddShapeType*(this: var Builder; shape: CollisionShapeType) =
  this.PrependSlot(3, shape, default(CollisionShapeType))

proc BallInfoAddShape*(this: var Builder; shape: uoffset) =
  this.PrependSlot(4, shape, default(uoffset))

proc BallInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  BoostPadState* = object of FlatObj


proc isActive*(this: BoostPadState): bool =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isActive=`*(this: var BoostPadState; n: bool) =
  discard this.tab.MutateSlot(4, n)

proc timer*(this: BoostPadState): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `timer=`*(this: var BoostPadState; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc BoostPadStateStart*(this: var Builder) =
  this.StartObject(2)

proc BoostPadStateAddIsActive*(this: var Builder; isActive: bool) =
  this.PrependSlot(0, isActive, default(bool))

proc BoostPadStateAddTimer*(this: var Builder; timer: float32) =
  this.PrependSlot(1, timer, default(float32))

proc BoostPadStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  TileState* {.pure.} = enum
    Unknown = 0.int8, Filled = 1.int8, Damaged = 2.int8, Open = 3.int8


type
  DropshotTile* = object of FlatObj


proc tileState*(this: DropshotTile): int8 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `tileState=`*(this: var DropshotTile; n: int8) =
  discard this.tab.MutateSlot(4, n)

proc DropshotTileStart*(this: var Builder) =
  this.StartObject(1)

proc DropshotTileAddTileState*(this: var Builder; tileState: TileState) =
  this.PrependSlot(0, tileState, default(TileState))

proc DropshotTileEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  GameInfo* = object of FlatObj


proc secondsElapsed*(this: GameInfo): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `secondsElapsed=`*(this: var GameInfo; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc gameTimeRemaining*(this: GameInfo): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameTimeRemaining=`*(this: var GameInfo; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc isOvertime*(this: GameInfo): bool =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isOvertime=`*(this: var GameInfo; n: bool) =
  discard this.tab.MutateSlot(8, n)

proc isUnlimitedTime*(this: GameInfo): bool =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isUnlimitedTime=`*(this: var GameInfo; n: bool) =
  discard this.tab.MutateSlot(10, n)

proc isRoundActive*(this: GameInfo): bool =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isRoundActive=`*(this: var GameInfo; n: bool) =
  discard this.tab.MutateSlot(12, n)

proc isKickoffPause*(this: GameInfo): bool =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isKickoffPause=`*(this: var GameInfo; n: bool) =
  discard this.tab.MutateSlot(14, n)

proc isMatchEnded*(this: GameInfo): bool =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isMatchEnded=`*(this: var GameInfo; n: bool) =
  discard this.tab.MutateSlot(16, n)

proc worldGravityZ*(this: GameInfo): float32 =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `worldGravityZ=`*(this: var GameInfo; n: float32) =
  discard this.tab.MutateSlot(18, n)

proc gameSpeed*(this: GameInfo): float32 =
  var o = this.tab.Offset(20)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameSpeed=`*(this: var GameInfo; n: float32) =
  discard this.tab.MutateSlot(20, n)

proc frameNum*(this: GameInfo): int32 =
  var o = this.tab.Offset(22)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `frameNum=`*(this: var GameInfo; n: int32) =
  discard this.tab.MutateSlot(22, n)

proc GameInfoStart*(this: var Builder) =
  this.StartObject(10)

proc GameInfoAddSecondsElapsed*(this: var Builder; secondsElapsed: float32) =
  this.PrependSlot(0, secondsElapsed, default(float32))

proc GameInfoAddGameTimeRemaining*(this: var Builder; gameTimeRemaining: float32) =
  this.PrependSlot(1, gameTimeRemaining, default(float32))

proc GameInfoAddIsOvertime*(this: var Builder; isOvertime: bool) =
  this.PrependSlot(2, isOvertime, default(bool))

proc GameInfoAddIsUnlimitedTime*(this: var Builder; isUnlimitedTime: bool) =
  this.PrependSlot(3, isUnlimitedTime, default(bool))

proc GameInfoAddIsRoundActive*(this: var Builder; isRoundActive: bool) =
  this.PrependSlot(4, isRoundActive, default(bool))

proc GameInfoAddIsKickoffPause*(this: var Builder; isKickoffPause: bool) =
  this.PrependSlot(5, isKickoffPause, default(bool))

proc GameInfoAddIsMatchEnded*(this: var Builder; isMatchEnded: bool) =
  this.PrependSlot(6, isMatchEnded, default(bool))

proc GameInfoAddWorldGravityZ*(this: var Builder; worldGravityZ: float32) =
  this.PrependSlot(7, worldGravityZ, default(float32))

proc GameInfoAddGameSpeed*(this: var Builder; gameSpeed: float32) =
  this.PrependSlot(8, gameSpeed, default(float32))

proc GameInfoAddFrameNum*(this: var Builder; frameNum: int32) =
  this.PrependSlot(9, frameNum, default(int32))

proc GameInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  TeamInfo* = object of FlatObj


proc teamIndex*(this: TeamInfo): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `teamIndex=`*(this: var TeamInfo; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc score*(this: TeamInfo): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `score=`*(this: var TeamInfo; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc TeamInfoStart*(this: var Builder) =
  this.StartObject(2)

proc TeamInfoAddTeamIndex*(this: var Builder; teamIndex: int32) =
  this.PrependSlot(0, teamIndex, default(int32))

proc TeamInfoAddScore*(this: var Builder; score: int32) =
  this.PrependSlot(1, score, default(int32))

proc TeamInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  GameTickPacket* = object of FlatObj


proc players*(this: GameTickPacket; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc playersLength*(this: GameTickPacket): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc boostPadStates*(this: GameTickPacket; j: int): uoffset =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc boostPadStatesLength*(this: GameTickPacket): int =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc ball*(this: GameTickPacket): BallInfo =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc gameInfo*(this: GameTickPacket): GameInfo =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc tileInformation*(this: GameTickPacket; j: int): uoffset =
  var o = this.tab.Offset(12)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc tileInformationLength*(this: GameTickPacket): int =
  var o = this.tab.Offset(12)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc teams*(this: GameTickPacket; j: int): uoffset =
  var o = this.tab.Offset(14)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc teamsLength*(this: GameTickPacket): int =
  var o = this.tab.Offset(14)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc GameTickPacketStart*(this: var Builder) =
  this.StartObject(6)

proc GameTickPacketAddPlayers*(this: var Builder; players: uoffset) =
  this.PrependSlot(0, players, default(uoffset))

proc GameTickPacketStartplayersVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc GameTickPacketAddBoostPadStates*(this: var Builder; boostPadStates: uoffset) =
  this.PrependSlot(1, boostPadStates, default(uoffset))

proc GameTickPacketStartboostPadStatesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc GameTickPacketAddBall*(this: var Builder; ball: uoffset) =
  this.PrependSlot(2, ball, default(uoffset))

proc GameTickPacketAddGameInfo*(this: var Builder; gameInfo: uoffset) =
  this.PrependSlot(3, gameInfo, default(uoffset))

proc GameTickPacketAddTileInformation*(this: var Builder;
                                       tileInformation: uoffset) =
  this.PrependSlot(4, tileInformation, default(uoffset))

proc GameTickPacketStarttileInformationVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc GameTickPacketAddTeams*(this: var Builder; teams: uoffset) =
  this.PrependSlot(5, teams, default(uoffset))

proc GameTickPacketStartteamsVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc GameTickPacketEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RigidBodyState* = object of FlatObj


proc frame*(this: RigidBodyState): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `frame=`*(this: var RigidBodyState; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc location*(this: RigidBodyState): Vector3 =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc rotation*(this: RigidBodyState): Quaternion =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc velocity*(this: RigidBodyState): Vector3 =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc angularVelocity*(this: RigidBodyState): Vector3 =
  var o = this.tab.Offset(12)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc RigidBodyStateStart*(this: var Builder) =
  this.StartObject(5)

proc RigidBodyStateAddFrame*(this: var Builder; frame: int32) =
  this.PrependSlot(0, frame, default(int32))

proc RigidBodyStateAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(1, location, default(uoffset))

proc RigidBodyStateAddRotation*(this: var Builder; rotation: uoffset) =
  this.PrependSlot(2, rotation, default(uoffset))

proc RigidBodyStateAddVelocity*(this: var Builder; velocity: uoffset) =
  this.PrependSlot(3, velocity, default(uoffset))

proc RigidBodyStateAddAngularVelocity*(this: var Builder;
                                       angularVelocity: uoffset) =
  this.PrependSlot(4, angularVelocity, default(uoffset))

proc RigidBodyStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerRigidBodyState* = object of FlatObj


proc state*(this: PlayerRigidBodyState): RigidBodyState =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc input*(this: PlayerRigidBodyState): ControllerState =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PlayerRigidBodyStateStart*(this: var Builder) =
  this.StartObject(2)

proc PlayerRigidBodyStateAddState*(this: var Builder; state: uoffset) =
  this.PrependSlot(0, state, default(uoffset))

proc PlayerRigidBodyStateAddInput*(this: var Builder; input: uoffset) =
  this.PrependSlot(1, input, default(uoffset))

proc PlayerRigidBodyStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  BallRigidBodyState* = object of FlatObj


proc state*(this: BallRigidBodyState): RigidBodyState =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc BallRigidBodyStateStart*(this: var Builder) =
  this.StartObject(1)

proc BallRigidBodyStateAddState*(this: var Builder; state: uoffset) =
  this.PrependSlot(0, state, default(uoffset))

proc BallRigidBodyStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RigidBodyTick* = object of FlatObj


proc ball*(this: RigidBodyTick): BallRigidBodyState =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc players*(this: RigidBodyTick; j: int): uoffset =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc playersLength*(this: RigidBodyTick): int =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc RigidBodyTickStart*(this: var Builder) =
  this.StartObject(2)

proc RigidBodyTickAddBall*(this: var Builder; ball: uoffset) =
  this.PrependSlot(0, ball, default(uoffset))

proc RigidBodyTickAddPlayers*(this: var Builder; players: uoffset) =
  this.PrependSlot(1, players, default(uoffset))

proc RigidBodyTickStartplayersVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc RigidBodyTickEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  GoalInfo* = object of FlatObj


proc teamNum*(this: GoalInfo): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `teamNum=`*(this: var GoalInfo; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc location*(this: GoalInfo): Vector3 =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc direction*(this: GoalInfo): Vector3 =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc width*(this: GoalInfo): float32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `width=`*(this: var GoalInfo; n: float32) =
  discard this.tab.MutateSlot(10, n)

proc height*(this: GoalInfo): float32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `height=`*(this: var GoalInfo; n: float32) =
  discard this.tab.MutateSlot(12, n)

proc GoalInfoStart*(this: var Builder) =
  this.StartObject(5)

proc GoalInfoAddTeamNum*(this: var Builder; teamNum: int32) =
  this.PrependSlot(0, teamNum, default(int32))

proc GoalInfoAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(1, location, default(uoffset))

proc GoalInfoAddDirection*(this: var Builder; direction: uoffset) =
  this.PrependSlot(2, direction, default(uoffset))

proc GoalInfoAddWidth*(this: var Builder; width: float32) =
  this.PrependSlot(3, width, default(float32))

proc GoalInfoAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(4, height, default(float32))

proc GoalInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  BoostPad* = object of FlatObj


proc location*(this: BoostPad): Vector3 =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc isFullBoost*(this: BoostPad): bool =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isFullBoost=`*(this: var BoostPad; n: bool) =
  discard this.tab.MutateSlot(6, n)

proc BoostPadStart*(this: var Builder) =
  this.StartObject(2)

proc BoostPadAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(0, location, default(uoffset))

proc BoostPadAddIsFullBoost*(this: var Builder; isFullBoost: bool) =
  this.PrependSlot(1, isFullBoost, default(bool))

proc BoostPadEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  FieldInfo* = object of FlatObj


proc boostPads*(this: FieldInfo; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc boostPadsLength*(this: FieldInfo): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc goals*(this: FieldInfo; j: int): uoffset =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc goalsLength*(this: FieldInfo): int =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc FieldInfoStart*(this: var Builder) =
  this.StartObject(2)

proc FieldInfoAddBoostPads*(this: var Builder; boostPads: uoffset) =
  this.PrependSlot(0, boostPads, default(uoffset))

proc FieldInfoStartboostPadsVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc FieldInfoAddGoals*(this: var Builder; goals: uoffset) =
  this.PrependSlot(1, goals, default(uoffset))

proc FieldInfoStartgoalsVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc FieldInfoEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  Float* = object of FlatObj


proc val*(this: Float): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc `val=`*(this: var Float; n: float32; ) =
  discard this.tab.Mutate(this.tab.Pos + 4, n)

proc CreateFloat*(this: var Builder; val: float32): uoffset =
  this.Prep(4, 4)
  this.Prepend(val)
  result = this.Offset()


type
  Bool* = object of FlatObj


proc val*(this: Bool): bool =
  result = Get[bool](this.tab, this.tab.Pos + 4)
proc `val=`*(this: var Bool; n: bool; ) =
  discard this.tab.Mutate(this.tab.Pos + 4, n)

proc CreateBool*(this: var Builder; val: bool): uoffset =
  this.Prep(1, 1)
  this.Prepend(val)
  result = this.Offset()


type
  Vector3Partial* = object of FlatObj


proc x*(this: Vector3Partial): Float =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc y*(this: Vector3Partial): Float =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc z*(this: Vector3Partial): Float =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc Vector3PartialStart*(this: var Builder) =
  this.StartObject(3)

proc Vector3PartialAddX*(this: var Builder; x: uoffset) =
  this.PrependSlot(0, x, default(uoffset))

proc Vector3PartialAddY*(this: var Builder; y: uoffset) =
  this.PrependSlot(1, y, default(uoffset))

proc Vector3PartialAddZ*(this: var Builder; z: uoffset) =
  this.PrependSlot(2, z, default(uoffset))

proc Vector3PartialEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RotatorPartial* = object of FlatObj


proc pitch*(this: RotatorPartial): Float =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc yaw*(this: RotatorPartial): Float =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc roll*(this: RotatorPartial): Float =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc RotatorPartialStart*(this: var Builder) =
  this.StartObject(3)

proc RotatorPartialAddPitch*(this: var Builder; pitch: uoffset) =
  this.PrependSlot(0, pitch, default(uoffset))

proc RotatorPartialAddYaw*(this: var Builder; yaw: uoffset) =
  this.PrependSlot(1, yaw, default(uoffset))

proc RotatorPartialAddRoll*(this: var Builder; roll: uoffset) =
  this.PrependSlot(2, roll, default(uoffset))

proc RotatorPartialEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredPhysics* = object of FlatObj


proc location*(this: DesiredPhysics): Vector3Partial =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc rotation*(this: DesiredPhysics): RotatorPartial =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc velocity*(this: DesiredPhysics): Vector3Partial =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc angularVelocity*(this: DesiredPhysics): Vector3Partial =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredPhysicsStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredPhysicsAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(0, location, default(uoffset))

proc DesiredPhysicsAddRotation*(this: var Builder; rotation: uoffset) =
  this.PrependSlot(1, rotation, default(uoffset))

proc DesiredPhysicsAddVelocity*(this: var Builder; velocity: uoffset) =
  this.PrependSlot(2, velocity, default(uoffset))

proc DesiredPhysicsAddAngularVelocity*(this: var Builder;
                                       angularVelocity: uoffset) =
  this.PrependSlot(3, angularVelocity, default(uoffset))

proc DesiredPhysicsEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredBallState* = object of FlatObj


proc physics*(this: DesiredBallState): DesiredPhysics =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredBallStateStart*(this: var Builder) =
  this.StartObject(1)

proc DesiredBallStateAddPhysics*(this: var Builder; physics: uoffset) =
  this.PrependSlot(0, physics, default(uoffset))

proc DesiredBallStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredCarState* = object of FlatObj


proc physics*(this: DesiredCarState): DesiredPhysics =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc boostAmount*(this: DesiredCarState): Float =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc jumped*(this: DesiredCarState): Bool =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc doubleJumped*(this: DesiredCarState): Bool =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredCarStateStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredCarStateAddPhysics*(this: var Builder; physics: uoffset) =
  this.PrependSlot(0, physics, default(uoffset))

proc DesiredCarStateAddBoostAmount*(this: var Builder; boostAmount: uoffset) =
  this.PrependSlot(1, boostAmount, default(uoffset))

proc DesiredCarStateAddJumped*(this: var Builder; jumped: uoffset) =
  this.PrependSlot(2, jumped, default(uoffset))

proc DesiredCarStateAddDoubleJumped*(this: var Builder; doubleJumped: uoffset) =
  this.PrependSlot(3, doubleJumped, default(uoffset))

proc DesiredCarStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredBoostState* = object of FlatObj


proc respawnTime*(this: DesiredBoostState): Float =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredBoostStateStart*(this: var Builder) =
  this.StartObject(1)

proc DesiredBoostStateAddRespawnTime*(this: var Builder; respawnTime: uoffset) =
  this.PrependSlot(0, respawnTime, default(uoffset))

proc DesiredBoostStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredGameInfoState* = object of FlatObj


proc worldGravityZ*(this: DesiredGameInfoState): Float =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc gameSpeed*(this: DesiredGameInfoState): Float =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc paused*(this: DesiredGameInfoState): Bool =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc endMatch*(this: DesiredGameInfoState): Bool =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredGameInfoStateStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredGameInfoStateAddWorldGravityZ*(this: var Builder;
    worldGravityZ: uoffset) =
  this.PrependSlot(0, worldGravityZ, default(uoffset))

proc DesiredGameInfoStateAddGameSpeed*(this: var Builder; gameSpeed: uoffset) =
  this.PrependSlot(1, gameSpeed, default(uoffset))

proc DesiredGameInfoStateAddPaused*(this: var Builder; paused: uoffset) =
  this.PrependSlot(2, paused, default(uoffset))

proc DesiredGameInfoStateAddEndMatch*(this: var Builder; endMatch: uoffset) =
  this.PrependSlot(3, endMatch, default(uoffset))

proc DesiredGameInfoStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  ConsoleCommand* = object of FlatObj

proc command*(this: ConsoleCommand): string =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc ConsoleCommandStart*(this: var Builder) =
  this.StartObject(1)

proc ConsoleCommandAddCommand*(this: var Builder; command: uoffset) =
  this.PrependSlot(1, command, default(uoffset))

proc ConsoleCommandEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  DesiredGameState* = object of FlatObj


proc ballState*(this: DesiredGameState): DesiredBallState =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc carStates*(this: DesiredGameState; j: int): uoffset =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc carStatesLength*(this: DesiredGameState): int =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc boostStates*(this: DesiredGameState; j: int): uoffset =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc boostStatesLength*(this: DesiredGameState): int =
  var o = this.tab.Offset(8)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc gameInfoState*(this: DesiredGameState): DesiredGameInfoState =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc consoleCommands*(this: DesiredGameState; j: int): uoffset =
  var o = this.tab.Offset(12)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc consoleCommandsLength*(this: DesiredGameState): int =
  var o = this.tab.Offset(12)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc DesiredGameStateStart*(this: var Builder) =
  this.StartObject(5)

proc DesiredGameStateAddBallState*(this: var Builder; ballState: uoffset) =
  this.PrependSlot(0, ballState, default(uoffset))

proc DesiredGameStateAddCarStates*(this: var Builder; carStates: uoffset) =
  this.PrependSlot(1, carStates, default(uoffset))

proc DesiredGameStateStartcarStatesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc DesiredGameStateAddBoostStates*(this: var Builder; boostStates: uoffset) =
  this.PrependSlot(2, boostStates, default(uoffset))

proc DesiredGameStateStartboostStatesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc DesiredGameStateAddGameInfoState*(this: var Builder; gameInfoState: uoffset) =
  this.PrependSlot(3, gameInfoState, default(uoffset))

proc DesiredGameStateAddConsoleCommands*(this: var Builder;
    consoleCommands: uoffset) =
  this.PrependSlot(4, consoleCommands, default(uoffset))

proc DesiredGameStateStartconsoleCommandsVector*(this: var Builder;
    numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc DesiredGameStateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RenderType* {.pure.} = enum
    DrawLine2D = 1.int8, DrawLine3D = 2.int8, DrawLine2D_3D = 3.int8,
    DrawRect2D = 4.int8, DrawRect3D = 5.int8, DrawString2D = 6.int8,
    DrawString3D = 7.int8, DrawCenteredRect3D = 8.int8


type
  Color* = object of FlatObj


proc a*(this: Color): byte =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `a=`*(this: var Color; n: byte) =
  discard this.tab.MutateSlot(4, n)

proc r*(this: Color): byte =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `r=`*(this: var Color; n: byte) =
  discard this.tab.MutateSlot(6, n)

proc g*(this: Color): byte =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `g=`*(this: var Color; n: byte) =
  discard this.tab.MutateSlot(8, n)

proc b*(this: Color): byte =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `b=`*(this: var Color; n: byte) =
  discard this.tab.MutateSlot(10, n)

proc ColorStart*(this: var Builder) =
  this.StartObject(4)

proc ColorAddA*(this: var Builder; a: uoffset) =
  this.PrependSlot(0, a, default(uoffset))

proc ColorAddR*(this: var Builder; r: uoffset) =
  this.PrependSlot(1, r, default(uoffset))

proc ColorAddG*(this: var Builder; g: uoffset) =
  this.PrependSlot(2, g, default(uoffset))

proc ColorAddB*(this: var Builder; b: uoffset) =
  this.PrependSlot(3, b, default(uoffset))

proc ColorEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RenderMessage* = object of FlatObj


proc renderType*(this: RenderMessage): int8 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `renderType=`*(this: var RenderMessage; n: int8) =
  discard this.tab.MutateSlot(4, n)

proc color*(this: RenderMessage): Color =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc start*(this: RenderMessage): Vector3 =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc endN*(this: RenderMessage): Vector3 =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc scaleX*(this: RenderMessage): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `scaleX=`*(this: var RenderMessage; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc scaleY*(this: RenderMessage): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `scaleY=`*(this: var RenderMessage; n: int32) =
  discard this.tab.MutateSlot(14, n)
proc text*(this: RenderMessage): string =
  var o = this.tab.Offset(16)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc isFilled*(this: RenderMessage): bool =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isFilled=`*(this: var RenderMessage; n: bool) =
  discard this.tab.MutateSlot(18, n)

proc RenderMessageStart*(this: var Builder) =
  this.StartObject(8)

proc RenderMessageAddRenderType*(this: var Builder; renderType: RenderType) =
  this.PrependSlot(0, renderType, default(RenderType))

proc RenderMessageAddColor*(this: var Builder; color: uoffset) =
  this.PrependSlot(1, color, default(uoffset))

proc RenderMessageAddStart*(this: var Builder; start: uoffset) =
  this.PrependSlot(2, start, default(uoffset))

proc RenderMessageAddEndN*(this: var Builder; endN: uoffset) =
  this.PrependSlot(3, endN, default(uoffset))

proc RenderMessageAddScaleX*(this: var Builder; scaleX: uoffset) =
  this.PrependSlot(4, scaleX, default(uoffset))

proc RenderMessageAddScaleY*(this: var Builder; scaleY: uoffset) =
  this.PrependSlot(5, scaleY, default(uoffset))

proc RenderMessageAddText*(this: var Builder; text: uoffset) =
  this.PrependSlot(7, text, default(uoffset))

proc RenderMessageAddIsFilled*(this: var Builder; isFilled: bool) =
  this.PrependSlot(7, isFilled, default(bool))

proc RenderMessageEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RenderGroup* = object of FlatObj


proc renderMessages*(this: RenderGroup; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc renderMessagesLength*(this: RenderGroup): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc id*(this: RenderGroup): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `id=`*(this: var RenderGroup; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc RenderGroupStart*(this: var Builder) =
  this.StartObject(2)

proc RenderGroupAddRenderMessages*(this: var Builder; renderMessages: uoffset) =
  this.PrependSlot(0, renderMessages, default(uoffset))

proc RenderGroupStartrenderMessagesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc RenderGroupAddId*(this: var Builder; id: int32) =
  this.PrependSlot(1, id, default(int32))

proc RenderGroupEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  QuickChatSelection* {.pure.} = enum
    Information_IGotIt = 0.int8, Information_NeedBoost = 1.int8,
    Information_TakeTheShot = 2.int8, Information_Defending = 3.int8,
    Information_GoForIt = 4.int8, Information_Centering = 5.int8,
    Information_AllYours = 6.int8, Information_InPosition = 7.int8,
    Information_Incoming = 8.int8, Compliments_NiceShot = 9.int8,
    Compliments_GreatPass = 10.int8, Compliments_Thanks = 11.int8,
    Compliments_WhatASave = 12.int8, Compliments_NiceOne = 13.int8,
    Compliments_WhatAPlay = 14.int8, Compliments_GreatClear = 15.int8,
    Compliments_NiceBlock = 16.int8, Reactions_OMG = 17.int8,
    Reactions_Noooo = 18.int8, Reactions_Wow = 19.int8,
    Reactions_CloseOne = 20.int8, Reactions_NoWay = 21.int8,
    Reactions_HolyCow = 22.int8, Reactions_Whew = 23.int8,
    Reactions_Siiiick = 24.int8, Reactions_Calculated = 25.int8,
    Reactions_Savage = 26.int8, Reactions_Okay = 27.int8,
    Apologies_Cursing = 28.int8, Apologies_NoProblem = 29.int8,
    Apologies_Whoops = 30.int8, Apologies_Sorry = 31.int8,
    Apologies_MyBad = 32.int8, Apologies_Oops = 33.int8,
    Apologies_MyFault = 34.int8, PostGame_Gg = 35.int8,
    PostGame_WellPlayed = 36.int8, PostGame_ThatWasFun = 37.int8,
    PostGame_Rematch = 38.int8, PostGame_OneMoreGame = 39.int8,
    PostGame_WhatAGame = 40.int8, PostGame_NiceMoves = 41.int8,
    PostGame_EverybodyDance = 42.int8, MaxPysonixQuickChatPresets = 43.int8,
    Custom_Toxic_WasteCPU = 44.int8, Custom_Toxic_GitGut = 45.int8,
    Custom_Toxic_DeAlloc = 46.int8, Custom_Toxic_404NoSkill = 47.int8,
    Custom_Toxic_CatchVirus = 48.int8, Custom_Useful_Passing = 49.int8,
    Custom_Useful_Faking = 50.int8, Custom_Useful_Demoing = 51.int8,
    Custom_Useful_Bumping = 52.int8, Custom_Compliments_TinyChances = 53.int8,
    Custom_Compliments_SkillLevel = 54.int8, Custom_Compliments_proud = 55.int8,
    Custom_Compliments_GC = 56.int8, Custom_Compliments_Pro = 57.int8,
    Custom_Excuses_Lag = 58.int8, Custom_Excuses_GhostInputs = 59.int8,
    Custom_Excuses_Rigged = 60.int8, Custom_Toxic_MafiaPlays = 61.int8,
    Custom_Exclamation_Yeet = 62.int8


type
  QuickChat* = object of FlatObj


proc quickChatSelection*(this: QuickChat): int8 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `quickChatSelection=`*(this: var QuickChat; n: int8) =
  discard this.tab.MutateSlot(4, n)

proc playerIndex*(this: QuickChat): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var QuickChat; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc teamOnly*(this: QuickChat): bool =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `teamOnly=`*(this: var QuickChat; n: bool) =
  discard this.tab.MutateSlot(8, n)

proc messageIndex*(this: QuickChat): int32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `messageIndex=`*(this: var QuickChat; n: int32) =
  discard this.tab.MutateSlot(10, n)

proc timeStamp*(this: QuickChat): float32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `timeStamp=`*(this: var QuickChat; n: float32) =
  discard this.tab.MutateSlot(12, n)

proc QuickChatStart*(this: var Builder) =
  this.StartObject(5)

proc QuickChatAddQuickChatSelection*(this: var Builder;
                                     quickChatSelection: QuickChatSelection) =
  this.PrependSlot(0, quickChatSelection, default(QuickChatSelection))

proc QuickChatAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(1, playerIndex, default(int32))

proc QuickChatAddTeamOnly*(this: var Builder; teamOnly: bool) =
  this.PrependSlot(2, teamOnly, default(bool))

proc QuickChatAddMessageIndex*(this: var Builder; messageIndex: int32) =
  this.PrependSlot(3, messageIndex, default(int32))

proc QuickChatAddTimeStamp*(this: var Builder; timeStamp: float32) =
  this.PrependSlot(4, timeStamp, default(float32))

proc QuickChatEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  TinyPlayer* = object of FlatObj


proc location*(this: TinyPlayer): Vector3 =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc rotation*(this: TinyPlayer): Rotator =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc velocity*(this: TinyPlayer): Vector3 =
  var o = this.tab.Offset(8)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc hasWheelContact*(this: TinyPlayer): bool =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `hasWheelContact=`*(this: var TinyPlayer; n: bool) =
  discard this.tab.MutateSlot(10, n)

proc isSupersonic*(this: TinyPlayer): bool =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `isSupersonic=`*(this: var TinyPlayer; n: bool) =
  discard this.tab.MutateSlot(12, n)

proc team*(this: TinyPlayer): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `team=`*(this: var TinyPlayer; n: int32) =
  discard this.tab.MutateSlot(14, n)

proc boost*(this: TinyPlayer): int32 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boost=`*(this: var TinyPlayer; n: int32) =
  discard this.tab.MutateSlot(16, n)

proc TinyPlayerStart*(this: var Builder) =
  this.StartObject(7)

proc TinyPlayerAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(0, location, default(uoffset))

proc TinyPlayerAddRotation*(this: var Builder; rotation: uoffset) =
  this.PrependSlot(1, rotation, default(uoffset))

proc TinyPlayerAddVelocity*(this: var Builder; velocity: uoffset) =
  this.PrependSlot(2, velocity, default(uoffset))

proc TinyPlayerAddHasWheelContact*(this: var Builder; hasWheelContact: bool) =
  this.PrependSlot(3, hasWheelContact, default(bool))

proc TinyPlayerAddIsSupersonic*(this: var Builder; isSupersonic: bool) =
  this.PrependSlot(4, isSupersonic, default(bool))

proc TinyPlayerAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(5, team, default(int32))

proc TinyPlayerAddBoost*(this: var Builder; boost: int32) =
  this.PrependSlot(6, boost, default(int32))

proc TinyPlayerEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  TinyBall* = object of FlatObj


proc location*(this: TinyBall): Vector3 =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc velocity*(this: TinyBall): Vector3 =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = o + this.tab.Pos
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc TinyBallStart*(this: var Builder) =
  this.StartObject(2)

proc TinyBallAddLocation*(this: var Builder; location: uoffset) =
  this.PrependSlot(0, location, default(uoffset))

proc TinyBallAddVelocity*(this: var Builder; velocity: uoffset) =
  this.PrependSlot(1, velocity, default(uoffset))

proc TinyBallEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  TinyPacket* = object of FlatObj


proc players*(this: TinyPacket; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc playersLength*(this: TinyPacket): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc ball*(this: TinyPacket): TinyBall =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc TinyPacketStart*(this: var Builder) =
  this.StartObject(2)

proc TinyPacketAddPlayers*(this: var Builder; players: uoffset) =
  this.PrependSlot(0, players, default(uoffset))

proc TinyPacketStartplayersVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc TinyPacketAddBall*(this: var Builder; ball: uoffset) =
  this.PrependSlot(1, ball, default(uoffset))

proc TinyPacketEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PredictionSlice* = object of FlatObj


proc gameSeconds*(this: PredictionSlice): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameSeconds=`*(this: var PredictionSlice; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc physics*(this: PredictionSlice): Physics =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PredictionSliceStart*(this: var Builder) =
  this.StartObject(2)

proc PredictionSliceAddGameSeconds*(this: var Builder; gameSeconds: float32) =
  this.PrependSlot(0, gameSeconds, default(float32))

proc PredictionSliceAddPhysics*(this: var Builder; physics: uoffset) =
  this.PrependSlot(1, physics, default(uoffset))

proc PredictionSliceEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  BallPrediction* = object of FlatObj


proc slices*(this: BallPrediction; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc slicesLength*(this: BallPrediction): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc BallPredictionStart*(this: var Builder) =
  this.StartObject(1)

proc BallPredictionAddSlices*(this: var Builder; slices: uoffset) =
  this.PrependSlot(0, slices, default(uoffset))

proc BallPredictionStartslicesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc BallPredictionEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  RLBotPlayer* = object of FlatObj


proc RLBotPlayerStart*(this: var Builder) =
  this.StartObject(0)

proc RLBotPlayerEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  HumanPlayer* = object of FlatObj


proc HumanPlayerStart*(this: var Builder) =
  this.StartObject(0)

proc HumanPlayerEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PsyonixBotPlayer* = object of FlatObj


proc botSkill*(this: PsyonixBotPlayer): float32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `botSkill=`*(this: var PsyonixBotPlayer; n: float32) =
  discard this.tab.MutateSlot(4, n)

proc PsyonixBotPlayerStart*(this: var Builder) =
  this.StartObject(1)

proc PsyonixBotPlayerAddBotSkill*(this: var Builder; botSkill: float32) =
  this.PrependSlot(0, botSkill, default(float32))

proc PsyonixBotPlayerEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PartyMemberBotPlayer* = object of FlatObj


proc PartyMemberBotPlayerStart*(this: var Builder) =
  this.StartObject(0)

proc PartyMemberBotPlayerEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerClassType* {.pure.} = enum
    RLBotPlayer = 0'u8, HumanPlayer = 1'u8, PsyonixBotPlayer = 2'u8,
    PartyMemberBotPlayer = 3'u8

type
  PlayerClass* = object of FlatObj

type
  LoadoutPaint* = object of FlatObj


proc carPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `carPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc decalPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `decalPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc wheelsPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `wheelsPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(8, n)

proc boostPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boostPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(10, n)

proc antennaPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `antennaPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc hatPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `hatPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(14, n)

proc trailsPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `trailsPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(16, n)

proc goalExplosionPaintId*(this: LoadoutPaint): int32 =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `goalExplosionPaintId=`*(this: var LoadoutPaint; n: int32) =
  discard this.tab.MutateSlot(18, n)

proc LoadoutPaintStart*(this: var Builder) =
  this.StartObject(8)

proc LoadoutPaintAddCarPaintId*(this: var Builder; carPaintId: int32) =
  this.PrependSlot(0, carPaintId, default(int32))

proc LoadoutPaintAddDecalPaintId*(this: var Builder; decalPaintId: int32) =
  this.PrependSlot(1, decalPaintId, default(int32))

proc LoadoutPaintAddWheelsPaintId*(this: var Builder; wheelsPaintId: int32) =
  this.PrependSlot(2, wheelsPaintId, default(int32))

proc LoadoutPaintAddBoostPaintId*(this: var Builder; boostPaintId: int32) =
  this.PrependSlot(3, boostPaintId, default(int32))

proc LoadoutPaintAddAntennaPaintId*(this: var Builder; antennaPaintId: int32) =
  this.PrependSlot(4, antennaPaintId, default(int32))

proc LoadoutPaintAddHatPaintId*(this: var Builder; hatPaintId: int32) =
  this.PrependSlot(5, hatPaintId, default(int32))

proc LoadoutPaintAddTrailsPaintId*(this: var Builder; trailsPaintId: int32) =
  this.PrependSlot(6, trailsPaintId, default(int32))

proc LoadoutPaintAddGoalExplosionPaintId*(this: var Builder;
    goalExplosionPaintId: int32) =
  this.PrependSlot(7, goalExplosionPaintId, default(int32))

proc LoadoutPaintEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerLoadout* = object of FlatObj


proc teamColorId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `teamColorId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc customColorId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `customColorId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(6, n)

proc carId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `carId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(8, n)

proc decalId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `decalId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(10, n)

proc wheelsId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `wheelsId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc boostId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boostId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(14, n)

proc antennaId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `antennaId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(16, n)

proc hatId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `hatId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(18, n)

proc paintFinishId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(20)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `paintFinishId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(20, n)

proc customFinishId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(22)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `customFinishId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(22, n)

proc engineAudioId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(24)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `engineAudioId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(24, n)

proc trailsId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(26)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `trailsId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(26, n)

proc goalExplosionId*(this: PlayerLoadout): int32 =
  var o = this.tab.Offset(28)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `goalExplosionId=`*(this: var PlayerLoadout; n: int32) =
  discard this.tab.MutateSlot(28, n)

proc loadoutPaint*(this: PlayerLoadout): LoadoutPaint =
  var o = this.tab.Offset(30)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc primaryColorLookup*(this: PlayerLoadout): Color =
  var o = this.tab.Offset(32)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc secondaryColorLookup*(this: PlayerLoadout): Color =
  var o = this.tab.Offset(34)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PlayerLoadoutStart*(this: var Builder) =
  this.StartObject(16)

proc PlayerLoadoutAddTeamColorId*(this: var Builder; teamColorId: int32) =
  this.PrependSlot(0, teamColorId, default(int32))

proc PlayerLoadoutAddCustomColorId*(this: var Builder; customColorId: int32) =
  this.PrependSlot(1, customColorId, default(int32))

proc PlayerLoadoutAddCarId*(this: var Builder; carId: int32) =
  this.PrependSlot(2, carId, default(int32))

proc PlayerLoadoutAddDecalId*(this: var Builder; decalId: int32) =
  this.PrependSlot(3, decalId, default(int32))

proc PlayerLoadoutAddWheelsId*(this: var Builder; wheelsId: int32) =
  this.PrependSlot(4, wheelsId, default(int32))

proc PlayerLoadoutAddBoostId*(this: var Builder; boostId: int32) =
  this.PrependSlot(5, boostId, default(int32))

proc PlayerLoadoutAddAntennaId*(this: var Builder; antennaId: int32) =
  this.PrependSlot(6, antennaId, default(int32))

proc PlayerLoadoutAddHatId*(this: var Builder; hatId: int32) =
  this.PrependSlot(7, hatId, default(int32))

proc PlayerLoadoutAddPaintFinishId*(this: var Builder; paintFinishId: int32) =
  this.PrependSlot(8, paintFinishId, default(int32))

proc PlayerLoadoutAddCustomFinishId*(this: var Builder; customFinishId: int32) =
  this.PrependSlot(9, customFinishId, default(int32))

proc PlayerLoadoutAddEngineAudioId*(this: var Builder; engineAudioId: int32) =
  this.PrependSlot(10, engineAudioId, default(int32))

proc PlayerLoadoutAddTrailsId*(this: var Builder; trailsId: int32) =
  this.PrependSlot(11, trailsId, default(int32))

proc PlayerLoadoutAddGoalExplosionId*(this: var Builder; goalExplosionId: int32) =
  this.PrependSlot(12, goalExplosionId, default(int32))

proc PlayerLoadoutAddLoadoutPaint*(this: var Builder; loadoutPaint: uoffset) =
  this.PrependSlot(13, loadoutPaint, default(uoffset))

proc PlayerLoadoutAddPrimaryColorLookup*(this: var Builder;
    primaryColorLookup: uoffset) =
  this.PrependSlot(14, primaryColorLookup, default(uoffset))

proc PlayerLoadoutAddSecondaryColorLookup*(this: var Builder;
    secondaryColorLookup: uoffset) =
  this.PrependSlot(15, secondaryColorLookup, default(uoffset))

proc PlayerLoadoutEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerConfiguration* = object of FlatObj


proc varietyType*(this: PlayerConfiguration): PlayerClassType =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[PlayerClassType](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `varietyType=`*(this: var PlayerConfiguration; n: PlayerClassType) =
  discard this.tab.MutateSlot(4, n)

proc variety*(this: PlayerConfiguration): FlatObj =
  var o = this.tab.Offset(4)
  if o != 0:
    this.tab.Union(result.tab, o)
  else:
    discard
proc name*(this: PlayerConfiguration): string =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc team*(this: PlayerConfiguration): int32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `team=`*(this: var PlayerConfiguration; n: int32) =
  discard this.tab.MutateSlot(8, n)

proc loadout*(this: PlayerConfiguration): PlayerLoadout =
  var o = this.tab.Offset(10)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc spawnId*(this: PlayerConfiguration): int32 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `spawnId=`*(this: var PlayerConfiguration; n: int32) =
  discard this.tab.MutateSlot(12, n)

proc PlayerConfigurationStart*(this: var Builder) =
  this.StartObject(5)

proc PlayerConfigurationAddVarietyType*(this: var Builder;
                                        variety: PlayerClassType) =
  this.PrependSlot(0, variety, default(PlayerClassType))

proc PlayerConfigurationAddVariety*(this: var Builder; variety: uoffset) =
  this.PrependSlot(1, variety, default(uoffset))

proc PlayerConfigurationAddName*(this: var Builder; name: uoffset) =
  this.PrependSlot(2, name, default(uoffset))

proc PlayerConfigurationAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(2, team, default(int32))

proc PlayerConfigurationAddLoadout*(this: var Builder; loadout: uoffset) =
  this.PrependSlot(3, loadout, default(uoffset))

proc PlayerConfigurationAddSpawnId*(this: var Builder; spawnId: int32) =
  this.PrependSlot(4, spawnId, default(int32))

proc PlayerConfigurationEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  GameMode* {.pure.} = enum
    Soccer = 0.int8, Hoops = 1.int8, Dropshot = 2.int8, Hockey = 3.int8,
    Rumble = 4.int8, Heatseeker = 5.int8


type
  GameMap* {.pure.} = enum
    DFHStadium = 0.int8, Mannfield = 1.int8, ChampionsField = 2.int8,
    UrbanCentral = 3.int8, BeckwithPark = 4.int8, UtopiaColiseum = 5.int8,
    Wasteland = 6.int8, NeoTokyo = 7.int8, AquaDome = 8.int8,
    StarbaseArc = 9.int8, Farmstead = 10.int8, SaltyShores = 11.int8,
    DFHStadium_Stormy = 12.int8, DFHStadium_Day = 13.int8,
    Mannfield_Stormy = 14.int8, Mannfield_Night = 15.int8,
    ChampionsField_Day = 16.int8, BeckwithPark_Stormy = 17.int8,
    BeckwithPark_Midnight = 18.int8, UrbanCentral_Night = 19.int8,
    UrbanCentral_Dawn = 20.int8, UtopiaColiseum_Dusk = 21.int8,
    DFHStadium_Snowy = 22.int8, Mannfield_Snowy = 23.int8,
    UtopiaColiseum_Snowy = 24.int8, Badlands = 25.int8,
    Badlands_Night = 26.int8, TokyoUnderpass = 27.int8, Arctagon = 28.int8,
    Pillars = 29.int8, Cosmic = 30.int8, DoubleGoal = 31.int8,
    Octagon = 32.int8, Underpass = 33.int8, UtopiaRetro = 34.int8,
    Hoops_DunkHouse = 35.int8, DropShot_Core707 = 36.int8,
    ThrowbackStadium = 37.int8, ForbiddenTemple = 38.int8,
    RivalsArena = 39.int8, Farmstead_Night = 40.int8,
    SaltyShores_Night = 41.int8


type
  MatchLength* {.pure.} = enum
    Five_Minutes = 0.int8, Ten_Minutes = 1.int8, Twenty_Minutes = 2.int8,
    Unlimited = 3.int8


type
  MaxScore* {.pure.} = enum
    Unlimited = 0.int8, One_Goal = 1.int8, Three_Goals = 2.int8,
    Five_Goals = 3.int8


type
  OvertimeOption* {.pure.} = enum
    Unlimited = 0.int8, Five_Max_First_Score = 1.int8,
    Five_Max_Random_Team = 2.int8


type
  SeriesLengthOption* {.pure.} = enum
    Unlimited = 0.int8, Three_Games = 1.int8, Five_Games = 2.int8,
    Seven_Games = 3.int8


type
  GameSpeedOption* {.pure.} = enum
    Default = 0.int8, Slo_Mo = 1.int8, Time_Warp = 2.int8


type
  BallMaxSpeedOption* {.pure.} = enum
    Default = 0.int8, Slow = 1.int8, Fast = 2.int8, Super_Fast = 3.int8


type
  BallTypeOption* {.pure.} = enum
    Default = 0.int8, Cube = 1.int8, Puck = 2.int8, Basketball = 3.int8


type
  BallWeightOption* {.pure.} = enum
    Default = 0.int8, Light = 1.int8, Heavy = 2.int8, Super_Light = 3.int8


type
  BallSizeOption* {.pure.} = enum
    Default = 0.int8, Small = 1.int8, Large = 2.int8, Gigantic = 3.int8


type
  BallBouncinessOption* {.pure.} = enum
    Default = 0.int8, Low = 1.int8, High = 2.int8, Super_High = 3.int8


type
  BoostOption* {.pure.} = enum
    Normal_Boost = 0.int8, Unlimited_Boost = 1.int8, Slow_Recharge = 2.int8,
    Rapid_Recharge = 3.int8, No_Boost = 4.int8


type
  RumbleOption* {.pure.} = enum
    No_Rumble = 0.int8, Default = 1.int8, Slow = 2.int8, Civilized = 3.int8,
    Destruction_Derby = 4.int8, Spring_Loaded = 5.int8, Spikes_Only = 6.int8,
    Spike_Rush = 7.int8


type
  BoostStrengthOption* {.pure.} = enum
    One = 0.int8, OneAndAHalf = 1.int8, Two = 2.int8, Ten = 3.int8


type
  GravityOption* {.pure.} = enum
    Default = 0.int8, Low = 1.int8, High = 2.int8, Super_High = 3.int8


type
  DemolishOption* {.pure.} = enum
    Default = 0.int8, Disabled = 1.int8, Friendly_Fire = 2.int8,
    On_Contact = 3.int8, On_Contact_FF = 4.int8


type
  RespawnTimeOption* {.pure.} = enum
    Three_Seconds = 0.int8, Two_Seconds = 1.int8, One_Seconds = 2.int8,
    Disable_Goal_Reset = 3.int8


type
  MutatorSettings* = object of FlatObj


proc matchLength*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `matchLength=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(4, n)

proc maxScore*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `maxScore=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(6, n)

proc overtimeOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `overtimeOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(8, n)

proc seriesLengthOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `seriesLengthOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(10, n)

proc gameSpeedOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameSpeedOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(12, n)

proc ballMaxSpeedOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(14)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ballMaxSpeedOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(14, n)

proc ballTypeOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ballTypeOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(16, n)

proc ballWeightOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ballWeightOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(18, n)

proc ballSizeOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(20)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ballSizeOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(20, n)

proc ballBouncinessOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(22)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `ballBouncinessOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(22, n)

proc boostOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(24)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boostOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(24, n)

proc rumbleOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(26)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `rumbleOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(26, n)

proc boostStrengthOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(28)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `boostStrengthOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(28, n)

proc gravityOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(30)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gravityOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(30, n)

proc demolishOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(32)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `demolishOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(32, n)

proc respawnTimeOption*(this: MutatorSettings): int8 =
  var o = this.tab.Offset(34)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `respawnTimeOption=`*(this: var MutatorSettings; n: int8) =
  discard this.tab.MutateSlot(34, n)

proc MutatorSettingsStart*(this: var Builder) =
  this.StartObject(16)

proc MutatorSettingsAddMatchLength*(this: var Builder; matchLength: MatchLength) =
  this.PrependSlot(0, matchLength, default(MatchLength))

proc MutatorSettingsAddMaxScore*(this: var Builder; maxScore: MaxScore) =
  this.PrependSlot(1, maxScore, default(MaxScore))

proc MutatorSettingsAddOvertimeOption*(this: var Builder;
                                       overtimeOption: OvertimeOption) =
  this.PrependSlot(2, overtimeOption, default(OvertimeOption))

proc MutatorSettingsAddSeriesLengthOption*(this: var Builder;
    seriesLengthOption: SeriesLengthOption) =
  this.PrependSlot(3, seriesLengthOption, default(SeriesLengthOption))

proc MutatorSettingsAddGameSpeedOption*(this: var Builder;
                                        gameSpeedOption: GameSpeedOption) =
  this.PrependSlot(4, gameSpeedOption, default(GameSpeedOption))

proc MutatorSettingsAddBallMaxSpeedOption*(this: var Builder;
    ballMaxSpeedOption: BallMaxSpeedOption) =
  this.PrependSlot(5, ballMaxSpeedOption, default(BallMaxSpeedOption))

proc MutatorSettingsAddBallTypeOption*(this: var Builder;
                                       ballTypeOption: BallTypeOption) =
  this.PrependSlot(6, ballTypeOption, default(BallTypeOption))

proc MutatorSettingsAddBallWeightOption*(this: var Builder;
    ballWeightOption: BallWeightOption) =
  this.PrependSlot(7, ballWeightOption, default(BallWeightOption))

proc MutatorSettingsAddBallSizeOption*(this: var Builder;
                                       ballSizeOption: BallSizeOption) =
  this.PrependSlot(8, ballSizeOption, default(BallSizeOption))

proc MutatorSettingsAddBallBouncinessOption*(this: var Builder;
    ballBouncinessOption: BallBouncinessOption) =
  this.PrependSlot(9, ballBouncinessOption, default(BallBouncinessOption))

proc MutatorSettingsAddBoostOption*(this: var Builder; boostOption: BoostOption) =
  this.PrependSlot(10, boostOption, default(BoostOption))

proc MutatorSettingsAddRumbleOption*(this: var Builder;
                                     rumbleOption: RumbleOption) =
  this.PrependSlot(11, rumbleOption, default(RumbleOption))

proc MutatorSettingsAddBoostStrengthOption*(this: var Builder;
    boostStrengthOption: BoostStrengthOption) =
  this.PrependSlot(12, boostStrengthOption, default(BoostStrengthOption))

proc MutatorSettingsAddGravityOption*(this: var Builder;
                                      gravityOption: GravityOption) =
  this.PrependSlot(13, gravityOption, default(GravityOption))

proc MutatorSettingsAddDemolishOption*(this: var Builder;
                                       demolishOption: DemolishOption) =
  this.PrependSlot(14, demolishOption, default(DemolishOption))

proc MutatorSettingsAddRespawnTimeOption*(this: var Builder;
    respawnTimeOption: RespawnTimeOption) =
  this.PrependSlot(15, respawnTimeOption, default(RespawnTimeOption))

proc MutatorSettingsEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  ExistingMatchBehavior* {.pure.} = enum
    Restart_If_Different = 0.int8, Restart = 1.int8, Continue_And_Spawn = 2.int8


type
  MatchSettings* = object of FlatObj


proc playerConfigurations*(this: MatchSettings; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc playerConfigurationsLength*(this: MatchSettings): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc gameMode*(this: MatchSettings): int8 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameMode=`*(this: var MatchSettings; n: int8) =
  discard this.tab.MutateSlot(6, n)

proc gameMap*(this: MatchSettings): int8 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameMap=`*(this: var MatchSettings; n: int8) =
  discard this.tab.MutateSlot(8, n)

proc skipReplays*(this: MatchSettings): bool =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `skipReplays=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(10, n)

proc instantStart*(this: MatchSettings): bool =
  var o = this.tab.Offset(12)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `instantStart=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(12, n)

proc mutatorSettings*(this: MatchSettings): MutatorSettings =
  var o = this.tab.Offset(14)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc existingMatchBehavior*(this: MatchSettings): int8 =
  var o = this.tab.Offset(16)
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `existingMatchBehavior=`*(this: var MatchSettings; n: int8) =
  discard this.tab.MutateSlot(16, n)

proc enableLockstep*(this: MatchSettings): bool =
  var o = this.tab.Offset(18)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `enableLockstep=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(18, n)

proc enableRendering*(this: MatchSettings): bool =
  var o = this.tab.Offset(20)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `enableRendering=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(20, n)

proc enableStateSetting*(this: MatchSettings): bool =
  var o = this.tab.Offset(22)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `enableStateSetting=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(22, n)

proc autoSaveReplay*(this: MatchSettings): bool =
  var o = this.tab.Offset(24)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `autoSaveReplay=`*(this: var MatchSettings; n: bool) =
  discard this.tab.MutateSlot(24, n)

proc MatchSettingsStart*(this: var Builder) =
  this.StartObject(11)

proc MatchSettingsAddPlayerConfigurations*(this: var Builder;
    playerConfigurations: uoffset) =
  this.PrependSlot(0, playerConfigurations, default(uoffset))

proc MatchSettingsStartplayerConfigurationsVector*(this: var Builder;
    numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc MatchSettingsAddGameMode*(this: var Builder; gameMode: GameMode) =
  this.PrependSlot(1, gameMode, default(GameMode))

proc MatchSettingsAddGameMap*(this: var Builder; gameMap: GameMap) =
  this.PrependSlot(2, gameMap, default(GameMap))

proc MatchSettingsAddSkipReplays*(this: var Builder; skipReplays: bool) =
  this.PrependSlot(3, skipReplays, default(bool))

proc MatchSettingsAddInstantStart*(this: var Builder; instantStart: bool) =
  this.PrependSlot(4, instantStart, default(bool))

proc MatchSettingsAddMutatorSettings*(this: var Builder;
                                      mutatorSettings: uoffset) =
  this.PrependSlot(5, mutatorSettings, default(uoffset))

proc MatchSettingsAddExistingMatchBehavior*(this: var Builder;
    existingMatchBehavior: ExistingMatchBehavior) =
  this.PrependSlot(6, existingMatchBehavior, default(ExistingMatchBehavior))

proc MatchSettingsAddEnableLockstep*(this: var Builder; enableLockstep: bool) =
  this.PrependSlot(7, enableLockstep, default(bool))

proc MatchSettingsAddEnableRendering*(this: var Builder; enableRendering: bool) =
  this.PrependSlot(8, enableRendering, default(bool))

proc MatchSettingsAddEnableStateSetting*(this: var Builder;
    enableStateSetting: bool) =
  this.PrependSlot(9, enableStateSetting, default(bool))

proc MatchSettingsAddAutoSaveReplay*(this: var Builder; autoSaveReplay: bool) =
  this.PrependSlot(10, autoSaveReplay, default(bool))

proc MatchSettingsEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  QuickChatMessages* = object of FlatObj


proc messages*(this: QuickChatMessages; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc messagesLength*(this: QuickChatMessages): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc QuickChatMessagesStart*(this: var Builder) =
  this.StartObject(1)

proc QuickChatMessagesAddMessages*(this: var Builder; messages: uoffset) =
  this.PrependSlot(0, messages, default(uoffset))

proc QuickChatMessagesStartmessagesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc QuickChatMessagesEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  ReadyMessage* = object of FlatObj


proc wantsBallPredictions*(this: ReadyMessage): bool =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `wantsBallPredictions=`*(this: var ReadyMessage; n: bool) =
  discard this.tab.MutateSlot(4, n)

proc wantsQuickChat*(this: ReadyMessage): bool =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `wantsQuickChat=`*(this: var ReadyMessage; n: bool) =
  discard this.tab.MutateSlot(6, n)

proc wantsGameMessages*(this: ReadyMessage): bool =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `wantsGameMessages=`*(this: var ReadyMessage; n: bool) =
  discard this.tab.MutateSlot(8, n)

proc ReadyMessageStart*(this: var Builder) =
  this.StartObject(3)

proc ReadyMessageAddWantsBallPredictions*(this: var Builder;
    wantsBallPredictions: bool) =
  this.PrependSlot(0, wantsBallPredictions, default(bool))

proc ReadyMessageAddWantsQuickChat*(this: var Builder; wantsQuickChat: bool) =
  this.PrependSlot(1, wantsQuickChat, default(bool))

proc ReadyMessageAddWantsGameMessages*(this: var Builder;
                                       wantsGameMessages: bool) =
  this.PrependSlot(2, wantsGameMessages, default(bool))

proc ReadyMessageEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerStatEvent* = object of FlatObj


proc playerIndex*(this: PlayerStatEvent): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var PlayerStatEvent; n: int32) =
  discard this.tab.MutateSlot(4, n)
proc statType*(this: PlayerStatEvent): string =
  var o = this.tab.Offset(6)
  if o != 0:
    result = this.tab.toString(o)
  else:
    discard

proc PlayerStatEventStart*(this: var Builder) =
  this.StartObject(2)

proc PlayerStatEventAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(0, playerIndex, default(int32))

proc PlayerStatEventAddStatType*(this: var Builder; statType: uoffset) =
  this.PrependSlot(2, statType, default(uoffset))

proc PlayerStatEventEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerSpectate* = object of FlatObj


proc playerIndex*(this: PlayerSpectate): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var PlayerSpectate; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc PlayerSpectateStart*(this: var Builder) =
  this.StartObject(1)

proc PlayerSpectateAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(0, playerIndex, default(int32))

proc PlayerSpectateEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  PlayerInputChange* = object of FlatObj


proc playerIndex*(this: PlayerInputChange): int32 =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `playerIndex=`*(this: var PlayerInputChange; n: int32) =
  discard this.tab.MutateSlot(4, n)

proc controllerState*(this: PlayerInputChange): ControllerState =
  var o = this.tab.Offset(6)
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc dodgeForward*(this: PlayerInputChange): float32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `dodgeForward=`*(this: var PlayerInputChange; n: float32) =
  discard this.tab.MutateSlot(8, n)

proc dodgeRight*(this: PlayerInputChange): float32 =
  var o = this.tab.Offset(10)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `dodgeRight=`*(this: var PlayerInputChange; n: float32) =
  discard this.tab.MutateSlot(10, n)

proc PlayerInputChangeStart*(this: var Builder) =
  this.StartObject(4)

proc PlayerInputChangeAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(0, playerIndex, default(int32))

proc PlayerInputChangeAddControllerState*(this: var Builder;
    controllerState: uoffset) =
  this.PrependSlot(1, controllerState, default(uoffset))

proc PlayerInputChangeAddDodgeForward*(this: var Builder; dodgeForward: float32) =
  this.PrependSlot(2, dodgeForward, default(float32))

proc PlayerInputChangeAddDodgeRight*(this: var Builder; dodgeRight: float32) =
  this.PrependSlot(3, dodgeRight, default(float32))

proc PlayerInputChangeEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  GameMessageType* {.pure.} = enum
    PlayerStatEvent = 0'u8, PlayerSpectate = 1'u8, PlayerInputChange = 2'u8

type
  GameMessage* = object of FlatObj

type
  GameMessageWrapper* = object of FlatObj


proc MessageType*(this: GameMessageWrapper): GameMessageType =
  var o = this.tab.Offset(4)
  if o != 0:
    result = Get[GameMessageType](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `MessageType=`*(this: var GameMessageWrapper; n: GameMessageType) =
  discard this.tab.MutateSlot(4, n)

proc Message*(this: GameMessageWrapper): FlatObj =
  var o = this.tab.Offset(4)
  if o != 0:
    this.tab.Union(result.tab, o)
  else:
    discard

proc GameMessageWrapperStart*(this: var Builder) =
  this.StartObject(1)

proc GameMessageWrapperAddMessageType*(this: var Builder;
                                       Message: GameMessageType) =
  this.PrependSlot(0, Message, default(GameMessageType))

proc GameMessageWrapperAddMessage*(this: var Builder; Message: uoffset) =
  this.PrependSlot(1, Message, default(uoffset))

proc GameMessageWrapperEnd*(this: var Builder): uoffset =
  result = this.EndObject()


type
  MessagePacket* = object of FlatObj


proc messages*(this: MessagePacket; j: int): uoffset =
  var o = this.tab.Offset(4)
  if o != 0:
    var x = this.tab.Vector(o)
    x += j.uoffset * 4.uoffset
    result = Get[uoffset](this.tab, o + this.tab.Pos)
  else:
    discard

proc messagesLength*(this: MessagePacket): int =
  var o = this.tab.Offset(4)
  if o != 0:
    result = this.tab.Vectorlen(o)

proc gameSeconds*(this: MessagePacket): float32 =
  var o = this.tab.Offset(6)
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `gameSeconds=`*(this: var MessagePacket; n: float32) =
  discard this.tab.MutateSlot(6, n)

proc frameNum*(this: MessagePacket): int32 =
  var o = this.tab.Offset(8)
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc `frameNum=`*(this: var MessagePacket; n: int32) =
  discard this.tab.MutateSlot(8, n)

proc MessagePacketStart*(this: var Builder) =
  this.StartObject(3)

proc MessagePacketAddMessages*(this: var Builder; messages: uoffset) =
  this.PrependSlot(0, messages, default(uoffset))

proc MessagePacketStartmessagesVector*(this: var Builder; numElems: int): uoffset =
  this.StartVector(4, numElems, 4)

proc MessagePacketAddGameSeconds*(this: var Builder; gameSeconds: float32) =
  this.PrependSlot(1, gameSeconds, default(float32))

proc MessagePacketAddFrameNum*(this: var Builder; frameNum: int32) =
  this.PrependSlot(2, frameNum, default(int32))

proc MessagePacketEnd*(this: var Builder): uoffset =
  result = this.EndObject()
