# nvim-file-link

The purpose of this project is to learn a little bit of lua and a little bit of neovim's internals.

I hope to have something similar to obsidians and dendrons note linking capabilities (but really less powerful) to be able to take notes with the **Zettelkasten** method of note taking.

Cheers ^^.

## CSV Data storage

because sqlite was too damn hard to make work with lua on windows in 1h ....

### Data Model

- 1 file
- headers as follows

| file_id | file_path | links |
| ------- | --------- | ----- |
