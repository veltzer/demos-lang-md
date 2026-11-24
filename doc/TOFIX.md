# TOFIX

Findings from a code scan on 2026-10-04.

## Medium

- `src/list_in_list_spaces.md:3-13` - the file is now identical to `src/list_in_list.md` except for the title: it was added (commit 22caf5e) to show two-space nested-list indentation, and a later lint normalization reindented both to four spaces, so the demo no longer demonstrates anything. Restore the different indentation (with an inline rumdl suppression for the intentional style, since that is the lesson) or delete the duplicate.

## Low

- `doc/TODO.txt:1-2` - both items are stale: "Add markdownlint verification" is already covered by the rumdl processor (`rsconstruct.toml:27-29`), and markdownlint is a JS tool the fleet avoids. Empty or delete the file.
- `src/comments.md:3` - typo "an markdown file" -> "a markdown file".
