Reven API Cookbook
==================

[Rendered Cookbook](https://tetrane.github.io/api-cookbook/)

## Building the cookbook

The cookbook requires mdbook (v0.4.13) and mdbook-tera (v0.4.0)

To install the pre-requisites:

```
cargo install --version "0.4.13" mdbook
cargo install --version "0.4.0" mdbook-tera
```

Then, the book can be built using:

```
mdbook build
cp -r static/ book/
```

## Serving the cookbook while modifying it

```
mdbook serve
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)

## License

[X11](./LICENSE)

## Using bulma in code

[Bulma 0.9.3](https://bulma.io) is available in md files, and is "bridged" using [Tera](https://tera.netlify.app) [macros](https://tera.netlify.app/docs/#macros).

The macros are documented in [MACROS.md](./MACROS.md)

## Generating the bulma.css file

The `bulma.css` file has been generated with the following command:

```bash
sass-rs < main.scss > bulma.css
```

from the root directory. Other sass generators can also be used.

Note that since the file is included in the repository, it shouldn't be necessary to re-generate it prior to building the mdbook.
