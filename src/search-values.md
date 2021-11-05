{% import "templates/bulma.tera" as bulma %}

# Searching for values in memory

## Searching for values in a range of memory at a single context

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
bulma::reven_version(version="v2.6.0")
]) }}

{{ bulma::related_examples(examples=[
  bulma::link(name="Network packet tools", url=user_doc_root ~ "/examples-book/analyze/network/network_packet_tools.html"),
  bulma::link(name="Dump PCAP", url=user_doc_root ~ "/examples-book/analyze/network/dump_pcap.html"),
  bulma::link(name="Detect use of uninitialized memory", url=user_doc_root ~ "/examples-book/analyze/vulnerability_detection/detect_use_of_uninitialized_memory.html"),
]) }}

{{ bulma::end_bulma() }}

If the value you are looking for might be in a range of memory at a specific point in the trace, you can search it with the following:

```py
pattern = bytearray([0x77, 0x43])
for match_address in ctx.search_in_memory(pattern,
                                          ctx.read(regs.rsp), 0x1000000):
     print(f"'{pattern}' is found starting at @{match_address}")
```

## Searching for string-like values accessed in the trace

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
bulma::reven_version(version="v2.2.0")
]) }}
{{ bulma::end_bulma() }}

If the value you are looking for looks like a string indexed by the strings resource (defaults to strings of printable characters of length 5-128, possibly UTF-16 encoded), then you can use the strings search API, which will be the fastest way:

```py
for string in server.trace.strings("Network"):
    for access in string.memory_accesses(from_tr, to_tr):
        print(access)
```

Sample output:

```
[#4653465 mov word ptr [rcx], ax]Write access at @phy:0x18e8252c (virtual address: lin:0x3a252c) of size 2
[#4653475 mov word ptr [rcx], ax]Write access at @phy:0x18e8252e (virtual address: lin:0x3a252e) of size 2
[#4653485 mov word ptr [rcx], ax]Write access at @phy:0x18e82530 (virtual address: lin:0x3a2530) of size 2
[#4653495 mov word ptr [rcx], ax]Write access at @phy:0x18e82532 (virtual address: lin:0x3a2532) of size 2
[#4653505 mov word ptr [rcx], ax]Write access at @phy:0x18e82534 (virtual address: lin:0x3a2534) of size 2
[#4653515 mov word ptr [rcx], ax]Write access at @phy:0x18e82536 (virtual address: lin:0x3a2536) of size 2
[#4653525 mov word ptr [rcx], ax]Write access at @phy:0x18e82538 (virtual address: lin:0x3a2538) of size 2
[#4653535 mov word ptr [rcx], ax]Write access at @phy:0x18e8253a (virtual address: lin:0x3a253a) of size 2
[#4653545 mov word ptr [rcx], ax]Write access at @phy:0x18e8253c (virtual address: lin:0x3a253c) of size 2
[#4653555 mov word ptr [rcx], ax]Write access at @phy:0x18e8253e (virtual address: lin:0x3a253e) of size 2
[#4653565 mov word ptr [rcx], ax]Write access at @phy:0x18e82540 (virtual address: lin:0x3a2540) of size 2
[#4653575 mov word ptr [rcx], ax]Write access at @phy:0x18e82542 (virtual address: lin:0x3a2542) of size 2
[#4653585 mov word ptr [rcx], ax]Write access at @phy:0x18e82544 (virtual address: lin:0x3a2544) of size 2
[#4653595 mov word ptr [rcx], ax]Write access at @phy:0x18e82546 (virtual address: lin:0x3a2546) of size 2
[#4653605 mov word ptr [rcx], ax]Write access at @phy:0x18e82548 (virtual address: lin:0x3a2548) of size 2
[#4653615 mov word ptr [rcx], ax]Write access at @phy:0x18e8254a (virtual address: lin:0x3a254a) of size 2
[#4653625 mov word ptr [rcx], ax]Write access at @phy:0x18e8254c (virtual address: lin:0x3a254c) of size 2
```

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Unaccessed values are not found by this method", class="is-info") }}
<p>
    This method only finds values in memory that are <strong>accessed</strong> (read from, written to) during the portion of the trace where the search takes place.
</p>
<p>
    If you don't know if your value is accessed in the trace, you can associate this method with a <a href="#searching-for-values-in-a-range-of-memory-at-a-single-context">search in memory at a context</a>.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}


## Searching for other kinds of values accessed in the trace

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
bulma::reven_version(version="v2.6.0")
]) }}
{{ bulma::end_bulma() }}

```py
for match in server.trace.search.memory(b"\xc0\xfc\x75\x02", from_ctx, to_ctx).matches():
    print(match)
```

Sample output:

```
id: 0 | @lin:0xab600 (mapped at Context before #5665813) | [Context before #5665813 - Context after #16899165] | 1 access(es)
id: 1 | @lin:0xbadf0 (mapped at Context before #5666826) | [Context before #5666826 - Context after #16899165] | 1 access(es)
id: 2 | @lin:0xac810 (mapped at Context before #5666966) | [Context before #5666966 - Context before #6141251] | 1 access(es)
id: 3 | @lin:0xb0935 (mapped at Context before #6140550) | [Context before #6140550 - Context after #16899165] | 1 access(es)
id: 4 | @lin:0xab790 (mapped at Context before #6143172) | [Context before #6143172 - Context after #16899165] | 1 access(es)
id: 5 | @lin:0xffffe0016aec9800 (mapped at Context before #6144279) | [Context before #6144279 - Context before #6379441] | 2 access(es)
id: 6 | @lin:0xffffe0016a7accc0 (mapped at Context before #6152909) | [Context before #6152909 - Context before #6372050] | 1 access(es)
id: 7 | @lin:0xc7e605 (mapped at Context before #6218204) | [Context before #6218204 - Context after #16899165] | 15 access(es)
id: 8 | @lin:0xc67780 (mapped at Context before #6235773) | [Context before #6235773 - Context after #16899165] | 10 access(es)
id: 9 | @lin:0x29feb26 (mapped at Context before #6360085) | [Context before #6360085 - Context before #6360107] | 2 access(es)
id: 10 | @lin:0x29feb26 (mapped at Context before #6360108) | [Context before #6360108 - Context before #6360254] | 3 access(es)
id: 11 | @lin:0x29feb26 (mapped at Context before #6360255) | [Context before #6360255 - Context after #16899165] | 2 access(es)
id: 12 | @lin:0x29feb06 (mapped at Context before #6360265) | [Context before #6360265 - Context before #6360264] | 0 access(es)
id: 13 | @lin:0x29feb06 (mapped at Context before #6360265) | [Context before #6360265 - Context after #16899165] | 2 access(es)
id: 14 | @lin:0x29fe946 (mapped at Context before #6360440) | [Context before #6360440 - Context before #6360439] | 0 access(es)
id: 15 | @lin:0x29fe946 (mapped at Context before #6360440) | [Context before #6360440 - Context before #6360458] | 2 access(es)
```

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Unaccessed values are not found by this method", class="is-info") }}
<p>
    This method only finds values in memory that are <strong>accessed</strong> (read from, written to) during the portion of the trace where the search takes place.
</p>
<p>
    If you don't know if your value is accessed in the trace, you can associate this method with a <a href="#searching-for-values-in-a-range-of-memory-at-a-single-context">search in memory at a context</a>.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}
