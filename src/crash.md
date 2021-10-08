# Looking for a crash


## System crashes

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">OS</span>
      <span class="tag is-primary icon-text">
        <span class="icon"><i class="fa fa-windows" aria-hidden="true"></i></span>
        <span>Windows 64-bit</span>
      </span>
    </div>
  </div>
</div>
</div>

[Look for the symbol](./search-calls.md#looking-for-an-exact-symbol-name) `KeBugCheckEx` in `ntoskrnl`:

```py
crash_symbol = next(server.ossi.symbols("^KeBugCheckEx$",
                                        binary_hint="ntoskrnl"))
for ctx in server.trace.search.symbol(crash_symbol):
    print(f"System crash at {ctx}")
```

<div class="bulma">
  <div class="message is-link">
     <div class="message-header">
         Related example
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li><a href="../examples-book/analyze/report/crash_detection.html">Crash detection</a></li>
        </ul>
     </div>
  </div>
</div>

## Process crashes

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.3.0</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">OS</span>
      <span class="tag is-primary icon-text">
        <span class="icon"><i class="fa fa-windows" aria-hidden="true"></i></span>
        <span>Windows 64-bit</span>
      </span>
    </div>
  </div>
</div>
</div>

[Look for the symbol](./search-calls.md#looking-for-an-exact-symbol-name) `KiUserExceptionDispatch` in `ntdll`:

```py
crash_symbol = next(server.ossi.symbols("^KiUserExceptionDispatch$",
                                        binary_hint="ntdll"))
for ctx in server.trace.search.symbol(crash_symbol):
    process = ctx.ossi.process()
    print(f"{process.name} crashed at {ctx}")
```

<div class="bulma">
  <div class="message is-link">
     <div class="message-header">
         Related example
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li><a href="../examples-book/analyze/report/crash_detection.html">Crash detection</a></li>
        </ul>
     </div>
  </div>
</div>
