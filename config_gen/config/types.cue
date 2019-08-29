package config

import (
  "strings"
)

_MODULE: {
  field_prefix: string
  code: bool | *true
  core: bool | *false
  i2c: bool | *false
  array_len: int | *0
  fields: {}
}

_CORE_MODULE: _MODULE & {
  core: true
}

_I2C_MODULE: _MODULE & {
  i2c: true
}

_FIELD: {
  type: "string" | "integer"
  nvs: {
    enable: bool | *false
    key: string if enable == true
  }
  ble: {
    enable: bool | *false
    uuid: string if enable == true
    write: bool | *false if enable == true
    notify: bool | *true if enable == true
    no_sync: bool | *false if enable == true
  }
  http: {
    enable: bool | *false
    write: bool | *false if enable == true
  }
  write_cb: bool | *false
}

_STRING: _FIELD & {
  type: "string"
  default: string | *""
}

_INT: _FIELD & {
  type: "integer"
  intlen: int
  default: int if _default_var == null
  default_var: string | *_default_var if _default_var != null
  _default_var: string | *null
}

_INT8: _INT & {
  intlen: 8
}

_INT16: _INT & {
  intlen: 16
}

_INT32: _INT & {
  intlen: 32
}

_NVS: {
  nvs: _FIELD.nvs & {
    enable: true
  }
}

_BLE: {
  ble: _FIELD.ble & {
    enable: true
  }
}

_BLE_RW: {
  ble: _BLE.ble & {
    write: true
  }
}

_HTTP: {
  http: _FIELD.http & {
    enable: true
  }
}

_HTTP_RW: {
  http: _HTTP.http & {
    write: true
  }
}

modules <Module>: {
  name: string | *Module
  field_prefix: string | *Module
}

modules <Module> fields <Field>: {
  name: string | *"\(modules[Module].field_prefix)_\(Field)"
  caps_name: string | *strings.ToUpper(name)
  nvs key: string | *caps_name if modules[Module].fields[Field].nvs.enable
}
