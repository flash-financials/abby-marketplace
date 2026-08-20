#!/bin/sh
#
# Install abbycli.
#
#   curl -fsSL https://marketplace.abby.fm/install.sh | sh
#   curl -fsSL .../install.sh | sh -s -- v1.0.0     # pin a version instead of latest
#
# Also published as a release asset, for a network that reaches github.com but
# not the marketplace domain:
#
#   curl -fsSL https://github.com/flash-financials/abbycli-dist/releases/latest/download/install.sh | sh
#
# Binaries keep coming from GitHub releases either way — the domain serves the
# repository's files, not its release assets.
#
# Installs to ~/.abby/bin (override with ABBY_INSTALL_DIR).
#
# Releases live in a PUBLIC repository, separate from the private source repo,
# so a plain curl works with no GitHub account, no gh and no token. Point
# ABBY_RELEASE_REPO somewhere else to install from a fork or a staging repo.
#
# Windows has no curl|sh route: download the .zip for your platform from the
# releases page and put abbycli.exe on PATH yourself.

set -eu

REPO="${ABBY_RELEASE_REPO:-flash-financials/abbycli-dist}"
VERSION="${1:-latest}"
INSTALL_DIR="${ABBY_INSTALL_DIR:-$HOME/.abby/bin}"
BASE="https://github.com/${REPO}/releases"

fail() {
	echo "install.sh: $*" >&2
	exit 1
}

detect_os() {
	case "$(uname -s)" in
	Darwin) echo darwin ;;
	Linux) echo linux ;;
	MINGW* | MSYS* | CYGWIN*)
		fail "Windows isn't supported by this script — download the .zip directly from ${BASE}"
		;;
	*) fail "unsupported OS: $(uname -s)" ;;
	esac
}

detect_arch() {
	case "$(uname -m)" in
	x86_64 | amd64) echo amd64 ;;
	arm64 | aarch64) echo arm64 ;;
	*) fail "unsupported architecture: $(uname -m)" ;;
	esac
}

# verify_checksum runs from inside the directory holding both the archive and
# SHA256SUMS, so the filename inside SHA256SUMS resolves relative to cwd.
# macOS ships shasum, not sha256sum; Linux is normally the other way around —
# try both rather than assume one.
verify_checksum() {
	archive="$1"
	if command -v sha256sum >/dev/null 2>&1; then
		grep " ${archive}\$" SHA256SUMS | sha256sum -c -
	elif command -v shasum >/dev/null 2>&1; then
		grep " ${archive}\$" SHA256SUMS | shasum -a 256 -c -
	else
		fail "neither sha256sum nor shasum is available to verify the download"
	fi
}

os="$(detect_os)"
arch="$(detect_arch)"
archive="abbycli_${os}_${arch}.tar.gz"

# Asset names carry no version, so /releases/latest/download resolves without
# knowing the version first, and a pinned tag serves the same names.
if [ "$VERSION" = "latest" ]; then
	url_base="${BASE}/latest/download"
else
	url_base="${BASE}/download/${VERSION}"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Downloading ${archive} (${VERSION})..."
curl -fsSL "${url_base}/${archive}" -o "${tmp_dir}/${archive}" \
	|| fail "download failed — check that ${VERSION} exists at ${BASE}"
curl -fsSL "${url_base}/SHA256SUMS" -o "${tmp_dir}/SHA256SUMS" \
	|| fail "could not download SHA256SUMS for ${VERSION}"

echo "Verifying checksum..."
(cd "$tmp_dir" && verify_checksum "$archive") || fail "checksum verification failed — the download may be corrupt"

mkdir -p "$INSTALL_DIR"
tar -xzf "${tmp_dir}/${archive}" -C "$tmp_dir"
mv "${tmp_dir}/abbycli" "${INSTALL_DIR}/abbycli"
chmod +x "${INSTALL_DIR}/abbycli"

echo "Installed abbycli to ${INSTALL_DIR}/abbycli"

# Name the actual rc file rather than showing an example: "add it to your PATH"
# is easy to skim past right after a success line, and then every command in the
# docs fails for a reason the user has already scrolled past. The plugin itself
# resolves the binary without PATH, so this is about the commands you type.
case ":${PATH}:" in
*":${INSTALL_DIR}:"*) ;;
*)
	case "$(basename "${SHELL:-sh}")" in
	zsh) rc="${ZDOTDIR:-$HOME}/.zshrc" ;;
	bash) rc="$HOME/.bashrc" ;;
	fish) rc="$HOME/.config/fish/config.fish" ;;
	*) rc="your shell's startup file" ;;
	esac
	echo
	echo "ONE MORE STEP: ${INSTALL_DIR} is not on your PATH, so typing \`abbycli\`"
	echo "will not work. Run:"
	echo
	if [ "${rc}" = "$HOME/.config/fish/config.fish" ]; then
		echo "  fish_add_path ${INSTALL_DIR}"
	else
		echo "  echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ${rc} && . ${rc}"
	fi
	echo
	;;
esac
