{% import "templates/bulma.tera" as bulma %}

# Managing bookmarks

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.5.0"),
    ]) }}

    {{ bulma::related_examples(examples=[
        bulma::link(name="Export bookmarks", url="../examples-book/analyze/report/export_bookmarks.html"),
        bulma::link(name="Bookmarks to WinDbg breakpoints", url="../examples-book/analyze/bk2bp.html"),
        bulma::link(name="Import classic bookmarks", url="../examples-book/analyze/migration/import_bookmarks.html"),
    ]) }}
{{ bulma::end_bulma() }}

## Working with bookmarks starting with a specific "tag"

Let's consider only bookmarks whose description starts with `"auto"`.

### Adding

```py
for i in range(0, 100):
    server.bookmarks.add(server.trace.transition(i), f"auto: {i}")
```

### Listing

```py
for bookmark in server.bookmarks.all():
    if not bookmark.description.startswith("auto"):
        continue
    print(bookmark)
```

### Removing

```py
server.bookmarks.remove_if(lambda bookmark: bookmark.description.startswith("auto:"))
```
