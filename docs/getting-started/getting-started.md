# Getting Started

Information for new members of the Electrical sub-team on how to navigate the electrical system, and setup CAD software and their firmware development environment.

---

## Version Control

We use Git for version control. Follow the instructions [here](https://git-scm.com/downloads) for your operating system to install Git.

### (Optional) Git Configurations

This is optional, but very useful and timesaving configurations.

#### Aliases

See [Hannah's aliases](.gitconfig) for recommended git aliases.

#### Core

Define your editor.

Since different operating systems use different conventions for line-ending and carriage-return characters, a convention must be defined. See information in the `core.autocrlf` section of the [Git configuration page](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration).

```.gitconfig
[core]
    editor = code --wait
    autocrlf = input
```

## CAD Software

To view or create any schematics and PCBs, you must first install CAD software for schematic capture and PCB layout. Follow the instructions in the [CAD software tutorial](cad-software.md) to get set up.

## Electronics

To become acquainted with the electrical system, read through the [board overview document](board-overview.md). The document provides a detailed overview of all the PCBs and their functionality.

## LED Patterns

To learn about the purposes of our different LED colours and patterns, read the [LED patterns document](led-patterns.md).
