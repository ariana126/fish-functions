 function ewa -a command; eval $command && set_color green && echo -e "\nDone.\n" && alarm || set_color red && echo -e "\nFailed.\n" && alarm; end
