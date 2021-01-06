import nimflatbuffers/nimflatbuffers


type ControllerState* = object of FlatObj


proc throttle*(this: var ControllerState): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateThrottle*(this: var ControllerState; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc steer*(this: var ControllerState): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSteer*(this: var ControllerState; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc pitch*(this: var ControllerState): float32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePitch*(this: var ControllerState; n: float32): bool =
  result = this.tab.MutateSlot(8, n)

proc yaw*(this: var ControllerState): float32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateYaw*(this: var ControllerState; n: float32): bool =
  result = this.tab.MutateSlot(10, n)

proc roll*(this: var ControllerState): float32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateRoll*(this: var ControllerState; n: float32): bool =
  result = this.tab.MutateSlot(12, n)

proc jump*(this: var ControllerState): bool =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateJump*(this: var ControllerState; n: bool): bool =
  result = this.tab.MutateSlot(14, n)

proc boost*(this: var ControllerState): bool =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoost*(this: var ControllerState; n: bool): bool =
  result = this.tab.MutateSlot(16, n)

proc handbrake*(this: var ControllerState): bool =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHandbrake*(this: var ControllerState; n: bool): bool =
  result = this.tab.MutateSlot(18, n)

proc useItem*(this: var ControllerState): bool =
  var o = this.tab.Offset(20).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateUseItem*(this: var ControllerState; n: bool): bool =
  result = this.tab.MutateSlot(20, n)

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


type PlayerInput* = object of FlatObj


proc playerIndex*(this: var PlayerInput): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePlayerIndex*(this: var PlayerInput; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc `=controllerState`*(result: var ControllerState; this: var PlayerInput) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PlayerInputStart*(this: var Builder) =
  this.StartObject(2)

proc PlayerInputAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(0, playerIndex, default(int32))

proc PlayerInputAddControllerState*(this: var Builder;
                                    controllerState: ControllerState) =
  this.PrependSlot(1, controllerState, default(ControllerState))


type Vector3* = object of FlatObj


proc x*(this: var Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 0)
proc mutateX*(this: var Vector3; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 0, n)

proc y*(this: var Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc mutateY*(this: var Vector3; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 4, n)

proc z*(this: var Vector3): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc mutateZ*(this: var Vector3; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 8, n)


type Rotator* = object of FlatObj


proc pitch*(this: var Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 0)
proc mutatePitch*(this: var Rotator; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 0, n)

proc yaw*(this: var Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc mutateYaw*(this: var Rotator; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 4, n)

proc roll*(this: var Rotator): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc mutateRoll*(this: var Rotator; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 8, n)


type Quaternion* = object of FlatObj


proc x*(this: var Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 0)
proc mutateX*(this: var Quaternion; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 0, n)

proc y*(this: var Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 4)
proc mutateY*(this: var Quaternion; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 4, n)

proc z*(this: var Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 8)
proc mutateZ*(this: var Quaternion; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 8, n)

proc w*(this: var Quaternion): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 12)
proc mutateW*(this: var Quaternion; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 12, n)


type BoxShape* = object of FlatObj


proc length*(this: var BoxShape): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateLength*(this: var BoxShape; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc width*(this: var BoxShape): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateWidth*(this: var BoxShape; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc height*(this: var BoxShape): float32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHeight*(this: var BoxShape; n: float32): bool =
  result = this.tab.MutateSlot(8, n)

proc BoxShapeStart*(this: var Builder) =
  this.StartObject(3)

proc BoxShapeAddLength*(this: var Builder; length: float32) =
  this.PrependSlot(0, length, default(float32))

proc BoxShapeAddWidth*(this: var Builder; width: float32) =
  this.PrependSlot(1, width, default(float32))

proc BoxShapeAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(2, height, default(float32))


type SphereShape* = object of FlatObj


proc diameter*(this: var SphereShape): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDiameter*(this: var SphereShape; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc SphereShapeStart*(this: var Builder) =
  this.StartObject(1)

proc SphereShapeAddDiameter*(this: var Builder; diameter: float32) =
  this.PrependSlot(0, diameter, default(float32))


type CylinderShape* = object of FlatObj


proc diameter*(this: var CylinderShape): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDiameter*(this: var CylinderShape; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc height*(this: var CylinderShape): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHeight*(this: var CylinderShape; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc CylinderShapeStart*(this: var Builder) =
  this.StartObject(2)

proc CylinderShapeAddDiameter*(this: var Builder; diameter: float32) =
  this.PrependSlot(0, diameter, default(float32))

proc CylinderShapeAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(1, height, default(float32))


type CollisionShape* {.pure.} = enum
    SphereShape = 0'u8, CylinderShape = 1'u8


type Touch* = object of FlatObj


proc playerName*(this: var Touch): string =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[string](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePlayerName*(this: var Touch; n: string): bool =
  result = this.tab.MutateSlot(4, n)

proc gameSeconds*(this: var Touch): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameSeconds*(this: var Touch; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc `=location`*(result: var Vector3; this: var Touch) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=normal`*(result: var Vector3; this: var Touch) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc team*(this: var Touch): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeam*(this: var Touch; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc playerIndex*(this: var Touch): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePlayerIndex*(this: var Touch; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc TouchStart*(this: var Builder) =
  this.StartObject(6)

proc TouchAddPlayerName*(this: var Builder; playerName: string) =
  this.PrependSlot(0, playerName, default(string))

proc TouchAddGameSeconds*(this: var Builder; gameSeconds: float32) =
  this.PrependSlot(1, gameSeconds, default(float32))

proc TouchAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(2, location, default(Vector3))

proc TouchAddNormal*(this: var Builder; normal: Vector3) =
  this.PrependSlot(3, normal, default(Vector3))

proc TouchAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(4, team, default(int32))

proc TouchAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(5, playerIndex, default(int32))


type ScoreInfo* = object of FlatObj


proc score*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateScore*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc goals*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGoals*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc ownGoals*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateOwnGoals*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(8, n)

proc assists*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateAssists*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(10, n)

proc saves*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSaves*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc shots*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateShots*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc demolitions*(this: var ScoreInfo): int32 =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDemolitions*(this: var ScoreInfo; n: int32): bool =
  result = this.tab.MutateSlot(16, n)

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


type Physics* = object of FlatObj


proc `=location`*(result: var Vector3; this: var Physics) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=rotation`*(result: var Rotator; this: var Physics) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=velocity`*(result: var Vector3; this: var Physics) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=angularVelocity`*(result: var Vector3; this: var Physics) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PhysicsStart*(this: var Builder) =
  this.StartObject(4)

proc PhysicsAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(0, location, default(Vector3))

proc PhysicsAddRotation*(this: var Builder; rotation: Rotator) =
  this.PrependSlot(1, rotation, default(Rotator))

proc PhysicsAddVelocity*(this: var Builder; velocity: Vector3) =
  this.PrependSlot(2, velocity, default(Vector3))

proc PhysicsAddAngularVelocity*(this: var Builder; angularVelocity: Vector3) =
  this.PrependSlot(3, angularVelocity, default(Vector3))


type PlayerInfo* = object of FlatObj


proc `=physics`*(result: var Physics; this: var PlayerInfo) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=scoreInfo`*(result: var ScoreInfo; this: var PlayerInfo) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc isDemolished*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsDemolished*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(8, n)

proc hasWheelContact*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHasWheelContact*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(10, n)

proc isSupersonic*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsSupersonic*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(12, n)

proc isBot*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsBot*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(14, n)

proc jumped*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateJumped*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(16, n)

proc doubleJumped*(this: var PlayerInfo): bool =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDoubleJumped*(this: var PlayerInfo; n: bool): bool =
  result = this.tab.MutateSlot(18, n)

proc name*(this: var PlayerInfo): string =
  var o = this.tab.Offset(20).uoffset
  if o != 0:
    result = Get[string](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateName*(this: var PlayerInfo; n: string): bool =
  result = this.tab.MutateSlot(20, n)

proc team*(this: var PlayerInfo): int32 =
  var o = this.tab.Offset(22).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeam*(this: var PlayerInfo; n: int32): bool =
  result = this.tab.MutateSlot(22, n)

proc boost*(this: var PlayerInfo): int32 =
  var o = this.tab.Offset(24).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoost*(this: var PlayerInfo; n: int32): bool =
  result = this.tab.MutateSlot(24, n)

proc `=hitbox`*(result: var BoxShape; this: var PlayerInfo) =
  var o = this.tab.Offset(26).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=hitboxOffset`*(result: var Vector3; this: var PlayerInfo) =
  var o = this.tab.Offset(28).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc spawnId*(this: var PlayerInfo): int32 =
  var o = this.tab.Offset(30).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSpawnId*(this: var PlayerInfo; n: int32): bool =
  result = this.tab.MutateSlot(30, n)

proc PlayerInfoStart*(this: var Builder) =
  this.StartObject(14)

proc PlayerInfoAddPhysics*(this: var Builder; physics: Physics) =
  this.PrependSlot(0, physics, default(Physics))

proc PlayerInfoAddScoreInfo*(this: var Builder; scoreInfo: ScoreInfo) =
  this.PrependSlot(1, scoreInfo, default(ScoreInfo))

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

proc PlayerInfoAddName*(this: var Builder; name: string) =
  this.PrependSlot(8, name, default(string))

proc PlayerInfoAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(9, team, default(int32))

proc PlayerInfoAddBoost*(this: var Builder; boost: int32) =
  this.PrependSlot(10, boost, default(int32))

proc PlayerInfoAddHitbox*(this: var Builder; hitbox: BoxShape) =
  this.PrependSlot(11, hitbox, default(BoxShape))

proc PlayerInfoAddHitboxOffset*(this: var Builder; hitboxOffset: Vector3) =
  this.PrependSlot(12, hitboxOffset, default(Vector3))

proc PlayerInfoAddSpawnId*(this: var Builder; spawnId: int32) =
  this.PrependSlot(13, spawnId, default(int32))


type DropShotBallInfo* = object of FlatObj


proc absorbedForce*(this: var DropShotBallInfo): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateAbsorbedForce*(this: var DropShotBallInfo; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc damageIndex*(this: var DropShotBallInfo): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDamageIndex*(this: var DropShotBallInfo; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc forceAccumRecent*(this: var DropShotBallInfo): float32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateForceAccumRecent*(this: var DropShotBallInfo; n: float32): bool =
  result = this.tab.MutateSlot(8, n)

proc DropShotBallInfoStart*(this: var Builder) =
  this.StartObject(3)

proc DropShotBallInfoAddAbsorbedForce*(this: var Builder; absorbedForce: float32) =
  this.PrependSlot(0, absorbedForce, default(float32))

proc DropShotBallInfoAddDamageIndex*(this: var Builder; damageIndex: int32) =
  this.PrependSlot(1, damageIndex, default(int32))

proc DropShotBallInfoAddForceAccumRecent*(this: var Builder;
    forceAccumRecent: float32) =
  this.PrependSlot(2, forceAccumRecent, default(float32))


type BallInfo* = object of FlatObj


proc `=physics`*(result: var Physics; this: var BallInfo) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=latestTouch`*(result: var Touch; this: var BallInfo) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=dropShotInfo`*(result: var DropShotBallInfo; this: var BallInfo) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc shapeType*(this: var BallInfo): byte =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateShapeType*(this: var BallInfo; n: byte): bool =
  result = this.tab.MutateSlot(10, n)

proc shape*(this: var BallInfo; obj: var FlatObj): bool =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    this.tab.Union(obj.tab, o)
    result = true
  else:
    result = false

proc BallInfoStart*(this: var Builder) =
  this.StartObject(4)

proc BallInfoAddPhysics*(this: var Builder; physics: Physics) =
  this.PrependSlot(0, physics, default(Physics))

proc BallInfoAddLatestTouch*(this: var Builder; latestTouch: Touch) =
  this.PrependSlot(1, latestTouch, default(Touch))

proc BallInfoAddDropShotInfo*(this: var Builder; dropShotInfo: DropShotBallInfo) =
  this.PrependSlot(2, dropShotInfo, default(DropShotBallInfo))

proc BallInfoAddShapeType*(this: var Builder; shape: CollisionShape) =
  this.PrependSlot(3, shape, default(CollisionShape))

proc BallInfoAddShape*(this: var Builder; shape: CollisionShape) =
  this.PrependSlot(4, shape, default(CollisionShape))


type BoostPadState* = object of FlatObj


proc isActive*(this: var BoostPadState): bool =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsActive*(this: var BoostPadState; n: bool): bool =
  result = this.tab.MutateSlot(4, n)

proc timer*(this: var BoostPadState): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTimer*(this: var BoostPadState; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc BoostPadStateStart*(this: var Builder) =
  this.StartObject(2)

proc BoostPadStateAddIsActive*(this: var Builder; isActive: bool) =
  this.PrependSlot(0, isActive, default(bool))

proc BoostPadStateAddTimer*(this: var Builder; timer: float32) =
  this.PrependSlot(1, timer, default(float32))


type TileState* {.pure.} = enum
    Unknown = 0.int8, Filled = 1.int8, Damaged = 2.int8, Open = 3.int8


type DropshotTile* = object of FlatObj


proc tileState*(this: var DropshotTile): int8 =
  var o = this.tab.Offset(0).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTileState*(this: var DropshotTile; n: int8): bool =
  result = this.tab.MutateSlot(0, n)

proc DropshotTileStart*(this: var Builder) =
  this.StartObject(1)

proc DropshotTileAddTileState*(this: var Builder; tileState: int8) =
  this.PrependSlot(0, tileState, default(int8))


type GameInfo* = object of FlatObj


proc secondsElapsed*(this: var GameInfo): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSecondsElapsed*(this: var GameInfo; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc gameTimeRemaining*(this: var GameInfo): float32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameTimeRemaining*(this: var GameInfo; n: float32): bool =
  result = this.tab.MutateSlot(6, n)

proc isOvertime*(this: var GameInfo): bool =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsOvertime*(this: var GameInfo; n: bool): bool =
  result = this.tab.MutateSlot(8, n)

proc isUnlimitedTime*(this: var GameInfo): bool =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsUnlimitedTime*(this: var GameInfo; n: bool): bool =
  result = this.tab.MutateSlot(10, n)

proc isRoundActive*(this: var GameInfo): bool =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsRoundActive*(this: var GameInfo; n: bool): bool =
  result = this.tab.MutateSlot(12, n)

proc isKickoffPause*(this: var GameInfo): bool =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsKickoffPause*(this: var GameInfo; n: bool): bool =
  result = this.tab.MutateSlot(14, n)

proc isMatchEnded*(this: var GameInfo): bool =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsMatchEnded*(this: var GameInfo; n: bool): bool =
  result = this.tab.MutateSlot(16, n)

proc worldGravityZ*(this: var GameInfo): float32 =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateWorldGravityZ*(this: var GameInfo; n: float32): bool =
  result = this.tab.MutateSlot(18, n)

proc gameSpeed*(this: var GameInfo): float32 =
  var o = this.tab.Offset(20).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameSpeed*(this: var GameInfo; n: float32): bool =
  result = this.tab.MutateSlot(20, n)

proc frameNum*(this: var GameInfo): int32 =
  var o = this.tab.Offset(22).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateFrameNum*(this: var GameInfo; n: int32): bool =
  result = this.tab.MutateSlot(22, n)

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


type TeamInfo* = object of FlatObj


proc teamIndex*(this: var TeamInfo): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeamIndex*(this: var TeamInfo; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc score*(this: var TeamInfo): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateScore*(this: var TeamInfo; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc TeamInfoStart*(this: var Builder) =
  this.StartObject(2)

proc TeamInfoAddTeamIndex*(this: var Builder; teamIndex: int32) =
  this.PrependSlot(0, teamIndex, default(int32))

proc TeamInfoAddScore*(this: var Builder; score: int32) =
  this.PrependSlot(1, score, default(int32))


type GameTickPacket* = object of FlatObj


proc `=players`*(result: var PlayerInfo; this: var GameTickPacket) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=boostPadStates`*(result: var BoostPadState; this: var GameTickPacket) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=ball`*(result: var BallInfo; this: var GameTickPacket) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=gameInfo`*(result: var GameInfo; this: var GameTickPacket) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=tileInformation`*(result: var DropshotTile; this: var GameTickPacket) =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=teams`*(result: var TeamInfo; this: var GameTickPacket) =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc GameTickPacketStart*(this: var Builder) =
  this.StartObject(6)

proc GameTickPacketAddPlayers*(this: var Builder; players: PlayerInfo) =
  this.PrependSlot(0, players, default(PlayerInfo))

proc GameTickPacketAddBoostPadStates*(this: var Builder;
                                      boostPadStates: BoostPadState) =
  this.PrependSlot(1, boostPadStates, default(BoostPadState))

proc GameTickPacketAddBall*(this: var Builder; ball: BallInfo) =
  this.PrependSlot(2, ball, default(BallInfo))

proc GameTickPacketAddGameInfo*(this: var Builder; gameInfo: GameInfo) =
  this.PrependSlot(3, gameInfo, default(GameInfo))

proc GameTickPacketAddTileInformation*(this: var Builder;
                                       tileInformation: DropshotTile) =
  this.PrependSlot(4, tileInformation, default(DropshotTile))

proc GameTickPacketAddTeams*(this: var Builder; teams: TeamInfo) =
  this.PrependSlot(5, teams, default(TeamInfo))


type RigidBodyState* = object of FlatObj


proc frame*(this: var RigidBodyState): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateFrame*(this: var RigidBodyState; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc `=location`*(result: var Vector3; this: var RigidBodyState) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=rotation`*(result: var Quaternion; this: var RigidBodyState) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=velocity`*(result: var Vector3; this: var RigidBodyState) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=angularVelocity`*(result: var Vector3; this: var RigidBodyState) =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc RigidBodyStateStart*(this: var Builder) =
  this.StartObject(5)

proc RigidBodyStateAddFrame*(this: var Builder; frame: int32) =
  this.PrependSlot(0, frame, default(int32))

proc RigidBodyStateAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(1, location, default(Vector3))

proc RigidBodyStateAddRotation*(this: var Builder; rotation: Quaternion) =
  this.PrependSlot(2, rotation, default(Quaternion))

proc RigidBodyStateAddVelocity*(this: var Builder; velocity: Vector3) =
  this.PrependSlot(3, velocity, default(Vector3))

proc RigidBodyStateAddAngularVelocity*(this: var Builder;
                                       angularVelocity: Vector3) =
  this.PrependSlot(4, angularVelocity, default(Vector3))


type PlayerRigidBodyState* = object of FlatObj


proc `=state`*(result: var RigidBodyState; this: var PlayerRigidBodyState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=input`*(result: var ControllerState; this: var PlayerRigidBodyState) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PlayerRigidBodyStateStart*(this: var Builder) =
  this.StartObject(2)

proc PlayerRigidBodyStateAddState*(this: var Builder; state: RigidBodyState) =
  this.PrependSlot(0, state, default(RigidBodyState))

proc PlayerRigidBodyStateAddInput*(this: var Builder; input: ControllerState) =
  this.PrependSlot(1, input, default(ControllerState))


type BallRigidBodyState* = object of FlatObj


proc `=state`*(result: var RigidBodyState; this: var BallRigidBodyState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc BallRigidBodyStateStart*(this: var Builder) =
  this.StartObject(1)

proc BallRigidBodyStateAddState*(this: var Builder; state: RigidBodyState) =
  this.PrependSlot(0, state, default(RigidBodyState))


type RigidBodyTick* = object of FlatObj


proc `=ball`*(result: var BallRigidBodyState; this: var RigidBodyTick) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=players`*(result: var PlayerRigidBodyState; this: var RigidBodyTick) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc RigidBodyTickStart*(this: var Builder) =
  this.StartObject(2)

proc RigidBodyTickAddBall*(this: var Builder; ball: BallRigidBodyState) =
  this.PrependSlot(0, ball, default(BallRigidBodyState))

proc RigidBodyTickAddPlayers*(this: var Builder; players: PlayerRigidBodyState) =
  this.PrependSlot(1, players, default(PlayerRigidBodyState))


type GoalInfo* = object of FlatObj


proc teamNum*(this: var GoalInfo): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeamNum*(this: var GoalInfo; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc `=location`*(result: var Vector3; this: var GoalInfo) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=direction`*(result: var Vector3; this: var GoalInfo) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc width*(this: var GoalInfo): float32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateWidth*(this: var GoalInfo; n: float32): bool =
  result = this.tab.MutateSlot(10, n)

proc height*(this: var GoalInfo): float32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHeight*(this: var GoalInfo; n: float32): bool =
  result = this.tab.MutateSlot(12, n)

proc GoalInfoStart*(this: var Builder) =
  this.StartObject(5)

proc GoalInfoAddTeamNum*(this: var Builder; teamNum: int32) =
  this.PrependSlot(0, teamNum, default(int32))

proc GoalInfoAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(1, location, default(Vector3))

proc GoalInfoAddDirection*(this: var Builder; direction: Vector3) =
  this.PrependSlot(2, direction, default(Vector3))

proc GoalInfoAddWidth*(this: var Builder; width: float32) =
  this.PrependSlot(3, width, default(float32))

proc GoalInfoAddHeight*(this: var Builder; height: float32) =
  this.PrependSlot(4, height, default(float32))


type BoostPad* = object of FlatObj


proc `=location`*(result: var Vector3; this: var BoostPad) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc isFullBoost*(this: var BoostPad): bool =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsFullBoost*(this: var BoostPad; n: bool): bool =
  result = this.tab.MutateSlot(6, n)

proc BoostPadStart*(this: var Builder) =
  this.StartObject(2)

proc BoostPadAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(0, location, default(Vector3))

proc BoostPadAddIsFullBoost*(this: var Builder; isFullBoost: bool) =
  this.PrependSlot(1, isFullBoost, default(bool))


type FieldInfo* = object of FlatObj


proc `=boostPads`*(result: var BoostPad; this: var FieldInfo) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=goals`*(result: var GoalInfo; this: var FieldInfo) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc FieldInfoStart*(this: var Builder) =
  this.StartObject(2)

proc FieldInfoAddBoostPads*(this: var Builder; boostPads: BoostPad) =
  this.PrependSlot(0, boostPads, default(BoostPad))

proc FieldInfoAddGoals*(this: var Builder; goals: GoalInfo) =
  this.PrependSlot(1, goals, default(GoalInfo))


type Float* = object of FlatObj


proc val*(this: var Float): float32 =
  result = Get[float32](this.tab, this.tab.Pos + 0)
proc mutateVal*(this: var Float; n: float32): bool =
  result = this.tab.Mutate(this.tab.Pos + 0, n)


type Bool* = object of FlatObj


proc val*(this: var Bool): bool =
  result = Get[bool](this.tab, this.tab.Pos + 0)
proc mutateVal*(this: var Bool; n: bool): bool =
  result = this.tab.Mutate(this.tab.Pos + 0, n)


type Vector3Partial* = object of FlatObj


proc `=x`*(result: var Float; this: var Vector3Partial) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=y`*(result: var Float; this: var Vector3Partial) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=z`*(result: var Float; this: var Vector3Partial) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc Vector3PartialStart*(this: var Builder) =
  this.StartObject(3)

proc Vector3PartialAddX*(this: var Builder; x: Float) =
  this.PrependSlot(0, x, default(Float))

proc Vector3PartialAddY*(this: var Builder; y: Float) =
  this.PrependSlot(1, y, default(Float))

proc Vector3PartialAddZ*(this: var Builder; z: Float) =
  this.PrependSlot(2, z, default(Float))


type RotatorPartial* = object of FlatObj


proc `=pitch`*(result: var Float; this: var RotatorPartial) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=yaw`*(result: var Float; this: var RotatorPartial) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=roll`*(result: var Float; this: var RotatorPartial) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc RotatorPartialStart*(this: var Builder) =
  this.StartObject(3)

proc RotatorPartialAddPitch*(this: var Builder; pitch: Float) =
  this.PrependSlot(0, pitch, default(Float))

proc RotatorPartialAddYaw*(this: var Builder; yaw: Float) =
  this.PrependSlot(1, yaw, default(Float))

proc RotatorPartialAddRoll*(this: var Builder; roll: Float) =
  this.PrependSlot(2, roll, default(Float))


type DesiredPhysics* = object of FlatObj


proc `=location`*(result: var Vector3Partial; this: var DesiredPhysics) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=rotation`*(result: var RotatorPartial; this: var DesiredPhysics) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=velocity`*(result: var Vector3Partial; this: var DesiredPhysics) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=angularVelocity`*(result: var Vector3Partial; this: var DesiredPhysics) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredPhysicsStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredPhysicsAddLocation*(this: var Builder; location: Vector3Partial) =
  this.PrependSlot(0, location, default(Vector3Partial))

proc DesiredPhysicsAddRotation*(this: var Builder; rotation: RotatorPartial) =
  this.PrependSlot(1, rotation, default(RotatorPartial))

proc DesiredPhysicsAddVelocity*(this: var Builder; velocity: Vector3Partial) =
  this.PrependSlot(2, velocity, default(Vector3Partial))

proc DesiredPhysicsAddAngularVelocity*(this: var Builder;
                                       angularVelocity: Vector3Partial) =
  this.PrependSlot(3, angularVelocity, default(Vector3Partial))


type DesiredBallState* = object of FlatObj


proc `=physics`*(result: var DesiredPhysics; this: var DesiredBallState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredBallStateStart*(this: var Builder) =
  this.StartObject(1)

proc DesiredBallStateAddPhysics*(this: var Builder; physics: DesiredPhysics) =
  this.PrependSlot(0, physics, default(DesiredPhysics))


type DesiredCarState* = object of FlatObj


proc `=physics`*(result: var DesiredPhysics; this: var DesiredCarState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=boostAmount`*(result: var Float; this: var DesiredCarState) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=jumped`*(result: var Bool; this: var DesiredCarState) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=doubleJumped`*(result: var Bool; this: var DesiredCarState) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredCarStateStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredCarStateAddPhysics*(this: var Builder; physics: DesiredPhysics) =
  this.PrependSlot(0, physics, default(DesiredPhysics))

proc DesiredCarStateAddBoostAmount*(this: var Builder; boostAmount: Float) =
  this.PrependSlot(1, boostAmount, default(Float))

proc DesiredCarStateAddJumped*(this: var Builder; jumped: Bool) =
  this.PrependSlot(2, jumped, default(Bool))

proc DesiredCarStateAddDoubleJumped*(this: var Builder; doubleJumped: Bool) =
  this.PrependSlot(3, doubleJumped, default(Bool))


type DesiredBoostState* = object of FlatObj


proc `=respawnTime`*(result: var Float; this: var DesiredBoostState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredBoostStateStart*(this: var Builder) =
  this.StartObject(1)

proc DesiredBoostStateAddRespawnTime*(this: var Builder; respawnTime: Float) =
  this.PrependSlot(0, respawnTime, default(Float))


type DesiredGameInfoState* = object of FlatObj


proc `=worldGravityZ`*(result: var Float; this: var DesiredGameInfoState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=gameSpeed`*(result: var Float; this: var DesiredGameInfoState) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=paused`*(result: var Bool; this: var DesiredGameInfoState) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=endMatch`*(result: var Bool; this: var DesiredGameInfoState) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredGameInfoStateStart*(this: var Builder) =
  this.StartObject(4)

proc DesiredGameInfoStateAddWorldGravityZ*(this: var Builder;
    worldGravityZ: Float) =
  this.PrependSlot(0, worldGravityZ, default(Float))

proc DesiredGameInfoStateAddGameSpeed*(this: var Builder; gameSpeed: Float) =
  this.PrependSlot(1, gameSpeed, default(Float))

proc DesiredGameInfoStateAddPaused*(this: var Builder; paused: Bool) =
  this.PrependSlot(2, paused, default(Bool))

proc DesiredGameInfoStateAddEndMatch*(this: var Builder; endMatch: Bool) =
  this.PrependSlot(3, endMatch, default(Bool))


type ConsoleCommand* = object of FlatObj


proc command*(this: var ConsoleCommand): string =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[string](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateCommand*(this: var ConsoleCommand; n: string): bool =
  result = this.tab.MutateSlot(4, n)

proc ConsoleCommandStart*(this: var Builder) =
  this.StartObject(1)

proc ConsoleCommandAddCommand*(this: var Builder; command: string) =
  this.PrependSlot(0, command, default(string))


type DesiredGameState* = object of FlatObj


proc `=ballState`*(result: var DesiredBallState; this: var DesiredGameState) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=carStates`*(result: var DesiredCarState; this: var DesiredGameState) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=boostStates`*(result: var DesiredBoostState; this: var DesiredGameState) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=gameInfoState`*(result: var DesiredGameInfoState;
                       this: var DesiredGameState) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=consoleCommands`*(result: var ConsoleCommand; this: var DesiredGameState) =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc DesiredGameStateStart*(this: var Builder) =
  this.StartObject(5)

proc DesiredGameStateAddBallState*(this: var Builder;
                                   ballState: DesiredBallState) =
  this.PrependSlot(0, ballState, default(DesiredBallState))

proc DesiredGameStateAddCarStates*(this: var Builder; carStates: DesiredCarState) =
  this.PrependSlot(1, carStates, default(DesiredCarState))

proc DesiredGameStateAddBoostStates*(this: var Builder;
                                     boostStates: DesiredBoostState) =
  this.PrependSlot(2, boostStates, default(DesiredBoostState))

proc DesiredGameStateAddGameInfoState*(this: var Builder;
                                       gameInfoState: DesiredGameInfoState) =
  this.PrependSlot(3, gameInfoState, default(DesiredGameInfoState))

proc DesiredGameStateAddConsoleCommands*(this: var Builder;
    consoleCommands: ConsoleCommand) =
  this.PrependSlot(4, consoleCommands, default(ConsoleCommand))


type RenderType* {.pure.} = enum
    DrawLine2D = 1.int8, DrawLine3D = 2.int8, DrawLine2D_3D = 3.int8,
    DrawRect2D = 4.int8, DrawRect3D = 5.int8, DrawString2D = 6.int8,
    DrawString3D = 7.int8, DrawCenteredRect3D = 8.int8


type Color* = object of FlatObj


proc a*(this: var Color): byte =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateA*(this: var Color; n: byte): bool =
  result = this.tab.MutateSlot(4, n)

proc r*(this: var Color): byte =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateR*(this: var Color; n: byte): bool =
  result = this.tab.MutateSlot(6, n)

proc g*(this: var Color): byte =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateG*(this: var Color; n: byte): bool =
  result = this.tab.MutateSlot(8, n)

proc b*(this: var Color): byte =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateB*(this: var Color; n: byte): bool =
  result = this.tab.MutateSlot(10, n)

proc ColorStart*(this: var Builder) =
  this.StartObject(4)

proc ColorAddA*(this: var Builder; a: byte) =
  this.PrependSlot(0, a, default(byte))

proc ColorAddR*(this: var Builder; r: byte) =
  this.PrependSlot(1, r, default(byte))

proc ColorAddG*(this: var Builder; g: byte) =
  this.PrependSlot(2, g, default(byte))

proc ColorAddB*(this: var Builder; b: byte) =
  this.PrependSlot(3, b, default(byte))


type RenderMessage* = object of FlatObj


proc renderType*(this: var RenderMessage): int8 =
  var o = this.tab.Offset(0).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateRenderType*(this: var RenderMessage; n: int8): bool =
  result = this.tab.MutateSlot(0, n)

proc `=color`*(result: var Color; this: var RenderMessage) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=start`*(result: var Vector3; this: var RenderMessage) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=endN`*(result: var Vector3; this: var RenderMessage) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc scaleX*(this: var RenderMessage): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateScaleX*(this: var RenderMessage; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc scaleY*(this: var RenderMessage): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateScaleY*(this: var RenderMessage; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc text*(this: var RenderMessage): string =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[string](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateText*(this: var RenderMessage; n: string): bool =
  result = this.tab.MutateSlot(16, n)

proc isFilled*(this: var RenderMessage): bool =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsFilled*(this: var RenderMessage; n: bool): bool =
  result = this.tab.MutateSlot(18, n)

proc RenderMessageStart*(this: var Builder) =
  this.StartObject(8)

proc RenderMessageAddRenderType*(this: var Builder; renderType: int8) =
  this.PrependSlot(0, renderType, default(int8))

proc RenderMessageAddColor*(this: var Builder; color: Color) =
  this.PrependSlot(1, color, default(Color))

proc RenderMessageAddStart*(this: var Builder; start: Vector3) =
  this.PrependSlot(2, start, default(Vector3))

proc RenderMessageAddEndN*(this: var Builder; endN: Vector3) =
  this.PrependSlot(3, endN, default(Vector3))

proc RenderMessageAddScaleX*(this: var Builder; scaleX: int32) =
  this.PrependSlot(4, scaleX, default(int32))

proc RenderMessageAddScaleY*(this: var Builder; scaleY: int32) =
  this.PrependSlot(5, scaleY, default(int32))

proc RenderMessageAddText*(this: var Builder; text: string) =
  this.PrependSlot(6, text, default(string))

proc RenderMessageAddIsFilled*(this: var Builder; isFilled: bool) =
  this.PrependSlot(7, isFilled, default(bool))


type RenderGroup* = object of FlatObj


proc `=renderMessages`*(result: var RenderMessage; this: var RenderGroup) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc id*(this: var RenderGroup): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateId*(this: var RenderGroup; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc RenderGroupStart*(this: var Builder) =
  this.StartObject(2)

proc RenderGroupAddRenderMessages*(this: var Builder;
                                   renderMessages: RenderMessage) =
  this.PrependSlot(0, renderMessages, default(RenderMessage))

proc RenderGroupAddId*(this: var Builder; id: int32) =
  this.PrependSlot(1, id, default(int32))


type QuickChatSelection* {.pure.} = enum
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


type QuickChat* = object of FlatObj


proc quickChatSelection*(this: var QuickChat): int8 =
  var o = this.tab.Offset(0).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateQuickChatSelection*(this: var QuickChat; n: int8): bool =
  result = this.tab.MutateSlot(0, n)

proc playerIndex*(this: var QuickChat): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePlayerIndex*(this: var QuickChat; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc teamOnly*(this: var QuickChat): bool =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeamOnly*(this: var QuickChat; n: bool): bool =
  result = this.tab.MutateSlot(8, n)

proc messageIndex*(this: var QuickChat): int32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateMessageIndex*(this: var QuickChat; n: int32): bool =
  result = this.tab.MutateSlot(10, n)

proc timeStamp*(this: var QuickChat): float32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTimeStamp*(this: var QuickChat; n: float32): bool =
  result = this.tab.MutateSlot(12, n)

proc QuickChatStart*(this: var Builder) =
  this.StartObject(5)

proc QuickChatAddQuickChatSelection*(this: var Builder; quickChatSelection: int8) =
  this.PrependSlot(0, quickChatSelection, default(int8))

proc QuickChatAddPlayerIndex*(this: var Builder; playerIndex: int32) =
  this.PrependSlot(1, playerIndex, default(int32))

proc QuickChatAddTeamOnly*(this: var Builder; teamOnly: bool) =
  this.PrependSlot(2, teamOnly, default(bool))

proc QuickChatAddMessageIndex*(this: var Builder; messageIndex: int32) =
  this.PrependSlot(3, messageIndex, default(int32))

proc QuickChatAddTimeStamp*(this: var Builder; timeStamp: float32) =
  this.PrependSlot(4, timeStamp, default(float32))


type TinyPlayer* = object of FlatObj


proc `=location`*(result: var Vector3; this: var TinyPlayer) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=rotation`*(result: var Rotator; this: var TinyPlayer) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=velocity`*(result: var Vector3; this: var TinyPlayer) =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc hasWheelContact*(this: var TinyPlayer): bool =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHasWheelContact*(this: var TinyPlayer; n: bool): bool =
  result = this.tab.MutateSlot(10, n)

proc isSupersonic*(this: var TinyPlayer): bool =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateIsSupersonic*(this: var TinyPlayer; n: bool): bool =
  result = this.tab.MutateSlot(12, n)

proc team*(this: var TinyPlayer): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeam*(this: var TinyPlayer; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc boost*(this: var TinyPlayer): int32 =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoost*(this: var TinyPlayer; n: int32): bool =
  result = this.tab.MutateSlot(16, n)

proc TinyPlayerStart*(this: var Builder) =
  this.StartObject(7)

proc TinyPlayerAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(0, location, default(Vector3))

proc TinyPlayerAddRotation*(this: var Builder; rotation: Rotator) =
  this.PrependSlot(1, rotation, default(Rotator))

proc TinyPlayerAddVelocity*(this: var Builder; velocity: Vector3) =
  this.PrependSlot(2, velocity, default(Vector3))

proc TinyPlayerAddHasWheelContact*(this: var Builder; hasWheelContact: bool) =
  this.PrependSlot(3, hasWheelContact, default(bool))

proc TinyPlayerAddIsSupersonic*(this: var Builder; isSupersonic: bool) =
  this.PrependSlot(4, isSupersonic, default(bool))

proc TinyPlayerAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(5, team, default(int32))

proc TinyPlayerAddBoost*(this: var Builder; boost: int32) =
  this.PrependSlot(6, boost, default(int32))


type TinyBall* = object of FlatObj


proc `=location`*(result: var Vector3; this: var TinyBall) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=velocity`*(result: var Vector3; this: var TinyBall) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc TinyBallStart*(this: var Builder) =
  this.StartObject(2)

proc TinyBallAddLocation*(this: var Builder; location: Vector3) =
  this.PrependSlot(0, location, default(Vector3))

proc TinyBallAddVelocity*(this: var Builder; velocity: Vector3) =
  this.PrependSlot(1, velocity, default(Vector3))


type TinyPacket* = object of FlatObj


proc `=players`*(result: var TinyPlayer; this: var TinyPacket) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=ball`*(result: var TinyBall; this: var TinyPacket) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc TinyPacketStart*(this: var Builder) =
  this.StartObject(2)

proc TinyPacketAddPlayers*(this: var Builder; players: TinyPlayer) =
  this.PrependSlot(0, players, default(TinyPlayer))

proc TinyPacketAddBall*(this: var Builder; ball: TinyBall) =
  this.PrependSlot(1, ball, default(TinyBall))


type PredictionSlice* = object of FlatObj


proc gameSeconds*(this: var PredictionSlice): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameSeconds*(this: var PredictionSlice; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc `=physics`*(result: var Physics; this: var PredictionSlice) =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc PredictionSliceStart*(this: var Builder) =
  this.StartObject(2)

proc PredictionSliceAddGameSeconds*(this: var Builder; gameSeconds: float32) =
  this.PrependSlot(0, gameSeconds, default(float32))

proc PredictionSliceAddPhysics*(this: var Builder; physics: Physics) =
  this.PrependSlot(1, physics, default(Physics))


type BallPrediction* = object of FlatObj


proc `=slices`*(result: var PredictionSlice; this: var BallPrediction) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc BallPredictionStart*(this: var Builder) =
  this.StartObject(1)

proc BallPredictionAddSlices*(this: var Builder; slices: PredictionSlice) =
  this.PrependSlot(0, slices, default(PredictionSlice))


type RLBotPlayer* = object of FlatObj


proc RLBotPlayerStart*(this: var Builder) =
  this.StartObject(0)


type HumanPlayer* = object of FlatObj


proc HumanPlayerStart*(this: var Builder) =
  this.StartObject(0)


type PsyonixBotPlayer* = object of FlatObj


proc botSkill*(this: var PsyonixBotPlayer): float32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[float32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBotSkill*(this: var PsyonixBotPlayer; n: float32): bool =
  result = this.tab.MutateSlot(4, n)

proc PsyonixBotPlayerStart*(this: var Builder) =
  this.StartObject(1)

proc PsyonixBotPlayerAddBotSkill*(this: var Builder; botSkill: float32) =
  this.PrependSlot(0, botSkill, default(float32))


type PartyMemberBotPlayer* = object of FlatObj


proc PartyMemberBotPlayerStart*(this: var Builder) =
  this.StartObject(0)


type PlayerClass* {.pure.} = enum
    HumanPlayer = 0'u8, PsyonixBotPlayer = 1'u8, PartyMemberBotPlayer = 2'u8


type LoadoutPaint* = object of FlatObj


proc carPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateCarPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc decalPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDecalPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc wheelsPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateWheelsPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(8, n)

proc boostPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoostPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(10, n)

proc antennaPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateAntennaPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc hatPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHatPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc trailsPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTrailsPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(16, n)

proc goalExplosionPaintId*(this: var LoadoutPaint): int32 =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGoalExplosionPaintId*(this: var LoadoutPaint; n: int32): bool =
  result = this.tab.MutateSlot(18, n)

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


type PlayerLoadout* = object of FlatObj


proc teamColorId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeamColorId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(4, n)

proc customColorId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateCustomColorId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(6, n)

proc carId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateCarId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(8, n)

proc decalId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDecalId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(10, n)

proc wheelsId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateWheelsId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc boostId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoostId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(14, n)

proc antennaId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(16).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateAntennaId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(16, n)

proc hatId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateHatId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(18, n)

proc paintFinishId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(20).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutatePaintFinishId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(20, n)

proc customFinishId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(22).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateCustomFinishId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(22, n)

proc engineAudioId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(24).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateEngineAudioId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(24, n)

proc trailsId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(26).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTrailsId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(26, n)

proc goalExplosionId*(this: var PlayerLoadout): int32 =
  var o = this.tab.Offset(28).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGoalExplosionId*(this: var PlayerLoadout; n: int32): bool =
  result = this.tab.MutateSlot(28, n)

proc `=loadoutPaint`*(result: var LoadoutPaint; this: var PlayerLoadout) =
  var o = this.tab.Offset(30).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=primaryColorLookup`*(result: var Color; this: var PlayerLoadout) =
  var o = this.tab.Offset(32).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc `=secondaryColorLookup`*(result: var Color; this: var PlayerLoadout) =
  var o = this.tab.Offset(34).uoffset
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

proc PlayerLoadoutAddLoadoutPaint*(this: var Builder; loadoutPaint: LoadoutPaint) =
  this.PrependSlot(13, loadoutPaint, default(LoadoutPaint))

proc PlayerLoadoutAddPrimaryColorLookup*(this: var Builder;
    primaryColorLookup: Color) =
  this.PrependSlot(14, primaryColorLookup, default(Color))

proc PlayerLoadoutAddSecondaryColorLookup*(this: var Builder;
    secondaryColorLookup: Color) =
  this.PrependSlot(15, secondaryColorLookup, default(Color))


type PlayerConfiguration* = object of FlatObj


proc varietyType*(this: var PlayerConfiguration): byte =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[byte](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateVarietyType*(this: var PlayerConfiguration; n: byte): bool =
  result = this.tab.MutateSlot(4, n)

proc variety*(this: var PlayerConfiguration; obj: var FlatObj): bool =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    this.tab.Union(obj.tab, o)
    result = true
  else:
    result = false

proc name*(this: var PlayerConfiguration): string =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[string](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateName*(this: var PlayerConfiguration; n: string): bool =
  result = this.tab.MutateSlot(6, n)

proc team*(this: var PlayerConfiguration): int32 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateTeam*(this: var PlayerConfiguration; n: int32): bool =
  result = this.tab.MutateSlot(8, n)

proc `=loadout`*(result: var PlayerLoadout; this: var PlayerConfiguration) =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc spawnId*(this: var PlayerConfiguration): int32 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int32](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSpawnId*(this: var PlayerConfiguration; n: int32): bool =
  result = this.tab.MutateSlot(12, n)

proc PlayerConfigurationStart*(this: var Builder) =
  this.StartObject(5)

proc PlayerConfigurationAddVarietyType*(this: var Builder; variety: PlayerClass) =
  this.PrependSlot(0, variety, default(PlayerClass))

proc PlayerConfigurationAddVariety*(this: var Builder; variety: PlayerClass) =
  this.PrependSlot(1, variety, default(PlayerClass))

proc PlayerConfigurationAddName*(this: var Builder; name: string) =
  this.PrependSlot(1, name, default(string))

proc PlayerConfigurationAddTeam*(this: var Builder; team: int32) =
  this.PrependSlot(2, team, default(int32))

proc PlayerConfigurationAddLoadout*(this: var Builder; loadout: PlayerLoadout) =
  this.PrependSlot(3, loadout, default(PlayerLoadout))

proc PlayerConfigurationAddSpawnId*(this: var Builder; spawnId: int32) =
  this.PrependSlot(4, spawnId, default(int32))


type GameMode* {.pure.} = enum
    Soccer = 0.int8, Hoops = 1.int8, Dropshot = 2.int8, Hockey = 3.int8,
    Rumble = 4.int8, Heatseeker = 5.int8


type GameMap* {.pure.} = enum
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


type MatchLength* {.pure.} = enum
    Five_Minutes = 0.int8, Ten_Minutes = 1.int8, Twenty_Minutes = 2.int8,
    Unlimited = 3.int8


type MaxScore* {.pure.} = enum
    Unlimited = 0.int8, One_Goal = 1.int8, Three_Goals = 2.int8,
    Five_Goals = 3.int8


type OvertimeOption* {.pure.} = enum
    Unlimited = 0.int8, Five_Max_First_Score = 1.int8,
    Five_Max_Random_Team = 2.int8


type SeriesLengthOption* {.pure.} = enum
    Unlimited = 0.int8, Three_Games = 1.int8, Five_Games = 2.int8,
    Seven_Games = 3.int8


type GameSpeedOption* {.pure.} = enum
    Default = 0.int8, Slo_Mo = 1.int8, Time_Warp = 2.int8


type BallMaxSpeedOption* {.pure.} = enum
    Default = 0.int8, Slow = 1.int8, Fast = 2.int8, Super_Fast = 3.int8


type BallTypeOption* {.pure.} = enum
    Default = 0.int8, Cube = 1.int8, Puck = 2.int8, Basketball = 3.int8


type BallWeightOption* {.pure.} = enum
    Default = 0.int8, Light = 1.int8, Heavy = 2.int8, Super_Light = 3.int8


type BallSizeOption* {.pure.} = enum
    Default = 0.int8, Small = 1.int8, Large = 2.int8, Gigantic = 3.int8


type BallBouncinessOption* {.pure.} = enum
    Default = 0.int8, Low = 1.int8, High = 2.int8, Super_High = 3.int8


type BoostOption* {.pure.} = enum
    Normal_Boost = 0.int8, Unlimited_Boost = 1.int8, Slow_Recharge = 2.int8,
    Rapid_Recharge = 3.int8, No_Boost = 4.int8


type RumbleOption* {.pure.} = enum
    No_Rumble = 0.int8, Default = 1.int8, Slow = 2.int8, Civilized = 3.int8,
    Destruction_Derby = 4.int8, Spring_Loaded = 5.int8, Spikes_Only = 6.int8,
    Spike_Rush = 7.int8


type BoostStrengthOption* {.pure.} = enum
    One = 0.int8, OneAndAHalf = 1.int8, Two = 2.int8, Ten = 3.int8


type GravityOption* {.pure.} = enum
    Default = 0.int8, Low = 1.int8, High = 2.int8, Super_High = 3.int8


type DemolishOption* {.pure.} = enum
    Default = 0.int8, Disabled = 1.int8, Friendly_Fire = 2.int8,
    On_Contact = 3.int8, On_Contact_FF = 4.int8


type RespawnTimeOption* {.pure.} = enum
    Three_Seconds = 0.int8, Two_Seconds = 1.int8, One_Seconds = 2.int8,
    Disable_Goal_Reset = 3.int8


type MutatorSettings* = object of FlatObj


proc matchLength*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(0).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateMatchLength*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(0, n)

proc maxScore*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(1).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateMaxScore*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(1, n)

proc overtimeOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(2).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateOvertimeOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(2, n)

proc seriesLengthOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(3).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSeriesLengthOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(3, n)

proc gameSpeedOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameSpeedOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(4, n)

proc ballMaxSpeedOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(5).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBallMaxSpeedOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(5, n)

proc ballTypeOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBallTypeOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(6, n)

proc ballWeightOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(7).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBallWeightOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(7, n)

proc ballSizeOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(8).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBallSizeOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(8, n)

proc ballBouncinessOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(9).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBallBouncinessOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(9, n)

proc boostOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoostOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(10, n)

proc rumbleOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(11).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateRumbleOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(11, n)

proc boostStrengthOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateBoostStrengthOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(12, n)

proc gravityOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(13).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGravityOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(13, n)

proc demolishOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateDemolishOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(14, n)

proc respawnTimeOption*(this: var MutatorSettings): int8 =
  var o = this.tab.Offset(15).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateRespawnTimeOption*(this: var MutatorSettings; n: int8): bool =
  result = this.tab.MutateSlot(15, n)

proc MutatorSettingsStart*(this: var Builder) =
  this.StartObject(16)

proc MutatorSettingsAddMatchLength*(this: var Builder; matchLength: int8) =
  this.PrependSlot(0, matchLength, default(int8))

proc MutatorSettingsAddMaxScore*(this: var Builder; maxScore: int8) =
  this.PrependSlot(1, maxScore, default(int8))

proc MutatorSettingsAddOvertimeOption*(this: var Builder; overtimeOption: int8) =
  this.PrependSlot(2, overtimeOption, default(int8))

proc MutatorSettingsAddSeriesLengthOption*(this: var Builder;
    seriesLengthOption: int8) =
  this.PrependSlot(3, seriesLengthOption, default(int8))

proc MutatorSettingsAddGameSpeedOption*(this: var Builder; gameSpeedOption: int8) =
  this.PrependSlot(4, gameSpeedOption, default(int8))

proc MutatorSettingsAddBallMaxSpeedOption*(this: var Builder;
    ballMaxSpeedOption: int8) =
  this.PrependSlot(5, ballMaxSpeedOption, default(int8))

proc MutatorSettingsAddBallTypeOption*(this: var Builder; ballTypeOption: int8) =
  this.PrependSlot(6, ballTypeOption, default(int8))

proc MutatorSettingsAddBallWeightOption*(this: var Builder;
    ballWeightOption: int8) =
  this.PrependSlot(7, ballWeightOption, default(int8))

proc MutatorSettingsAddBallSizeOption*(this: var Builder; ballSizeOption: int8) =
  this.PrependSlot(8, ballSizeOption, default(int8))

proc MutatorSettingsAddBallBouncinessOption*(this: var Builder;
    ballBouncinessOption: int8) =
  this.PrependSlot(9, ballBouncinessOption, default(int8))

proc MutatorSettingsAddBoostOption*(this: var Builder; boostOption: int8) =
  this.PrependSlot(10, boostOption, default(int8))

proc MutatorSettingsAddRumbleOption*(this: var Builder; rumbleOption: int8) =
  this.PrependSlot(11, rumbleOption, default(int8))

proc MutatorSettingsAddBoostStrengthOption*(this: var Builder;
    boostStrengthOption: int8) =
  this.PrependSlot(12, boostStrengthOption, default(int8))

proc MutatorSettingsAddGravityOption*(this: var Builder; gravityOption: int8) =
  this.PrependSlot(13, gravityOption, default(int8))

proc MutatorSettingsAddDemolishOption*(this: var Builder; demolishOption: int8) =
  this.PrependSlot(14, demolishOption, default(int8))

proc MutatorSettingsAddRespawnTimeOption*(this: var Builder;
    respawnTimeOption: int8) =
  this.PrependSlot(15, respawnTimeOption, default(int8))


type ExistingMatchBehavior* {.pure.} = enum
    Restart_If_Different = 0.int8, Restart = 1.int8, Continue_And_Spawn = 2.int8


type MatchSettings* = object of FlatObj


proc `=playerConfigurations`*(result: var PlayerConfiguration;
                              this: var MatchSettings) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc gameMode*(this: var MatchSettings): int8 =
  var o = this.tab.Offset(1).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameMode*(this: var MatchSettings; n: int8): bool =
  result = this.tab.MutateSlot(1, n)

proc gameMap*(this: var MatchSettings): int8 =
  var o = this.tab.Offset(2).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateGameMap*(this: var MatchSettings; n: int8): bool =
  result = this.tab.MutateSlot(2, n)

proc skipReplays*(this: var MatchSettings): bool =
  var o = this.tab.Offset(10).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateSkipReplays*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(10, n)

proc instantStart*(this: var MatchSettings): bool =
  var o = this.tab.Offset(12).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateInstantStart*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(12, n)

proc `=mutatorSettings`*(result: var MutatorSettings; this: var MatchSettings) =
  var o = this.tab.Offset(14).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc existingMatchBehavior*(this: var MatchSettings): int8 =
  var o = this.tab.Offset(6).uoffset
  if o != 0:
    result = Get[int8](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateExistingMatchBehavior*(this: var MatchSettings; n: int8): bool =
  result = this.tab.MutateSlot(6, n)

proc enableLockstep*(this: var MatchSettings): bool =
  var o = this.tab.Offset(18).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateEnableLockstep*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(18, n)

proc enableRendering*(this: var MatchSettings): bool =
  var o = this.tab.Offset(20).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateEnableRendering*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(20, n)

proc enableStateSetting*(this: var MatchSettings): bool =
  var o = this.tab.Offset(22).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateEnableStateSetting*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(22, n)

proc autoSaveReplay*(this: var MatchSettings): bool =
  var o = this.tab.Offset(24).uoffset
  if o != 0:
    result = Get[bool](this.tab, o + this.tab.Pos)
  else:
    result = default(type(result))

proc mutateAutoSaveReplay*(this: var MatchSettings; n: bool): bool =
  result = this.tab.MutateSlot(24, n)

proc MatchSettingsStart*(this: var Builder) =
  this.StartObject(11)

proc MatchSettingsAddPlayerConfigurations*(this: var Builder;
    playerConfigurations: PlayerConfiguration) =
  this.PrependSlot(0, playerConfigurations, default(PlayerConfiguration))

proc MatchSettingsAddGameMode*(this: var Builder; gameMode: int8) =
  this.PrependSlot(1, gameMode, default(int8))

proc MatchSettingsAddGameMap*(this: var Builder; gameMap: int8) =
  this.PrependSlot(2, gameMap, default(int8))

proc MatchSettingsAddSkipReplays*(this: var Builder; skipReplays: bool) =
  this.PrependSlot(3, skipReplays, default(bool))

proc MatchSettingsAddInstantStart*(this: var Builder; instantStart: bool) =
  this.PrependSlot(4, instantStart, default(bool))

proc MatchSettingsAddMutatorSettings*(this: var Builder;
                                      mutatorSettings: MutatorSettings) =
  this.PrependSlot(5, mutatorSettings, default(MutatorSettings))

proc MatchSettingsAddExistingMatchBehavior*(this: var Builder;
    existingMatchBehavior: int8) =
  this.PrependSlot(6, existingMatchBehavior, default(int8))

proc MatchSettingsAddEnableLockstep*(this: var Builder; enableLockstep: bool) =
  this.PrependSlot(7, enableLockstep, default(bool))

proc MatchSettingsAddEnableRendering*(this: var Builder; enableRendering: bool) =
  this.PrependSlot(8, enableRendering, default(bool))

proc MatchSettingsAddEnableStateSetting*(this: var Builder;
    enableStateSetting: bool) =
  this.PrependSlot(9, enableStateSetting, default(bool))

proc MatchSettingsAddAutoSaveReplay*(this: var Builder; autoSaveReplay: bool) =
  this.PrependSlot(10, autoSaveReplay, default(bool))


type QuickChatMessages* = object of FlatObj


proc `=messages`*(result: var QuickChat; this: var QuickChatMessages) =
  var o = this.tab.Offset(4).uoffset
  if o != 0:
    var x = this.tab.Indirect(o + this.tab.Pos)
    result.Init(this.tab.Bytes, x)
  else:
    result = default(type(result))

proc QuickChatMessagesStart*(this: var Builder) =
  this.StartObject(1)

proc QuickChatMessagesAddMessages*(this: var Builder; messages: QuickChat) =
  this.PrependSlot(0, messages, default(QuickChat))
