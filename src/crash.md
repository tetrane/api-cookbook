{% import "templates/bulma.tera" as bulma %}

# Looking for a crash


## System crashes

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
  bulma::windows_tag()
]) }}
{{ bulma::end_bulma() }}

[Look for the symbol](./search-calls.md#looking-for-an-exact-symbol-name) `KeBugCheckEx` in `ntoskrnl`:

```py
crash_symbol = next(server.ossi.symbols("^KeBugCheckEx$",
                                        binary_hint="ntoskrnl"))
for ctx in server.trace.search.symbol(crash_symbol):
    print(f"System crash at {ctx}")
```

{{ bulma::begin_bulma() }}
{{ bulma::related_examples(examples=[
  bulma::link(name="Crash detection", url=user_doc_root ~ "/examples-book/analyze/report/crash_detection.html")
]) }}
{{ bulma::end_bulma() }}

## Process crashes

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.3.0"),
  bulma::windows_tag(),
]) }}
{{ bulma::end_bulma() }}

[Look for the symbol](./search-calls.md#looking-for-an-exact-symbol-name) `KiUserExceptionDispatch` in `ntdll`:

```py
crash_symbol = next(server.ossi.symbols("^KiUserExceptionDispatch$",
                                        binary_hint="ntdll"))
for ctx in server.trace.search.symbol(crash_symbol):
    process = ctx.ossi.process()
    print(f"{process.name} crashed at {ctx}")
```

{{ bulma::begin_bulma() }}
{{ bulma::related_examples(examples=[
  bulma::link(name="Crash detection", url=user_doc_root ~ "/examples-book/analyze/report/crash_detection.html")
]) }}
{{ bulma::end_bulma() }}
