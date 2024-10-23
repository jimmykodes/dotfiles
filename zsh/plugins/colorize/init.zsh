DEFAULT_STYLE=lovelace

ccat() {
	chroma --style "${CHROMA_STYLE:-$DEFAULT_STYLE}" "$@"
}
