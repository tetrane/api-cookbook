{% import "templates/bulma.tera" as bulma %}

# Finding out when a memory location is accessed

## Getting all the memory accesses of a range of addresses

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

```py
for access in server.trace.memory_accesses(0xffff88007fc03000, 4096):
    print(access)
```

Sample output:

```
[#39 call 0xffffffff81611fe0 ($+0x165133)]Write access at @phy:0x7fc03ec8 (virtual address:
        lin:0xffff88007fc03ec8) of size 8
[#41 call qword ptr [0xffffffff81c24448]]Write access at @phy:0x7fc03ec0 (virtual address:
        lin:0xffff88007fc03ec0) of size 8
[#42 push rdx]Write access at @phy:0x7fc03eb8 (virtual address: lin:0xffff88007fc03eb8) of size 8
[#48 pop rdx]Read access at @phy:0x7fc03eb8 (virtual address: lin:0xffff88007fc03eb8) of size 8
[#49 ret ]Read access at @phy:0x7fc03ec0 (virtual address: lin:0xffff88007fc03ec0) of size 8
[#51 push rdi]Write access at @phy:0x7fc03ec0 (virtual address: lin:0xffff88007fc03ec0) of size 8
[#52 popfq ]Read access at @phy:0x7fc03ec0 (virtual address: lin:0xffff88007fc03ec0) of size 8
[#54 ret ]Read access at @phy:0x7fc03ec8 (virtual address: lin:0xffff88007fc03ec8) of size 8
[#60 call 0xffffffff814abe30 ($-0x108f)]Write access at @phy:0x7fc03ec8 (virtual address:
        lin:0xffff88007fc03ec8) of size 8
[#62 push r14]Write access at @phy:0x7fc03ec0 (virtual address: lin:0xffff88007fc03ec0) of size 8
```

## Getting all the memory accesses on a range of transitions

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.9.0"),
]) }}
{{ bulma::end_bulma() }}

```py
for access in server.trace.memory_accesses(from_transition=server.trace.transition(1000),
                                    to_transition=server.trace.transition(1010)):
    print(access)
```

Sample output:

```
[#1005 mov qword ptr [rsp+0x40], r14]Write access at @phy:0x6645a9b0
        (virtual address: lin:0xfffffe0ff31db9b0) of size 8
[#1007 mov qword ptr [rsp+0x98], r14]Write access at @phy:0x6645aa08
        (virtual address: lin:0xfffffe0ff31dba08) of size 8
[#1008 or dword ptr [rsp+0x90], 0x2]Read access at @phy:0x6645aa00
        (virtual address: lin:0xfffffe0ff31dba00) of size 4
[#1008 or dword ptr [rsp+0x90], 0x2]Write access at @phy:0x6645aa00
        (virtual address: lin:0xfffffe0ff31dba00) of size 4
```

## Finding the memory accesses at a transition

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

```py
for access in tr.memory_accesses():
    print(access)
```

Sample output:

```
[MemoryAccess(transition=Transition(id=42), physical_address=PhysicalAddress(offset=0x7fc03eb8), size=8,
    operation=MemoryAccessOperation.Write, virtual_address=LinearAddress(offset=0xffff88007fc03eb8))]
```
