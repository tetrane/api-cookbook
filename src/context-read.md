# Reading values from registers or memory

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div>
</div>

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
ctx.read(LogicalAddress(0xffffe00041cac2ea), Array(U8, 4))
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
