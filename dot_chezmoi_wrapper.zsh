# shellcheck shell=bash
# Wrapper for chezmoi that handles encrypted files correctly:
#   re-add: auto-injects --encrypt for files already tracked as encrypted,
#           runs plain re-add for the rest (two separate invocations if mixed)
#   add:    fails if any file is already tracked as encrypted and --encrypt is missing
chezmoi() {
  if [[ "$1" == "add" || "$1" == "re-add" ]]; then
    local subcommand="$1"
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
        if [[ "$subcommand" == "re-add" ]]; then
          local ret=0
          if (( ${#encrypted_files[@]} > 0 )); then
            command chezmoi re-add --encrypt "${other_args[@]}" "${encrypted_files[@]}" || ret=$?
          fi
          if (( ${#plain_files[@]} > 0 )); then
            command chezmoi re-add "${other_args[@]}" "${plain_files[@]}" || ret=$?
          fi
          return $ret
        else
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
  fi

  command chezmoi "$@"
}
