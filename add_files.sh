#!/usr/bin/env bash
set -e

for dir in [0-9][0-9]-*; do
    if [ -d "$dir" ]; then
        echo "Processing $dir"
        for file in README.md notes.md resources.md exercises.md flashcards.md cheat-sheet.md; do
            if [ ! -f "$dir/$file" ]; then
                echo "  Creating $dir/$file"
                case "$file" in
                    README.md)
                        echo -e "# ${dir#*-}\n\nDescription of ${dir#*-} topics." > "$dir/$file"
                        ;;
                    notes.md)
                        echo -e "# Notes\n\nAdd your notes here." > "$dir/$file"
                        ;;
                    resources.md)
                        echo -e "# Resources\n\n- [Link 1](url)\n- [Link 2](url)" > "$dir/$file"
                        ;;
                    exercises.md)
                        echo -e "# Exercises\n\n1. Problem 1\n2. Problem 2" > "$dir/$file"
                        ;;
                    flashcards.md)
                        echo -e "# Flashcards\n\n- Q: ...\n  A: ..." > "$dir/$file"
                        ;;
                    cheat-sheet.md)
                        echo -e "# Cheat Sheet\n\n## Quick Reference\n\nFill in key points." > "$dir/$file"
                        ;;
                esac
            fi
        done
    fi
done
echo "Done."