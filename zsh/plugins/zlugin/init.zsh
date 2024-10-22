ZLUGIN_PATH="$HOME/.local/share/zsh/zlugin"
[[ -d "$ZLUGIN_PATH" ]] || mkdir -p "$ZLUGIN_PATH"

zlugin_clone() {
	local src repo
	zparseopts -E -D -A opt -repo:=repo -src:=src

	repo=$repo[2]

	case $src[2] in
		gh)
			local dest=$ZLUGIN_PATH/$repo
			if [[ ! -d $dest ]]; then
				if [[ ! -d $ZLUGIN_PATH ]]; then
					mkdir -p $ZLUGIN_PATH
				fi
				git clone git@github.com:$repo $dest
			fi
			;;
		*)
			echo "unsupported source $src"
			;;
	esac

}

zlugin_source() {
	local repo file
	zparseopts -E -D -F -repo:=repo -file:=file

	source "$ZLUGIN_PATH/$repo[2]/$file[2]"
}

# zlugin_load should take three flags
# --repo which should be in the format <user>/<repo>
# --src which should be "gh" for github (others currently unsupported)
# --file which is the file inside the repo that should be sourced after clone
zlugin_load() {
	local repo src file
	zparseopts -E -D -F -repo:=repo -src:=src -file:=file

	zlugin_clone $repo $src
	zlugin_source $repo $file
}
