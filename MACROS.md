The macros are defined in [src/templates/bulma.tera](./src/templates/bulma.tera)

# Using macros

To use macros in a file, the following statement should be the first line of the file:

```
{% import "templates/bulma.tera" as bulma %}
```

Otherwise, Tera will complain:

```
Failed to render 'taint.md'

Caused by:
    Macro namespace `bulma` was not found in template `taint.md`. Have you maybe forgotten to import it, or misspelled it?
2021-10-27 12:38:57 [ERROR] (mdbook::utils): Error: The "tera" preprocessor exited unsuccessfully with exit status: 1 status
```

If the statement is not at the very beginning of the file, Tera will also complain:

```
Failed to parse 'taint.md'

Caused by:
     --> 3:1
      |
    3 | {% import "templates/bulma.tera" as bulma %}␊
      | ^---
      |
      = unexpected tag; expected end of input or some content
```

Because bulma is not seamlessly integrated with mdbook, we must use the bulma classes inside of a bulma environment.
To do so, enclose bulma macros invocations (and raw usages of bulma classes in HTML) with invocations to the `begin_bulma` and `end_bulma` macros:

```
{{ bulma::begin_bulma() }}

{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.6.0"),
  bulma::preview_tag(),
]) }}

{{ bulma::related_examples(examples=[
  bulma::link(name="Use-after-Free vulnerabilities detection", url="../examples-book/analyze/vulnerability_detection/detect_use_after_free.html"),
  bulma::link(name="Searching for Buffer-Overflow vulnerabilities", url="../examples-book/analyze/vulnerability_detection/detect_buffer_overflow.html"),
  bulma::link(name="Searching for Use-of-Uninitialized-Memory vulnerabilities", url="../examples-book/analyze/vulnerability_detection/detect_use_of_uninitialized_memory.html"),
]) }}

{{ bulma::end_bulma() }}
``` 
