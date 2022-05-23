{% import "templates/bulma.tera" as bulma %}

# Managing ranges of memory

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
    bulma::reven_version(version="v2.11.0"),
    ])
}}
{{ bulma::end_bulma() }}

A range of memory is a very common concept. Storing, updating, merging or iterating on such ranges are operations that are likely to be necessary to users of the REVEN API. 

REVEN provides a "canonical" implementation in the API that spares users from having to deal with multiple reimplementations.

## Creating & updating memory ranges

```py
import reven2.memory_range as mr

# First range
r1 = mr.MemoryRange(reven2.address.LogicalAddress(0x1000), 0x1000)
# This range will overlap with previous one
r2 = mr.MemoryRange(reven2.address.LogicalAddress(0x1500), 0x1000)
# This range does not overlap
r3 = mr.MemoryRange(reven2.address.LogicalAddress(0x5000), 0x1000)

print(r1)
# Union is non-empty
print(r1.union(r2))
# Union is empty
print(r1.union(r2).union(r3))
```

Sample output:

```
[ds:0x1000; 4096]
[ds:0x1000; 5376]
None
```

## Translating a range of virtual addresses

Users might need to access the physical addresses of a buffer. However, a range of memory may be mapped onto non-contiguous physical pages, rendering the conversion error-prone.

The `MemoryRange` object offers a translation method that is guaranteed to be correct.

```py
virtual_range = mr.MemoryRange(reven2.address.LogicalAddress(0x10000), 0x2000)
for phy in virtual_range.translate(ctx): print(phy)
```

Sample output:

```
[phy:0x59ce000; 4096]
[phy:0x764f000; 4096]
```


{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="This is the only recommended path", class="is-note") }}
<p>
    As mentioned above, it is easy to get the translation wrong: while translating a virtual address into physical address is valid, translating a whole buffer is more complex. Please use the MemoryRange object for this purpose.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}

## Working with mulitple ranges

The API provides object to manage mutiple ranges, depending on the situation

### Set of ranges

```py
# First range
r1 = mr.MemoryRange(reven2.address.LogicalAddress(0x1000), 0x1000)
# This range will overlap with previous one
r2 = mr.MemoryRange(reven2.address.LogicalAddress(0x1500), 0x1000)
# This range does not overlap
r3 = mr.MemoryRange(reven2.address.LogicalAddress(0x5000), 0x1000)

# Range that overlap are merged
s = mr.MemoryRangeSet([r1, r2, r3])
for r in s: print(r)
```

Sample output:

```
[ds:0x1000; 5376]
[ds:0x5000; 4096]
```
### Map of ranges

Maps of ranges are useful to associate data with these memory ranges. For example, you might want to associate buffers with a particular named source.

```py
mem_map = mr.MemoryRangeMap(items=((r1, "from r1"), (r2, "from r2"), (r3, "from r3")),
                            # Do not handle subtraction:
                            subtract=lambda a: None,        
                            # Concatenate strings on merge:
                            merge=lambda a, b: a + ", " + b)
for r, source in mem_map: print(r, source)
```

Sample output:

```
[ds:0x1000; 1280] from r1
[ds:0x1500; 2816] from r1, from r2
[ds:0x2000; 1280] from r2
[ds:0x5000; 4096] from r3
```
