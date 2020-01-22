# Contribute to Taurus

## Code
To follow.

## Documentation
We welcome documentation contributions. You can view our documentation at [nearform.github.io/taurus][docs]

### Run the Documentation Locally
You can run our documentation by serving the `docs` folder at a given port. If you have node installed you can use the `docsfiy-cli`.
To install node, use a command console to enter the following command:
```sh
npm install -g docsify-cli
```

From the root folder on a command console, enter the command:

```sh
docsify serve docs
```

This displays the following:

```sh
Serving /path/to/your/repo/taurus/docs now.
Listening at http://localhost:3000
```

The documentation is served on `localhost:3000`.

#### Serve in Other Ways
Our documentation builds on the fly. This means all you need to do is serve the `docs` folder. Any program or CLI tool used for serving a folder works - __as long as it can handle hash routing__.

Another module to serve files is `serve` on npm. To install node, use a command console to enter the following command:

```sh
npm install -g docsify-cli
```

From the root folder on a command console, enter the following command (with hash router support):

```sh
npx serve -s -l 4000 docs
```

This displays the following:

```
 ┌──────────────────────────────────────────────────┐
 │                                                  │
 │   Serving!                                       │
 │                                                  │
 │   - Local:            http://localhost:4000      │
 │   - On Your Network:  http://192.168.1.60:4000   │
 │                                                  │
 │   Copied local address to clipboard!             │
 │                                                  │
 └──────────────────────────────────────────────────┘
```

The documentation is served on `localhost:4000` in this case.

[docs]:https://nearform.github.io/taurus
