# shellcheck shell=bash
# Wrapper for chezmoi add: errors if any target is already tracked as
# encrypted_ in the source state but --encrypt was not passed, preventing
# silent plaintext overwrites of encrypted files.
chezmoi() {
  if [[ "$1" == "add" ]]; then
    local has_encrypt=0
    local -a file_args=()
    local -a other_args=()

    local arg
    for arg in "${@:2}"; do
      if [[ "$arg" == "--encrypt" || "$arg" == "-encrypt" ]]; then
        has_encrypt=1
        other_args+=("$arg")
      elif [[ "$arg" != -* ]]; then
        file_args+=("$arg")
      else
        other_args+=("$arg")
      fi
    done

    if (( !has_encrypt )) && (( ${#file_args[@]} > 0 )); then
      local file source_path
      local -a encrypted_files=()
      local -a plain_files=()
      for file in "${file_args[@]}"; do
        source_path=$(command chezmoi source-path "$file" 2>/dev/null)
        if [[ -n "$source_path" && "$(basename "$source_path")" == encrypted_* ]]; then
          encrypted_files+=("$file")
        else
          plain_files+=("$file")
        fi
      done

      if (( ${#encrypted_files[@]} > 0 )); then
        for file in "${encrypted_files[@]}"; do
          echo "chezmoi: '$file' is already managed as an encrypted file. Use --encrypt flag." >&2
        done
        if (( ${#plain_files[@]} > 0 )); then
          command chezmoi add "${other_args[@]}" "${plain_files[@]}"
        fi
        return 1
      fi
    fi
  fi

  command chezmoi "$@"
}
