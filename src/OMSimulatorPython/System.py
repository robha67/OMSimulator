from OMSimulator import Scope, Types


class System:
  def __init__(self, cref: str):
    self._cref = cref

  @property
  def cref(self):
    return self._cref

  @property
  def type(self):
    type_, status = Scope._capi.getSystemType(self.cref)
    if Types.Status(status) != Types.Status.OK:
      raise Exception('error {}'.format(Types.Status(status)))
    return Types.System(type_)

  def addSystem(self, cref: str, type_: Types.System):
    new_cref = self.cref + '.' + cref
    status = Scope._capi.addSystem(new_cref, type_.value)
    if Types.Status(status) != Types.Status.OK:
      raise Exception('error {}'.format(Types.Status(status)))
    return System(new_cref)

  def addSubModel(self, cref: str, path: str):
    new_cref = self.cref + '.' + cref
    status = Scope._capi.addSubModel(new_cref, path)
    if Types.Status(status) != Types.Status.OK:
      raise Exception('error {}'.format(Types.Status(status)))

  def addConnection(self, conA: str, conB: str):
    new_conA = self.cref + '.' + conA
    new_conB = self.cref + '.' + conB
    status = Scope._capi.addConnection(new_conA, new_conB)
    if Types.Status(status) != Types.Status.OK:
      raise Exception('error {}'.format(Types.Status(status)))
