{% import "templates/bulma.tera" as bulma %}

# Reading values or structs from registers or memory

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[bulma::reven_version(version="v2.2.0")]) }}
{{ bulma::end_bulma() }}

## Common imports for easy access

```py
from reven2.address import LinearAddress, LogicalAddress, LogicalAddressSegmentIndex, PhysicalAddress
from reven2.arch import x64 as regs
from reven2.types import *
```

## Getting the current ring

```py
def current_ring(ctx):
    return ctx.read(regs.cs) & 3
```

## Reading as a type

### Integer types

```py
ctx.read(regs.rax, U8)
ctx.read(regs.rax, U16)
ctx.read(regs.rax, I16)
ctx.read(regs.rax, BigEndian(U16))
```

Sample output:

```py
96
35680
-29856
24715
```

### String

```py
ctx.read(LogicalAddress(0xffffe00041cac2ea), CString(encoding=Encoding.Utf16,
                                                     max_character_count=1000))
```

Sample output:

```py
u'Network Store Interface Service'
```

### Array

```py
list(ctx.read(LogicalAddress(0xffffe00041cac2ea), Array(U8, 4)))
```

Sample output:

```py
[78, 0, 101, 0]
```

### Dereferencing pointers, reading the stack

Reading `[rsp+0x20]` manually:

```py
addr = LogicalAddress(0x20) + ctx.read(regs.rsp, USize)
ctx.read(addr, U64)
```

Reading `[rsp+0x20]` using `deref`:

```py
ctx.deref(regs.rsp, Pointer(U64, base_address=LogicalAddress(0x20)))
```

Sample output:

```py
10738
```

### Reading struct values

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
    bulma::reven_version(version="v2.11.0"),
    bulma::windows_tag(),
    bulma::windows_32_tag(),
    ])
}}
{{ bulma::end_bulma() }}

Getting a `struct` type from a binary:

```py
object_attributes_ty = next(server.ossi.executed_binaries("ntoskrnl")).exact_type("_OBJECT_ATTRIBUTES")
```

Sample output of printing `object_attributes_ty`:

```
StructKind.Struct _OBJECT_ATTRIBUTES /* 0x30 */ {
    /* 0x0 */ Length : U32,
    /* 0x8 */ RootDirectory : void*,
    /* 0x10 */ ObjectName : _UNICODE_STRING*,
    /* 0x18 */ Attributes : U32,
    /* 0x20 */ SecurityDescriptor : void*,
    /* 0x28 */ SecurityQualityOfService : void*,
}
```

Reading a struct instance from a source (register, memory, etc):

```py
# Reading structure from pointer stored in r8
object_attributes = ctx.read(reven2.address.LogicalAddress(0xffffe00041cac2ea), object_attributes_ty)

# Read one field according to declared type
object_attributes.field("Length").read()
```

Sample output:

```py
48
```

You can also:

```py
# Read one field, forcing its type to int-like. Useful for IDE type hints
object_attributes.field("Attributes").read_int()

# Get whole struct content as bytes
object_attributes.as_bytes()

# Dereferences a pointer-like field, read it as an inner struct, display its type
print(object_attributes.field("ObjectName").deref_struct().type)
```

Sample output:

```py
0
b'0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x98\xd1]\x06\x00\x00\x00\x00B\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
StructKind.Struct _UNICODE_STRING /* 0x10 */ {
    /* 0x0 */ Length : U16,
    /* 0x2 */ MaximumLength : U16,
    /* 0x8 */ Buffer : U16*,
}
```

### Parsing a raw buffer as a type

```py
U16.parse(b"\x10\x20")
BigEndian(U16).parse(b"\x10\x20")
Array(U8, 2).parse(b"\x10\x20")
```

Sample output:

```py
8208
4128
[16, 32]
```
