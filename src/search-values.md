# Searching for values in memory

## Searching for values in a range of memory at a single context

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.6.0</span>
    </div>
  </div>
</div>

  <div class="message is-link">
     <div class="message-header">
         Related examples
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li><a href="../examples-book/analyze/network/network_packet_tools.html">Network packet tools</a></li>
            <li><a href="../examples-book/analyze/network/dump_pcap.html">Dump PCAP</a></li>
            <li><a href="../examples-book/analyze/vulnerability_detection/detect_use_of_uninitialized_memory.html">Detect use of uninitialized memory</a></li>
        </ul>
     </div>
  </div>
</div>

If the value you are looking for might be in a range of memory at a specific point in the trace, you can search it with the following:

```py
pattern = bytearray([0x77, 0x43])
for match_address in ctx.search_in_memory(pattern,
                                          ctx.read(regs.rsp), 0x1000000):
     print(f"'{pattern}' is found starting at @{match_address}")
```

## Searching for string-like values accessed in the trace

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

If the value you are looking for looks like a string indexed by the strings resource (defaults to strings of printable characters of length 5-128, possibly UTF-16 encoded), then you can use the strings search API, which will be the fastest way:

```py
for string in server.trace.strings("Network")):
    for access in string.memory_accesses(from_tr, to_tr):
        print(access)
```

<div class="bulma">
  <div class="message is-info">
     <div class="message-header">
         Unaccessed values are not found by this method
     </div>
     <div class="message-body content">
         <p>
         This method only finds values in memory that are <strong>accessed</strong> (read from, written to) during the portion of the trace where the search takes place.
         </p>
         <p>
         If you don't know if your value is accessed in the trace, you can associate this method with a <a href="#searching-for-values-in-a-range-of-memory-at-a-single-context">search in memory at a context</a>.
         </p>
     </div>
  </div>
</div>


## Searching for other kinds of values accessed in the trace

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.6.0</span>
    </div>
  </div>
</div>
</div>

```py
for match in search.memory(b"\xc0\xfc\x75\x02", from_ctx, to_ctx).matches():
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

<div class="bulma">
  <div class="message is-info">
     <div class="message-header">
         Unaccessed values are not found by this method
     </div>
     <div class="message-body content">
         <p>
         This method only finds values in memory that are <strong>accessed</strong> (read from, written to) during the portion of the trace where the search takes place.
         </p>
         <p>
         If you don't know if your value is accessed in the trace, you can associate this method with a <a href="#searching-for-values-in-a-range-of-memory-at-a-single-context">search in memory at a context</a>.
         </p>
     </div>
  </div>
</div>
