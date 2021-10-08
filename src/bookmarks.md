# Managing bookmarks

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.5.0</span>
    </div>
  </div>
</div>
  <div class="message is-link">
     <div class="message-header">
         Related examples
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li><a href="../examples-book/analyze/report/export_bookmarks.html">Export bookmarks</a></li>
            <li><a href="../examples-book/analyze/bk2bp.html">Bookmarks to WinDbg breakpoints</a></li>
            <li><a href="../examples-book/analyze/migration/import_bookmarks.html">Import classic bookmarks</a></li>
        </ul>
     </div>
  </div>

</div>

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
