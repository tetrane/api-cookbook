{% import "templates/bulma.tera" as bulma %}

# Accessing handles

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
    bulma::reven_version(version="v2.11.0"),
    bulma::windows_tag(),
    ])
}}
{{ bulma::end_bulma() }}

## Listing the file handles owned by the process

```py
# Focus on process handles, ignore the rest
for h in ctx.handles(kernel_handles = False, special_handles = False):
    try:
        # Request FileObject handles only, otherwise raise exception
        o = h.object(win.FileObject)
    except ValueError:
        continue
    print(f"{h}: {o.filename_with_device}")
```

Sample output:

```
Handle 0x4 (object: lin:0xffffc8016fc2c760): \Device\ConDrv\Reference
Handle 0x44 (object: lin:0xffffc8016fa92810): \Device\HarddiskVolume2\reven
Handle 0x48 (object: lin:0xffffc8016fa94a70): \Device\ConDrv\Connect
Handle 0x50 (object: lin:0xffffc8016fa921d0): \Device\ConDrv\Input
Handle 0x54 (object: lin:0xffffc8016fa91eb0): \Device\ConDrv\Output
Handle 0x58 (object: lin:0xffffc8016fa91eb0): \Device\ConDrv\Output
Handle 0xa4 (object: lin:0xffffc8016f8e3b00): \Device\HarddiskVolume2\reven\output
```

## Getting a handle by value

```py
h = ctx.handle(0xa4)
print(h.object())
```

Sample output:

```
File object "\Device\HarddiskVolume2\reven\output" (lin:0xffffc8016f8e3b00)
```
