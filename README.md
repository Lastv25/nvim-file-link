# nvim-file-link

The purpose of this project is to learn a little bit of lua and a little bit of neovim's internals.

I hope to have something similar to obsidians and dendrons note linking capabilities (but really less powerful) to be able to take notes with the **Zettelkasten** method of note taking.

The way this code behaves is similar to the [https://github.com/ThePrimeagen/harpoon/blob/harpoon2](harpoon) project by ThePrimeagen as this is inspired by it but with a lot less skill on my part.

Cheers ^^.

## Json Data storage

because sqlite was too damn hard to make work with lua on windows in 1h ....

### Data Model

- 1 file per working directory
- Using hashes as key for files

```json
{
    "hashes_indexes": [
        "string":{
            "file_path": string,
            "links": [strings]
        }
    ]
}
```

## Functions

just to remind me what functions I have added...

- Append new value to json
- List all values in json
- Remove value from json

# TODOs

- reduce hash size
- add remove from links
- optimize json travel
- implement ui like minifiles for navigation and edits ?
- use telescope for new links ?
