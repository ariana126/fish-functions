function fas; for i in *.srt; iconv -f Windows-1256 "$i" > "$i.swp" && rm "$i" && mv "$i.swp" "$i"; end; end;
# TODO: Implement it in the 0T project.
