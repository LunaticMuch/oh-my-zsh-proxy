# zsh-proxy

An [`oh-my-zsh`](https://ohmyz.sh/) plugin to configure proxy.

## Features

- ZSH proxy with standard variables (HTTP_PROXY, HTTPS_PROXY, NO_PROXY, FTP_PROXY)
- GIT proxy (global configuration)
- NPM & YARN proxy
- NPM & YARN custom registry within a proxy environment

## Installation

### oh-my-zsh

Firstly, clone this repository in `oh-my-zsh`'s plugins directory.

```bash
git clone git clone https://github.com/LunaticMuch/zsh-proxy.git  ~/.oh-my-zsh/custom/plugins/zsh-proxy
```

Secondly, activate the plugin in `~/.zshrc`. Enable it by adding `zsh-proxy` to the [plugins array](https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template#L66).

```bash
plugins=(
    [plugins
     ...]
    zsh-proxy
)
```
----

Congratulations! Open a new terminal or run `source $HOME/.zshrc`. If you see following lines, you have successfully installed `zsh-proxy`:

```
----------------------------------------
You should run following command first:
$ init_proxy
----------------------------------------
```

## Usage

### `init_proxy`

The tip mentioned below will show up next time you open a new terminal if you haven't  initialized the plugin with `init_proxy`.

After you run `init_proxy`, it is time to configure the plugin.

### `config_proxy`

Execute `config_proxy` will lead you to zsh-proxy configuration. Fill in socks5 & http proxy address in format `address:port` like `127.0.0.1:1080` & `127.0.0.1:8080`.

Default configuration of socks5 proxy is `127.0.0.1:1080`, and http proxy is `127.0.0.1:8080`. You can leave any of them blank during configuration to use their default configuration.

Currently `zsh-proxy` doesn't support proxy with authentication, but I am working on it.

### `proxy`

After you configure the `zsh-proxy`, you are good to go. Try following command will enable proxy for supported package manager & software:

```bash
$ proxy
```

And next time you open a new terminal, zsh-proxy will automatically enable proxy for you.

### `noproxy`

If you want to disable proxy, you can run following command:

```bash
$ noproxy
```

## Configuration files

It is possible at any time to manually change proxy settings on configuration files. The list of configuration files is the following:

- `http_proxy`: http proxy server to be used
- `no_proxy`: list of proxy exclusions, comma separated
- `npm_repo`: custom npm repository to be activated in proxy enviroment

## Uninstallation

**If you install `zsh-proxy` with oh-myzsh**, you need to remove `zsh-proxy` item from plugin array, then run `rm -rf ~/.oh-my-zsh/custom/plugins/zsh-proxy` to remove the plugin.

And you can clean up files & folders created by `zsh-proxy` using following command:

```bash
$ rm -rf ~/.zsh-proxy
```

## Todo List

To be defined

## Author(s)

This is an implementation done by [Stefano Cislaghi](https://stefanocislaghi.com/) based on [Sukka](https://github.com/SukkaW) [zsh-proxy](https://github.com/SukkaW/zsh-proxy)


