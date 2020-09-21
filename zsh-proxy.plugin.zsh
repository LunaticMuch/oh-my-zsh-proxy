__read_proxy_config() {
	__ZSHPROXY_STATUS=$(cat "${HOME}/.zsh-proxy/status")
	__ZSHPROXY_HTTP=$(cat "${HOME}/.zsh-proxy/http")
	__ZSHPROXY_NO_PROXY=$(cat "${HOME}/.zsh-proxy/no_proxy")
	__ZSHPROXY_NPM_REGISTRY=$(cat "${HOME}/.zsh-proxy/npm_registry")
}

__check_whether_init() {
	if [ ! -f "${HOME}/.zsh-proxy/status" ] || [ ! -f "${HOME}/.zsh-proxy/http" ] || [ ! -f "${HOME}/.zsh-proxy/no_proxy" ]; then
		echo "----------------------------------------"
		echo "You should run following command first:"
		echo "$ init_proxy"
		echo "----------------------------------------"
	else
		__read_proxy_config
	fi
}

__config_proxy() {
	echo "========================================"
	echo "ZSH Proxy Plugin Config"
	echo "----------------------------------------"

	echo -n "[http proxy]   {Default as 127.0.0.1:8080}
(address:port): "
	read -r __read_http

	echo -n "[no proxy domain] {Default as 'localhost,127.0.0.1,localaddress,.localdomain.com'}
(comma separate domains): "
	read -r __read_no_proxy

	echo "========================================"

	if [ -z "${__read_http}" ]; then
		__read_http="127.0.0.1:8080"
	fi
	if [ -z "${__read_no_proxy}" ]; then
		__read_no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	fi

	echo "http://${__read_http}" >"${HOME}/.zsh-proxy/http"
	echo "${__read_no_proxy}" >"${HOME}/.zsh-proxy/no_proxy"

	__read_proxy_config
}

# ==================================================


# Proxy for terminal

__enable_proxy_shell() {
	# http_proxy
	export http_proxy="${__ZSHPROXY_HTTP}"
	export HTTP_PROXY="${__ZSHPROXY_HTTP}"
	# https_proxy
	export https_proxy="${__ZSHPROXY_HTTP}"
	export HTTPS_PROXY="${__ZSHPROXY_HTTP}"
	# ftp_proxy
	export ftp_proxy="${__ZSHPROXY_HTTP}"
	export FTP_PROXY="${__ZSHPROXY_HTTP}"
	# rsync_proxy
	export rsync_proxy="${__ZSHPROXY_HTTP}"
	export RSYNC_PROXY="${__ZSHPROXY_HTTP}"
	# all_proxy
	export ALL_PROXY="${__ZSHPROXY_SOCKS5}"
	export all_proxy="${__ZSHPROXY_SOCKS5}"
	export no_proxy="${__ZSHPROXY_NO_PROXY}"
}

__disable_proxy_shell() {
	unset http_proxy
	unset HTTP_PROXY
	unset https_proxy
	unset HTTPS_PROXY
	unset ftp_proxy
	unset FTP_PROXY
	unset rsync_proxy
	unset RSYNC_PROXY
	unset ALL_PROXY
	unset all_proxy
	unset no_proxy
}

# Proxy for Git

__enable_proxy_git() {
	git config --global http.proxy "${__ZSHPROXY_HTTP}"
	git config --global https.proxy "${__ZSHPROXY_HTTP}"
}

__disable_proxy_git() {
	git config --global --unset http.proxy
	git config --global --unset https.proxy
}

# NPMŸ
__enable_proxy_npm() {
	if command -v npm >/dev/null; then
		npm config set proxy "${__ZSHPROXY_HTTP}"
		npm config set https-proxy "${__ZSHPROXY_HTTP}"
		npm config set noproxy "${__ZSHPROXY_NO_PROXY}"
		npm config set registry "${__ZSHPROXY_NPM_REGISTRY}"
	fi
	# if command -v yarn >/dev/null; then
	# 	yarn config set proxy "${__ZSHPROXY_HTTP}" >/dev/null 2>&1
	# 	yarn config set https-proxy "${__ZSHPROXY_HTTP}" >/dev/null 2>&1
	# 	yarn config set noproxy "${__ZSHPROXY_NO_PROXY}" >/dev/null 2>&1
	# 	yarn config set registry "${__ZSHPROXY_NPM_REGISTRY}" >/dev/null 2>&1
	# fi
}

__disable_proxy_npm() {
	if command -v npm >/dev/null; then
		npm config delete proxy
		npm config delete https-proxy
		npm config delete noproxy
		npm config delete registry
	fi
	# if command -v yarn >/dev/null; then
	# 	yarn config delete proxy >/dev/null 2>&1
	# 	yarn config delete https-proxy >/dev/null 2>&1
	# 	yarn config delete noproxy >/dev/null 2>&1
	# 	yarn config delete registry >/dev/null 2>&1
	# fi
}

# ==================================================

__enable_proxy() {
	if [ -z "${__ZSHPROXY_STATUS}" ] || [ -z "${__ZSHPROXY_HTTP}" ]; then
		echo "========================================"
		echo "zsh-proxy can not read -r configuration."
		echo "You may have to reinitialize and reconfigure the plugin."
		echo "Use following commands would help:"
		echo "$ init_proxy"
		echo "$ config_proxy"
		echo "$ proxy"
		echo "========================================"
	else
		echo "========================================"
		echo -n "Resetting proxy... "
		#__disable_proxy_all
		#__disable_proxy_git
		#__disable_proxy_npm
		echo "Done!"
		echo "----------------------------------------"
		echo "Enable proxy for:"
		echo "- shell"
		__enable_proxy_shell
		echo "- git"
		__enable_proxy_git
		echo "- npm"
		__enable_proxy_npm
		echo "Done!"
	fi
}

__disable_proxy() {
	__disable_proxy_shell
	__disable_proxy_git
	__disable_proxy_npm
}

__auto_proxy() {
	if [ "${__ZSHPROXY_STATUS}" = "1" ]; then
		__enable_proxy_shell
	fi
}

# ==================================================

init_proxy() {
	mkdir -p "$HOME/.zsh-proxy"
	touch "$HOME/.zsh-proxy/status"
	echo "0" >"${HOME}/.zsh-proxy/status"
	touch "$HOME/.zsh-proxy/http"
	touch "$HOME/.zsh-proxy/no_proxy"
	touch "$HOME/.zsh-proxy/npm_repo"
	echo "----------------------------------------"
	echo "Great! The zsh-proxy is initialized"
}

config_proxy() {
	__config_proxy
}

proxy() {
	echo "1" >"${HOME}/.zsh-proxy/status"
	__enable_proxy
}

noproxy() {
	echo "0" >"${HOME}/.zsh-proxy/status"
	__disable_proxy
}

myip() {
	__check_ip
}

__check_whether_init
__auto_proxy
