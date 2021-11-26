{% import "templates/bulma.tera" as bulma %}

# Searching for function calls

## Looking for an exact symbol name

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

```py
symbol_name = "CreateProcessW"
try:
    symbol = next(server.ossi.symbols(f"^{symbol_name}$",
                                      binary_hint=r'kernelbase\.dll'))
except StopIteration:
    raise RuntimeError(f"Could not find symbol '{symbol_name}'")
for ctx in server.trace.search.symbol(symbol):
    print(ctx)
```

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Handling of the case where the symbol is not in the trace", class="is-warning") }}
<p>
    When looking for an <strong>exact</strong> symbol, you need to prepare for the case where the symbol is not available in the trace. Note that a symbol can be available <emph>even if it is never called</emph>.
</p>
<p>
    In the example, it manifests with the iterator having no element, which raises a <code>StopIteration</code>, that we catch and then convert to a more specific error.
</p>
{{ bulma::end_message() }}

{{ bulma::begin_message(header="Symbol pattern is a regular expression", class="is-warning") }}
<p>
    When looking for a <strong>single, exact</strong> symbol, you need to enclose the symbol's name
    in the pattern with <code>^$</code> because the pattern is actually a
    regular expression. Failure to do that could result in several matching
    symbols, with the risk that the rest of your code actually chooses the
    wrong one.
</p>
{{ bulma::end_message() }}

{% set file_activity = bulma::link(name="File activity", url="https://github.com/tetrane/reven2-file-activity") %}

{{ bulma::related_examples(examples=[
  "(GitHub)" ~ file_activity,
]) }}

{{ bulma::end_bulma() }}

## Looking for multiple symbols

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

The example provides an iterator of the tuples where the first element is the context of the call, and the second the name of the called symbol.

```py
from itertools import repeat

def first_symbol(symbol_name):
    return next(server.ossi.symbols(f"^{symbol_name}$", binary_hint=binary))


binary = "c:/windows/system32/ntoskrnl.exe"
symbols = ['NtCreateFile', 'NtOpenFile', 'NtOpenDirectoryObject']

symbols_name = [(first_symbol(symbol), symbol) for symbol in symbols]

symbols_name = [zip(server.trace.search.symbol(symbol[0]),
                    repeat(symbol[1])) for symbol in symbols_name]

for ctx_name in reven2.util.collate(symbols_name, lambda ctx_name: ctx_name[0]):
    print(f"{ctx_name[1]}: {ctx_name[0]}")
```

Sample output:

```
NtCreateFile: Context before #4468509
NtCreateFile: Context before #4479526
NtCreateFile: Context before #6451786
NtCreateFile: Context before #6852400
NtCreateFile: Context before #7666717
NtCreateFile: Context before #8067013
NtCreateFile: Context before #8298671
NtCreateFile: Context before #8648240
NtOpenFile: Context before #26656294
NtCreateFile: Context before #35251786
NtOpenFile: Context before #36420358
NtOpenFile: Context before #43268534
NtOpenDirectoryObject: Context before #43420816
NtOpenFile: Context before #43450170
```

{{ bulma::begin_bulma() }}
{{ bulma::related_examples(examples=[
  bulma::link(name="Thread synchronization", url=user_doc_root ~ "/examples-book/analyze/report/threadsync.html"),
  bulma::link(name="Detect data race", url=user_doc_root ~ "/examples-book/analyze/vulnerability_detection/detect_data_race.html")
]) }}
{{ bulma::end_bulma() }}
