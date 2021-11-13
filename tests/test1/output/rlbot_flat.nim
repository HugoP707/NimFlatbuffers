import
  Nimflatbuffers


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
