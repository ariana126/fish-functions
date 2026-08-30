function cas; for i in *.ass; ffmpeg -i "$i" -codec:s text ""(echo $i | sed 's/.ass$/.srt/')""; end; end
